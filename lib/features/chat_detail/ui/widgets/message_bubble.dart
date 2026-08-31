import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../data/db/app_database.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../photo_association/media_kind.dart';
import '../../../photo_association/ui/full_image_viewer.dart';
import '../../../photo_association/ui/full_video_player.dart';
import 'linkified_text.dart';

Future<void> _openDocument(BuildContext context, String path) async {
  final result = await OpenFilex.open(path);
  if (result.type == ResultType.done || !context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        AppLocalizations.of(context)!.openFileFailedMessage(result.message),
      ),
    ),
  );
}

/// Distinct, muted colours cycled per sender so a group transcript is
/// easier to follow at a glance. Keyed by a stable hash of the name.
const _senderPalette = <Color>[
  Color(0xFFCE7C6C), // coral
  Color(0xFF8A6FB0), // lavender
  Color(0xFF3E7CA6), // ocean
  Color(0xFF5FA07A), // sage
  Color(0xFFB07C3E), // amber
];

Color _senderColor(String? name) {
  if (name == null || name.isEmpty) return const Color(0xFF8A8390);
  var h = 0;
  for (final c in name.codeUnits) {
    h = (h * 31 + c) & 0x7fffffff;
  }
  return _senderPalette[h % _senderPalette.length];
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.senderName,
    required this.selected,
    required this.selectionMode,
    required this.onTap,
    required this.onLongPress,
    this.showHeader = true,
    this.attachment,
    this.onAttachPhoto,
  });

  final Message message;
  final String? senderName;
  final bool selected;
  final bool selectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  /// When false this message follows another from the same sender within a
  /// few minutes, so the name/time line is dropped and just the bubble shows.
  final bool showHeader;

  /// A photo the user has manually attached to this message, if any.
  final ImageAttachment? attachment;

  /// Called when the user taps a media-placeholder message that has no
  /// attachment yet, to let them pick and attach a photo manually.
  final VoidCallback? onAttachPhoto;

  @override
  Widget build(BuildContext context) {
    if (message.isSystemMessage) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Center(
          child: Text(
            message.rawText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      );
    }

    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        color: selected ? scheme.primaryContainer.withValues(alpha: 0.4) : null,
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: showHeader ? 8 : 2,
          bottom: 3,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectionMode)
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 4),
                child: Icon(
                  selected ? Icons.check_circle : Icons.circle_outlined,
                  size: 20,
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showHeader) ...[
                    Row(
                      children: [
                        Text(
                          senderName ??
                              AppLocalizations.of(context)!.unknownSender,
                          style: textTheme.labelLarge?.copyWith(
                            color: _senderColor(senderName),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('HH:mm').format(message.timestamp),
                          style: textTheme.labelSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                  ],
                  _MessageContent(
                    message: message,
                    attachment: attachment,
                    onAttachPhoto: onAttachPhoto,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageContent extends StatelessWidget {
  const _MessageContent({
    required this.message,
    required this.attachment,
    required this.onAttachPhoto,
  });

  final Message message;
  final ImageAttachment? attachment;
  final VoidCallback? onAttachPhoto;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (message.mediaPlaceholderType != null) {
      if (attachment != null) {
        if (isDocumentPath(attachment!.localFilePath)) {
          return InkWell(
            onTap: () => _openDocument(context, attachment!.localFilePath),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: scheme.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.insert_drive_file_outlined, size: 18),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      documentDisplayName(attachment!.localFilePath),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        final isVideo = isVideoPath(attachment!.localFilePath);
        return GestureDetector(
          onTap: () => isVideo
              ? showFullVideoScreen(context, attachment!)
              : showFullImageScreen(context, attachment!),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isVideo
                ? Container(
                    width: 160,
                    height: 160,
                    color: Colors.black87,
                    child: const Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 40,
                    ),
                  )
                : Image.file(
                    File(attachment!.localFilePath),
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _placeholderBox(context),
                  ),
          ),
        );
      }
      final isVideoPlaceholder = message.mediaPlaceholderType == 'video';
      final isFilePlaceholder = message.mediaPlaceholderType == 'file';
      return InkWell(
        onTap: onAttachPhoto,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: scheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_iconFor(message.mediaPlaceholderType!), size: 18),
              const SizedBox(width: 6),
              Text(
                isFilePlaceholder
                    ? AppLocalizations.of(context)!
                          .tapToAttachFile(message.rawText)
                    : isVideoPlaceholder
                    ? AppLocalizations.of(context)!
                          .tapToAttachVideo(message.rawText)
                    : AppLocalizations.of(context)!
                          .tapToAttachPhoto(message.rawText),
                style: TextStyle(color: Colors.grey[700], fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            border: Border.all(color: scheme.outline),
            borderRadius: BorderRadius.circular(18),
          ),
          child: LinkifiedText(message.rawText),
        ),
      ),
    );
  }

  Widget _placeholderBox(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.broken_image_outlined),
    );
  }

  IconData _iconFor(String placeholderType) {
    switch (placeholderType) {
      case 'photo':
        return Icons.image_outlined;
      case 'sticker':
        return Icons.emoji_emotions_outlined;
      case 'video':
        return Icons.videocam_outlined;
      case 'file':
        return Icons.insert_drive_file_outlined;
      default:
        return Icons.image_outlined;
    }
  }
}
