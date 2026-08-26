// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_attachment_dao.dart';

// ignore_for_file: type=lint
mixin _$ImageAttachmentDaoMixin on DatabaseAccessor<AppDatabase> {
  $ChatsTable get chats => attachedDatabase.chats;
  $SendersTable get senders => attachedDatabase.senders;
  $MessagesTable get messages => attachedDatabase.messages;
  $ImageAttachmentsTable get imageAttachments =>
      attachedDatabase.imageAttachments;
  ImageAttachmentDaoManager get managers => ImageAttachmentDaoManager(this);
}

class ImageAttachmentDaoManager {
  final _$ImageAttachmentDaoMixin _db;
  ImageAttachmentDaoManager(this._db);
  $$ChatsTableTableManager get chats =>
      $$ChatsTableTableManager(_db.attachedDatabase, _db.chats);
  $$SendersTableTableManager get senders =>
      $$SendersTableTableManager(_db.attachedDatabase, _db.senders);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db.attachedDatabase, _db.messages);
  $$ImageAttachmentsTableTableManager get imageAttachments =>
      $$ImageAttachmentsTableTableManager(
        _db.attachedDatabase,
        _db.imageAttachments,
      );
}
