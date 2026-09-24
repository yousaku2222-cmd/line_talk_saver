import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';

const _reminderEnabledKey = 'save_reminder_enabled';

final reminderEnabledProvider = StateProvider<bool>((ref) {
  return ref.watch(sharedPreferencesProvider).getBool(_reminderEnabledKey) ?? false;
});

Future<void> setReminderEnabled(WidgetRef ref, bool enabled) async {
  ref.read(reminderEnabledProvider.notifier).state = enabled;
  await ref.read(sharedPreferencesProvider).setBool(_reminderEnabledKey, enabled);
}
