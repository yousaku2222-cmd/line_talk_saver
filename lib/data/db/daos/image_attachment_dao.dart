import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/image_attachments_table.dart';

part 'image_attachment_dao.g.dart';

@DriftAccessor(tables: [ImageAttachments])
class ImageAttachmentDao extends DatabaseAccessor<AppDatabase>
    with _$ImageAttachmentDaoMixin {
  ImageAttachmentDao(super.db);

  Stream<List<ImageAttachment>> watchForChat(int chatId) {
    return (select(imageAttachments)..where((t) => t.chatId.equals(chatId)))
        .watch();
  }

  Future<List<ImageAttachment>> getAll() => select(imageAttachments).get();

  Future<void> updateLocalFilePath(int id, String newPath) {
    return (update(imageAttachments)..where((t) => t.id.equals(id)))
        .write(ImageAttachmentsCompanion(localFilePath: Value(newPath)));
  }

  Future<int> attachToMessage({
    required int chatId,
    required int? messageId,
    required String localFilePath,
  }) {
    return into(imageAttachments).insert(
      ImageAttachmentsCompanion.insert(
        chatId: chatId,
        messageId: Value(messageId),
        localFilePath: localFilePath,
        addedAt: DateTime.now(),
      ),
    );
  }

  Future<List<ImageAttachment>> getForMessages(List<int> messageIds) {
    return (select(
      imageAttachments,
    )..where((t) => t.messageId.isIn(messageIds))).get();
  }

  Future<void> deleteAttachment(int id) {
    return (delete(imageAttachments)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteAttachmentsForMessages(List<int> messageIds) {
    return (delete(
      imageAttachments,
    )..where((t) => t.messageId.isIn(messageIds))).go();
  }
}
