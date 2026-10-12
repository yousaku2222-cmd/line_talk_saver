import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/chat_dao.dart';
import 'daos/image_attachment_dao.dart';
import 'daos/message_dao.dart';
import 'tables/chats_table.dart';
import 'tables/image_attachments_table.dart';
import 'tables/messages_table.dart';
import 'tables/senders_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Chats, Senders, Messages, ImageAttachments],
  daos: [ChatDao, MessageDao, ImageAttachmentDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'line_talk_saver'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(chats, chats.iconKey);
      }
      if (from < 3) {
        await m.addColumn(chats, chats.isLocked);
      }
      if (from < 4) {
        await m.addColumn(chats, chats.isFavorite);
      }
      if (from < 5) {
        await m.addColumn(chats, chats.selfSenderName);
      }
    },
    // Before 1.3.2 deleting a chat removed only its chats row, leaving its
    // messages, senders and attachments behind (still counted by the
    // dashboard, still in backups). Sweep any such leftovers on every open;
    // with nothing orphaned these are cheap no-op deletes.
    beforeOpen: (details) async {
      if (details.wasCreated) return;
      for (final path in await deleteOrphanedRows()) {
        try {
          await File(path).delete();
        } on FileSystemException {
          // Already gone -- nothing to clean up.
        }
      }
    },
  );

  /// Deletes rows whose chat no longer exists and returns the attachment
  /// file paths they referenced, so the caller can remove the files too.
  Future<List<String>> deleteOrphanedRows() {
    return transaction(() async {
      final orphanAttachments = await (select(imageAttachments)
            ..where((t) => t.chatId.isNotInQuery(selectOnly(chats)..addColumns([chats.id]))))
          .get();
      await customStatement(
        'DELETE FROM image_attachments WHERE chat_id NOT IN (SELECT id FROM chats)',
      );
      await customStatement(
        'DELETE FROM messages WHERE chat_id NOT IN (SELECT id FROM chats)',
      );
      await customStatement(
        'DELETE FROM senders WHERE chat_id NOT IN (SELECT id FROM chats)',
      );
      return [for (final a in orphanAttachments) a.localFilePath];
    });
  }

  /// Deletes [chatId] with everything stored under it and returns its
  /// attachment file paths, for the caller to remove from disk.
  Future<List<String>> deleteChatWithContents(int chatId) {
    return transaction(() async {
      final attachments = await (select(imageAttachments)
            ..where((t) => t.chatId.equals(chatId)))
          .get();
      await (delete(imageAttachments)..where((t) => t.chatId.equals(chatId)))
          .go();
      await (delete(messages)..where((t) => t.chatId.equals(chatId))).go();
      await (delete(senders)..where((t) => t.chatId.equals(chatId))).go();
      await (delete(chats)..where((t) => t.id.equals(chatId))).go();
      return [for (final a in attachments) a.localFilePath];
    });
  }
}
