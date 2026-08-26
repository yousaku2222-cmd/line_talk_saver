import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';

const _appLockEnabledKey = 'app_lock_enabled';

final appLockEnabledProvider = StateProvider<bool>((ref) {
  return ref.watch(sharedPreferencesProvider).getBool(_appLockEnabledKey) ?? false;
});

Future<void> setAppLockEnabled(WidgetRef ref, bool enabled) async {
  ref.read(appLockEnabledProvider.notifier).state = enabled;
  await ref.read(sharedPreferencesProvider).setBool(_appLockEnabledKey, enabled);
}
