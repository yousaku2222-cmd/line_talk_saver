import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:line_talk_saver/app.dart';
import 'package:line_talk_saver/core/navigation/root_navigator_key.dart';
import 'package:line_talk_saver/core/providers/app_providers.dart';
import 'package:line_talk_saver/dev/screenshot_seed.dart';

/// Walks the app through the screens the store listing sells and captures each
/// one. Driving it from a test rather than by hand is not a preference here --
/// Xcode 27 ships no Simulator.app on this machine, so there is no window to
/// click in; the simulator only exists as a framebuffer `simctl` can read.
///
/// See `test_driver/store_screenshots_driver.dart` for the command to run.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('captures the store screenshots', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    await seedScreenshotSamplesIfNeeded(container);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const LineTalkSaverApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Android renders into a surface the test framework can't read directly;
    // iOS needs no such conversion and throws if asked for one.
    if (Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
    }

    // The "what's new" sheet fires on the first launch after an update and
    // would sit on top of every shot.
    final dismiss = find.text('OK');
    if (dismiss.evaluate().isNotEmpty) {
      await tester.tap(dismiss.first);
      await tester.pumpAndSettle();
    }

    await binding.takeScreenshot('01_chat_list');

    // 2. A saved conversation -- the thing the app exists to produce.
    final firstChat = find.textContaining('とのトーク履歴');
    expect(firstChat, findsWidgets, reason: 'seeded chats should be listed');
    await tester.tap(firstChat.first);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await binding.takeScreenshot('02_chat_detail');
    rootNavigatorKey.currentState!.pop();
    await tester.pumpAndSettle();

    // 3. Cross-chat search, with a keyword that hits more than one chat.
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '旅行');
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await binding.takeScreenshot('03_cross_search');
    rootNavigatorKey.currentState!.pop();
    await tester.pumpAndSettle();

    // 4. The stats dashboard across every saved chat.
    await tester.tap(find.byIcon(Icons.leaderboard_outlined));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await binding.takeScreenshot('04_dashboard');
    rootNavigatorKey.currentState!.pop();
    await tester.pumpAndSettle();

    // 5. Settings, where the save reminder lives.
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('05_settings');
  });
}
