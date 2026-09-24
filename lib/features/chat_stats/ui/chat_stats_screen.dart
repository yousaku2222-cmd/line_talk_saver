import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../chat_detail/providers/chat_detail_provider.dart';
import '../../monetization/ads/rewarded_ad_service.dart';
import '../../monetization/purchase/purchase_prefs.dart';
import '../../search/providers/message_filter.dart';
import '../chat_stats_calculator.dart';
import '../stats_image_share.dart';
import '../stats_prefs.dart';
import 'monthly_bar_chart.dart';
import 'section_card.dart';

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

class ChatStatsScreen extends ConsumerStatefulWidget {
  const ChatStatsScreen({super.key, required this.chatId});

  final int chatId;

  @override
  ConsumerState<ChatStatsScreen> createState() => _ChatStatsScreenState();
}

/// Split across 3 tabs (rather than one long scroll) now that v1+v2+v3
/// stats add up to 9 cards -- each tab's own [RepaintBoundary] backs that
/// tab's "share all" button, so sharing covers everything on the visible
/// tab rather than the whole (now much longer) screen.
class _ChatStatsScreenState extends ConsumerState<ChatStatsScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 3, vsync: this);
  final _overviewKey = GlobalKey();
  final _trendsKey = GlobalKey();
  final _triviaKey = GlobalKey();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  GlobalKey _keyForTab(int index) {
    switch (index) {
      case 0:
        return _overviewKey;
      case 1:
        return _trendsKey;
      default:
        return _triviaKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final messagesAsync = ref.watch(
      chatMessagesProvider((widget.chatId, MessageFilter.empty)),
    );
    final sendersAsync = ref.watch(chatSendersProvider(widget.chatId));

    return messagesAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.chatStatsScreenTitle)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.chatStatsScreenTitle)),
        body: Center(child: Text(l10n.loadErrorWithMessage(e.toString()))),
      ),
      data: (messages) {
        final senders = sendersAsync.valueOrNull ?? const {};
        final stats = ChatStatsCalculator.compute(messages, senders);
        if (stats.totalMessages == 0) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.chatStatsScreenTitle)),
            body: Center(child: Text(l10n.chatStatsNoDataMessage)),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.chatStatsScreenTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.ios_share),
                tooltip: l10n.statsShareAllTooltip,
                onPressed: () => shareWidgetAsImage(
                  _keyForTab(_tabController.index),
                  fileName: l10n.chatStatsScreenTitle,
                ),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: l10n.chatStatsTabOverview),
                Tab(text: l10n.chatStatsTabTrends),
                Tab(text: l10n.chatStatsTabTrivia),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _StatsTabScroll(
                shareKey: _overviewKey,
                children: [
                  SectionCard(
                    title: l10n.chatStatsSectionHeatmapTitle,
                    child: MonthlyBarChart(
                      monthlyCounts: stats.monthlyCounts,
                      peakMonth: stats.peakMonth,
                    ),
                  ),
                  if (stats.isGroup)
                    SectionCard(
                      title: l10n.chatStatsSectionShareTitle,
                      child: _ShareChart(stats: stats),
                    )
                  else if (stats.senderStats.length == 2)
                    SectionCard(
                      title: l10n.chatStatsSectionCompatibilityTitle,
                      child: _CompatibilityCard(stats: stats),
                    ),
                ],
              ),
              _StatsTabScroll(
                shareKey: _trendsKey,
                children: [
                  SectionCard(
                    title: l10n.chatStatsSectionTimeOfDayTitle,
                    child: _TimeOfDaySection(stats: stats),
                  ),
                  if (stats.questionsAsked > 0)
                    SectionCard(
                      title: l10n.chatStatsSectionQuestionCatchTitle,
                      child: _QuestionCatchRateSection(stats: stats),
                    ),
                  SectionCard(
                    title: l10n.chatStatsSectionWeekdayHeatmapTitle,
                    child: _WeekdayHeatmap(stats: stats),
                  ),
                ],
              ),
              _StatsTabScroll(
                shareKey: _triviaKey,
                children: [
                  if (stats.topWords.isNotEmpty)
                    SectionCard(
                      title: l10n.chatStatsSectionWordsTitle,
                      child: _TopWordsList(stats: stats),
                    ),
                  SectionCard(
                    title: l10n.chatStatsSectionTriviaTitle,
                    child: _TriviaSection(stats: stats),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// One tab's worth of [SectionCard]s, scrollable and wrapped in a
/// [RepaintBoundary] (keyed by [shareKey]) so the AppBar's "share all"
/// button can render just this tab to an image.
class _StatsTabScroll extends StatelessWidget {
  const _StatsTabScroll({required this.shareKey, required this.children});

  final GlobalKey shareKey;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: RepaintBoundary(
        key: shareKey,
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i != 0) const SizedBox(height: 16),
                children[i],
              ],
            ],
          ),
        ),
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

