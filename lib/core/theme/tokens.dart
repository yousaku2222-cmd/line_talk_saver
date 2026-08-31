import 'package:flutter/material.dart';

/// Design tokens for the redesign (see docs/ui_redesign_plan.md §1).
///
/// These are the values for the default **「ペーパー」** theme. §2.10's
/// per-theme `AppThemePalette` will later supply the same *roles* for other
/// themes; until then, [AppColors] is the single source of truth referenced
/// by [AppTheme] and the redesigned widgets.
abstract final class AppColors {
  AppColors._();

  // --- ペーパー (light) ---
  static const paper = Color(0xFFF5F1EA); // screen background
  static const card = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF1EEE9); // "other" bubble, faint fills
  static const line = Color(0xFFEAE3DA); // dividers, hairline borders
  static const ink = Color(0xFF2B2730);
  static const inkSoft = Color(0xFF8A8390);
  static const accent = Color(0xFFE5988A); // dusty coral
  static const accentDeep = Color(0xFFCE7C6C); // accent text on light
  static const accentSoft = Color(0xFFF7E5DF); // chips, icon tiles, own bubble
  static const accent2 = Color(0xFFB9A7D6); // soft lavender (2nd sender / theme)
  static const accent2Deep = Color(0xFF8A6FB0);
  static const danger = Color(0xFFB3564A);

  // --- ナイト (dark) ---
  static const paperDark = Color(0xFF1B1820);
  static const cardDark = Color(0xFF262029);
  static const surfaceMutedDark = Color(0xFF2E2833);
  static const lineDark = Color(0xFF3A333F);
  static const inkDark = Color(0xFFF2ECEF);
  static const inkSoftDark = Color(0xFFA79FA6);
  static const accentDark = Color(0xFFEBA99B);
  static const accentSoftDark = Color(0xFF4A3B44);
}

abstract final class AppSpacing {
  AppSpacing._();

  static const x1 = 4.0;
  static const x2 = 8.0;
  static const x3 = 12.0;
  static const x4 = 16.0;
  static const x5 = 24.0;
  static const x6 = 32.0;

  /// Horizontal screen padding (Anniv 風 の広めの余白).
  static const screen = 20.0;
}

abstract final class AppRadius {
  AppRadius._();

  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 26.0;
  static const pill = 999.0;
}

abstract final class AppShadows {
  AppShadows._();

  /// Soft lift for elevated cards. Most surfaces use a 1px [AppColors.line]
  /// border instead; this is the "floating card" case.
  static const card = <BoxShadow>[
    BoxShadow(color: Color(0x142B2730), blurRadius: 22, offset: Offset(0, 8)),
  ];
}

abstract final class AppMotion {
  AppMotion._();

  static const fast = Duration(milliseconds: 150);
  static const base = Duration(milliseconds: 250);
  static const curve = Curves.easeOutCubic;
}
