import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/db/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../app_lock/authenticate.dart';
import '../../monetization/ads/banner_ad_widget.dart';
import '../../monetization/purchase/purchase_flow.dart';
import '../../monetization/purchase/purchase_prefs.dart';
import '../chat_icon_options.dart';
import '../providers/chat_list_provider.dart';
import 'pick_chat_icon_sheet.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  Future<void> _pickIcon(BuildContext context, WidgetRef ref, Chat chat) async {
    final chosen = await showPickChatIconSheet(
      context,
      ref: ref,
      currentIconKey: chat.iconKey,
    );
    if (chosen == null) return;
    await ref.read(chatRepositoryProvider).updateChatIcon(chat.id, chosen);
  }

  Future<void> _createChatRoom(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.createChatRoomTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: l10n.createChatRoomHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()),
            child: Text(l10n.createChatRoomButton),
          ),
        ],
      ),
    );
    if (title == null || title.isEmpty) return;
    final chatId = await ref.read(chatRepositoryProvider).createEmptyChat(title);
    if (!context.mounted) return;
    Navigator.of(context).pushNamed('/photos', arguments: chatId);
  }

  Future<void> _renameChat(BuildContext context, WidgetRef ref, Chat chat) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: chat.title);
    final title = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.renameChatTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: l10n.createChatRoomHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()),
            child: Text(l10n.renameChatButton),
          ),
        ],
      ),
    );
    if (title == null || title.isEmpty || title == chat.title) return;
    await ref.read(chatRepositoryProvider).renameChat(chat.id, title);
  }

  /// Locking a chat for the first time requires the "広告を非表示にする"
  /// purchase (per-chat lock is bundled with it) -- but a chat that was
  /// already locked before this gate existed stays fully usable for free:
  /// unlocking it, and opening it, never check the purchase state, only
  /// turning a *new* lock on does.
  ///
  /// Turning the lock ON needs no authentication beyond the purchase check
  /// (the owner is choosing to protect a chat); turning it OFF -- and
  /// opening a locked chat at all -- requires the same device
  /// authentication so a locked chat can't be unlocked by anyone else just
  /// by tapping the icon.
  Future<void> _toggleLock(BuildContext context, WidgetRef ref, Chat chat) async {
    final l10n = AppLocalizations.of(context)!;
    if (!chat.isLocked) {
      if (!ref.read(adsRemovedProvider)) {
        final buy = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(l10n.chatLockPaywallTitle),
            content: Text(l10n.chatLockPaywallBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(l10n.purchaseButton),
              ),
            ],
          ),
        );
        if (buy != true || !context.mounted) return;
        await purchaseRemoveAds(context, ref);
        return;
      }
      final available = await canAuthenticate(ref);
      if (!available) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.appLockUnsupportedMessage)));
        return;
      }
      await ref.read(chatRepositoryProvider).setChatLocked(chat.id, true);
      return;
    }
    final ok = await requestAuthentication(
      context,
      ref,
      reason: l10n.chatLockAuthReason,
    );
    if (!ok || !context.mounted) return;
    await ref.read(chatRepositoryProvider).setChatLocked(chat.id, false);
  }

  Future<void> _openChat(BuildContext context, WidgetRef ref, Chat chat) async {
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
    Navigator.of(context).pushNamed(
      chat.sourceFileName.isEmpty ? '/photos' : '/chat',
      arguments: chat.id,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(chatListProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            tooltip: l10n.createChatRoomTitle,
            onPressed: () => _createChatRoom(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsTooltip,
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
        ],
      ),
      body: chatsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text(l10n.loadErrorWithMessage(err))),
        data: (chats) {
          if (chats.isEmpty) {
            return const _EmptyState();
          }
          return ListView.separated(
            itemCount: chats.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final chat = chats[index];
              return Dismissible(
                key: ValueKey(chat.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Theme.of(context).colorScheme.errorContainer,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete_outline),
                ),
                confirmDismiss: (_) => _confirmDelete(context),
                onDismissed: (_) =>
                    ref.read(chatRepositoryProvider).deleteChat(chat.id),
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () => _pickIcon(context, ref, chat),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          child: Icon(chatIconForKey(chat.iconKey)),
                        ),
                        if (chat.sourceFileName.isEmpty)
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.photo_library_outlined,
                                size: 12,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
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
                      if (chat.sourceFileName.isEmpty) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            l10n.manualRoomBadgeLabel,
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text(
                    chat.sourceFileName.isEmpty
                        ? l10n.createdAtLabel(
                            DateFormat('yyyy/MM/dd HH:mm').format(chat.importedAt),
                          )
                        : l10n.importedAtLabel(
                            DateFormat('yyyy/MM/dd HH:mm').format(chat.importedAt),
                          ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          chat.isLocked ? Icons.lock : Icons.lock_open_outlined,
                        ),
                        tooltip: chat.isLocked
                            ? l10n.chatUnlockTooltip
                            : l10n.chatLockTooltip,
                        onPressed: () => _toggleLock(context, ref, chat),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: l10n.renameChatTooltip,
                        onPressed: () => _renameChat(context, ref, chat),
                      ),
                    ],
                  ),
                  onTap: () => _openChat(context, ref, chat),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed('/import'),
        icon: const Icon(Icons.file_open_outlined),
        label: Text(l10n.importButtonLabel),
      ),
      bottomNavigationBar: const SafeArea(child: DismissibleBannerAd()),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteChatConfirmTitle),
        content: Text(l10n.deleteChatConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.forum_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.emptyChatListMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
