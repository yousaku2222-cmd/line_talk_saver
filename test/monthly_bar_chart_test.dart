import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:line_talk_saver/features/chat_stats/ui/monthly_bar_chart.dart';
import 'package:line_talk_saver/l10n/app_localizations.dart';

Widget _chart(List<DateTime> months) => MaterialApp(
      locale: const Locale('ja'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: MonthlyBarChart(
          monthlyCounts: [for (final m in months) MapEntry(m, 5)],
          peakMonth: months.first,
        ),
      ),
    );

void main() {
  testWidgets('labels name the year when the months span years',
      (tester) async {
    // 2024-06 .. 2025-08: 15 months, so every 3rd month gets a label and
    // both Junes are labelled.
    final months = [
      for (var i = 0; i < 15; i++) DateTime(2024, 6 + i),
    ];
    await tester.pumpWidget(_chart(months));
    await tester.pumpAndSettle();

    expect(find.text('24年6月'), findsOneWidget);
    expect(find.text('25年3月'), findsOneWidget);
    expect(find.text('25年6月'), findsNothing);
    expect(find.text('6月'), findsOneWidget);
  });

  testWidgets('labels stay month-only within one year', (tester) async {
    final months = [for (var i = 5; i <= 8; i++) DateTime(2024, i)];
    await tester.pumpWidget(_chart(months));
    await tester.pumpAndSettle();

    expect(find.text('5月'), findsOneWidget);
    expect(find.textContaining('年'), findsOneWidget); // the peak headline
  });
}
