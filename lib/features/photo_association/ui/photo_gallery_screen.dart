import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';

import '../../../core/providers/app_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../chat_detail/providers/chat_detail_provider.dart';
import '../../monetization/ads/banner_ad_widget.dart';
import '../media_kind.dart';
import '../photo_attach_service.dart';
import '../providers/photo_provider.dart';
import 'full_image_viewer.dart';
import 'full_video_player.dart';

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

class PhotoGalleryScreen extends ConsumerStatefulWidget {
  const PhotoGalleryScreen({
    super.key,
    required this.chatId,
    this.pendingPhotoPaths = const [],
  });

  final int chatId;

  /// One or more photos/videos/files shared in from another app, attached
  /// directly to this chat as soon as the screen opens -- there's no
  /// message to tap one at a time here, unlike `ChatDetailScreen`.
  final List<String> pendingPhotoPaths;

  @override
  ConsumerState<PhotoGalleryScreen> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends ConsumerState<PhotoGalleryScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.pendingPhotoPaths.isEmpty) return;
    // Deferred past the current build for the same reason as elsewhere in
    // the app: an inherited-widget lookup (AppLocalizations.of, used by the
    // snackbar below) throws if triggered synchronously from initState().
    WidgetsBinding.instance.addPostFrameCallback((_) => _attachPending());
  }

  Future<void> _attachPending() async {
    if (!mounted) return;
    final repo = ref.read(chatRepositoryProvider);
    for (final path in widget.pendingPhotoPaths) {
      await repo.attachImage(chatId: widget.chatId, localFilePath: path);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(
            context,
          )!.pendingAttachedToRoomMessage(widget.pendingPhotoPaths.length),
        ),
      ),
    );
  }

  Future<void> _addMedia(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final choice = await showModalBottomSheet<_MediaChoice>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_photo_alternate_outlined),
              title: Text(l10n.addPhotoTooltip),
              onTap: () => Navigator.of(sheetContext).pop(_MediaChoice.photo),
            ),
            ListTile(
              leading: const Icon(Icons.video_call_outlined),
              title: Text(l10n.addVideoLabel),
              onTap: () => Navigator.of(sheetContext).pop(_MediaChoice.video),
            ),
            ListTile(
              leading: const Icon(Icons.attach_file_outlined),
              title: Text(l10n.addFileLabel),
              onTap: () => Navigator.of(sheetContext).pop(_MediaChoice.file),
            ),
          ],
        ),
      ),
    );
    if (choice == null) return;

    final String? path;
    switch (choice) {
      case _MediaChoice.photo:
        path = await pickAndPersistPhoto();
      case _MediaChoice.video:
        path = await pickAndPersistVideo();
      case _MediaChoice.file:
        path = await pickAndPersistFile();
    }
    if (path == null) return;
    if (!context.mounted) return;
    await ref
        .read(chatRepositoryProvider)
        .attachImage(chatId: widget.chatId, localFilePath: path);
  }

  @override
  Widget build(BuildContext context) {
    final attachmentsAsync = ref.watch(chatImageAttachmentsProvider(widget.chatId));
    final chatAsync = ref.watch(chatProvider(widget.chatId));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(chatAsync.valueOrNull?.title ?? l10n.photosTitle)),
      body: attachmentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text(l10n.loadErrorWithMessage(err))),
        data: (attachments) {
          if (attachments.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.photo_library_outlined,
                        size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noPhotosMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: attachments.length,
            itemBuilder: (context, index) {
              final attachment = attachments[index];
              final path = attachment.localFilePath;
              if (isDocumentPath(path)) {
                return GestureDetector(
                  onTap: () => _openDocument(context, path),
                  child: Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.insert_drive_file_outlined),
                        Text(
                          documentDisplayName(path),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final isVideo = isVideoPath(path);
              return GestureDetector(
                onTap: () => isVideo
                    ? showFullVideoScreen(context, attachment)
                    : showFullImageScreen(context, attachment),
                child: isVideo
                    ? Container(
                        color: Colors.black87,
                        child: const Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                        ),
                      )
                    : Image.file(
                        File(path),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.broken_image_outlined),
                        ),
                      ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMedia(context, ref),
        tooltip: l10n.addMediaTooltip,
        child: const Icon(Icons.add_photo_alternate_outlined),
      ),
      bottomNavigationBar: const SafeArea(child: DismissibleBannerAd()),
    );
  }
}

enum _MediaChoice { photo, video, file }
