import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/messages_table.dart';
import '../tables/senders_table.dart';

part 'message_dao.g.dart';

@DriftAccessor(tables: [Messages, Senders])
class MessageDao extends DatabaseAccessor<AppDatabase>
    with _$MessageDaoMixin {
  MessageDao(super.db);

  Stream<List<Message>> watchMessages(
    int chatId, {
    List<int>? senderIds,
    DateTime? from,
    DateTime? to,
    String? textQuery,
  }) {
    final query = select(messages)
      ..where((t) => t.chatId.equals(chatId))
      ..orderBy([(t) => OrderingTerm.asc(t.sortIndex)]);
    if (senderIds != null && senderIds.isNotEmpty) {
      query.where((t) => t.senderId.isIn(senderIds));
    }
    if (from != null) {
      query.where((t) => t.timestamp.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      query.where((t) => t.timestamp.isSmallerOrEqualValue(to));
    }
    if (textQuery != null && textQuery.trim().isNotEmpty) {
      query.where((t) => t.rawText.contains(textQuery.trim()));
    }
    return query.watch();
  }

  Future<void> insertMessages(List<MessagesCompanion> rows) async {
    await batch((b) => b.insertAll(messages, rows));
  }

  Future<void> deleteMessage(int id) {
    return (delete(messages)..where((t) => t.id.equals(id))).go();
  }

  Future<List<Sender>> sendersForChat(int chatId) {
    return (select(senders)..where((t) => t.chatId.equals(chatId))).get();
  }

  Future<void> insertSenders(List<SendersCompanion> rows) async {
    await batch((b) => b.insertAll(senders, rows));
  }
}
