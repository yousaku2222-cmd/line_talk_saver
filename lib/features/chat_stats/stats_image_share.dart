import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Renders the widget wrapped by [key] (a [RepaintBoundary]) to a PNG file
/// and hands it to the OS share sheet -- the same underlying mechanism the
/// export feature uses for Excel/PDF/Word, just for a rendered widget
/// instead of a generated document.
Future<void> shareWidgetAsImage(
  GlobalKey key, {
  required String fileName,
}) async {
  final boundary =
      key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) return;

  final image = await boundary.toImage(pixelRatio: 3);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) return;

  final dir = await getTemporaryDirectory();
  final safeName = fileName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  final file = File('${dir.path}${Platform.pathSeparator}$safeName.png');
  await file.writeAsBytes(byteData.buffer.asUint8List());
  await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
}
