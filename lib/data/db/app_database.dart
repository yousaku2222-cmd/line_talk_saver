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
  int get schemaVersion => 3;

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
    },
  );
}
