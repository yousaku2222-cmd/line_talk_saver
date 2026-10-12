import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:line_talk_saver/data/db/app_database.dart';

Future<int> _seedChat(AppDatabase db, String title) async {
  final chatId = await db.chatDao.insertChat(
    ChatsCompanion.insert(
      title: title,
      importedAt: DateTime(2026),
      sourceFileName: title,
      rawTxtPath: '',
    ),
  );
  await db.messageDao.insertSenders([
    SendersCompanion.insert(chatId: chatId, displayName: '山田'),
  ]);
  final sender = (await db.messageDao.sendersForChat(chatId)).single;
  await db.messageDao.insertMessages([
    for (var i = 0; i < 3; i++)
      MessagesCompanion.insert(
        chatId: chatId,
        senderId: Value(sender.id),
        timestamp: DateTime(2026, 1, 1, 9, i),
        rawText: 'msg $i',
        sortIndex: i,
      ),
  ]);
  await db.imageAttachmentDao.attachToMessage(
    chatId: chatId,
    messageId: null,
    localFilePath: '/photos/$title.jpg',
  );
  return chatId;
}

Future<int> _count(AppDatabase db, String table) async =>
    (await db.customSelect('SELECT COUNT(*) AS c FROM $table').getSingle())
        .read<int>('c');

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('deleting a chat removes its contents and keeps other chats', () async {
    final a = await _seedChat(db, 'a');
    await _seedChat(db, 'b');

    final paths = await db.deleteChatWithContents(a);

    expect(paths, ['/photos/a.jpg']);
    expect(await _count(db, 'chats'), 1);
    expect(await _count(db, 'messages'), 3);
    expect(await _count(db, 'senders'), 1);
    expect(await _count(db, 'image_attachments'), 1);
  });

  test('sweeps rows left behind by an old chats-only delete', () async {
    final a = await _seedChat(db, 'a');
    await _seedChat(db, 'b');
    await db.customStatement('DELETE FROM chats WHERE id = $a');

    final paths = await db.deleteOrphanedRows();

    expect(paths, ['/photos/a.jpg']);
    expect(await _count(db, 'messages'), 3);
    expect(await _count(db, 'senders'), 1);
    expect(await _count(db, 'image_attachments'), 1);
  });
}
