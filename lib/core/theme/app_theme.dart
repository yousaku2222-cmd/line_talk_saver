import 'package:flutter/material.dart';

import 'tokens.dart';

/// App-wide theming for the redesign (docs/ui_redesign_plan.md §1).
///
/// Built from [AppColors] tokens rather than a raw `fromSeed` so the
/// "ペーパー" palette (warm ivory + dusty coral) reads as intentional. A
/// later PR generalises this to `AppTheme.of(AppThemeId)` for 着せ替え.
class AppTheme {
  AppTheme._();

  static const fontFamily = 'NotoSansJP';

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final paper = isDark ? AppColors.paperDark : AppColors.paper;
    final card = isDark ? AppColors.cardDark : AppColors.card;
    final muted = isDark ? AppColors.surfaceMutedDark : AppColors.surfaceMuted;
    final line = isDark ? AppColors.lineDark : AppColors.line;
    final ink = isDark ? AppColors.inkDark : AppColors.ink;
    final inkSoft = isDark ? AppColors.inkSoftDark : AppColors.inkSoft;
    final accent = isDark ? AppColors.accentDark : AppColors.accent;
    final accentText = isDark ? AppColors.accentDark : AppColors.accentDeep;
    final accentSoft = isDark ? AppColors.accentSoftDark : AppColors.accentSoft;

    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: brightness,
        ).copyWith(
          primary: accent,
          onPrimary: Colors.white,
          primaryContainer: accentSoft,
          onPrimaryContainer: accentText,
          secondary: isDark ? AppColors.accent2 : AppColors.accent2Deep,
          surface: paper,
          onSurface: ink,
          surfaceContainerLowest: card,
          surfaceContainerLow: card,
          surfaceContainer: muted,
          surfaceContainerHigh: muted,
          surfaceContainerHighest: muted,
          onSurfaceVariant: inkSoft,
          outline: line,
          outlineVariant: line,
          error: AppColors.danger,
          errorContainer: isDark
              ? const Color(0xFF4A2B2B)
              : const Color(0xFFF6DAD5),
          onErrorContainer: AppColors.danger,
        );

    final textTheme = _textTheme(isDark ? Brightness.dark : Brightness.light, ink, inkSoft);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: paper,
      fontFamily: fontFamily,
      textTheme: textTheme,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: paper,
        surfaceTintColor: Colors.transparent,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: line),
        ),
      ),
      dividerTheme: DividerThemeData(color: line, thickness: 1, space: 1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentText,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: accent, width: 1.5),
          shape: const StadiumBorder(),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentText,
          textStyle: textTheme.labelLarge,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 2,
        highlightElevation: 4,
        shape: const StadiumBorder(),
        extendedTextStyle: textTheme.labelLarge,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: paper,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: line,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        titleTextStyle: textTheme.titleMedium,
        contentTextStyle: textTheme.bodyMedium,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: card,
        selectedColor: accentSoft,
        checkmarkColor: accentText,
        side: BorderSide(color: line),
        shape: const StadiumBorder(),
        labelStyle: textTheme.bodyMedium,
        secondaryLabelStyle: textTheme.bodyMedium,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: accentText,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(color: inkSoft),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ink,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: paper),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
      ),
    );
  }

  static TextTheme _textTheme(Brightness brightness, Color ink, Color inkSoft) {
    final base = (brightness == Brightness.dark
            ? Typography.material2021().white
            : Typography.material2021().black)
        .apply(fontFamily: fontFamily, bodyColor: ink, displayColor: ink);

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
      bodyLarge: base.bodyLarge?.copyWith(fontWeight: FontWeight.w400, fontSize: 15),
      bodyMedium: base.bodyMedium?.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 13),
      labelSmall: base.labelSmall?.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 11,
        letterSpacing: 0.4,
        color: inkSoft,
      ),
    );
  }
}
