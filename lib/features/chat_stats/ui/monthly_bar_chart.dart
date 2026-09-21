import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';

/// Shared 温度感グラフ bar chart: message counts per calendar month, with
/// the busiest month highlighted and called out in a headline sentence.
/// Used by both the per-chat トーク統計 screen and the cross-chat dashboard.
class MonthlyBarChart extends StatelessWidget {
  const MonthlyBarChart({
    super.key,
    required this.monthlyCounts,
    required this.peakMonth,
  });

  /// Message count per calendar month, keyed by the first day of that
  /// month, ordered chronologically.
  final List<MapEntry<DateTime, int>> monthlyCounts;

  /// The single busiest month, or null when there are no messages.
  final DateTime? peakMonth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final months = monthlyCounts;
    final maxCount = months.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final locale = Localizations.localeOf(context).toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (peakMonth != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              l10n.chatStatsPeakMonthLabel(
                DateFormat.yMMMM(locale).format(peakMonth!),
              ),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        SizedBox(
          height: 160,
          child: BarChart(
            BarChartData(
              maxY: maxCount.toDouble() * 1.15,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= months.length) return const SizedBox.shrink();
                      // Thin out labels so they don't overlap on long
                      // histories -- show at most ~6 across the chart.
                      final step = (months.length / 6).ceil().clamp(1, months.length);
                      if (i % step != 0) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          DateFormat.MMM(locale).format(months[i].key),
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                for (var i = 0; i < months.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: months[i].value.toDouble(),
                        color: months[i].key == peakMonth
                            ? scheme.primary
                            : scheme.primary.withValues(alpha: 0.4),
                        width: (months.length > 24) ? 4 : 10,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
