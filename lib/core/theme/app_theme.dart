import 'package:flutter/material.dart';

import 'tokens.dart';

/// App-wide theming for the redesign (docs/ui_redesign_plan.md §1 / §2.10).
///
/// A [ThemeData] is built from an [AppThemePalette] so the 着せ替え themes
/// all share one layout vocabulary and only swap colour roles.
class AppTheme {
  AppTheme._();

  static const fontFamily = 'NotoSansJP';

  static ThemeData light() => fromPalette(paletteFor(AppThemeId.mint));
  static ThemeData dark() => fromPalette(paletteFor(AppThemeId.night));

  static ThemeData fromPalette(AppThemePalette p) {
    final isDark = p.brightness == Brightness.dark;

    final scheme =
        ColorScheme.fromSeed(
          seedColor: p.accent,
          brightness: p.brightness,
        ).copyWith(
          primary: p.accent,
          onPrimary: isDark ? const Color(0xFF1B1820) : Colors.white,
          primaryContainer: p.accentSoft,
          onPrimaryContainer: p.accentText,
          secondary: p.accent2,
          surface: p.paper,
          onSurface: p.ink,
          surfaceContainerLowest: p.card,
          surfaceContainerLow: p.card,
          surfaceContainer: p.surfaceMuted,
          surfaceContainerHigh: p.surfaceMuted,
          surfaceContainerHighest: p.surfaceMuted,
          onSurfaceVariant: p.inkSoft,
          outline: p.line,
          outlineVariant: p.line,
          error: p.danger,
          errorContainer: isDark
              ? const Color(0xFF4A2B2B)
              : const Color(0xFFF6DAD5),
          onErrorContainer: p.danger,
        );

    final textTheme = _textTheme(p);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.paper,
      fontFamily: fontFamily,
      textTheme: textTheme,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: p.paper,
        surfaceTintColor: Colors.transparent,
        foregroundColor: p.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: p.card,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: p.line),
        ),
      ),
      dividerTheme: DividerThemeData(color: p.line, thickness: 1, space: 1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.accent,
          foregroundColor: isDark ? const Color(0xFF1B1820) : Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.accentText,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: p.accent, width: 1.5),
          shape: const StadiumBorder(),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.accentText,
          textStyle: textTheme.labelLarge,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.accent,
        foregroundColor: isDark ? const Color(0xFF1B1820) : Colors.white,
        elevation: 2,
        highlightElevation: 4,
        shape: const StadiumBorder(),
        extendedTextStyle: textTheme.labelLarge,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.paper,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: p.line,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        titleTextStyle: textTheme.titleMedium,
        contentTextStyle: textTheme.bodyMedium,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.card,
        selectedColor: p.accentSoft,
        checkmarkColor: p.accentText,
        side: BorderSide(color: p.line),
        shape: const StadiumBorder(),
        labelStyle: textTheme.bodyMedium,
        secondaryLabelStyle: textTheme.bodyMedium,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: p.accentText,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(color: p.inkSoft),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.ink,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: p.paper),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: p.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: p.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: p.accent, width: 1.5),
        ),
      ),
    );
  }

  static TextTheme _textTheme(AppThemePalette p) {
    final base =
        (p.brightness == Brightness.dark
                ? Typography.material2021().white
                : Typography.material2021().black)
            .apply(
              fontFamily: fontFamily,
              bodyColor: p.ink,
              displayColor: p.ink,
            );

    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(
        fontWeight: FontWeight.w300,
        fontSize: 44,
        letterSpacing: -0.5,
        height: 1.1,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 22,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 15,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 11,
        letterSpacing: 0.4,
        color: p.inkSoft,
      ),
    );
  }
}
