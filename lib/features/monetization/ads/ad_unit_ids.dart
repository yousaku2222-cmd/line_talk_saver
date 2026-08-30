import 'dart:io';

/// Real AdMob app / ad unit IDs from the developer's own AdMob account
/// (console.admob.google.com), for the "トーク保存" app.
class AdUnitIds {
  AdUnitIds._();

  /// While true, every install requests Google's official public test ad
  /// unit instead of the real one, so closed/open testers on unregistered
  /// devices see clearly-labeled test creatives instead of real ads —
  /// avoiding any invalid-traffic risk from testers who aren't real users.
  /// The AndroidManifest/Info.plist App ID stays the real one either way;
  /// only the ad *unit* ID needs to change. Reference:
  /// https://developers.google.com/admob/android/test-ads
  ///
  /// TODO: flip to false only for the production release build, once the
  /// closed test period is over and this is being shipped to real users.
  static const bool useTestAds = true;

  static const androidAppId = 'ca-app-pub-3818461038959537~7254635029';
  static const iosAppId = 'ca-app-pub-3818461038959537~5614922743';

  static const _realAndroidBanner = 'ca-app-pub-3818461038959537/2054279234';
  static const _testAndroidBanner = 'ca-app-pub-3940256099942544/6300978111';

  static const _realIosBanner = 'ca-app-pub-3818461038959537/6185768387';
  static const _testIosBanner = 'ca-app-pub-3940256099942544/2934735716';

  static String get androidBanner =>
      useTestAds ? _testAndroidBanner : _realAndroidBanner;

  static String get iosBanner => useTestAds ? _testIosBanner : _realIosBanner;

  /// Platform-aware banner ad unit ID.
  static String get bannerAdUnitId => Platform.isIOS ? iosBanner : androidBanner;

  // TODO: create real "Rewarded" ad units in the AdMob console
  // (console.admob.google.com) for both platforms and fill these in, the
  // same way the banner units above were. Until then this always falls back
  // to Google's public test rewarded ad unit, regardless of [useTestAds].
  static const _realAndroidRewarded = '';
  static const _testAndroidRewarded = 'ca-app-pub-3940256099942544/5224354917';

  static const _realIosRewarded = '';
  static const _testIosRewarded = 'ca-app-pub-3940256099942544/1712485313';

  static String get androidRewarded =>
      (useTestAds || _realAndroidRewarded.isEmpty)
          ? _testAndroidRewarded
          : _realAndroidRewarded;

  static String get iosRewarded =>
      (useTestAds || _realIosRewarded.isEmpty) ? _testIosRewarded : _realIosRewarded;

  /// Platform-aware rewarded ad unit ID.
  static String get rewardedAdUnitId => Platform.isIOS ? iosRewarded : androidRewarded;
}
