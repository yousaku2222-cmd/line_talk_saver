import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/navigation/root_navigator_key.dart';
import 'core/providers/app_providers.dart';
import 'features/import/share_intake/share_intent_listener.dart';
import 'features/monetization/ads/ad_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  // Must run before initializeAds() so the first ad request already
  // reflects the user's tracking choice.
  await requestTrackingIfNeeded();
  // Must be awaited: initializeAds() also registers this device's test-ad
  // ID, and the very first ad request (from the chat list's banner, right
  // after the first frame) needs that to already be in effect -- doing it
  // unawaited raced the real request against the test-device registration,
  // so it kept going out as a live, and so far always no-fill, request.
  await initializeAds();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const LineTalkSaverApp(),
    ),
  );

  // Wait for the first frame so `rootNavigatorKey.currentState` exists
  // before a share event tries to push a route through it.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ShareIntentListener(rootNavigatorKey).start();
  });
}
