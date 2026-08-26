import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/chats_table.dart';

part 'chat_dao.g.dart';

@DriftAccessor(tables: [Chats])
class ChatDao extends DatabaseAccessor<AppDatabase> with _$ChatDaoMixin {
  ChatDao(super.db);

  Stream<List<Chat>> watchAllChats() {
    return (select(chats)
          ..orderBy([(t) => OrderingTerm.desc(t.importedAt)]))
        .watch();
  }

  Future<Chat> getChat(int chatId) {
    return (select(chats)..where((t) => t.id.equals(chatId))).getSingle();
  }

  Future<int> insertChat(ChatsCompanion chat) => into(chats).insert(chat);

  Future<void> deleteChat(int chatId) async {
    await (delete(chats)..where((t) => t.id.equals(chatId))).go();
  }

  Future<void> updateIcon(int chatId, String? iconKey) {
    return (update(chats)..where((t) => t.id.equals(chatId)))
        .write(ChatsCompanion(iconKey: Value(iconKey)));
  }

  Future<void> updateTitle(int chatId, String title) {
    return (update(chats)..where((t) => t.id.equals(chatId)))
        .write(ChatsCompanion(title: Value(title)));
  }

  Future<void> updateLocked(int chatId, bool locked) {
    return (update(chats)..where((t) => t.id.equals(chatId)))
        .write(ChatsCompanion(isLocked: Value(locked)));
  }
}
