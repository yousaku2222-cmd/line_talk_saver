import '../../data/db/app_database.dart';

/// One chat's position in the 一番よく話す相手ランキング.
class ChatRanking {
  const ChatRanking({
    required this.chatId,
    required this.title,
    required this.messageCount,
  });

  final int chatId;
  final String title;
  final int messageCount;
}

/// Dashboard summing every saved chat together -- only possible because
/// this app keeps every imported chat around long-term, unlike a one-shot
/// analysis tool that discards the source after showing a result.
class CrossChatStats {
  const CrossChatStats({
    required this.totalMessages,
    required this.totalChats,
    required this.ranking,
    required this.monthlyCounts,
    required this.peakMonth,
  });

  final int totalMessages;
  final int totalChats;

  /// Every chat with at least one message, ordered by [ChatRanking.messageCount]
  /// descending.
  final List<ChatRanking> ranking;

  /// Message count per calendar month, summed across every chat.
  final List<MapEntry<DateTime, int>> monthlyCounts;

  /// The single busiest month across every chat, or null when empty.
  final DateTime? peakMonth;

  static const empty = CrossChatStats(
    totalMessages: 0,
    totalChats: 0,
    ranking: [],
    monthlyCounts: [],
    peakMonth: null,
  );
}

class CrossChatStatsCalculator {
  CrossChatStatsCalculator._();

  static CrossChatStats compute(List<Chat> chats, List<Message> allMessages) {
    if (allMessages.isEmpty) return CrossChatStats.empty;

    final countsByChat = <int, int>{};
    final monthlyCounts = <DateTime, int>{};
    for (final m in allMessages) {
      countsByChat.update(m.chatId, (v) => v + 1, ifAbsent: () => 1);
      final monthKey = DateTime(m.timestamp.year, m.timestamp.month);
      monthlyCounts.update(monthKey, (v) => v + 1, ifAbsent: () => 1);
    }

    final titleById = {for (final c in chats) c.id: c.title};
    final ranking = countsByChat.entries
        .map(
          (e) => ChatRanking(
            chatId: e.key,
            title: titleById[e.key] ?? '',
            messageCount: e.value,
          ),
        )
        .toList()
      ..sort((a, b) => b.messageCount.compareTo(a.messageCount));

    final sortedMonths = monthlyCounts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final peakMonth = sortedMonths.isEmpty
        ? null
        : sortedMonths.reduce((a, b) => b.value > a.value ? b : a).key;

    return CrossChatStats(
      totalMessages: allMessages.length,
      totalChats: countsByChat.length,
      ranking: ranking,
      monthlyCounts: sortedMonths,
      peakMonth: peakMonth,
    );
  }
}
