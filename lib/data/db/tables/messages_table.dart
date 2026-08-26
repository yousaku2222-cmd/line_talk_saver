import 'package:drift/drift.dart';

import 'chats_table.dart';
import 'senders_table.dart';

class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get chatId => integer().references(Chats, #id)();
  IntColumn get senderId =>
      integer().nullable().references(Senders, #id)();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get rawText => text()();
  BoolColumn get isSystemMessage =>
      boolean().withDefault(const Constant(false))();
  // 'photo' | 'sticker' | 'video' | 'file' | null (no placeholder)
  TextColumn get mediaPlaceholderType => text().nullable()();
  IntColumn get sortIndex => integer()();
}
