import '../../data/db/app_database.dart';

/// Which part of the day a sender's messages cluster in, used for the
/// 夜型/朝型診断 section. Boundaries: 深夜 0-5, 朝 5-9, 日中 9-18, 夜 18-24.
enum TimeOfDaySegment { lateNight, morning, day, evening }

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
    required this.dominantTimeSegment,
    required this.dominantTimeSegmentRatio,
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

  /// The time-of-day segment this sender sends the most messages in.
  final TimeOfDaySegment dominantTimeSegment;

  /// [dominantTimeSegment]'s share of this sender's own messages, 0.0-1.0.
  final double dominantTimeSegmentRatio;
}

/// 温度感グラフ + 相性診断/発言割合 for one chat, computed entirely from
/// already-imported messages -- no extra DB columns needed.
class ChatStats {
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

  /// Messages ending in "?"/"？" (excluding system messages), chat-wide.
  final int questionsAsked;

  /// Of [questionsAsked], how many got a reply from a *different* sender
  /// within [ChatStatsCalculator.sessionGap] -- see 質問キャッチボール度.
  final int questionsAnswered;

  /// [questionsAnswered] / [questionsAsked], or 0 when none were asked.
  double get questionCatchRate =>
      questionsAsked == 0 ? 0 : questionsAnswered / questionsAsked;

  static const empty = ChatStats(
    totalMessages: 0,
    monthlyCounts: [],
    peakMonth: null,
    isGroup: false,
    senderStats: [],
    questionsAsked: 0,
    questionsAnswered: 0,
  );

  const ChatStats({
    required this.totalMessages,
    required this.monthlyCounts,
    required this.peakMonth,
    required this.isGroup,
    required this.senderStats,
    required this.questionsAsked,
    required this.questionsAnswered,
  });
}

class ChatStatsCalculator {
  ChatStatsCalculator._();

  /// A reply counts toward [SenderStat.avgReplyTime] only if it follows the
  /// other sender's message within this long; a bigger gap starts a new
  /// "session" instead (see [SenderStat.initiatedCount]).
  static const sessionGap = Duration(hours: 3);

  static TimeOfDaySegment _segmentForHour(int hour) {
    if (hour < 5) return TimeOfDaySegment.lateNight;
    if (hour < 9) return TimeOfDaySegment.morning;
    if (hour < 18) return TimeOfDaySegment.day;
    return TimeOfDaySegment.evening;
  }

  static bool _isQuestion(Message m) {
    if (m.isSystemMessage) return false;
    final text = m.rawText.trim();
    return text.endsWith('?') || text.endsWith('？');
  }

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
    final segmentCounts = <int, Map<TimeOfDaySegment, int>>{};
    var questionsAsked = 0;
    var questionsAnswered = 0;

    Message? previous;
    Message? pendingQuestion;
    for (final m in sorted) {
      final monthKey = DateTime(m.timestamp.year, m.timestamp.month);
      monthlyCounts.update(monthKey, (v) => v + 1, ifAbsent: () => 1);

      final senderId = m.senderId;
      final gap =
          previous == null ? null : m.timestamp.difference(previous.timestamp);

      // Does this message answer a still-open question? A same-sender
      // follow-up doesn't count and doesn't cancel the wait either -- only
      // a reply from someone else, or the session ending unanswered, ever
      // resolves it.
      if (pendingQuestion != null) {
        final answered = senderId != null &&
            pendingQuestion.senderId != null &&
            senderId != pendingQuestion.senderId &&
            gap != null &&
            gap <= sessionGap;
        if (answered) {
          questionsAnswered++;
          pendingQuestion = null;
        } else if (gap == null || gap > sessionGap) {
          pendingQuestion = null;
        }
      }
      if (_isQuestion(m)) {
        questionsAsked++;
        pendingQuestion = m;
      }

      if (senderId != null) {
        messageCounts.update(senderId, (v) => v + 1, ifAbsent: () => 1);
        if (m.mediaPlaceholderType == 'sticker') {
          stampCounts.update(senderId, (v) => v + 1, ifAbsent: () => 1);
        }
        final segment = _segmentForHour(m.timestamp.hour);
        final segMap = segmentCounts.putIfAbsent(
          senderId,
          () => {for (final s in TimeOfDaySegment.values) s: 0},
        );
        segMap[segment] = segMap[segment]! + 1;

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
      final segMap = segmentCounts[id] ?? const {};
      var dominantSegment = TimeOfDaySegment.day;
      var dominantCount = -1;
      for (final entry in segMap.entries) {
        if (entry.value > dominantCount) {
          dominantSegment = entry.key;
          dominantCount = entry.value;
        }
      }
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
        dominantTimeSegment: dominantSegment,
        dominantTimeSegmentRatio:
            (count == 0 || dominantCount < 0) ? 0 : dominantCount / count,
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
      questionsAsked: questionsAsked,
      questionsAnswered: questionsAnswered,
    );
  }
}
