import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../monetization/ads/rewarded_ad_service.dart';
import '../../monetization/purchase/purchase_prefs.dart';
import '../theme_prefs.dart';
import '../unlocked_themes_prefs.dart';

/// 着せ替え picker (docs/ui_redesign_plan.md §2.10). ミント ([freeThemeId]) is
/// free; every other theme is locked (🔒) until the user watches one rewarded
/// ad for it -- after that it's unlocked for good, no repeat ads. Picking an
/// unlocked theme applies it immediately across the app and persists it
/// (see [setAppThemeId]/[isThemeUnlocked]/[unlockTheme]).
class ThemePickerScreen extends ConsumerStatefulWidget {
  const ThemePickerScreen({super.key});

  @override
  ConsumerState<ThemePickerScreen> createState() => _ThemePickerScreenState();
}

class _ThemePickerScreenState extends ConsumerState<ThemePickerScreen> {
  AppThemeId? _loadingThemeId;

  Future<void> _onTapTheme(AppThemeId id) async {
    if (isThemeUnlocked(ref, id)) {
      await setAppThemeId(ref, id);
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.unlockThemeDialogTitle),
        content: Text(l10n.unlockThemeDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.unlockIconWatchAdButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _loadingThemeId = id);
    final earned = await RewardedAdService.instance.show();
    if (!mounted) return;
    setState(() => _loadingThemeId = null);

    if (earned) {
      await unlockTheme(ref, id);
      if (!mounted) return;
      await setAppThemeId(ref, id);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.unlockIconFailedMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final current = ref.watch(themeIdProvider);
    // Re-evaluate lock state on every rebuild so the grid updates the instant
    // a theme is unlocked (or ads get removed).
    ref.watch(unlockedThemesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('着せ替え')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Once "広告を非表示にする" is bought every theme is already
          // unlocked (see isThemeUnlocked), so the watch-an-ad hint would
          // just be noise.
          if (!ref.watch(adsRemovedProvider))
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.x3,
                AppSpacing.screen,
                0,
              ),
              child: Text(
                l10n.themePickerLockedHint,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(AppSpacing.screen),
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.x3,
              crossAxisSpacing: AppSpacing.x3,
              childAspectRatio: 1.35,
              children: [
                for (final id in AppThemeId.values)
                  _ThemeCard(
                    palette: paletteFor(id),
                    selected: id == current,
                    unlocked: isThemeUnlocked(ref, id),
                    loading: _loadingThemeId == id,
                    onTap: () => _onTapTheme(id),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.palette,
    required this.selected,
    required this.unlocked,
    required this.loading,
    required this.onTap,
  });

  final AppThemePalette palette;
  final bool selected;
  final bool unlocked;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: palette.card,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: selected ? scheme.primary : scheme.outline,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: loading ? null : onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: ColoredBox(color: palette.paper)),
                      Expanded(child: ColoredBox(color: palette.accentSoft)),
                      Expanded(child: ColoredBox(color: palette.accent)),
                    ],
                  ),
                  if (!unlocked && !loading)
                    Positioned.fill(
                      child: ColoredBox(
                        color: Colors.black.withValues(alpha: 0.28),
                      ),
                    ),
                  if (loading)
                    const Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    )
                  else if (!unlocked)
                    const Center(
                      child: Icon(Icons.lock, size: 22, color: Colors.white),
                    ),
                  if (selected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: scheme.primary,
                        child: Icon(
                          Icons.check,
                          size: 14,
                          color: scheme.onPrimary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(
                palette.id.label,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600, color: palette.ink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
