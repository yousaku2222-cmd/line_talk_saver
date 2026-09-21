import 'package:flutter_test/flutter_test.dart';
import 'package:line_talk_saver/data/db/app_database.dart';
import 'package:line_talk_saver/features/chat_stats/chat_stats_calculator.dart';

Message _msg({
  required int id,
  required int? senderId,
  required DateTime timestamp,
  String rawText = 'hi',
  String? mediaPlaceholderType,
}) {
  return Message(
    id: id,
    chatId: 1,
    senderId: senderId,
    timestamp: timestamp,
    rawText: rawText,
    isSystemMessage: false,
    mediaPlaceholderType: mediaPlaceholderType,
    sortIndex: id,
  );
}

void main() {
  test('empty input yields ChatStats.empty', () {
    final stats = ChatStatsCalculator.compute([], {});
    expect(stats.totalMessages, 0);
    expect(stats.senderStats, isEmpty);
  });

  test('two senders: reply time only counts within the session gap', () {
    // A opens the conversation, B replies 10 minutes later (within the
    // 3h session gap -- counts as a reply). Then a 5h gap before A's next
    // message starts a brand new session (not a "slow reply").
    final messages = [
      _msg(id: 1, senderId: 1, timestamp: DateTime(2026, 1, 1, 9, 0)),
      _msg(id: 2, senderId: 2, timestamp: DateTime(2026, 1, 1, 9, 10)),
      _msg(id: 3, senderId: 1, timestamp: DateTime(2026, 1, 1, 14, 10)),
    ];
    final stats = ChatStatsCalculator.compute(
      messages,
      {1: 'Alice', 2: 'Bob'},
    );

    expect(stats.isGroup, isFalse);
    expect(stats.totalMessages, 3);
    expect(stats.senderStats, hasLength(2));

    final alice = stats.senderStats.firstWhere((s) => s.senderId == 1);
    final bob = stats.senderStats.firstWhere((s) => s.senderId == 2);

    // Alice started 2 sessions (message 1, and message 3 after the 5h gap).
    expect(alice.initiatedCount, 2);
    expect(alice.avgReplyTime, isNull);

    // Bob only ever replied within-session, once, 10 minutes after Alice.
    expect(bob.initiatedCount, 0);
    expect(bob.avgReplyTime, const Duration(minutes: 10));
  });

  test('3+ senders is flagged as a group and shares sum to the total', () {
    final messages = [
      _msg(id: 1, senderId: 1, timestamp: DateTime(2026, 2, 1)),
      _msg(id: 2, senderId: 2, timestamp: DateTime(2026, 2, 1, 0, 1)),
      _msg(id: 3, senderId: 3, timestamp: DateTime(2026, 2, 1, 0, 2)),
      _msg(id: 4, senderId: 1, timestamp: DateTime(2026, 2, 1, 0, 3)),
    ];
    final stats = ChatStatsCalculator.compute(
      messages,
      {1: 'Alice', 2: 'Bob', 3: 'Cara'},
    );

    expect(stats.isGroup, isTrue);
    final shareSum = stats.senderStats.fold<double>(0, (s, e) => s + e.share);
    expect(shareSum, closeTo(1.0, 1e-9));
  });

  test('peak month is the calendar month with the most messages', () {
    final messages = [
      _msg(id: 1, senderId: 1, timestamp: DateTime(2026, 1, 5)),
      _msg(id: 2, senderId: 1, timestamp: DateTime(2026, 3, 1)),
      _msg(id: 3, senderId: 1, timestamp: DateTime(2026, 3, 2)),
      _msg(id: 4, senderId: 1, timestamp: DateTime(2026, 3, 3)),
    ];
    final stats = ChatStatsCalculator.compute(messages, {1: 'Alice'});

    expect(stats.peakMonth, DateTime(2026, 3));
  });

  test('stamp ratio only counts sticker placeholders, not photos', () {
    final messages = [
      _msg(
        id: 1,
        senderId: 1,
        timestamp: DateTime(2026, 1, 1),
        mediaPlaceholderType: 'sticker',
      ),
      _msg(
        id: 2,
        senderId: 1,
        timestamp: DateTime(2026, 1, 1, 0, 1),
        mediaPlaceholderType: 'photo',
      ),
      _msg(id: 3, senderId: 1, timestamp: DateTime(2026, 1, 1, 0, 2)),
      _msg(id: 4, senderId: 1, timestamp: DateTime(2026, 1, 1, 0, 3)),
    ];
    final stats = ChatStatsCalculator.compute(messages, {1: 'Alice'});

    expect(stats.senderStats.single.stampRatio, closeTo(0.25, 1e-9));
  });

  test('dominant time segment picks the hour range with the most messages', () {
    final messages = [
      _msg(id: 1, senderId: 1, timestamp: DateTime(2026, 1, 1, 1, 0)), // lateNight
      _msg(id: 2, senderId: 1, timestamp: DateTime(2026, 1, 1, 2, 0)), // lateNight
      _msg(id: 3, senderId: 1, timestamp: DateTime(2026, 1, 1, 20, 0)), // evening
    ];
    final stats = ChatStatsCalculator.compute(messages, {1: 'Alice'});

    final alice = stats.senderStats.single;
    expect(alice.dominantTimeSegment, TimeOfDaySegment.lateNight);
    expect(alice.dominantTimeSegmentRatio, closeTo(2 / 3, 1e-9));
  });

  test('question catch rate: same-sender follow-ups don\'t count as an answer', () {
    final messages = [
      // Alice asks a question; Bob's reply 5 minutes later answers it.
      _msg(id: 1, senderId: 1, timestamp: DateTime(2026, 1, 1, 9, 0), rawText: '行く?'),
      _msg(id: 2, senderId: 2, timestamp: DateTime(2026, 1, 1, 9, 5), rawText: '行く！'),
      // Alice asks again, but only follows up with more of her own
      // messages before the session lapses -- never actually answered.
      _msg(id: 3, senderId: 1, timestamp: DateTime(2026, 1, 1, 9, 10), rawText: '何時にする？'),
      _msg(id: 4, senderId: 1, timestamp: DateTime(2026, 1, 1, 9, 11), rawText: '10時とか'),
      _msg(id: 5, senderId: 1, timestamp: DateTime(2026, 1, 2, 9, 0), rawText: 'おはよう'),
    ];
    final stats = ChatStatsCalculator.compute(messages, {1: 'Alice', 2: 'Bob'});

    expect(stats.questionsAsked, 2);
    expect(stats.questionsAnswered, 1);
    expect(stats.questionCatchRate, closeTo(0.5, 1e-9));
  });
}
