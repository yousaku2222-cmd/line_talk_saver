import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/db/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../docx/export_docx.dart';
import '../excel/export_excel.dart';
import '../pdf/export_pdf.dart';

/// Shows a sheet letting the user pick Excel or PDF, generates the file,
/// and hands it to the OS share sheet.
Future<void> showExportOptionsSheet(
  BuildContext context, {
  required String chatTitle,
  required List<Message> messages,
  required Map<int, String> senderNames,
}) {
  final l10n = AppLocalizations.of(context)!;
  return showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(l10n.exportFormatTitle),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.table_chart_outlined),
            title: Text(l10n.excelOption),
            onTap: () {
              Navigator.of(sheetContext).pop();
              _export(
                context,
                build: () => buildExcelFile(
                  l10n: l10n,
                  chatTitle: chatTitle,
                  messages: messages,
                  senderNames: senderNames,
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf_outlined),
            title: Text(l10n.pdfOption),
            onTap: () {
              Navigator.of(sheetContext).pop();
              _export(
                context,
                build: () => buildPdfFile(
                  l10n: l10n,
                  chatTitle: chatTitle,
                  messages: messages,
                  senderNames: senderNames,
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.wordOption),
            onTap: () {
              Navigator.of(sheetContext).pop();
              _export(
                context,
                build: () => buildDocxFile(
                  l10n: l10n,
                  chatTitle: chatTitle,
                  messages: messages,
                  senderNames: senderNames,
                ),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

Future<void> _export(
  BuildContext context, {
  required Future<File> Function() build,
}) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final file = await build();
    if (!context.mounted) return;
    Navigator.of(context).pop(); // close loading dialog
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  } catch (e) {
    if (!context.mounted) return;
    Navigator.of(context).pop(); // close loading dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.exportFailedMessage(e))),
    );
  }
}
