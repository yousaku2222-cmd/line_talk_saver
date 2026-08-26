import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/db/app_database.dart';
import '../../search/providers/message_filter.dart';

final chatProvider = FutureProvider.family<Chat, int>((ref, chatId) {
  return ref.watch(chatRepositoryProvider).getChat(chatId);
});

final chatMessagesProvider =
    StreamProvider.family<List<Message>, (int chatId, MessageFilter filter)>(
        (ref, args) {
  final (chatId, filter) = args;
  return ref.watch(chatRepositoryProvider).watchMessages(
        chatId,
        senderIds: filter.senderIds?.toList(),
        from: filter.dateRange?.start,
        to: filter.inclusiveEnd,
        textQuery: filter.textQuery,
      );
});

final chatSendersProvider =
    FutureProvider.family<Map<int, String>, int>((ref, chatId) async {
  final senders = await ref.read(chatRepositoryProvider).sendersForChat(chatId);
  return {for (final s in senders) s.id: s.displayName};
});
