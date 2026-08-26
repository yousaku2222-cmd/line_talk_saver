/// Arguments for opening [PhotoGalleryScreen] when one or more photos/
/// videos/files shared in from another app are waiting to be attached
/// directly to this chat (used for chat rooms created without an import,
/// which have no placeholder messages to tap one at a time).
class PhotoGalleryScreenArgs {
  const PhotoGalleryScreenArgs({
    required this.chatId,
    this.pendingPhotoPaths = const [],
  });

  final int chatId;
  final List<String> pendingPhotoPaths;
}
