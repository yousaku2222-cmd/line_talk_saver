import 'package:drift/drift.dart';

import 'chats_table.dart';
import 'messages_table.dart';

class ImageAttachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get chatId => integer().references(Chats, #id)();
  IntColumn get messageId =>
      integer().nullable().references(Messages, #id)();
  TextColumn get localFilePath => text()();
  DateTimeColumn get addedAt => dateTime()();
}
