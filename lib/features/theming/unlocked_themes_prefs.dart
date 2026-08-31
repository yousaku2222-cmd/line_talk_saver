import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../core/theme/tokens.dart';
import '../monetization/purchase/purchase_prefs.dart';
import 'theme_prefs.dart';

const _unlockedThemesKey = 'unlocked_themes';

/// The one 着せ替え theme that's always free -- the app's default look.
/// Every other [AppThemeId] starts locked until the user watches a rewarded
/// ad for it, mirroring the chat-icon unlock flow (see unlocked_icons_prefs).
const freeThemeId = AppThemeId.mint;

/// Theme ids the user has unlocked by watching a rewarded ad (one ad unlocks
/// that theme permanently). Stored by [AppThemeId.name]; [freeThemeId] and
/// the currently-applied theme are never stored here.
final unlockedThemesProvider = StateProvider<Set<String>>((ref) {
  return ref
          .watch(sharedPreferencesProvider)
          .getStringList(_unlockedThemesKey)
          ?.toSet() ??
      {};
});

/// Whether [id] can be applied without watching another ad -- it's the free
/// default, it's already applied (grandfathered so an existing pick never
/// re-locks), it was already unlocked, or the user bought "広告を非表示にする".
bool isThemeUnlocked(WidgetRef ref, AppThemeId id) {
  if (id == freeThemeId) return true;
  if (id == ref.read(themeIdProvider)) return true;
  if (ref.read(adsRemovedProvider)) return true;
  return ref.read(unlockedThemesProvider).contains(id.name);
}

Future<void> unlockTheme(WidgetRef ref, AppThemeId id) async {
  final updated = {...ref.read(unlockedThemesProvider), id.name};
  ref.read(unlockedThemesProvider.notifier).state = updated;
  await ref
      .read(sharedPreferencesProvider)
      .setStringList(_unlockedThemesKey, updated.toList());
}