class _TopWordsList extends StatelessWidget {
  const _TopWordsList({required this.stats});

  final ChatStats stats;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < stats.topWords.length; i++)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${stats.topWords[i].word} ×${stats.topWords[i].count}',
              style: textTheme.bodySmall?.copyWith(
                color: scheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

/// Weekday (columns) × time-of-day segment (rows) activity grid. Weekday
/// labels use `DateFormat.E` against a known Monday (2024-01-01) so they
/// come out localized without needing our own translated strings.
class _WeekdayHeatmap extends StatelessWidget {
  const _WeekdayHeatmap({required this.stats});

  final ChatStats stats;

  static String _segmentLabel(AppLocalizations l10n, int segIndex) {
    switch (TimeOfDaySegment.values[segIndex]) {
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
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toString();
    final weekdayFormat = DateFormat.E(locale);

    var maxCount = 1;
    for (final row in stats.weekdaySegmentCounts) {
      for (final c in row) {
        if (c > maxCount) maxCount = c;
      }
    }

    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 44),
            for (var wd = 0; wd < 7; wd++)
              Expanded(
                child: Center(
                  child: Text(
                    weekdayFormat.format(DateTime(2024, 1, 1 + wd)),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
          ],
        ),
        for (var seg = 0; seg < 4; seg++)
          Row(
            children: [
              SizedBox(
                width: 44,
                child: Text(
                  _segmentLabel(l10n, seg),
                  style: Theme.of(context).textTheme.labelSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              for (var wd = 0; wd < 7; wd++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(
                            alpha:
                                0.08 +
                                0.82 *
                                    (stats.weekdaySegmentCounts[wd][seg] /
                                        maxCount),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _TriviaSection extends StatelessWidget {
  const _TriviaSection({required this.stats});

  final ChatStats stats;

  static const _oneLinerThreshold = 15;

  /// Formats a gap duration at whichever granularity it's actually
  /// legible at -- most gaps in an active chat are well under a day, so
  /// always showing whole days (as [Duration.inDays] does) rounds almost
  /// everything down to "0日間".
  static String _formatGapDuration(AppLocalizations l10n, Duration d) {
    if (d.inDays >= 1) return l10n.chatStatsDurationDays(d.inDays);
    if (d.inHours >= 1) return l10n.chatStatsDurationHours(d.inHours);
    return l10n.chatStatsDurationMinutes(d.inMinutes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat.MMMd(locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.chatStatsStreakLabel(stats.longestStreakDays),
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 10),
        Text(l10n.chatStatsTopDaysLabel, style: textTheme.bodyMedium),
        const SizedBox(height: 4),
        for (final day in stats.topDays)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              '${dateFormat.format(day.date)}  '
              '${l10n.chatStatsMessageCountLabel} ${day.count}',
              style: textTheme.bodySmall,
            ),
          ),
        if (stats.longestSilenceGap != null) ...[
          const SizedBox(height: 10),
          Text(
            l10n.chatStatsSilenceGapLabel(
              _formatGapDuration(l10n, stats.longestSilenceGap!),
              dateFormat.format(stats.longestSilenceGapStart!),
              dateFormat.format(stats.longestSilenceGapEnd!),
            ),
            style: textTheme.bodyMedium,
          ),
        ],
        const SizedBox(height: 10),
        Text(
          l10n.chatStatsEmojiRateLabel((stats.emojiMessageRate * 100).round()),
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 10),
        for (final s in stats.senderStats)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              l10n.chatStatsAvgLengthLabel(
                s.name,
                s.avgMessageLength.round(),
                s.avgMessageLength < _oneLinerThreshold
                    ? l10n.chatStatsOneLinerLabel
                    : l10n.chatStatsLongFormLabel,
              ),
              style: textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}
