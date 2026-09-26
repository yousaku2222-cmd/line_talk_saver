import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// Host side of the store-screenshot run. Each `binding.takeScreenshot(name)`
/// in `integration_test/store_screenshots_test.dart` lands here as PNG bytes
/// and is written next to the Android shots.
///
/// Run with:
///   flutter drive \
///     --driver=test_driver/store_screenshots_driver.dart \
///     --target=integration_test/store_screenshots_test.dart \
///     -d `<simulator udid>` --dart-define=SCREENSHOT=true
Future<void> main() async {
  await integrationDriver(
    onScreenshot: (String name, List<int> bytes, [Map<String, Object?>? args]) async {
      final file = File('store_listing/screenshots_ios/$name.png');
      file.parent.createSync(recursive: true);
      file.writeAsBytesSync(bytes);
      stdout.writeln('saved ${file.path} (${bytes.length} bytes)');
      return true;
    },
  );
}
