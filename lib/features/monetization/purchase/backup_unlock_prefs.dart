import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';

const _backupUnlockedKey = 'backup_unlocked';

/// Whether the user has bought the one-time "バックアップ機能" unlock, which
/// gates both creating and restoring backups (see settings_screen). Set by
/// the app-wide PurchaseListener when the [ProductIds.backupUnlock] product
/// arrives from a purchase or restore.
final backupUnlockedProvider = StateProvider<bool>((ref) {
  return ref.watch(sharedPreferencesProvider).getBool(_backupUnlockedKey) ??
      false;
});

Future<void> setBackupUnlocked(WidgetRef ref, bool value) async {
  ref.read(backupUnlockedProvider.notifier).state = value;
  await ref.read(sharedPreferencesProvider).setBool(_backupUnlockedKey, value);
}
