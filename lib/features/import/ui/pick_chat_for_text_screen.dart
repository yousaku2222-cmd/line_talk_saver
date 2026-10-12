import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/db/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../app_lock/authenticate.dart';
import '../../chat_detail/ui/chat_detail_screen_args.dart';
import '../../chat_list/providers/chat_list_provider.dart';
import '../../monetization/ads/banner_ad_widget.dart';

/// Shown when text shared in from LINE is not a chat-history export but a
/// single message (LINE's per-message share hands over only the bare text,
/// with no sender or time), so the user can add it to a chat as one message.
class PickChatForTextScreen extends ConsumerStatefulWidget {
  const PickChatForTextScreen({super.key, required this.text});

  final String text;

  @override
  ConsumerState<PickChatForTextScreen> createState() =>
      _PickChatForTextScreenState();
}

class _PickChatForTextScreenState extends ConsumerState<PickChatForTextScreen> {
  bool _saving = false;

  Future<void> _openChat(int chatId) async {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.sharedTextSavedMessage)));
    await Navigator.of(context).pushReplacementNamed(
      '/chat',
      arguments: ChatDetailScreenArgs(chatId: chatId),
    );
  }

  Future<void> _saveAsNewChat() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _saving = true);
    final chatId = await ref.read(chatRepositoryProvider).createChatFromSharedText(
          title: l10n.sharedTextNewChatTitle(
            DateFormat('yyyy/MM/dd').format(DateTime.now()),
          ),
          text: widget.text,
          senderName: l10n.sharedTextSenderName,
        );
    if (!mounted) return;
    await _openChat(chatId);
  }

  /// A locked chat must be unlocked the same way as opening it normally --
  /// otherwise sharing text in would add content to it without
  /// authenticating.
  Future<void> _addToChat(Chat chat) async {
    final l10n = AppLocalizations.of(context)!;
    if (chat.isLocked) {
      final available = await canAuthenticate(ref);
      if (!available) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.appLockUnsupportedMessage)),
        );
        return;
      }
      if (!mounted) return;
      final ok = await requestAuthentication(
        context,
        ref,
        reason: l10n.chatLockAuthReason,
      );
      if (!ok || !mounted) return;
    }
    setState(() => _saving = true);
    await ref.read(chatRepositoryProvider).appendSharedText(
          chatId: chat.id,
          text: widget.text,
          senderName: l10n.sharedTextSenderName,
        );
    if (!mounted) return;
    await _openChat(chat.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final chatsAsync = ref.watch(chatListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.pickChatForTextTitle)),
      body: _saving
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(
                    l10n.pickChatForTextLead,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      widget.text,
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: scheme.primaryContainer,
                    child: Icon(Icons.add, color: scheme.onPrimaryContainer),
                  ),
                  title: Text(l10n.sharedTextNewChatButton),
                  onTap: _saveAsNewChat,
                ),
                const Divider(height: 1),
                ...chatsAsync.when(
                  loading: () => const [
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ],
                  error: (err, st) => [
                    Center(child: Text(l10n.loadErrorWithMessage(err))),
                  ],
                  // Photo-only rooms (empty sourceFileName) open as a photo
                  // gallery with no timeline, so a text message has nowhere
                  // to show there.
                  data: (chats) => [
                    for (final chat
                        in chats.where((c) => c.sourceFileName.isNotEmpty))
                      ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.forum)),
                        title: Row(
                          children: [
                            if (chat.isLocked) ...[
                              Icon(Icons.lock, size: 16, color: scheme.error),
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
                            DateFormat('yyyy/MM/dd HH:mm')
                                .format(chat.importedAt),
                          ),
                        ),
                        onTap: () => _addToChat(chat),
                      ),
                  ],
                ),
              ],
            ),
      bottomNavigationBar: const SafeArea(child: DismissibleBannerAd()),
    );
  }
}
