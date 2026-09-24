/// Arguments for opening [ChatDetailScreen] when one or more photos/videos
/// shared in from another app are waiting to be attached to messages in
/// this chat.
class ChatDetailScreenArgs {
  const ChatDetailScreenArgs({
    required this.chatId,
    this.pendingPhotoPaths = const [],
    this.initialTextQuery,
  });

  final int chatId;
  final List<String> pendingPhotoPaths;
  final String? initialTextQuery;
}
