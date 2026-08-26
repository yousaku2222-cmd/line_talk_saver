import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/db/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../save_to_gallery_service.dart';

/// Shows [attachment]'s photo full-screen, pinch-zoomable, with a delete
/// action in the app bar.
Future<void> showFullImageScreen(BuildContext context, ImageAttachment attachment) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _FullImageScreen(attachment: attachment),
    ),
  );
}

class _FullImageScreen extends ConsumerWidget {
  const _FullImageScreen({required this.attachment});

  final ImageAttachment attachment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            onPressed: () => _saveToDevice(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.deleteAttachmentTooltip,
            onPressed: () => _confirmAndDelete(context, ref),
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.file(File(attachment.localFilePath)),
        ),
      ),
    );
  }

  Future<void> _saveToDevice(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await saveToDeviceGallery(attachment.localFilePath);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.saveToDeviceSuccessMessage)),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.saveToDeviceFailedMessage(e))),
      );
    }
  }

  Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref) async {
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
      await ref.read(chatRepositoryProvider).deleteImageAttachment(attachment);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.deleteAttachmentFailedMessage(e))),
      );
      return;
    }
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }
}
