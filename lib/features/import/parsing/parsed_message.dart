enum MediaPlaceholderType { photo, sticker, video, file }

MediaPlaceholderType? mediaPlaceholderTypeFromMarker(String text) {
  switch (text.trim()) {
    case '[写真]':
      return MediaPlaceholderType.photo;
    case '[スタンプ]':
      return MediaPlaceholderType.sticker;
    case '[動画]':
      return MediaPlaceholderType.video;
    case '[ファイル]':
      return MediaPlaceholderType.file;
    default:
      return null;
  }
}

class ParsedMessage {
  ParsedMessage({
    required this.senderName,
    required this.timestamp,
    required this.rawText,
    required this.isSystemMessage,
    required this.sortIndex,
  }) : mediaPlaceholderType = mediaPlaceholderTypeFromMarker(rawText);

  /// Null for system messages (e.g. someone left the group).
  final String? senderName;
  final DateTime timestamp;
  final String rawText;
  final bool isSystemMessage;
  final MediaPlaceholderType? mediaPlaceholderType;
  final int sortIndex;

  ParsedMessage appendContinuation(String line) {
    return ParsedMessage(
      senderName: senderName,
      timestamp: timestamp,
      rawText: '$rawText\n$line',
      isSystemMessage: isSystemMessage,
      sortIndex: sortIndex,
    );
  }
}
