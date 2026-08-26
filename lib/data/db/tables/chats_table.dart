import 'package:drift/drift.dart';

class Chats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get importedAt => dateTime()();
  TextColumn get sourceFileName => text()();
  TextColumn get rawTxtPath => text()();

  /// Key into `chatIconOptions` (see chat_icon_options.dart) for the icon
  /// shown in the chat list; null falls back to the default icon.
  TextColumn get iconKey => text().nullable()();

  /// When true, opening this chat requires device authentication
  /// (see AppLockService), independent of the app-wide lock setting.
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();
}
