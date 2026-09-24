import '../../data/db/app_database.dart';

/// Which part of the day a sender's messages cluster in, used for the
/// 夜型/朝型診断 section. Boundaries: 深夜 0-5, 朝 5-9, 日中 9-18, 夜 18-24.
enum TimeOfDaySegment { lateNight, morning, day, evening }

/// One entry in the よく使う単語 ranking.
class WordCount {
  const WordCount({required this.word, required this.count});

  final String word;
  final int count;
}

/// One entry in the 一番盛り上がった日 ranking.
class DayCount {
  const DayCount({required this.date, required this.count});

  final DateTime date;
  final int count;
}

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
    required this.avgMessageLength,
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

  /// Average character count of this sender's own text messages (photo/
  /// sticker/video placeholder messages excluded, since their rawText is
  /// just a `[写真]`-style marker, not authored content). 0 when this
  /// sender has no qualifying messages.
  final double avgMessageLength;
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

  /// Chat-wide top 10 よく使う単語, most frequent first (see
  /// [ChatStatsCalculator._extractWords] for how a "word" is approximated).
  final List<WordCount> topWords;

  /// Message counts by [weekday-1][TimeOfDaySegment.index], i.e.
  /// `weekdaySegmentCounts[0]` is Monday, `[6]` is Sunday, and within each
  /// weekday the 4 entries follow [TimeOfDaySegment.values] order.
  final List<List<int>> weekdaySegmentCounts;

  /// Longest run of consecutive calendar days with at least one
  /// (non-system) message.
  final int longestStreakDays;

  /// Top 5 busiest calendar days by message count, most messages first.
  final List<DayCount> topDays;

  /// The longest gap between two consecutive (non-system) messages, or
  /// null when there are fewer than 2 messages.
  final Duration? longestSilenceGap;
  final DateTime? longestSilenceGapStart;
  final DateTime? longestSilenceGapEnd;

  /// Fraction of non-system messages containing at least one Unicode emoji
  /// character, 0.0-1.0.
  final double emojiMessageRate;

  static const empty = ChatStats(
    totalMessages: 0,
    monthlyCounts: [],
    peakMonth: null,
    isGroup: false,
    senderStats: [],
    questionsAsked: 0,
    questionsAnswered: 0,
    topWords: [],
    weekdaySegmentCounts: [],
    longestStreakDays: 0,
    topDays: [],
    longestSilenceGap: null,
    longestSilenceGapStart: null,
    longestSilenceGapEnd: null,
    emojiMessageRate: 0,
  );

  const ChatStats({
    required this.totalMessages,
    required this.monthlyCounts,
    required this.peakMonth,
    required this.isGroup,
    required this.senderStats,
    required this.questionsAsked,
    required this.questionsAnswered,
    required this.topWords,
    required this.weekdaySegmentCounts,
    required this.longestStreakDays,
    required this.topDays,
    required this.longestSilenceGap,
    required this.longestSilenceGapStart,
    required this.longestSilenceGapEnd,
    required this.emojiMessageRate,
  });
}

class ChatStatsCalculator {
  ChatStatsCalculator._();

  /// A reply counts toward [SenderStat.avgReplyTime] only if it follows the
  /// other sender's message within this long; a bigger gap starts a new
  /// "session" instead (see [SenderStat.initiatedCount]).
  static const sessionGap = Duration(hours: 3);

  /// Common hiragana-only particles/auxiliary words, excluded from
  /// [_extractWords] since a raw hiragana run without real Japanese
  /// tokenization is more likely to be grammar than a meaningful word.
  static const _hiraganaStopwords = {
    'これ', 'それ', 'あれ', 'この', 'その', 'あの', 'ここ', 'そこ', 'あそこ',
    'から', 'まで', 'けど', 'でも', 'そして', 'または', 'なので', 'だから',
    'という', 'として', 'について', 'ください', 'します', 'ました', 'ません',
    'できる', 'できます', 'よろしく', 'ちょっと', 'なんか', 'やっぱり',
    'いただき', 'おります', 'ございます', 'こんにちは', 'こんばんは',
  };

  static final _wordRegex = RegExp(
    '[一-鿿㐀-䶿]+' // kanji
    '|[゠-ヿ]+' // katakana
    '|[぀-ゟ]+' // hiragana
    '|[A-Za-z0-9]+',
  );

  static final _emojiRegex = RegExp(
    r'[\u{1F300}-\u{1FAFF}\u{2600}-\u{27BF}\u{1F1E6}-\u{1F1FF}]',
    unicode: true,
  );

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

