// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dao.dart';

// ignore_for_file: type=lint
mixin _$MessageDaoMixin on DatabaseAccessor<AppDatabase> {
  $ChatsTable get chats => attachedDatabase.chats;
  $SendersTable get senders => attachedDatabase.senders;
  $MessagesTable get messages => attachedDatabase.messages;
  MessageDaoManager get managers => MessageDaoManager(this);
}

class MessageDaoManager {
  final _$MessageDaoMixin _db;
  MessageDaoManager(this._db);
  $$ChatsTableTableManager get chats =>
      $$ChatsTableTableManager(_db.attachedDatabase, _db.chats);
  $$SendersTableTableManager get senders =>
      $$SendersTableTableManager(_db.attachedDatabase, _db.senders);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db.attachedDatabase, _db.messages);
}
