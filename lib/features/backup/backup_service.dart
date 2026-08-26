import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/providers/app_providers.dart';

const _backupFormatVersion = 1;
const _dbFileName = 'line_talk_saver.sqlite';
const _photosDirName = 'photos';

/// Thrown when a picked file doesn't look like a backup this app produced.
class InvalidBackupFileException implements Exception {}

/// Bundles the local Drift database and every attached photo into a single
/// portable .zip so a user can move their data to a new device -- including
/// Android -> iOS or iOS -> Android, since the archive format itself has no
/// OS dependency (unlike Android Auto Backup or iCloud, which only restore
/// within the same platform, and are capped well below what years of chat
/// history + photos typically need anyway).
class BackupService {
  BackupService(this._ref);

  final WidgetRef _ref;

  Future<File> createBackup() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(docsDir.path, _dbFileName));
    final photosDir = Directory(p.join(docsDir.path, _photosDirName));

    // Closing (then lazily reopening via invalidate) forces SQLite to
    // checkpoint its -wal file into the main database file first, so the
    // copy below is a complete, consistent snapshot rather than missing
    // whatever's still sitting in the write-ahead log.
    await _ref.read(appDatabaseProvider).close();
    _ref.invalidate(appDatabaseProvider);

    final archive = Archive();

    final dbBytes = await dbFile.readAsBytes();
    archive.addFile(ArchiveFile('db/$_dbFileName', dbBytes.length, dbBytes));

    if (photosDir.existsSync()) {
      await for (final entity in photosDir.list()) {
        if (entity is File) {
          final bytes = await entity.readAsBytes();
          archive.addFile(
            ArchiveFile(
              '$_photosDirName/${p.basename(entity.path)}',
              bytes.length,
              bytes,
            ),
          );
        }
      }
    }

    final manifestBytes = utf8.encode(jsonEncode({
      'formatVersion': _backupFormatVersion,
      'createdAt': DateTime.now().toIso8601String(),
    }));
    archive.addFile(
      ArchiveFile('manifest.json', manifestBytes.length, manifestBytes),
    );

    final zipBytes = ZipEncoder().encode(archive);
    if (zipBytes == null) {
      throw StateError('failed to encode backup archive');
    }
    final outDir = await getTemporaryDirectory();
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final outFile = File(p.join(outDir.path, 'line_talk_saver_backup_$stamp.zip'));
    await outFile.writeAsBytes(zipBytes);
    return outFile;
  }

  Future<void> restoreBackup(List<int> zipBytes) async {
    final archive = ZipDecoder().decodeBytes(zipBytes);

    ArchiveFile? find(String name) {
      for (final f in archive.files) {
        if (f.name == name) return f;
      }
      return null;
    }

    final manifestEntry = find('manifest.json');
    final dbEntry = find('db/$_dbFileName');
    if (manifestEntry == null || dbEntry == null || !dbEntry.isFile) {
      throw InvalidBackupFileException();
    }

    final docsDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(docsDir.path, _photosDirName));

    await _ref.read(appDatabaseProvider).close();
    _ref.invalidate(appDatabaseProvider);

    // Drop any sidecar files left by the *old* database so nothing from
    // the previous session gets replayed against the restored file.
    for (final suffix in ['-wal', '-shm', '-journal']) {
      final sidecar = File(p.join(docsDir.path, '$_dbFileName$suffix'));
      if (sidecar.existsSync()) await sidecar.delete();
    }

    final dbFile = File(p.join(docsDir.path, _dbFileName));
    await dbFile.writeAsBytes(dbEntry.content as List<int>);

    if (photosDir.existsSync()) {
      await photosDir.delete(recursive: true);
    }
    await photosDir.create(recursive: true);
    for (final file in archive.files) {
      if (!file.isFile) continue;
      if (!file.name.startsWith('$_photosDirName/')) continue;
      final name = file.name.substring(_photosDirName.length + 1);
      if (name.isEmpty) continue;
      await File(p.join(photosDir.path, name))
          .writeAsBytes(file.content as List<int>);
    }

    // Reopen the (now-restored) database and repoint every attachment's
    // absolute path at this device's photos/ directory -- the backup may
    // have been made on a different device (different OS, different
    // sandbox path), so the path string stored in the DB is only reliable
    // by its filename, not its directory prefix.
    final dao = _ref.read(appDatabaseProvider).imageAttachmentDao;
    for (final attachment in await dao.getAll()) {
      final newPath = p.join(photosDir.path, p.basename(attachment.localFilePath));
      if (newPath != attachment.localFilePath) {
        await dao.updateLocalFilePath(attachment.id, newPath);
      }
    }
  }
}
