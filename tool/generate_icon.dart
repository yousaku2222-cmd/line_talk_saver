// One-off generator for the app icon source image (assets/icon/icon.png).
// Run with: dart run tool/generate_icon.dart
import 'dart:io';

import 'package:image/image.dart' as img;

void main() {
  const size = 1024;
  final image = img.Image(width: size, height: size, numChannels: 3);

  final green = img.ColorRgb8(6, 199, 85); // matches AppTheme.seedColor
  final white = img.ColorRgb8(255, 255, 255);

  img.fillRect(image, x1: 0, y1: 0, x2: size - 1, y2: size - 1, color: green);

  // Chat bubble.
  img.fillRect(
    image,
    x1: 140,
    y1: 220,
    x2: 884,
    y2: 650,
    color: white,
    radius: 110,
  );

  // Bubble tail.
  img.fillPolygon(
    image,
    vertices: [
      img.Point(260, 640),
      img.Point(340, 640),
      img.Point(230, 770),
    ],
    color: white,
  );

  // Three dots suggesting text/typing.
  for (final cx in [400, 512, 624]) {
    img.fillCircle(image, x: cx, y: 435, radius: 45, color: green);
  }

  final bytes = img.encodePng(image);
  final outFile = File('assets/icon/icon.png');
  outFile.parent.createSync(recursive: true);
  outFile.writeAsBytesSync(bytes);
  // ignore: avoid_print
  print('Wrote ${outFile.path} (${bytes.length} bytes)');
}
