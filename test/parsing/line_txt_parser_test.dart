import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:line_talk_saver/features/import/parsing/line_txt_parser.dart';
import 'package:line_talk_saver/features/import/parsing/parsed_message.dart';

String _fixture(String name) =>
    File('test/fixtures/$name').readAsStringSync();

void main() {
  final parser = LineTxtParser();

  test('parses a normal 1:1 chat', () {
    final result = parser.parse(_fixture('normal_chat.txt'));

    expect(result.chatTitle, '田中太郎とのトーク履歴');
    expect(result.messages, hasLength(3));
    expect(result.senderNames, ['田中太郎', '自分']);
    expect(result.unrecognizedLineCount, 0);

    final first = result.messages.first;
    expect(first.senderName, '田中太郎');
    expect(first.rawText, 'おはようございます');
    expect(first.timestamp, DateTime(2024, 3, 15, 9, 0));
    expect(first.isSystemMessage, isFalse);
  });

  test('parses a group chat and tags media placeholders', () {
    final result = parser.parse(_fixture('group_chat.txt'));

    expect(result.messages, hasLength(4));
    expect(result.senderNames, ['田中太郎', '鈴木花子', '佐藤次郎']);

    final stampMessage = result.messages[2];
    expect(stampMessage.mediaPlaceholderType, MediaPlaceholderType.sticker);

    final photoMessage = result.messages[3];
    expect(photoMessage.mediaPlaceholderType, MediaPlaceholderType.photo);
  });

  test(
      'joins multi-line messages, flags system messages, '
      'and carries the date across midnight', () {
    final result = parser.parse(_fixture('multiline_and_system.txt'));

    expect(result.messages, hasLength(4));

    final multiline = result.messages[0];
    expect(multiline.senderName, '田中太郎');
    expect(
      multiline.rawText,
      '明日の予定ですが\n1. 朝9時に集合\n2. 資料を持参\n\tお願いします',
    );
    expect(multiline.isSystemMessage, isFalse);

    final system = result.messages[2];
    expect(system.isSystemMessage, isTrue);
    expect(system.senderName, isNull);
    expect(system.rawText, '田中太郎さんが退出しました。');
    expect(system.timestamp, DateTime(2024, 3, 19, 23, 59));

    // Rolled over to the next day's date separator.
    final afterMidnight = result.messages[3];
    expect(afterMidnight.senderName, '鈴木花子');
    expect(afterMidnight.timestamp, DateTime(2024, 3, 20, 0, 5));

    // The three lines making up the rest of the multi-line message are
    // syntactically indistinguishable from garbage, so they're folded in
    // as continuations and counted -- this is expected, not a parse error.
    expect(result.unrecognizedLineCount, 3);
  });

  test('never throws on garbage input and yields zero messages', () {
    const garbage = 'this is not a LINE export at all\njust some text';
    final result = parser.parse(garbage);

    // Unrecognized-before-any-message content is treated as header noise
    // rather than a continuation, so it isn't counted -- but zero parsed
    // messages is itself the signal the UI treats as suspicious.
    expect(result.messages, isEmpty);
  });

  test('folds unclassifiable lines into the previous message and counts them',
      () {
    final result = parser.parse(
      '2024/03/15(金)\n'
      '09:00\t田中太郎\tおはよう\n'
      'これは追加の行です\n',
    );

    expect(result.messages, hasLength(1));
    expect(result.messages.first.rawText, 'おはよう\nこれは追加の行です');
    expect(result.unrecognizedLineCount, 1);
  });
}
