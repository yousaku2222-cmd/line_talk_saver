import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../monetization/ads/rewarded_ad_service.dart';

/// Decides whether a paid-for-by-ad stats viewing may open, given the
/// rewarded ad's [outcome], and shows a snackbar when it may not.
///
/// When there is simply no ad to show (no fill, AdMob account paused) the
/// viewing opens anyway -- users shouldn't lose the feature over it. Being
/// offline does not count, so switching to airplane mode can't skip the ad.
bool showGateAdResult(BuildContext context, RewardOutcome outcome) {
  final l10n = AppLocalizations.of(context)!;
  switch (outcome) {
    case RewardOutcome.earned || RewardOutcome.unavailable:
      return true;
    case RewardOutcome.offline:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.adOfflineMessage)),
      );
      return false;
    case RewardOutcome.dismissed:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.unlockIconFailedMessage)),
      );
      return false;
  }
}
