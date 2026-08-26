import 'parsed_message.dart';

class ParseResult {
  ParseResult({
    required this.chatTitle,
    required this.messages,
    required this.senderNames,
    required this.unrecognizedLineCount,
  });

  final String? chatTitle;
  final List<ParsedMessage> messages;

  /// Unique sender display names, in order of first appearance.
  final List<String> senderNames;

  /// Lines that matched neither a date separator nor a message line and
  /// were conservatively treated as a continuation of the previous message.
  final int unrecognizedLineCount;
}
