import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../chat_stats/chat_stats_calculator.dart';

/// Plain-text summary lines for the export sheet's "統計情報を含める"
/// option. Shared by the PDF/Excel/Word builders instead of duplicating
/// the wording three times -- each builder just lays these lines out in
/// whatever way fits its own format (a page, a sheet, a section).
List<String> buildStatsSummaryLines(
  AppLocalizations l10n,
  ChatStats stats,
  String locale,
) {
  final lines = <String>[
    l10n.exportStatsTotalMessagesLabel(stats.totalMessages),
  ];

  if (stats.peakMonth != null) {
    lines.add(
      l10n.chatStatsPeakMonthLabel(DateFormat.yMMMM(locale).format(stats.peakMonth!)),
    );
  }

  for (final s in stats.senderStats) {
    lines.add('${s.name}: ${l10n.chatStatsMessageCountLabel} ${s.messageCount}');
  }

  if (stats.questionsAsked > 0) {
    lines.add(
      l10n.chatStatsQuestionCatchRateValue(
        (stats.questionCatchRate * 100).round(),
        stats.questionsAnswered,
        stats.questionsAsked,
      ),
    );
  }

  return lines;
}
