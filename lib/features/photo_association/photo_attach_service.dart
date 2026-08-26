import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Copies an arbitrary source file (a gallery pick, or a photo shared in
/// from another app) into the app's own documents directory -- the source
/// path is often a transient cache location -- so it stays available for as
/// long as the chat does. Returns the copied file's path.
Future<String> persistPhotoFile(String sourcePath) async {
  final dir = await getApplicationDocumentsDirectory();
  final photosDir = Directory('${dir.path}${Platform.pathSeparator}photos');
  if (!await photosDir.exists()) {
    await photosDir.create(recursive: true);
  }

  final ext = sourcePath.contains('.') ? sourcePath.split('.').last : 'jpg';
  final destPath =
      '${photosDir.path}${Platform.pathSeparator}${DateTime.now().millisecondsSinceEpoch}.$ext';
  await File(sourcePath).copy(destPath);
  return destPath;
}

/// Lets the user pick a photo from the gallery and persists it via
/// [persistPhotoFile]. Returns null if the user cancelled.
Future<String?> pickAndPersistPhoto() async {
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (picked == null) return null;
  return persistPhotoFile(picked.path);
}

/// Lets the user pick a video from the gallery and persists it via
/// [persistPhotoFile]. Returns null if the user cancelled.
Future<String?> pickAndPersistVideo() async {
  final picked = await ImagePicker().pickVideo(source: ImageSource.gallery);
  if (picked == null) return null;
  return persistPhotoFile(picked.path);
}

/// Copies [bytes] into the app's `photos/` directory, keeping
/// [originalFileName] (sanitized) as part of the stored file's name -- see
/// `documentDisplayName` in media_kind.dart, which recovers it for display.
/// Unlike photos/videos, a document attachment's real name matters: the
/// user needs to recognize "契約書.docx" rather than a bare timestamp.
Future<String> persistFileBytes(List<int> bytes, String originalFileName) async {
  final dir = await getApplicationDocumentsDirectory();
  final photosDir = Directory('${dir.path}${Platform.pathSeparator}photos');
  if (!await photosDir.exists()) {
    await photosDir.create(recursive: true);
  }

  final safeName = originalFileName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  final destPath =
      '${photosDir.path}${Platform.pathSeparator}${DateTime.now().millisecondsSinceEpoch}_$safeName';
  await File(destPath).writeAsBytes(bytes);
  return destPath;
}

/// Lets the user pick any file (PDF, Word, Excel, etc.) and persists it via
/// [persistFileBytes]. Returns null if the user cancelled.
Future<String?> pickAndPersistFile() async {
  final picked = await FilePicker.pickFiles();
  if (picked.isEmpty) return null;
  final file = picked.single;
  final bytes = await file.readAsBytes();
  return persistFileBytes(bytes, file.name);
}
