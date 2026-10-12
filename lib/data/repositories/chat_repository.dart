import 'dart:io';

import 'package:drift/drift.dart';

import '../db/app_database.dart';

class ChatRepository {
  ChatRepository(this._db);

  final AppDatabase _db;

  Future<void> _deleteFileIfExists(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Stream<List<Chat>> watchAllChats() => _db.chatDao.watchAllChats();

  /// Creates a chat with no imported messages -- a plain room to freely
  /// attach photos/videos/files to (e.g. shared in directly from LINE)
  /// without first needing a `.txt` chat-history export.
  Future<int> createEmptyChat(String title) {
    return _db.chatDao.insertChat(
      ChatsCompanion.insert(
        title: title,
        importedAt: DateTime.now(),
        sourceFileName: '',
        rawTxtPath: '',
      ),
    );
  }

  Future<Chat> getChat(int chatId) => _db.chatDao.getChat(chatId);

  Future<void> deleteChat(int chatId) => _db.chatDao.deleteChat(chatId);

  Future<void> updateChatIcon(int chatId, String? iconKey) =>
      _db.chatDao.updateIcon(chatId, iconKey);

  Future<void> renameChat(int chatId, String title) =>
      _db.chatDao.updateTitle(chatId, title);

  Future<void> setChatLocked(int chatId, bool locked) =>
      _db.chatDao.updateLocked(chatId, locked);

  Future<void> setChatFavorite(int chatId, bool favorite) =>
      _db.chatDao.updateFavorite(chatId, favorite);

  Stream<List<Message>> watchAllMessages() => _db.messageDao.watchAllMessages();

  Stream<List<Sender>> watchAllSenders() => _db.messageDao.watchAllSenders();

  Stream<List<Message>> watchMessages(
    int chatId, {
    List<int>? senderIds,
    DateTime? from,
    DateTime? to,
    String? textQuery,
  }) {
    return _db.messageDao.watchMessages(
      chatId,
      senderIds: senderIds,
      from: from,
      to: to,
      textQuery: textQuery,
    );
  }

  Future<List<Sender>> sendersForChat(int chatId) =>
      _db.messageDao.sendersForChat(chatId);

  /// Appends [text] (a single message shared from LINE, which arrives as
  /// bare text with no sender or time) to the end of [chatId], stamped now
  /// and attributed to a [senderName] sender created on first use.
  Future<void> appendSharedText({
    required int chatId,
    required String text,
    required String senderName,
  }) {
    return _db.transaction(() async {
      final dao = _db.messageDao;
      var sender = (await dao.sendersForChat(chatId))
          .where((s) => s.displayName == senderName)
          .firstOrNull;
      if (sender == null) {
        await dao.insertSenders([
          SendersCompanion.insert(chatId: chatId, displayName: senderName),
        ]);
        sender = (await dao.sendersForChat(chatId))
            .lastWhere((s) => s.displayName == senderName);
      }
      await dao.insertMessages([
        MessagesCompanion.insert(
          chatId: chatId,
          senderId: Value(sender.id),
          timestamp: DateTime.now(),
          rawText: text,
          sortIndex: await dao.nextSortIndex(chatId),
        ),
      ]);
    });
  }

  /// Saves [text] as the first message of a new chat named [title]. Unlike
  /// [createEmptyChat] it gets a non-empty sourceFileName, so it opens as a
  /// normal chat timeline rather than a photo room.
  Future<int> createChatFromSharedText({
    required String title,
    required String text,
    required String senderName,
  }) async {
    final chatId = await _db.chatDao.insertChat(
      ChatsCompanion.insert(
        title: title,
        importedAt: DateTime.now(),
        sourceFileName: title,
        rawTxtPath: '',
      ),
    );
    await appendSharedText(chatId: chatId, text: text, senderName: senderName);
    return chatId;
  }

  Stream<List<ImageAttachment>> watchImageAttachments(int chatId) =>
      _db.imageAttachmentDao.watchForChat(chatId);

  Future<int> attachImage({
    required int chatId,
    int? messageId,
    required String localFilePath,
  }) {
    return _db.imageAttachmentDao.attachToMessage(
      chatId: chatId,
      messageId: messageId,
      localFilePath: localFilePath,
    );
  }

  Future<void> deleteImageAttachment(ImageAttachment attachment) async {
    await _db.imageAttachmentDao.deleteAttachment(attachment.id);
    await _deleteFileIfExists(attachment.localFilePath);
  }

  /// Removes just the attached photos/videos for these messages, leaving
  /// the messages themselves (and their `[写真]`/`[動画]` placeholders)
  /// in place.
  Future<void> detachImagesForMessages(List<int> messageIds) async {
    final attachments = await _db.imageAttachmentDao.getForMessages(messageIds);
    await _db.imageAttachmentDao.deleteAttachmentsForMessages(messageIds);
    for (final attachment in attachments) {
      await _deleteFileIfExists(attachment.localFilePath);
    }
  }

  /// Removes a single `[写真]`/`[動画]`/etc. placeholder message entirely
  /// (unlike [detachImagesForMessages], which keeps the message and only
  /// clears its attachment), along with any attached file it still had.
  Future<void> deletePlaceholderMessage(int messageId) async {
    final attachments = await _db.imageAttachmentDao.getForMessages([messageId]);
    await _db.imageAttachmentDao.deleteAttachmentsForMessages([messageId]);
    await _db.messageDao.deleteMessage(messageId);
    for (final attachment in attachments) {
      await _deleteFileIfExists(attachment.localFilePath);
    }
  }
}
