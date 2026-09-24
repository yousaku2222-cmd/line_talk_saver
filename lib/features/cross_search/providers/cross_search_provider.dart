import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/db/app_database.dart';
import '../../chat_stats/providers/cross_chat_stats_provider.dart';

final crossSearchQueryProvider = StateProvider<String>((ref) => '');

final allSendersProvider = StreamProvider<List<Sender>>((ref) {
  return ref.watch(chatRepositoryProvider).watchAllSenders();
});

class CrossSearchResult {
  const CrossSearchResult({
    required this.message,
    required this.chatId,
    required this.chatTitle,
    required this.senderName,
  });

  final Message message;
  final int chatId;
  final String chatTitle;
  final String senderName;
}

/// Cross-chat keyword search: filters every saved message (across every
/// chat) in Dart, the same small-personal-data-scale approach already used
/// by [allMessagesForDashboardProvider] -- no SQL-side full text search
/// needed for this app's typical data size.
final crossSearchResultsProvider = Provider<AsyncValue<List<CrossSearchResult>>>((ref) {
  final query = ref.watch(crossSearchQueryProvider).trim();
  final chatsAsync = ref.watch(allChatsForDashboardProvider);
  final messagesAsync = ref.watch(allMessagesForDashboardProvider);
  final sendersAsync = ref.watch(allSendersProvider);

  if (query.isEmpty) {
    return const AsyncValue.data([]);
  }

  if (chatsAsync is AsyncLoading ||
      messagesAsync is AsyncLoading ||
      sendersAsync is AsyncLoading) {
    return const AsyncValue.loading();
  }
  final error = chatsAsync.hasError
      ? chatsAsync
      : (messagesAsync.hasError ? messagesAsync : sendersAsync);
  if (error.hasError) {
    return AsyncValue.error(error.error!, error.stackTrace!);
  }

  final chats = chatsAsync.value ?? const <Chat>[];
  final messages = messagesAsync.value ?? const <Message>[];
  final senders = sendersAsync.value ?? const <Sender>[];

  final chatTitles = {for (final c in chats) c.id: c.title};
  final senderNames = {for (final s in senders) s.id: s.displayName};
  final lowerQuery = query.toLowerCase();

  final results = messages
      .where((m) => !m.isSystemMessage && m.rawText.toLowerCase().contains(lowerQuery))
      .map(
        (m) => CrossSearchResult(
          message: m,
          chatId: m.chatId,
          chatTitle: chatTitles[m.chatId] ?? '',
          senderName: m.senderId != null ? (senderNames[m.senderId] ?? '') : '',
        ),
      )
      .toList()
    ..sort((a, b) => b.message.timestamp.compareTo(a.message.timestamp));

  return AsyncValue.data(results);
});
