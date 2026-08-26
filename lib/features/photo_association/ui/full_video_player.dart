import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/db/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../save_to_gallery_service.dart';

/// Opens [attachment]'s video full-screen with basic play/pause controls
/// and a delete action in the app bar.
Future<void> showFullVideoScreen(BuildContext context, ImageAttachment attachment) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _FullVideoPlayerScreen(attachment: attachment),
    ),
  );
}

class _FullVideoPlayerScreen extends ConsumerStatefulWidget {
  const _FullVideoPlayerScreen({required this.attachment});

  final ImageAttachment attachment;

  @override
  ConsumerState<_FullVideoPlayerScreen> createState() =>
      _FullVideoPlayerScreenState();
}

class _FullVideoPlayerScreenState extends ConsumerState<_FullVideoPlayerScreen> {
  late final VideoPlayerController _controller;
  late final Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.attachment.localFilePath));
    _initialization = _controller.initialize().then((_) => _controller.play());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirmAndDelete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteAttachmentConfirmTitle),
        content: Text(l10n.deleteAttachmentConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(chatRepositoryProvider).deleteImageAttachment(widget.attachment);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.deleteAttachmentFailedMessage(e))),
      );
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _saveToDevice() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await saveToDeviceGallery(widget.attachment.localFilePath);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.saveToDeviceSuccessMessage)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.saveToDeviceFailedMessage(e))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            tooltip: l10n.saveToDeviceTooltip,
            onPressed: _saveToDevice,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.deleteAttachmentTooltip,
            onPressed: _confirmAndDelete,
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<void>(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          },
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (!_controller.value.isInitialized) return const SizedBox.shrink();
          return FloatingActionButton(
            onPressed: () {
              setState(() {
                _controller.value.isPlaying ? _controller.pause() : _controller.play();
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          );
        },
      ),
    );
  }
}
