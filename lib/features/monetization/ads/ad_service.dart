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

Future<void> initializeAds() async {
  await MobileAds.instance.initialize();
  await MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(testDeviceIds: _testDeviceIds),
  );
}
