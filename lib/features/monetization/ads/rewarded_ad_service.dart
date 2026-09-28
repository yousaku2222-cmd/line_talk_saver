import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_unit_ids.dart';

/// Result of [RewardedAdService.show].
enum RewardOutcome {
  /// The user watched the ad through and earned the reward.
  earned,

  /// The ad was shown but closed early, or failed to show.
  dismissed,

  /// No ad could be loaded (no fill, account paused). Gated features may let
  /// the user through anyway; cosmetic unlocks don't.
  unavailable,

  /// The load failed with a network error (airplane mode, no signal). Never
  /// let the user through, or going offline would become a free bypass.
  offline,
}

/// `LoadAdError.code` for a network failure (same value on Android and iOS).
const _networkErrorCode = 2;

/// Loads and shows a single rewarded ad and reports how it went.
///
/// Used to gate cosmetic-only unlocks (e.g. a chat icon) behind "watch one
/// ad" rather than a purchase -- see [[project_line_talk_saver_monetization]]
/// ground rules: this must never gate the core import/read/export flow.
class RewardedAdService {
  RewardedAdService._();

  static final RewardedAdService instance = RewardedAdService._();

  Completer<RewardOutcome>? _pendingLoad;

  /// Shows a rewarded ad and returns [RewardOutcome.earned] once the user
  /// earns the reward, or another outcome if the ad failed to load, failed
  /// to show, or was dismissed before completion. Never throws.
  Future<RewardOutcome> show() async {
    // Avoid two concurrent load/show attempts stomping on each other --
    // e.g. a double-tap on the "watch ad" button.
    if (_pendingLoad != null) return _pendingLoad!.future;
    final completer = Completer<RewardOutcome>();
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
              if (!completer.isCompleted) {
                completer.complete(earnedReward
                    ? RewardOutcome.earned
                    : RewardOutcome.dismissed);
              }
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _pendingLoad = null;
              if (!completer.isCompleted) {
                completer.complete(RewardOutcome.dismissed);
              }
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
          if (!completer.isCompleted) {
            completer.complete(error.code == _networkErrorCode
                ? RewardOutcome.offline
                : RewardOutcome.unavailable);
          }
        },
      ),
    );

    return completer.future;
  }
}
