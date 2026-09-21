import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../monetization/purchase/purchase_prefs.dart';

const _lastFreeStatsUseDateKey = 'last_free_chat_stats_use_date';
const _lastFreeDashboardUseDateKey = 'last_free_chat_dashboard_use_date';

String _todayKey(DateTime now) =>
    '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

/// Whether the daily-quota feature stored under [key] can be opened right
/// now without watching a rewarded ad -- either the user has already
/// bought "広告を非表示にする" (no reason to gate a feature behind an ad
/// for a paying user), or today's one free viewing hasn't been used yet.
bool _canUseFree(WidgetRef ref, String key) {
  if (ref.read(adsRemovedProvider)) return true;
  final lastUse = ref.read(sharedPreferencesProvider).getString(key);
  return lastUse != _todayKey(DateTime.now());
}

/// Records that today's one free viewing of the feature stored under [key]
/// was just used. Not called at all when the viewing was unlocked via a
/// rewarded ad instead (each extra viewing that day requires watching
/// another ad), and never needed for ads-removed users since they're
/// always free.
Future<void> _markFreeUseToday(WidgetRef ref, String key) async {
  await ref
      .read(sharedPreferencesProvider)
      .setString(key, _todayKey(DateTime.now()));
}

/// トーク統計（1つのチャットの分析画面）の1日1回無料枠。
bool canUseChatStatsFree(WidgetRef ref) => _canUseFree(ref, _lastFreeStatsUseDateKey);

Future<void> markChatStatsFreeUseToday(WidgetRef ref) =>
    _markFreeUseToday(ref, _lastFreeStatsUseDateKey);

/// 全トーク横断ダッシュボードの1日1回無料枠。トーク統計とは別枠 -- 片方を
/// 今日すでに見ていても、もう片方はまだ無料で開ける。
bool canUseDashboardFree(WidgetRef ref) =>
    _canUseFree(ref, _lastFreeDashboardUseDateKey);

Future<void> markDashboardFreeUseToday(WidgetRef ref) =>
    _markFreeUseToday(ref, _lastFreeDashboardUseDateKey);
