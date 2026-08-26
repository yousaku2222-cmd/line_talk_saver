import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../../photo_association/photo_attach_service.dart';
import '../../photo_association/ui/pending_photo_args.dart';
import '../ui/import_screen_args.dart';

/// Watches for a LINE chat .txt export shared into the app via the OS share
/// sheet (Android `ACTION_SEND`) and pushes the import screen with that
/// file pre-loaded, both for a cold start and while the app is running.
class ShareIntentListener {
  ShareIntentListener(this._navigatorKey);

  final GlobalKey<NavigatorState> _navigatorKey;
  StreamSubscription<List<SharedMediaFile>>? _subscription;

  Future<void> start() async {
    final initial = await ReceiveSharingIntent.instance.getInitialMedia();
    _handle(initial);

    _subscription = ReceiveSharingIntent.instance.getMediaStream().listen(
          _handle,
          onError: (Object _) {},
        );
  }

  void dispose() {
    _subscription?.cancel();
  }

  Future<void> _handle(List<SharedMediaFile> files) async {
    if (files.isEmpty) return;

    // LINE's "トークをテキストで送信" is normally delivered as a .txt file
    // attachment, but depending on OS/LINE version the share sheet may
    // instead hand over the chat content as inline text -- handle both so
    // neither delivery path silently drops the share.
    SharedMediaFile? firstWhereOrNull(bool Function(SharedMediaFile) test) {
      for (final f in files) {
        if (test(f)) return f;
      }
      return null;
    }

    // Some OS/plugin version combos classify a shared LINE .txt file as
    // SharedMediaType.text even though `path` is actually a real cached
    // file on disk, not the literal text -- this used to make the app
    // "import" the file path string itself as if it were chat content
    // (0 messages, since the path obviously matches no parser pattern).
    // Checking the filesystem directly is more reliable than trusting
    // `type` alone.
    bool looksLikeTxtFile(SharedMediaFile f) =>
        f.path.toLowerCase().endsWith('.txt') && File(f.path).existsSync();

    bool looksLikeImage(SharedMediaFile f) =>
        f.type == SharedMediaType.image ||
        (f.mimeType?.startsWith('image/') ?? false);

    bool looksLikeVideo(SharedMediaFile f) =>
        f.type == SharedMediaType.video ||
        (f.mimeType?.startsWith('video/') ?? false);

    // Any other file share (PDF, Word, Excel, etc.) attached to a
    // `[ファイル]` placeholder the same way photos/videos attach to theirs.
    bool looksLikeDocument(SharedMediaFile f) =>
        !looksLikeTxtFile(f) &&
        !looksLikeImage(f) &&
        !looksLikeVideo(f) &&
        f.type != SharedMediaType.text &&
        f.type != SharedMediaType.url;

    final txtFile = firstWhereOrNull(looksLikeTxtFile);
    final textShare = firstWhereOrNull(
      (f) => f.type == SharedMediaType.text && !looksLikeTxtFile(f),
    );
    // One or more photos/videos/documents shared directly from LINE (or any
    // other app, including a multi-select share of several at once) --
    // checked only once neither of the chat-export paths above matched.
    final pendingFiles = txtFile == null && textShare == null
        ? files
              .where(
                (f) => looksLikeImage(f) || looksLikeVideo(f) || looksLikeDocument(f),
              )
              .toList()
        : const <SharedMediaFile>[];

    if (txtFile == null && textShare == null && pendingFiles.isEmpty) return;
    ReceiveSharingIntent.instance.reset();

    if (txtFile != null) {
      _navigatorKey.currentState?.pushNamed(
        '/import',
        arguments: ImportScreenArgs.file(txtFile.path),
      );
    } else if (textShare != null) {
      _navigatorKey.currentState?.pushNamed(
        '/import',
        arguments: ImportScreenArgs.text(textShare.path),
      );
    } else {
      final persistedPaths = <String>[];
      for (final f in pendingFiles) {
        if (looksLikeDocument(f)) {
          final bytes = await File(f.path).readAsBytes();
          final name = f.path.split(RegExp(r'[\\/]')).last;
          persistedPaths.add(await persistFileBytes(bytes, name));
        } else {
          persistedPaths.add(await persistPhotoFile(f.path));
        }
      }
      _navigatorKey.currentState?.pushNamed(
        '/pick-chat-for-photo',
        arguments: PendingPhotoArgs(persistedPaths),
      );
    }
  }
}
