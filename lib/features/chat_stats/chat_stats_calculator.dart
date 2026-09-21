import '../../data/db/app_database.dart';

/// Per-sender numbers shown in the 相性診断 (1:1) and 発言割合 (group)
/// sections. [messageCount] / [share] always apply; [avgReplyTime] and
/// [initiatedCount] are only meaningful once there's at least one other
/// sender to reply to or be interrupted by.
class SenderStat {
  const SenderStat({
    required this.senderId,
    required this.name,
    required this.messageCount,
    required this.share,
    required this.avgReplyTime,
    required this.initiatedCount,
    required this.stampRatio,
  });

  final int senderId;
  final String name;
  final int messageCount;

  /// This sender's share of the chat's total messages, 0.0-1.0.
  final double share;

  /// Average time this sender took to reply, counting only replies sent
  /// within [ChatStatsCalculator.sessionGap] of the other sender's message
  /// (a longer gap reads as "started a new conversation", not "replied").
  /// Null when this sender never had a qualifying reply.
  final Duration? avgReplyTime;

  /// Number of times this sender sent the first message of a new
  /// "conversation session" (see [ChatStatsCalculator.sessionGap]).
  final int initiatedCount;

  /// Fraction of this sender's own messages that were a LINE sticker
  /// (`mediaPlaceholderType == 'sticker'`), 0.0-1.0.
  final double stampRatio;
}

/// 温度感グラフ + 相性診断/発言割合 for one chat, computed entirely from
/// already-imported messages -- no extra DB columns needed.
class ChatStats {
  const ChatStats({
    required this.totalMessages,
    required this.monthlyCounts,
    required this.peakMonth,
    required this.isGroup,
    required this.senderStats,
  });

  final int totalMessages;

  /// Message count per calendar month, keyed by the first day of that
  /// month, ordered chronologically.
  final List<MapEntry<DateTime, int>> monthlyCounts;

  /// The single busiest month, or null when there are no messages.
  final DateTime? peakMonth;

  /// True when 3 or more distinct senders appear in the chat (a LINE group
  /// or open chat), in which case the UI shows 発言割合 instead of
  /// 相性診断 (which only makes sense for exactly two people).
  final bool isGroup;

  /// One entry per distinct sender, ordered by [SenderStat.messageCount]
  /// descending.
  final List<SenderStat> senderStats;

  static const empty = ChatStats(
    totalMessages: 0,
    monthlyCounts: [],
    peakMonth: null,
    isGroup: false,
    senderStats: [],
  );
}

class ChatStatsCalculator {
  ChatStatsCalculator._();

  /// A reply counts toward [SenderStat.avgReplyTime] only if it follows the
  /// other sender's message within this long; a bigger gap starts a new
  /// "session" instead (see [SenderStat.initiatedCount]).
  static const sessionGap = Duration(hours: 3);

  static ChatStats compute(
    List<Message> messages,
    Map<int, String> senderNames,
  ) {
    if (messages.isEmpty) return ChatStats.empty;

    // Messages already come sorted by sortIndex from the DAO, but sort by
    // timestamp defensively since the stats below assume chronological
    // order and sortIndex/timestamp could theoretically disagree on
    // malformed imports.
    final sorted = [...messages]..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final monthlyCounts = <DateTime, int>{};
    final messageCounts = <int, int>{};
    final stampCounts = <int, int>{};
    final replyTotals = <int, Duration>{};
    final replyCounts = <int, int>{};
    final initiatedCounts = <int, int>{};

    Message? previous;
    for (final m in sorted) {
      final monthKey = DateTime(m.timestamp.year, m.timestamp.month);
      monthlyCounts.update(monthKey, (v) => v + 1, ifAbsent: () => 1);

      final senderId = m.senderId;
      if (senderId != null) {
        messageCounts.update(senderId, (v) => v + 1, ifAbsent: () => 1);
        if (m.mediaPlaceholderType == 'sticker') {
          stampCounts.update(senderId, (v) => v + 1, ifAbsent: () => 1);
        }

        final gap =
            previous == null ? null : m.timestamp.difference(previous.timestamp);
        final isNewSession = gap == null || gap > sessionGap;
        if (isNewSession) {
          initiatedCounts.update(senderId, (v) => v + 1, ifAbsent: () => 1);
        } else if (previous!.senderId != null && previous.senderId != senderId) {
          replyTotals.update(
            senderId,
            (v) => v + gap,
            ifAbsent: () => gap,
          );
          replyCounts.update(senderId, (v) => v + 1, ifAbsent: () => 1);
        }
      }

      previous = m;
    }

    final total = sorted.length;
    final senderIds = messageCounts.keys.toList()
      ..sort((a, b) => messageCounts[b]!.compareTo(messageCounts[a]!));

    final senderStats = senderIds.map((id) {
      final count = messageCounts[id]!;
      final replyCount = replyCounts[id];
      return SenderStat(
        senderId: id,
        name: senderNames[id] ?? '',
        messageCount: count,
        share: total == 0 ? 0 : count / total,
        avgReplyTime: (replyCount == null || replyCount == 0)
            ? null
            : Duration(
                milliseconds:
                    replyTotals[id]!.inMilliseconds ~/ replyCount,
              ),
        initiatedCount: initiatedCounts[id] ?? 0,
        stampRatio: count == 0 ? 0 : (stampCounts[id] ?? 0) / count,
      );
    }).toList();

    final sortedMonths = monthlyCounts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final peakMonth = sortedMonths.isEmpty
        ? null
        : sortedMonths.reduce((a, b) => b.value > a.value ? b : a).key;

    return ChatStats(
      totalMessages: total,
      monthlyCounts: sortedMonths,
      peakMonth: peakMonth,
      isGroup: senderIds.length >= 3,
      senderStats: senderStats,
    );
  }
}
