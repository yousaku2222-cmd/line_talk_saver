import 'package:flutter_test/flutter_test.dart';
import 'package:line_talk_saver/data/db/app_database.dart';
import 'package:line_talk_saver/features/chat_stats/cross_chat_stats_calculator.dart';

Chat _chat({required int id, required String title}) {
  return Chat(
    id: id,
    title: title,
    importedAt: DateTime(2026, 1, 1),
    sourceFileName: 'a.txt',
    rawTxtPath: '/a.txt',
    iconKey: null,
    isLocked: false,
    isFavorite: false,
  );
}

Message _msg({
  required int id,
  required int chatId,
  required DateTime timestamp,
}) {
  return Message(
    id: id,
    chatId: chatId,
    senderId: 1,
    timestamp: timestamp,
    rawText: 'hi',
    isSystemMessage: false,
    mediaPlaceholderType: null,
    sortIndex: id,
  );
}

void main() {
  test('empty input yields CrossChatStats.empty', () {
    final stats = CrossChatStatsCalculator.compute([], []);
    expect(stats.totalMessages, 0);
    expect(stats.ranking, isEmpty);
  });

  test('ranking sorts chats by message count descending', () {
    final chats = [
      _chat(id: 1, title: 'Alice'),
      _chat(id: 2, title: 'Bob'),
    ];
    final messages = [
      _msg(id: 1, chatId: 1, timestamp: DateTime(2026, 1, 1)),
      _msg(id: 2, chatId: 2, timestamp: DateTime(2026, 1, 1)),
      _msg(id: 3, chatId: 2, timestamp: DateTime(2026, 1, 2)),
      _msg(id: 4, chatId: 2, timestamp: DateTime(2026, 1, 3)),
    ];
    final stats = CrossChatStatsCalculator.compute(chats, messages);

    expect(stats.totalMessages, 4);
    expect(stats.totalChats, 2);
    expect(stats.ranking.first.title, 'Bob');
    expect(stats.ranking.first.messageCount, 3);
    expect(stats.ranking.last.title, 'Alice');
    expect(stats.ranking.last.messageCount, 1);
  });

  test('monthly counts sum across every chat', () {
    final chats = [_chat(id: 1, title: 'Alice'), _chat(id: 2, title: 'Bob')];
    final messages = [
      _msg(id: 1, chatId: 1, timestamp: DateTime(2026, 3, 1)),
      _msg(id: 2, chatId: 2, timestamp: DateTime(2026, 3, 2)),
      _msg(id: 3, chatId: 2, timestamp: DateTime(2026, 4, 1)),
    ];
    final stats = CrossChatStatsCalculator.compute(chats, messages);

    expect(stats.peakMonth, DateTime(2026, 3));
    final march = stats.monthlyCounts.firstWhere(
      (e) => e.key == DateTime(2026, 3),
    );
    expect(march.value, 2);
  });
}
