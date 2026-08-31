import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:line_talk_saver/app.dart';
import 'package:line_talk_saver/data/db/app_database.dart';
import 'package:line_talk_saver/core/providers/app_providers.dart';
import 'package:line_talk_saver/features/chat_list/providers/chat_list_provider.dart';
import 'package:line_talk_saver/features/settings/locale/locale_prefs.dart';

void main() {
  testWidgets('App launches to an empty chat list', (tester) async {
    // Override the list provider directly with a plain, already-resolved
    // stream rather than routing through a real drift database: drift's
    // native query-stream cleanup doesn't play well with flutter_test's
    // fake timer/zone environment and leaves the test hanging. The
    // provider-level parsing/persistence logic itself is already covered
    // by the parser unit tests; this test only exercises navigation/UI.
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chatListProvider.overrideWith((ref) => Stream.value(<Chat>[])),
          sharedPreferencesProvider.overrideWithValue(prefs),
          // Pin the locale so this test's expectations don't depend on the
          // host machine's default/system locale.
          localeProvider.overrideWith((ref) => const Locale('ja')),
        ],
        child: const LineTalkSaverApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('トーク保存'), findsOneWidget);
    // The import affordance appears both as the FAB and as the empty-state
    // call-to-action, so there can be more than one.
    expect(find.text('トークを取り込む'), findsWidgets);
  });
}
