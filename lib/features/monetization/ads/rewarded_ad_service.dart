import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_unit_ids.dart';

/// Loads and shows a single rewarded ad, resolving to whether the user
/// actually watched it through to completion (i.e. earned the reward).
///
/// Used to gate cosmetic-only unlocks (e.g. a chat icon) behind "watch one
/// ad" rather than a purchase -- see [[project_line_talk_saver_monetization]]
/// ground rules: this must never gate the core import/read/export flow.
class RewardedAdService {
  RewardedAdService._();

  static final RewardedAdService instance = RewardedAdService._();

  Completer<bool>? _pendingLoad;

  /// Shows a rewarded ad and returns true once the user earns the reward,
  /// or false if the ad failed to load, failed to show, or was dismissed
  /// before completion. Never throws.
  Future<bool> show() async {
    // Avoid two concurrent load/show attempts stomping on each other --
    // e.g. a double-tap on the "watch ad" button.
    if (_pendingLoad != null) return _pendingLoad!.future;
    final completer = Completer<bool>();
    _pendingLoad = completer;

    await RewardedAd.load(
      adUnitId: AdUnitIds.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          var earnedReward = false;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _pendingLoad = null;
              if (!completer.isCompleted) completer.complete(earnedReward);
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _pendingLoad = null;
              if (!completer.isCompleted) completer.complete(false);
            },
          );
          ad.show(
            onUserEarnedReward: (ad, reward) {
              earnedReward = true;
            },
          );
        },
        onAdFailedToLoad: (error) {
          _pendingLoad = null;
          if (!completer.isCompleted) completer.complete(false);
        },
      ),
    );

    return completer.future;
  }
}