  /// Splits [text] into rough "word" candidates -- runs of kanji, katakana,
  /// hiragana, or latin/digits, each treated as one token since Japanese
  /// has no spaces between words and a full morphological analyzer isn't
  /// available in pure Dart. Hiragana runs are further filtered against
  /// [_hiraganaStopwords] (common particles/auxiliaries), and anything
  /// under 2 characters is dropped either way.
  static Iterable<String> _extractWords(String text) sync* {
    for (final match in _wordRegex.allMatches(text)) {
      final word = match.group(0)!;
      if (word.length < 2) continue;
      final isHiragana = word.codeUnitAt(0) >= 0x3040 && word.codeUnitAt(0) <= 0x309F;
      if (isHiragana && _hiraganaStopwords.contains(word)) continue;
      yield word;
    }
  }

  static DateTime _dateOnly(DateTime t) => DateTime(t.year, t.month, t.day);

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
    final textLengthTotals = <int, int>{};
    final textMessageCounts = <int, int>{};
    final wordCounts = <String, int>{};
    final weekdaySegmentCounts = List.generate(7, (_) => List.filled(4, 0));
    final dailyCounts = <DateTime, int>{};
    var questionsAsked = 0;
    var questionsAnswered = 0;
    var emojiMessages = 0;
    var nonSystemMessages = 0;

    Message? previous;
    Message? pendingQuestion;
    Duration? maxGap;
    DateTime? maxGapStart;
    DateTime? maxGapEnd;

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

      if (!m.isSystemMessage) {
        nonSystemMessages++;
        final dateKey = _dateOnly(m.timestamp);
        dailyCounts.update(dateKey, (v) => v + 1, ifAbsent: () => 1);
        final segment = _segmentForHour(m.timestamp.hour);
        final segIndex = TimeOfDaySegment.values.indexOf(segment);
        final weekdayIndex = m.timestamp.weekday - 1;
        weekdaySegmentCounts[weekdayIndex][segIndex]++;

        if (m.mediaPlaceholderType == null) {
          for (final word in _extractWords(m.rawText)) {
            wordCounts.update(word, (v) => v + 1, ifAbsent: () => 1);
          }
        }
        if (_emojiRegex.hasMatch(m.rawText)) emojiMessages++;

        if (previous != null && gap != null &&
            (maxGap == null || gap > maxGap)) {
          maxGap = gap;
          maxGapStart = previous.timestamp;
          maxGapEnd = m.timestamp;
        }
      }

      if (senderId != null) {
        messageCounts.update(senderId, (v) => v + 1, ifAbsent: () => 1);
        if (m.mediaPlaceholderType == 'sticker') {
          stampCounts.update(senderId, (v) => v + 1, ifAbsent: () => 1);
        }
        if (m.mediaPlaceholderType == null) {
          textLengthTotals.update(
            senderId,
            (v) => v + m.rawText.length,
            ifAbsent: () => m.rawText.length,
          );
          textMessageCounts.update(senderId, (v) => v + 1, ifAbsent: () => 1);
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
      final textCount = textMessageCounts[id] ?? 0;
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
        avgMessageLength:
            textCount == 0 ? 0 : (textLengthTotals[id] ?? 0) / textCount,
      );
    }).toList();

    final sortedMonths = monthlyCounts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final peakMonth = sortedMonths.isEmpty
        ? null
        : sortedMonths.reduce((a, b) => b.value > a.value ? b : a).key;

    final topWords = (wordCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(10)
        .map((e) => WordCount(word: e.key, count: e.value))
        .toList();

    final sortedDays = dailyCounts.keys.toList()..sort();
    var longestStreak = sortedDays.isEmpty ? 0 : 1;
    var currentStreak = longestStreak;
    for (var i = 1; i < sortedDays.length; i++) {
      if (sortedDays[i].difference(sortedDays[i - 1]).inDays == 1) {
        currentStreak++;
        if (currentStreak > longestStreak) longestStreak = currentStreak;
      } else {
        currentStreak = 1;
      }
    }

    final topDays = (dailyCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(5)
        .map((e) => DayCount(date: e.key, count: e.value))
        .toList();

    return ChatStats(
      totalMessages: total,
      monthlyCounts: sortedMonths,
      peakMonth: peakMonth,
      isGroup: senderIds.length >= 3,
      senderStats: senderStats,
      questionsAsked: questionsAsked,
      questionsAnswered: questionsAnswered,
      topWords: topWords,
      weekdaySegmentCounts: weekdaySegmentCounts,
      longestStreakDays: longestStreak,
      topDays: topDays,
      longestSilenceGap: maxGap,
      longestSilenceGapStart: maxGapStart,
      longestSilenceGapEnd: maxGapEnd,
      emojiMessageRate: nonSystemMessages == 0 ? 0 : emojiMessages / nonSystemMessages,
    );
  }
}
