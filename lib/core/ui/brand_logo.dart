import 'package:flutter/material.dart';

/// The app's text wordmark. Used in the Help intro and the Settings footer.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.fontSize = 16});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      'トーク保存',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: fontSize),
    );
  }
}
