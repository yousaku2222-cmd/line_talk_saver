import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../chat_detail/ui/chat_detail_screen_args.dart';
import '../providers/cross_search_provider.dart';

/// Keyword search across every saved chat at once (as opposed to the
/// in-chat filter sheet, which only searches the currently open chat).
class CrossSearchScreen extends ConsumerStatefulWidget {
  const CrossSearchScreen({super.key});

  @override
  ConsumerState<CrossSearchScreen> createState() => _CrossSearchScreenState();
}

class _CrossSearchScreenState extends ConsumerState<CrossSearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final query = ref.watch(crossSearchQueryProvider);
    final resultsAsync = ref.watch(crossSearchResultsProvider);
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l10n.crossSearchHint,
            border: InputBorder.none,
          ),
          onChanged: (value) =>
              ref.read(crossSearchQueryProvider.notifier).state = value,
        ),
      ),
      body: query.trim().isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screen),
                child: Text(
                  l10n.crossSearchPrompt,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          : resultsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) =>
                  Center(child: Text(l10n.loadErrorWithMessage(err))),
              data: (results) {
                if (results.isEmpty) {
                  return Center(
                    child: Text(l10n.crossSearchNoResults),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.screen),
                  itemCount: results.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x2),
                  itemBuilder: (context, index) {
                    final result = results[index];
                    return Card(
                      margin: EdgeInsets.zero,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        onTap: () => Navigator.of(context).pushNamed(
                          '/chat',
                          arguments: ChatDetailScreenArgs(
                            chatId: result.chatId,
                            initialTextQuery: query,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.x3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      result.chatTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Text(
                                    dateFormat.format(result.message.timestamp),
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              if (result.senderName.isNotEmpty)
                                Text(
                                  result.senderName,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              const SizedBox(height: 2),
                              Text(
                                result.message.rawText,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
