import 'package:drift/drift.dart';

import 'chats_table.dart';

class Senders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get chatId => integer().references(Chats, #id)();
  TextColumn get displayName => text()();
}
