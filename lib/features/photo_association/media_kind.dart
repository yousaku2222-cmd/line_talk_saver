const _videoExtensions = {'mp4', 'mov', 'm4v', '3gp', 'webm', 'mkv', 'avi'};
const _imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'heic', 'heif'};

String _extensionOf(String path) {
  final dot = path.lastIndexOf('.');
  if (dot == -1) return '';
  return path.substring(dot + 1).toLowerCase();
}

/// Whether a locally stored attachment file is a video, based on its file
/// extension (attachments carry no separate "kind" column -- the extension
/// from the original picked/shared file is preserved when persisting it).
bool isVideoPath(String path) => _videoExtensions.contains(_extensionOf(path));

bool isImagePath(String path) => _imageExtensions.contains(_extensionOf(path));

/// Anything that isn't a recognized image or video (PDF, Word, Excel, etc.)
/// -- attached via the generic file picker to a `[ファイル]` placeholder,
/// and opened with whatever app the device has for that file type.
bool isDocumentPath(String path) => !isVideoPath(path) && !isImagePath(path);

/// Recovers a readable name for a document attachment. Files persisted via
/// `persistFileBytes` are named `<timestamp>_<original file name>` (unlike
/// photos/videos, which don't need a human-readable name); this strips that
/// prefix back off for display.
String documentDisplayName(String path) {
  final base = path.split(RegExp(r'[\\/]')).last;
  final match = RegExp(r'^\d+_(.+)$').firstMatch(base);
  return match?.group(1) ?? base;
}
