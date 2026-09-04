import 'package:app_tracking_transparency/app_tracking_transparency.dart';
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
  await MobileAds.instance.initialize();
  await MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(testDeviceIds: _testDeviceIds),
  );
}
