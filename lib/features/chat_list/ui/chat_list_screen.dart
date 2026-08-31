import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/ui/empty_state.dart';
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
            return EmptyState(
              icon: Icons.forum_outlined,
              message: l10n.emptyChatListMessage,
              action: FilledButton.icon(
                onPressed: () => Navigator.of(context).pushNamed('/import'),
                icon: const Icon(Icons.file_open_outlined),
                label: Text(l10n.importButtonLabel),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.x2,
              AppSpacing.screen,
              96,
            ),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Dismissible(
                  key: ValueKey(chat.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  confirmDismiss: (_) => _confirmDelete(context),
                  onDismissed: (_) =>
                      ref.read(chatRepositoryProvider).deleteChat(chat.id),
                  child: _ChatCard(
                    chat: chat,
                    onTap: () => _openChat(context, ref, chat),
                    onIconTap: () => _pickIcon(context, ref, chat),
                    onRename: () => _renameChat(context, ref, chat),
                    onToggleLock: () => _toggleLock(context, ref, chat),
                    onDelete: () => _deleteChat(context, ref, chat),
                  ),
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

  Future<void> _deleteChat(
    BuildContext context,
    WidgetRef ref,
    Chat chat,
  ) async {
    if (!await _confirmDelete(context)) return;
    await ref.read(chatRepositoryProvider).deleteChat(chat.id);
  }
}

/// A single chat row: a soft icon tile (tap to change icon), the title with
/// its lock / 写真ルーム markers, a one-line meta subtitle, and an overflow
/// menu carrying rename / lock / delete.
class _ChatCard extends StatelessWidget {
  const _ChatCard({
    required this.chat,
    required this.onTap,
    required this.onIconTap,
    required this.onRename,
    required this.onToggleLock,
    required this.onDelete,
  });

  final Chat chat;
  final VoidCallback onTap;
  final VoidCallback onIconTap;
  final VoidCallback onRename;
  final VoidCallback onToggleLock;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final isRoom = chat.sourceFileName.isEmpty;
    final metaTime = DateFormat('yyyy/MM/dd HH:mm').format(chat.importedAt);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Row(
            children: [
              GestureDetector(
                onTap: onIconTap,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(
                        chatIconForKey(chat.iconKey),
                        size: 24,
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                    if (isRoom)
                      Positioned(
                        right: -3,
                        bottom: -3,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: scheme.surface,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.photo_library_outlined,
                            size: 11,
                            color: scheme.onPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (chat.isLocked) ...[
                          Icon(Icons.lock, size: 15, color: scheme.error),
                          const SizedBox(width: 4),
                        ],
                        Flexible(
                          child: Text(
                            chat.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isRoom) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.primaryContainer,
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                            child: Text(
                              l10n.manualRoomBadgeLabel,
                              style: textTheme.labelSmall?.copyWith(
                                color: scheme.onPrimaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      isRoom
                          ? l10n.createdAtLabel(metaTime)
                          : l10n.importedAtLabel(metaTime),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: scheme.onSurfaceVariant),
                onSelected: (value) {
                  switch (value) {
                    case 'rename':
                      onRename();
                    case 'lock':
                      onToggleLock();
                    case 'delete':
                      onDelete();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'rename',
                    child: _MenuRow(
                      icon: Icons.edit_outlined,
                      label: l10n.renameChatTooltip,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'lock',
                    child: _MenuRow(
                      icon: chat.isLocked
                          ? Icons.lock_open_outlined
                          : Icons.lock_outline,
                      label: chat.isLocked
                          ? l10n.chatUnlockTooltip
                          : l10n.chatLockTooltip,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: _MenuRow(
                      icon: Icons.delete_outline,
                      label: l10n.delete,
                      color: scheme.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: AppSpacing.x3),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}
