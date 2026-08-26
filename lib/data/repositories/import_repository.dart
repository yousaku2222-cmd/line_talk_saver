import 'package:drift/drift.dart';

import '../../features/import/parsing/parse_result.dart';
import '../db/app_database.dart';

class ImportRepository {
  ImportRepository(this._db);

  final AppDatabase _db;

  /// Persists a [ParseResult] as a new chat and returns its id.
  Future<int> importParsedChat({
    required ParseResult result,
    required String sourceFileName,
    required String rawTxtPath,
  }) async {
    final title = (result.chatTitle?.isNotEmpty ?? false)
        ? result.chatTitle!
        : sourceFileName;

    return _db.transaction(() async {
      final chatId = await _db.chatDao.insertChat(
        ChatsCompanion.insert(
          title: title,
          importedAt: DateTime.now(),
          sourceFileName: sourceFileName,
          rawTxtPath: rawTxtPath,
        ),
      );

      final senderIdByName = <String, int>{};
      if (result.senderNames.isNotEmpty) {
        await _db.messageDao.insertSenders([
          for (final name in result.senderNames)
            SendersCompanion.insert(chatId: chatId, displayName: name),
        ]);
        final inserted = await _db.messageDao.sendersForChat(chatId);
        for (final s in inserted) {
          senderIdByName[s.displayName] = s.id;
        }
      }

      await _db.messageDao.insertMessages([
        for (final m in result.messages)
          MessagesCompanion.insert(
            chatId: chatId,
            senderId: Value(
              m.senderName != null ? senderIdByName[m.senderName] : null,
            ),
            timestamp: m.timestamp,
            rawText: m.rawText,
            isSystemMessage: Value(m.isSystemMessage),
            mediaPlaceholderType:
                Value(m.mediaPlaceholderType?.name),
            sortIndex: m.sortIndex,
          ),
      ]);

      return chatId;
    });
  }
}
