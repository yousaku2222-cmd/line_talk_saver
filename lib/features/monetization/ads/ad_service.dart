import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Physical devices used for development, registered so they always get
/// real-looking test creatives instead of competing for actual ad fill (and
/// to avoid any risk of accidental invalid-traffic clicks on a real ad unit
/// during testing). Find a new device's ID in its logcat output the first
/// time it requests an ad -- AdMob logs it directly:
/// "Use RequestConfiguration.Builder().setTestDeviceIds(Arrays.asList(...))".
const _testDeviceIds = [
  '4D7022F59B58DC6CB29480812256B633', // Hi10_XPro tablet
];

/// Shows the iOS App Tracking Transparency prompt on first launch, if the
/// user hasn't already answered it. No-op on Android (the plugin returns
/// [TrackingStatus.notSupported] there). Must be awaited before
/// [initializeAds] so the very first ad request already reflects the
/// user's choice, matching the "トラッキングに使用" = はい declaration in
/// App Store Connect's App Privacy section.
Future<void> requestTrackingIfNeeded() async {
  final status = await AppTrackingTransparency.trackingAuthorizationStatus;
  if (status != TrackingStatus.notDetermined) return;
  // The prompt can silently fail to appear if fired before the app has
  // finished becoming active right after launch -- this delay gives iOS
  // a moment to settle first.
  await Future.delayed(const Duration(milliseconds: 300));
  await AppTrackingTransparency.requestTrackingAuthorization();
}

Future<void> initializeAds() async {
  // Google's consent callbacks aren't guaranteed to fire promptly on a slow
  // network, so cap the wait rather than let a stalled form block startup --
  // the SDK falls back to non-personalised ads when consent is unresolved.
  await _requestConsent().timeout(const Duration(seconds: 8), onTimeout: () {});
  await MobileAds.instance.initialize();
  await MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(testDeviceIds: _testDeviceIds),
  );
}

/// Google UMP (User Messaging Platform): shows the consent form only where
/// consent is legally required (EEA/UK). Everywhere else
/// [ConsentInformation.requestConsentInfoUpdate] reports that no form is
/// needed and this resolves without showing anything, so users outside those
/// regions see no change at launch.
///
/// Requires a published GDPR message in AdMob (Privacy & messaging); without
/// one [ConsentForm.loadAndShowConsentFormIfRequired] has nothing to show.
Future<void> _requestConsent() {
  final completer = Completer<void>();
  void finish() {
    if (!completer.isCompleted) completer.complete();
  }

  ConsentInformation.instance.requestConsentInfoUpdate(
    ConsentRequestParameters(),
    () async {
      try {
        ConsentForm.loadAndShowConsentFormIfRequired((error) {
          if (error != null) {
            debugPrint('talk: consent form dismissed with error: $error');
          }
          finish();
        });
      } catch (e) {
        debugPrint('talk: consent form failed, continuing without it: $e');
        finish();
      }
    },
    (error) {
      debugPrint('talk: consent info update failed: $error');
      finish();
    },
  );
  return completer.future;
}

/// Whether this user must be offered a way back into the consent form. True
/// only in regions where consent applies (EEA/UK) and only once the SDK has
/// resolved that -- the settings entry point is hidden otherwise, so users
/// elsewhere don't get a menu item that opens nothing.
Future<bool> isPrivacyOptionsRequired() async {
  try {
    final status =
        await ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
    return status == PrivacyOptionsRequirementStatus.required;
  } catch (e) {
    debugPrint('talk: privacy options status unavailable: $e');
    return false;
  }
}

/// Re-opens Google's consent form so the user can change or withdraw the
/// choice they made at first launch -- required by GDPR, which treats consent
/// as revocable at any time.
Future<void> showPrivacyOptionsForm() {
  final completer = Completer<void>();
  ConsentForm.showPrivacyOptionsForm((error) {
    if (error != null) {
      debugPrint('talk: privacy options form error: $error');
    }
    if (!completer.isCompleted) completer.complete();
  });
  return completer.future;
}
