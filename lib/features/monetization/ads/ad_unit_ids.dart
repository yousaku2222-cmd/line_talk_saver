/// Real AdMob app / ad unit IDs from the developer's own AdMob account
/// (console.admob.google.com), for the "LINEトーク保存" Android app.
class AdUnitIds {
  AdUnitIds._();

  /// While true, every install requests Google's official public test ad
  /// unit instead of the real one, so closed/open testers on unregistered
  /// devices see clearly-labeled test creatives instead of real ads —
  /// avoiding any invalid-traffic risk from testers who aren't real users.
  /// The AndroidManifest App ID stays the real one either way; only the ad
  /// *unit* ID needs to change. Reference:
  /// https://developers.google.com/admob/android/test-ads
  ///
  /// TODO: flip to false only for the production release build, once the
  /// closed test period is over and this is being shipped to real users.
  static const bool useTestAds = true;

  static const androidAppId = 'ca-app-pub-3818461038959537~7254635029';

  static const _realAndroidBanner = 'ca-app-pub-3818461038959537/2054279234';
  static const _testAndroidBanner = 'ca-app-pub-3940256099942544/6300978111';

  static String get androidBanner =>
      useTestAds ? _testAndroidBanner : _realAndroidBanner;
}
