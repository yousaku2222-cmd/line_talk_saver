import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // LINE-ish accent green, used for the "self" message bubble color etc.
  static const seedColor = Color(0xFF06C755);

  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      useMaterial3: true,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }
}
