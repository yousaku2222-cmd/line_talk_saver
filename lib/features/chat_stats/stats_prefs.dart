import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../monetization/purchase/purchase_prefs.dart';

const _lastFreeStatsUseDateKey = 'last_free_chat_stats_use_date';

String _todayKey(DateTime now) =>
    '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

/// Whether トーク統計 can be opened right now without watching a rewarded ad
/// -- either the user has already bought "広告を非表示にする" (no reason to
/// gate a feature behind an ad for a paying user), or today's one free
/// viewing hasn't been used yet.
bool canUseChatStatsFree(WidgetRef ref) {
  if (ref.read(adsRemovedProvider)) return true;
  final lastUse =
      ref.read(sharedPreferencesProvider).getString(_lastFreeStatsUseDateKey);
  return lastUse != _todayKey(DateTime.now());
}

/// Records that today's one free トーク統計 viewing was just used. Not
/// called at all when the viewing was unlocked via a rewarded ad instead
/// (each extra viewing that day requires watching another ad), and never
/// needed for ads-removed users since they're always free.
Future<void> markChatStatsFreeUseToday(WidgetRef ref) async {
  await ref
      .read(sharedPreferencesProvider)
      .setString(_lastFreeStatsUseDateKey, _todayKey(DateTime.now()));
}
