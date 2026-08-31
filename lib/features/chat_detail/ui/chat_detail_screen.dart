import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/db/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../export/ui/export_options_sheet.dart';
import '../../monetization/ads/banner_ad_widget.dart';
import '../../photo_association/media_kind.dart';
import '../../photo_association/photo_attach_service.dart';
import '../../photo_association/providers/photo_provider.dart';
import '../../search/providers/message_filter.dart';
import '../../search/ui/search_filter_sheet.dart';
import '../providers/chat_detail_provider.dart';
import 'widgets/message_bubble.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.chatId,
    this.pendingPhotoPaths = const [],
  });

  final int chatId;

  /// One or more photos/videos shared into the app from another app (e.g.
  /// a LINE multi-select share), waiting to be attached one at a time to
  /// whichever messages the user taps next, in order.
  final List<String> pendingPhotoPaths;

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  bool _selectionMode = false;
  final _selectedIds = <int>{};
  MessageFilter _filter = MessageFilter.empty;
  late final List<String> _pendingPhotoPaths = [...widget.pendingPhotoPaths];

  Future<void> _openFilterSheet() async {
    final senders =
        ref.read(chatSendersProvider(widget.chatId)).valueOrNull ?? const {};
    final result = await showSearchFilterSheet(
      context,
      senders: senders,
      current: _filter,
    );
    if (result != null) {
      setState(() => _filter = result);
    }
  }

  void _enterSelection(int messageId) {
    setState(() {
      _selectionMode = true;
      _selectedIds.add(messageId);
    });
  }

  void _toggleSelection(int messageId) {
    setState(() {
      if (_selectedIds.contains(messageId)) {
        _selectedIds.remove(messageId);
      } else {
        _selectedIds.add(messageId);
      }
      if (_selectedIds.isEmpty) _selectionMode = false;
    });
  }

  void _cancelSelection() {
    setState(() {
      _selectionMode = false;
      _selectedIds.clear();
    });
  }

  String _formatMessages(List<Message> messages, Map<int, String> senderNames) {
    final unknownSender = AppLocalizations.of(context)!.unknownSender;
    final buffer = StringBuffer();
    for (final m in messages) {
      final name = m.isSystemMessage
          ? null
          : (m.senderId != null ? senderNames[m.senderId] : null) ??
                unknownSender;
      final time = DateFormat('yyyy/MM/dd HH:mm').format(m.timestamp);
      if (name != null) {
        buffer.writeln('[$time] $name: ${m.rawText}');
      } else {
        buffer.writeln('[$time] ${m.rawText}');
      }
    }
    return buffer.toString().trimRight();
  }

  Future<void> _copyToClipboard(String text, {required String label}) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.copiedMessage(label)),
      ),
    );
  }

  Future<void> _attachPhoto(Message message) async {
    final hasPending = _pendingPhotoPaths.isNotEmpty;
    final String? path;
    if (hasPending) {
      path = _pendingPhotoPaths.first;
    } else if (message.mediaPlaceholderType == 'video') {
      path = await pickAndPersistVideo();
    } else if (message.mediaPlaceholderType == 'file') {
      path = await pickAndPersistFile();
    } else {
      path = await pickAndPersistPhoto();
    }
    if (path == null) return;
    await ref
        .read(chatRepositoryProvider)
        .attachImage(
          chatId: widget.chatId,
          messageId: message.id,
          localFilePath: path,
        );
    if (hasPending) await _advancePendingQueue(path);
  }

  /// Attaches the next pending shared item straight to the chat, not tied
  /// to any specific message -- so photos/videos/files shared in from LINE
  /// can be freely imported even into a chat room with no matching
  /// placeholder message to tap (e.g. one created from scratch, or once
  /// all its placeholders are already used up).
  Future<void> _attachPendingDirectly() async {
    if (_pendingPhotoPaths.isEmpty) return;
    final path = _pendingPhotoPaths.first;
    await ref
        .read(chatRepositoryProvider)
        .attachImage(chatId: widget.chatId, localFilePath: path);
    await _advancePendingQueue(path);
  }

  Future<void> _advancePendingQueue(String attachedPath) async {
    setState(() => _pendingPhotoPaths.removeAt(0));
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isDocumentPath(attachedPath)
              ? l10n.fileAttachedMessage
              : l10n.photoAttachedMessage,
        ),
      ),
    );
  }

  /// Swiping a placeholder with an attachment only clears the attachment
  /// (message stays, reverts to "tap to attach"); swiping a bare
  /// placeholder removes the message itself -- so the confirmation shown,
  /// and what actually gets deleted, both depend on [hasAttachment].
  Future<bool> _confirmDeletePlaceholder({required bool hasAttachment}) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          hasAttachment
              ? l10n.deleteAttachmentConfirmTitle
              : l10n.deletePlaceholderConfirmTitle,
        ),
        content: Text(
          hasAttachment
              ? l10n.deleteAttachmentConfirmBody
              : l10n.deletePlaceholderConfirmBody,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _detachSelectedImages() async {
    final l10n = AppLocalizations.of(context)!;
    final count = _selectedIds.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.detachMessagesConfirmTitle),
        content: Text(l10n.detachMessagesConfirmBody(count)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref
        .read(chatRepositoryProvider)
        .detachImagesForMessages(_selectedIds.toList());
    if (!mounted) return;
    _cancelSelection();
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatProvider(widget.chatId));
    final messagesAsync = ref.watch(
      chatMessagesProvider((widget.chatId, _filter)),
    );
    final sendersAsync = ref.watch(chatSendersProvider(widget.chatId));
    final attachmentsAsync = ref.watch(
      chatImageAttachmentsProvider(widget.chatId),
    );
    final attachmentsByMessageId = {
      for (final a in attachmentsAsync.valueOrNull ?? const <ImageAttachment>[])
        if (a.messageId != null) a.messageId!: a,
    };
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(chatAsync.valueOrNull?.title ?? l10n.loadingTitle),
        leading: _selectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _cancelSelection,
              )
            : null,
        actions: [
          if (_selectionMode) ...[
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: l10n.copySelectedTooltip,
              onPressed: messagesAsync.maybeWhen(
                data: (messages) {
                  final senders = sendersAsync.valueOrNull ?? const {};
                  return () {
                    final selected = messages
                        .where((m) => _selectedIds.contains(m.id))
                        .toList();
                    _copyToClipboard(
                      _formatMessages(selected, senders),
                      label: l10n.selectedCountLabel(selected.length),
                    );
                    _cancelSelection();
                  };
                },
                orElse: () => null,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.image_not_supported_outlined),
              tooltip: l10n.detachSelectedTooltip,
              onPressed: _selectedIds.isEmpty ? null : _detachSelectedImages,
            ),
          ] else ...[
            IconButton(
              icon: Badge(
                isLabelVisible: _filter.isActive,
                child: const Icon(Icons.filter_list),
              ),
              tooltip: l10n.filterTooltip,
              onPressed: _openFilterSheet,
            ),
            IconButton(
              icon: const Icon(Icons.ios_share_outlined),
              tooltip: l10n.exportTooltip,
              onPressed: messagesAsync.maybeWhen(
                data: (messages) {
                  if (messages.isEmpty) return null;
                  final senders = sendersAsync.valueOrNull ?? const {};
                  return () => showExportOptionsSheet(
                    context,
                    chatTitle:
                        chatAsync.valueOrNull?.title ??
                        l10n.defaultChatTitleForExport,
                    messages: messages,
                    senderNames: senders,
                  );
                },
                orElse: () => null,
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'photos':
                    Navigator.of(context)
                        .pushNamed('/photos', arguments: widget.chatId);
                  case 'copyAll':
                    final messages = messagesAsync.valueOrNull ?? const [];
                    if (messages.isEmpty) return;
                    final senders = sendersAsync.valueOrNull ?? const {};
                    _copyToClipboard(
                      _formatMessages(messages, senders),
                      label: l10n.allCountLabel(messages.length),
                    );
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'photos',
                  child: Row(
                    children: [
                      const Icon(Icons.photo_library_outlined, size: 20),
                      const SizedBox(width: 12),
                      Text(l10n.photosTooltip),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'copyAll',
                  enabled: (messagesAsync.valueOrNull ?? const []).isNotEmpty,
                  child: Row(
                    children: [
                      const Icon(Icons.copy_all_outlined, size: 20),
                      const SizedBox(width: 12),
                      Text(l10n.copyAllTooltip),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          if (_pendingPhotoPaths.isNotEmpty)
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.attachPendingPhotoBannerMessage(
                            _pendingPhotoPaths.length,
                          ),
                        ),
                        Wrap(
                          spacing: 12,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () =>
                                  setState(_pendingPhotoPaths.clear),
                              child: Text(l10n.cancel),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: _attachPendingDirectly,
                              child: Text(l10n.attachPendingDirectlyButton),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _PendingMediaThumbnail(path: _pendingPhotoPaths.first),
                  if (isDocumentPath(_pendingPhotoPaths.first)) ...[
                    const SizedBox(width: 6),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 90),
                      child: Text(
                        documentDisplayName(_pendingPhotoPaths.first),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) =>
                  Center(child: Text(l10n.loadErrorWithMessage(err))),
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      _filter.isActive
                          ? l10n.noMessagesFiltered
                          : l10n.noMessagesAtAll,
                    ),
                  );
                }
                final senders = sendersAsync.valueOrNull ?? const {};
                // Precompute, in chronological order, whether each message
                // opens a new calendar day (-> date separator) and whether it
                // needs its own name/time header (new day, sender change,
                // >5min gap, or following a system line).
                final showDateSep = <int, bool>{};
                final showHeader = <int, bool>{};
                for (var i = 0; i < messages.length; i++) {
                  final m = messages[i];
                  final prev = i > 0 ? messages[i - 1] : null;
                  final newDay =
                      prev == null || !_sameDay(prev.timestamp, m.timestamp);
                  showDateSep[m.id] = newDay;
                  showHeader[m.id] =
                      m.isSystemMessage ||
                      prev == null ||
                      newDay ||
                      prev.isSystemMessage ||
                      prev.senderId != m.senderId ||
                      m.timestamp.difference(prev.timestamp).inMinutes.abs() >=
                          5;
                }
                // Rendered newest-first with reverse:true so the list opens
                // scrolled to the latest message (like a normal chat app)
                // while still displaying oldest-to-newest top-to-bottom.
                final reversedMessages = messages.reversed.toList();
                return ListView.builder(
                  reverse: true,
                  itemCount: reversedMessages.length,
                  itemBuilder: (context, index) {
                    final message = reversedMessages[index];
                    final senderName = message.senderId != null
                        ? senders[message.senderId]
                        : null;
                    final bubble = MessageBubble(
                      message: message,
                      senderName: senderName,
                      selected: _selectedIds.contains(message.id),
                      selectionMode: _selectionMode,
                      showHeader: showHeader[message.id] ?? true,
                      attachment: attachmentsByMessageId[message.id],
                      onAttachPhoto: _selectionMode
                          ? null
                          : () => _attachPhoto(message),
                      onTap: () {
                        if (_selectionMode) _toggleSelection(message.id);
                      },
                      onLongPress: () {
                        if (message.isSystemMessage) return;
                        if (!_selectionMode) {
                          _enterSelection(message.id);
                        } else {
                          _toggleSelection(message.id);
                        }
                      },
                    );

                    Widget item = bubble;
                    // Swipe-to-delete, like the chat list's own swipe-to-
                    // delete -- only for placeholder messages
                    // (`[写真]`/`[動画]`/etc.), and not while selecting.
                    if (!_selectionMode &&
                        message.mediaPlaceholderType != null) {
                      final attachment = attachmentsByMessageId[message.id];
                      item = Dismissible(
                        key: ValueKey(message.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Theme.of(context).colorScheme.errorContainer,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(
                            Icons.delete_outline,
                            color: Theme.of(context)
                                .colorScheme
                                .onErrorContainer,
                          ),
                        ),
                        confirmDismiss: (_) async {
                          final confirmed = await _confirmDeletePlaceholder(
                            hasAttachment: attachment != null,
                          );
                          if (!confirmed) return false;
                          if (attachment != null) {
                            // Only the attachment goes away; the message
                            // stays (reverts to "tap to attach"), so the
                            // swipe shouldn't actually remove this list item
                            // -- Dismissible animates it back into place.
                            await ref
                                .read(chatRepositoryProvider)
                                .deleteImageAttachment(attachment);
                            return false;
                          }
                          return true;
                        },
                        onDismissed: (_) => ref
                            .read(chatRepositoryProvider)
                            .deletePlaceholderMessage(message.id),
                        child: bubble,
                      );
                    }

                    if (showDateSep[message.id] != true) return item;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _DateSeparator(date: message.timestamp),
                        item,
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SafeArea(child: DismissibleBannerAd()),
    );
  }
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Centered date pill inserted where the transcript crosses midnight.
class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            MaterialLocalizations.of(context).formatFullDate(date),
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

/// A small preview of the next pending shared photo/video, shown alongside
/// the "tap a message to attach" banner so the user can see what they're
/// about to attach.
class _PendingMediaThumbnail extends StatelessWidget {
  const _PendingMediaThumbnail({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final size = 48.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: isVideoPath(path)
          ? Container(
              width: size,
              height: size,
              color: Colors.black87,
              child: const Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 20,
              ),
            )
          : isDocumentPath(path)
          ? Container(
              width: size,
              height: size,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.insert_drive_file_outlined, size: 20),
            )
          : Image.file(
              File(path),
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: size,
                height: size,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.broken_image_outlined, size: 20),
              ),
            ),
    );
  }
}
