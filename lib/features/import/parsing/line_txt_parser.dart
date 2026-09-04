import 'parse_result.dart';
import 'parsed_message.dart';

/// Parses a LINE "トークをテキストで送信" (.txt) export.
///
/// The exporter's exact line format has drifted across LINE versions and
/// between iOS/Android, so this is a tolerant, stateful line scanner rather
/// than a strict grammar: a line only starts a new message when it matches
/// the `HH:MM<TAB>...` shape, and anything else is treated as a
/// continuation of the previous message. Unrecognized lines are never
/// dropped or thrown on — they're folded into the previous message and
/// counted, so the caller can surface "N lines could not be classified"
/// instead of silently losing content.
class LineTxtParser {
  static final _dateSeparator = RegExp(r'^(\d{4})/(\d{1,2})/(\d{1,2})(\(.*\))?$');
  // LINE for Android exports "HH:MM" (24h). LINE for iOS instead exports
  // "午前/午後H:MM" (12h with a Japanese AM/PM prefix), so both are matched
  // here and normalized to 24h below.
  static final _messageLine =
      RegExp(r'^(?:(午前|午後)\s*)?(\d{1,2}):(\d{2})\t(.*)$');

  ParseResult parse(String content) {
    final lines = content.split(RegExp(r'\r\n|\r|\n'));

    String? chatTitle;
    DateTime? currentDate;
    var inHeader = true;
    var unrecognizedLineCount = 0;
    var sortIndex = 0;

    final messages = <ParsedMessage>[];
    final senderNames = <String>[];

    void appendContinuation(String line) {
      if (messages.isEmpty) {
        // Continuation before any message was ever opened (e.g. odd
        // trailing header content) — nothing to attach it to, so drop it
        // silently rather than crash; header content isn't chat data.
        return;
      }
      messages[messages.length - 1] =
          messages.last.appendContinuation(line);
    }

    for (final rawLine in lines) {
      final line = rawLine.trimRight();
      if (line.isEmpty) continue;

      if (inHeader) {
        if (line.startsWith('[LINE]')) {
          chatTitle = line.substring('[LINE]'.length).trim();
          continue;
        }
        final dateMatch = _dateSeparator.firstMatch(line);
        final msgMatch = _messageLine.firstMatch(line);
        if (dateMatch == null && msgMatch == null) {
          // Still inside header (e.g. "保存日時:...") — ignore.
          continue;
        }
        inHeader = false;
        // Fall through to body handling below for this same line.
      }

      final dateMatch = _dateSeparator.firstMatch(line);
      if (dateMatch != null) {
        currentDate = DateTime(
          int.parse(dateMatch.group(1)!),
          int.parse(dateMatch.group(2)!),
          int.parse(dateMatch.group(3)!),
        );
        continue;
      }

      final msgMatch = _messageLine.firstMatch(line);
      if (msgMatch != null && currentDate != null) {
        final meridiem = msgMatch.group(1);
        var hour = int.parse(msgMatch.group(2)!);
        if (meridiem == '午後' && hour != 12) {
          hour += 12;
        } else if (meridiem == '午前' && hour == 12) {
          hour = 0;
        }
        final minute = int.parse(msgMatch.group(3)!);
        final rest = msgMatch.group(4)!;
        final tabIndex = rest.indexOf('\t');

        final timestamp = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          hour,
          minute,
        );

        if (tabIndex == -1) {
          // Two-field line: no sender column -> system message
          // (e.g. "〇〇さんが退出しました。").
          messages.add(ParsedMessage(
            senderName: null,
            timestamp: timestamp,
            rawText: rest,
            isSystemMessage: true,
            sortIndex: sortIndex++,
          ));
        } else {
          final sender = rest.substring(0, tabIndex);
          final text = rest.substring(tabIndex + 1);
          if (!senderNames.contains(sender)) senderNames.add(sender);
          messages.add(ParsedMessage(
            senderName: sender,
            timestamp: timestamp,
            rawText: text,
            isSystemMessage: false,
            sortIndex: sortIndex++,
          ));
        }
        continue;
      }

      // Doesn't match a date separator or a message line (or no date
      // context yet) — safest assumption is that it's a continuation of
      // the previous message's text.
      appendContinuation(line);
      unrecognizedLineCount++;
    }

    return ParseResult(
      chatTitle: chatTitle,
      messages: messages,
      senderNames: senderNames,
      unrecognizedLineCount: unrecognizedLineCount,
    );
  }
}
