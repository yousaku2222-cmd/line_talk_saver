import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../monetization/purchase/purchase_prefs.dart';
import 'chat_icon_options.dart';

const _unlockedIconsKey = 'unlocked_chat_icons';

/// Chat icon keys the user has unlocked by watching a rewarded ad (one ad
/// unlocks that one icon permanently -- see [showPickChatIconSheet]).
/// [defaultChatIconKey] is always free and never stored here.
final unlockedChatIconsProvider = StateProvider<Set<String>>((ref) {
  return ref
      .watch(sharedPreferencesProvider)
      .getStringList(_unlockedIconsKey)
      ?.toSet() ??
      {};
});

/// Whether [iconKey] can be used without watching another ad -- either it
/// was already unlocked, it's the free default, or the user has bought the
/// "広告を非表示にする" unlock (no reason to make a paying user sit through
/// an ad for a cosmetic extra).
bool isChatIconUnlocked(WidgetRef ref, String iconKey) {
  if (iconKey == defaultChatIconKey) return true;
  if (ref.read(adsRemovedProvider)) return true;
  return ref.read(unlockedChatIconsProvider).contains(iconKey);
}

Future<void> unlockChatIcon(WidgetRef ref, String iconKey) async {
  final updated = {...ref.read(unlockedChatIconsProvider), iconKey};
  ref.read(unlockedChatIconsProvider.notifier).state = updated;
  await ref
      .read(sharedPreferencesProvider)
      .setStringList(_unlockedIconsKey, updated.toList());
}
