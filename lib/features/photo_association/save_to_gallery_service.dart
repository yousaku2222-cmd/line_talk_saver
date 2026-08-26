import 'package:gal/gal.dart';

import 'media_kind.dart';

/// Saves a locally-attached photo or video to the device's own gallery
/// (Photos app / DCIM), separate from the app's private copy.
Future<void> saveToDeviceGallery(String path) {
  return isVideoPath(path) ? Gal.putVideo(path) : Gal.putImage(path);
}
