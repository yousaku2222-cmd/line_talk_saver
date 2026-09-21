import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../monetization/ads/rewarded_ad_service.dart';
import '../../monetization/purchase/purchase_prefs.dart';
import '../cross_chat_stats_calculator.dart';
import '../providers/cross_chat_stats_provider.dart';
import '../stats_prefs.dart';
import 'monthly_bar_chart.dart';

/// Entry point for the 全トーク横断ダッシュボード, gated the same way as
/// [showChatStatsScreen] but with its own separate daily-free quota (see
/// [canUseDashboardFree]) -- opening one doesn't spend the other's free
/// viewing for the day.
Future<void> showDashboardScreen(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context)!;
  final adsRemoved = ref.read(adsRemovedProvider);

  if (!adsRemoved && !canUseDashboardFree(ref)) {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.chatDashboardGateDialogTitle),
        content: Text(l10n.chatDashboardGateDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.unlockIconWatchAdButton),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final earned = await RewardedAdService.instance.show();
    if (!context.mounted) return;
    if (!earned) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.unlockIconFailedMessage)),
      );
      return;
    }
  } else if (!adsRemoved) {
    await markDashboardFreeUseToday(ref);
  }

  if (!context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const DashboardScreen()),
  );
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final chatsAsync = ref.watch(allChatsForDashboardProvider);
    final messagesAsync = ref.watch(allMessagesForDashboardProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatDashboardScreenTitle)),
      body: chatsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.loadErrorWithMessage(e.toString()))),
        data: (chats) {
          return messagesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text(l10n.loadErrorWithMessage(e.toString()))),
            data: (messages) {
              final stats = CrossChatStatsCalculator.compute(chats, messages);
              if (stats.totalMessages == 0) {
                return Center(child: Text(l10n.chatDashboardNoDataMessage));
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SectionCard(
                    title: l10n.chatDashboardSectionSummaryTitle,
                    child: Text(
                      l10n.chatDashboardSummaryValue(
                        stats.totalChats,
                        stats.totalMessages,
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: l10n.chatStatsSectionHeatmapTitle,
                    child: MonthlyBarChart(
                      monthlyCounts: stats.monthlyCounts,
                      peakMonth: stats.peakMonth,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: l10n.chatDashboardSectionRankingTitle,
                    child: _RankingList(stats: stats),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _RankingList extends StatelessWidget {
  const _RankingList({required this.stats});

  final CrossChatStats stats;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final maxCount = stats.ranking.first.messageCount;

    return Column(
      children: [
        for (var i = 0; i < stats.ranking.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 22,
                  child: Text('${i + 1}', style: textTheme.bodySmall),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stats.ranking[i].title,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: stats.ranking[i].messageCount / maxCount,
                          minHeight: 6,
                          backgroundColor: scheme.surfaceContainerHigh,
                          color: scheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text('${stats.ranking[i].messageCount}', style: textTheme.bodySmall),
              ],
            ),
          ),
      ],
    );
  }
}
