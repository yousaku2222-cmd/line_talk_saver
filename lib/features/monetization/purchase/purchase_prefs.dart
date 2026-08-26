import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';

const _adsRemovedKey = 'ads_removed';

/// Whether the user has bought the one-time "広告を非表示にする" unlock.
final adsRemovedProvider = StateProvider<bool>((ref) {
  return ref.watch(sharedPreferencesProvider).getBool(_adsRemovedKey) ?? false;
});

Future<void> setAdsRemoved(WidgetRef ref, bool value) async {
  ref.read(adsRemovedProvider.notifier).state = value;
  await ref.read(sharedPreferencesProvider).setBool(_adsRemovedKey, value);
}
