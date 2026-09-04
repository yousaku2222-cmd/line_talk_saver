import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/app_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../monetization/ads/banner_ad_widget.dart';
import '../parsing/line_txt_parser.dart';
import '../parsing/parse_result.dart';
import 'import_screen_args.dart';

class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key, this.initialShare});

  /// When the screen is opened via the OS share sheet (LINE's "トークを
  /// テキストで送信"), the content is already known -- skip straight to
  /// parsing it instead of showing the manual file-picker idle state.
  final ImportScreenArgs? initialShare;

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

enum _Status { idle, working, preview, error }

class _ImportScreenState extends ConsumerState<ImportScreen> {
  _Status _status = _Status.idle;
  String? _errorMessage;
  ParseResult? _result;
  String? _sourceFileName;
  String? _rawTxtPath;

  @override
  void initState() {
    super.initState();
    final share = widget.initialShare;
    final sharedPath = share?.filePath;
    final sharedText = share?.text;
    if (sharedPath == null && sharedText == null) return;
    // Defer past the current build: initState() runs before this State is
    // fully mounted, so any inherited-widget lookup (AppLocalizations.of,
    // used deeper in these calls) throws if triggered synchronously from
    // here -- which was silently swallowing the whole share-intake flow
    // (screen stayed on the idle "select file" view with no error shown).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (sharedPath != null) {
        _loadAndParseFromPath(
          sharedPath,
          sharedPath.split(RegExp(r'[\\/]')).last,
        );
      } else {
        _loadFromSharedText(sharedText!);
      }
    });
  }

  Future<void> _loadFromSharedText(String content) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _status = _Status.working;
      _errorMessage = null;
    });
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'shared_${DateTime.now().millisecondsSinceEpoch}.txt';
      final file = File('${dir.path}${Platform.pathSeparator}$fileName');
      await file.writeAsString(content);
      await _loadAndParseFromPath(file.path, l10n.sharedTextFallbackTitle);
    } catch (e) {
      setState(() {
        _errorMessage = l10n.sharedContentLoadFailed(e);
        _status = _Status.error;
      });
    }
  }

  Future<void> _openLine() async {
    // LINE's old `line://` custom scheme is officially deprecated (LINE
    // itself now rejects most paths through it with an "update the app"
    // dialog, seen on-device); `https://line.me/R/nv/chat` is the current
    // documented App Link, which LINE registers as a verified domain so it
    // opens the app directly instead of a browser.
    final launched = await launchUrl(
      Uri.parse('https://line.me/R/nv/chat'),
      mode: LaunchMode.externalApplication,
    );
    if (launched || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.lineNotInstalledMessage),
      ),
    );
  }

  Future<void> _pickFile() async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );
    if (picked.isEmpty) return;
    final file = picked.single;
    setState(() {
      _status = _Status.working;
      _errorMessage = null;
    });
    try {
      // PlatformFile.readAsBytes() reads the file's data regardless of
      // whether it resolves to a real filesystem path -- on Android, files
      // picked from cloud-backed providers (Drive, "Files" app recents, etc.)
      // don't always have a usable `path`, which made the old path-only
      // approach silently no-op.
      final bytes = await file.readAsBytes();
      await _loadAndParseBytes(bytes, file.name, file.path ?? file.name);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.fileLoadFailed(e);
        _status = _Status.error;
      });
    }
  }

  Future<void> _loadAndParseFromPath(String path, String displayName) async {
    setState(() {
      _status = _Status.working;
      _errorMessage = null;
    });
    try {
      final bytes = await File(path).readAsBytes();
      await _loadAndParseBytes(bytes, displayName, path);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.fileLoadFailed(e);
        _status = _Status.error;
      });
    }
  }

  Future<void> _loadAndParseBytes(
    List<int> bytes,
    String displayName,
    String rawTxtPath,
  ) async {
    setState(() {
      _status = _Status.working;
      _errorMessage = null;
    });

    try {
      String content;
      try {
        content = utf8.decode(bytes);
      } on FormatException {
        content = utf8.decode(bytes, allowMalformed: true);
      }

      final result = LineTxtParser().parse(content);
      setState(() {
        _result = result;
        _sourceFileName = displayName;
        _rawTxtPath = rawTxtPath;
        _status = _Status.preview;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.fileLoadFailed(e);
        _status = _Status.error;
      });
    }
  }

  Future<void> _confirmImport() async {
    final result = _result;
    if (result == null || _sourceFileName == null || _rawTxtPath == null) {
      return;
    }
    setState(() => _status = _Status.working);
    try {
      final chatId = await ref
          .read(importRepositoryProvider)
          .importParsedChat(
            result: result,
            sourceFileName: _sourceFileName!,
            rawTxtPath: _rawTxtPath!,
          );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/chat', arguments: chatId);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.saveFailedMessage(e);
        _status = _Status.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.importScreenTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _buildBody(context),
      ),
      bottomNavigationBar: const SafeArea(child: DismissibleBannerAd()),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_status) {
      case _Status.idle:
        return _IdleView(onPick: _pickFile, onOpenLine: _openLine);
      case _Status.working:
        return const Center(child: CircularProgressIndicator());
      case _Status.error:
        return _ErrorView(message: _errorMessage!, onRetry: _pickFile);
      case _Status.preview:
        return _PreviewView(
          result: _result!,
          fileName: _sourceFileName!,
          onConfirm: _confirmImport,
          onCancel: () => setState(() => _status = _Status.idle),
        );
    }
  }
}

class _IdleView extends StatelessWidget {
  const _IdleView({required this.onPick, required this.onOpenLine});

  final VoidCallback onPick;
  final VoidCallback onOpenLine;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.file_upload_outlined,
                size: 44,
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.idleImportInstruction,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onOpenLine,
                icon: const Icon(Icons.chat_bubble_outline),
                label: Text(l10n.openLineButton),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onPick,
                icon: const Icon(Icons.folder_open),
                label: Text(l10n.selectFileButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              color: scheme.errorContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 44,
              color: scheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: 24),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context)!.retrySelectFileButton),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewView extends StatelessWidget {
  const _PreviewView({
    required this.result,
    required this.fileName,
    required this.onConfirm,
    required this.onCancel,
  });

  final ParseResult result;
  final String fileName;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    // Zero parsed messages from a non-empty file is inherently suspicious,
    // regardless of whether any specific line could be flagged as the
    // reason why (e.g. the whole file never left "header" parsing).
    final looksSuspicious = result.messages.isEmpty;
    final l10n = AppLocalizations.of(context)!;

    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: scheme.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(fileName, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              _StatRow(
                label: l10n.previewLabelTitle,
                value: result.chatTitle ?? l10n.previewNoTitleDetected,
              ),
              _StatRow(
                label: l10n.previewLabelMessageCount,
                value: l10n.previewMessageCountValue(result.messages.length),
              ),
              _StatRow(
                label: l10n.previewLabelParticipantCount,
                value: l10n.previewParticipantCountValue(
                  result.senderNames.length,
                ),
              ),
            ],
          ),
        ),
        if (looksSuspicious || result.unrecognizedLineCount > 0)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              looksSuspicious
                  ? l10n.previewSuspiciousMessage
                  : l10n.previewUnrecognizedLinesMessage(
                      result.unrecognizedLineCount,
                    ),
              style: TextStyle(
                color: looksSuspicious
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                child: Text(l10n.cancel),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: result.messages.isEmpty ? null : onConfirm,
                child: Text(l10n.saveButton),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
