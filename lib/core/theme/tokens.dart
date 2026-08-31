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
  static const accent2 = Color(
    0xFFB9A7D6,
  ); // soft lavender (2nd sender / theme)
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

/// The built-in 着せ替え themes (docs/ui_redesign_plan.md §2.10).
enum AppThemeId {
  paper('ペーパー'),
  night('ナイト'),
  sakura('サクラ'),
  mint('ミント'),
  lavender('ラベンダー'),
  mono('モノクロ'),
  ocean('オーシャン'),
  sunset('サンセット');

  const AppThemeId(this.label);

  final String label;
}

/// One theme's colours, addressed by *role* so [AppTheme] and widgets never
/// name a literal hex. Every [AppThemeId] has exactly one palette in
/// [appThemePalettes].
class AppThemePalette {
  const AppThemePalette({
    required this.id,
    required this.brightness,
    required this.paper,
    required this.card,
    required this.surfaceMuted,
    required this.line,
    required this.ink,
    required this.inkSoft,
    required this.accent,
    required this.accentText,
    required this.accentSoft,
    required this.accent2,
    required this.danger,
  });

  final AppThemeId id;
  final Brightness brightness;
  final Color paper;
  final Color card;
  final Color surfaceMuted;
  final Color line;
  final Color ink;
  final Color inkSoft;

  /// Fill for primary buttons / FAB / selected states.
  final Color accent;

  /// Accent used as *text/icon on a light surface* (a touch darker).
  final Color accentText;

  /// Pale accent tint: chips, icon tiles, own message bubble.
  final Color accentSoft;

  /// Secondary accent (2nd sender colour hint, small flourishes).
  final Color accent2;

  final Color danger;
}

AppThemePalette paletteFor(AppThemeId id) => appThemePalettes[id]!;

const appThemePalettes = <AppThemeId, AppThemePalette>{
  AppThemeId.paper: AppThemePalette(
    id: AppThemeId.paper,
    brightness: Brightness.light,
    paper: Color(0xFFF5F1EA),
    card: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF1EEE9),
    line: Color(0xFFEAE3DA),
    ink: Color(0xFF2B2730),
    inkSoft: Color(0xFF8A8390),
    accent: Color(0xFFE5988A),
    accentText: Color(0xFFCE7C6C),
    accentSoft: Color(0xFFF7E5DF),
    accent2: Color(0xFFB9A7D6),
    danger: Color(0xFFB3564A),
  ),
  AppThemeId.night: AppThemePalette(
    id: AppThemeId.night,
    brightness: Brightness.dark,
    paper: Color(0xFF1B1820),
    card: Color(0xFF262029),
    surfaceMuted: Color(0xFF2E2833),
    line: Color(0xFF3A333F),
    ink: Color(0xFFF2ECEF),
    inkSoft: Color(0xFFA79FA6),
    accent: Color(0xFFEBA99B),
    accentText: Color(0xFFEBA99B),
    accentSoft: Color(0xFF4A3B44),
    accent2: Color(0xFFB9A7D6),
    danger: Color(0xFFE49488),
  ),
  AppThemeId.sakura: AppThemePalette(
    id: AppThemeId.sakura,
    brightness: Brightness.light,
    paper: Color(0xFFFBF1F4),
    card: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF7E7EC),
    line: Color(0xFFF0DBE2),
    ink: Color(0xFF3A2A31),
    inkSoft: Color(0xFF97808A),
    accent: Color(0xFFE48AAB),
    accentText: Color(0xFFCC6E92),
    accentSoft: Color(0xFFF9DDE6),
    accent2: Color(0xFFB99AD6),
    danger: Color(0xFFB3564A),
  ),
  AppThemeId.mint: AppThemePalette(
    id: AppThemeId.mint,
    brightness: Brightness.light,
    paper: Color(0xFFF0F5F2),
    card: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFE6F0EA),
    line: Color(0xFFDCE9E1),
    ink: Color(0xFF243029),
    inkSoft: Color(0xFF7C8C83),
    accent: Color(0xFF5FB394),
    accentText: Color(0xFF3F8C70),
    accentSoft: Color(0xFFD6EFE1),
    accent2: Color(0xFF6F9BC8),
    danger: Color(0xFFB3564A),
  ),
  AppThemeId.lavender: AppThemePalette(
    id: AppThemeId.lavender,
    brightness: Brightness.light,
    paper: Color(0xFFF3F1F8),
    card: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFEAE6F3),
    line: Color(0xFFE0DAEE),
    ink: Color(0xFF2E2A38),
    inkSoft: Color(0xFF868099),
    accent: Color(0xFF8A6FB0),
    accentText: Color(0xFF735699),
    accentSoft: Color(0xFFE3D9F1),
    accent2: Color(0xFFE096B0),
    danger: Color(0xFFB3564A),
  ),
  AppThemeId.mono: AppThemePalette(
    id: AppThemeId.mono,
    brightness: Brightness.light,
    paper: Color(0xFFF5F4F2),
    card: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFEDECE9),
    line: Color(0xFFE1E0DC),
    ink: Color(0xFF23221F),
    inkSoft: Color(0xFF8A8884),
    accent: Color(0xFF3B3A38),
    accentText: Color(0xFF3B3A38),
    accentSoft: Color(0xFFE4E3DF),
    accent2: Color(0xFF9A9894),
    danger: Color(0xFFB3564A),
  ),
  AppThemeId.ocean: AppThemePalette(
    id: AppThemeId.ocean,
    brightness: Brightness.light,
    paper: Color(0xFFEFF4F7),
    card: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFE2EEF3),
    line: Color(0xFFD6E5EC),
    ink: Color(0xFF1F2E36),
    inkSoft: Color(0xFF758993),
    accent: Color(0xFF3E7CA6),
    accentText: Color(0xFF316588),
    accentSoft: Color(0xFFD4E7F0),
    accent2: Color(0xFF5FB0A6),
    danger: Color(0xFFB3564A),
  ),
  AppThemeId.sunset: AppThemePalette(
    id: AppThemeId.sunset,
    brightness: Brightness.light,
    paper: Color(0xFFF9EFE9),
    card: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF3E3DA),
    line: Color(0xFFEDD8CC),
    ink: Color(0xFF3A2A26),
    inkSoft: Color(0xFF9A8177),
    accent: Color(0xFFD07E7E),
    accentText: Color(0xFFBB6666),
    accentSoft: Color(0xFFF6DDD1),
    accent2: Color(0xFFCE8BB4),
    danger: Color(0xFFB3564A),
  ),
};

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
