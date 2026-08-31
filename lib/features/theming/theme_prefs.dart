import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../core/theme/tokens.dart';
import 'unlocked_themes_prefs.dart';

const _themeIdKey = 'app_theme_id';

/// The 着せ替え theme the user has chosen (docs/ui_redesign_plan.md §2.10).
/// Defaults to [freeThemeId] (ミント), the one theme that needs no ad to use.
/// Persisted by [setAppThemeId].
final themeIdProvider = StateProvider<AppThemeId>((ref) {
  final raw = ref.watch(sharedPreferencesProvider).getString(_themeIdKey);
  return AppThemeId.values.firstWhere(
    (t) => t.name == raw,
    orElse: () => freeThemeId,
  );
});

Future<void> setAppThemeId(WidgetRef ref, AppThemeId id) async {
  ref.read(themeIdProvider.notifier).state = id;
  await ref.read(sharedPreferencesProvider).setString(_themeIdKey, id.name);
}
