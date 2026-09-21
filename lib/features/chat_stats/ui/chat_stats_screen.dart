import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../chat_detail/providers/chat_detail_provider.dart';
import '../../monetization/ads/rewarded_ad_service.dart';
import '../../monetization/purchase/purchase_prefs.dart';
import '../../search/providers/message_filter.dart';
import '../chat_stats_calculator.dart';
import '../stats_prefs.dart';
import 'monthly_bar_chart.dart';

/// Entry point for the トーク統計 screen: gates on today's one free viewing
/// (unlimited for ads-removed users), offering a rewarded ad for any extra
/// viewing the same day, then pushes [ChatStatsScreen] once allowed.
Future<void> showChatStatsScreen(
  BuildContext context,
  WidgetRef ref,
  int chatId,
) async {
  final l10n = AppLocalizations.of(context)!;
  final adsRemoved = ref.read(adsRemovedProvider);

  if (!adsRemoved && !canUseChatStatsFree(ref)) {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.chatStatsGateDialogTitle),
        content: Text(l10n.chatStatsGateDialogBody),
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
    // Paying (ads-removed) users never spend their free daily viewing --
    // they always have unlimited access, so there's nothing to record.
    await markChatStatsFreeUseToday(ref);
  }

  if (!context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => ChatStatsScreen(chatId: chatId)),
  );
}

class ChatStatsScreen extends ConsumerWidget {
  const ChatStatsScreen({super.key, required this.chatId});

  final int chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final messagesAsync = ref.watch(
      chatMessagesProvider((chatId, MessageFilter.empty)),
    );
    final sendersAsync = ref.watch(chatSendersProvider(chatId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatStatsScreenTitle)),
      body: messagesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.loadErrorWithMessage(e.toString()))),
        data: (messages) {
          final senders = sendersAsync.valueOrNull ?? const {};
          final stats = ChatStatsCalculator.compute(messages, senders);
          if (stats.totalMessages == 0) {
            return Center(child: Text(l10n.chatStatsNoDataMessage));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionCard(
                title: l10n.chatStatsSectionHeatmapTitle,
                child: MonthlyBarChart(
                  monthlyCounts: stats.monthlyCounts,
                  peakMonth: stats.peakMonth,
                ),
              ),
              const SizedBox(height: 16),
              if (stats.isGroup)
                _SectionCard(
                  title: l10n.chatStatsSectionShareTitle,
                  child: _ShareChart(stats: stats),
                )
              else if (stats.senderStats.length == 2)
                _SectionCard(
                  title: l10n.chatStatsSectionCompatibilityTitle,
                  child: _CompatibilityCard(stats: stats),
                ),
              const SizedBox(height: 16),
              _SectionCard(
                title: l10n.chatStatsSectionTimeOfDayTitle,
                child: _TimeOfDaySection(stats: stats),
              ),
              if (stats.questionsAsked > 0) ...[
                const SizedBox(height: 16),
                _SectionCard(
                  title: l10n.chatStatsSectionQuestionCatchTitle,
                  child: _QuestionCatchRateSection(stats: stats),
                ),
              ],
            ],
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

class _ShareChart extends StatelessWidget {
  const _ShareChart({required this.stats});

  final ChatStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final palette = [
      scheme.primary,
      scheme.secondary,
      scheme.tertiary,
      scheme.error,
      scheme.outline,
    ];

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 32,
              sections: [
                for (var i = 0; i < stats.senderStats.length; i++)
                  PieChartSectionData(
                    value: stats.senderStats[i].messageCount.toDouble(),
                    color: palette[i % palette.length],
                    title: '${(stats.senderStats[i].share * 100).round()}%',
                    radius: 48,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            for (var i = 0; i < stats.senderStats.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: palette[i % palette.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        stats.senderStats[i].name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${l10n.chatStatsMessageCountLabel} ${stats.senderStats[i].messageCount}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _CompatibilityCard extends StatelessWidget {
  const _CompatibilityCard({required this.stats});

  final ChatStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final a = stats.senderStats[0];
    final b = stats.senderStats[1];

    String? fasterReplyName;
    if (a.avgReplyTime != null && b.avgReplyTime != null) {
      fasterReplyName =
          a.avgReplyTime! <= b.avgReplyTime! ? a.name : b.name;
    }
    final moreInitiationsName =
        a.initiatedCount == b.initiatedCount
            ? null
            : (a.initiatedCount > b.initiatedCount ? a.name : b.name);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _senderHeader(context, a.name, scheme.primary)),
            Expanded(child: _senderHeader(context, b.name, scheme.secondary)),
          ],
        ),
        const SizedBox(height: 12),
        _compareRow(
          context,
          label: l10n.chatStatsAvgReplyTimeLabel,
          left: _formatDuration(l10n, a.avgReplyTime),
          right: _formatDuration(l10n, b.avgReplyTime),
        ),
        _compareRow(
          context,
          label: l10n.chatStatsInitiatedCountLabel,
          left: '${a.initiatedCount}',
          right: '${b.initiatedCount}',
        ),
        _compareRow(
          context,
          label: l10n.chatStatsStampRatioLabel,
          left: '${(a.stampRatio * 100).round()}%',
          right: '${(b.stampRatio * 100).round()}%',
        ),
        if (fasterReplyName != null || moreInitiationsName != null) ...[
          const SizedBox(height: 12),
          Divider(color: scheme.outlineVariant),
          const SizedBox(height: 8),
          if (fasterReplyName != null)
            Text(
              l10n.chatStatsFasterReplyLabel(fasterReplyName),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (moreInitiationsName != null)
            Text(
              l10n.chatStatsMoreInitiationsLabel(moreInitiationsName),
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ],
    );
  }

  Widget _senderHeader(BuildContext context, String name, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _compareRow(
    BuildContext context, {
    required String label,
    required String left,
    required String right,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.bodySmall),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(child: Text(left, style: textTheme.bodyMedium)),
              Expanded(child: Text(right, style: textTheme.bodyMedium)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(AppLocalizations l10n, Duration? d) {
    if (d == null) return l10n.chatStatsNoReplyDataLabel;
    return l10n.chatStatsDurationMinutes(d.inMinutes.clamp(0, 999));
  }
}

class _TimeOfDaySection extends StatelessWidget {
  const _TimeOfDaySection({required this.stats});

  final ChatStats stats;

  static String _segmentLabel(AppLocalizations l10n, TimeOfDaySegment seg) {
    switch (seg) {
      case TimeOfDaySegment.lateNight:
        return l10n.chatStatsTimeSegmentLateNight;
      case TimeOfDaySegment.morning:
        return l10n.chatStatsTimeSegmentMorning;
      case TimeOfDaySegment.day:
        return l10n.chatStatsTimeSegmentDay;
      case TimeOfDaySegment.evening:
        return l10n.chatStatsTimeSegmentEvening;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        for (final s in stats.senderStats)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(s.name, overflow: TextOverflow.ellipsis),
                ),
                Text(
                  '${_segmentLabel(l10n, s.dominantTimeSegment)}'
                  ' (${(s.dominantTimeSegmentRatio * 100).round()}%)',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _QuestionCatchRateSection extends StatelessWidget {
  const _QuestionCatchRateSection({required this.stats});

  final ChatStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      l10n.chatStatsQuestionCatchRateValue(
        (stats.questionCatchRate * 100).round(),
        stats.questionsAnswered,
        stats.questionsAsked,
      ),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
