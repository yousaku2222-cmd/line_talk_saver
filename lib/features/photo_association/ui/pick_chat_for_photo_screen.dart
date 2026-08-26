import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/db/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../app_lock/authenticate.dart';
import '../../chat_detail/ui/chat_detail_screen_args.dart';
import '../../chat_list/providers/chat_list_provider.dart';
import '../../monetization/ads/banner_ad_widget.dart';
import 'pending_photo_args.dart';
import 'photo_gallery_screen_args.dart';

/// Shown right after a photo is shared into the app from another app (e.g.
/// LINE), so the user can pick which chat -- and then which message -- to
/// attach it to.
class PickChatForPhotoScreen extends ConsumerWidget {
  const PickChatForPhotoScreen({super.key, required this.args});

  final PendingPhotoArgs args;

  /// A locked chat must be unlocked the same way as opening it normally --
  /// otherwise sharing media in from another app would be a way to add
  /// content into a locked chat without ever authenticating.
  Future<void> _selectChat(BuildContext context, WidgetRef ref, Chat chat) async {
    if (chat.isLocked) {
      final l10n = AppLocalizations.of(context)!;
      final available = await canAuthenticate(ref);
      if (!available) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.appLockUnsupportedMessage)));
        return;
      }
      if (!context.mounted) return;
      final ok = await requestAuthentication(
        context,
        ref,
        reason: l10n.chatLockAuthReason,
      );
      if (!ok || !context.mounted) return;
    }
    Navigator.of(context).pushReplacementNamed(
      chat.sourceFileName.isEmpty ? '/photos' : '/chat',
      arguments: chat.sourceFileName.isEmpty
          ? PhotoGalleryScreenArgs(
              chatId: chat.id,
              pendingPhotoPaths: args.localFilePaths,
            )
          : ChatDetailScreenArgs(
              chatId: chat.id,
              pendingPhotoPaths: args.localFilePaths,
            ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(chatListProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.pickChatForPhotoTitle)),
      body: chatsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text(l10n.loadErrorWithMessage(err))),
        data: (chats) {
          if (chats.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l10n.noChatsForPhotoMessage,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            itemCount: chats.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.forum)),
                title: Row(
                  children: [
                    if (chat.isLocked) ...[
                      Icon(
                        Icons.lock,
                        size: 16,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Flexible(
                      child: Text(
                        chat.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  l10n.importedAtLabel(
                    DateFormat('yyyy/MM/dd HH:mm').format(chat.importedAt),
                  ),
                ),
                onTap: () => _selectChat(context, ref, chat),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const SafeArea(child: DismissibleBannerAd()),
    );
  }
}
