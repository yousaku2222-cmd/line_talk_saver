import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../monetization/ads/rewarded_ad_service.dart';
import '../chat_icon_options.dart';
import '../unlocked_icons_prefs.dart';

/// Shows a grid of [chatIconOptions] and returns the key the user picked,
/// or null if they dismissed the sheet without choosing.
///
/// Every icon except [defaultChatIconKey] starts locked (🔒) until the user
/// watches one rewarded ad for it -- after that it's unlocked for good, no
/// repeat ads. See [unlockChatIcon]/[isChatIconUnlocked].
Future<String?> showPickChatIconSheet(
  BuildContext context, {
  required WidgetRef ref,
  required String? currentIconKey,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => _PickChatIconSheet(
      ref: ref,
      currentIconKey: currentIconKey,
    ),
  );
}

class _PickChatIconSheet extends ConsumerStatefulWidget {
  const _PickChatIconSheet({required this.ref, required this.currentIconKey});

  // Accepted from the caller rather than obtained via `Consumer` internally
  // so unlockChatIcon() can update provider state that this same sheet
  // watches, without threading a second BuildContext through the ad flow.
  final WidgetRef ref;
  final String? currentIconKey;

  @override
  ConsumerState<_PickChatIconSheet> createState() => _PickChatIconSheetState();
}

class _PickChatIconSheetState extends ConsumerState<_PickChatIconSheet> {
  String? _loadingIconKey;

  Future<void> _onTapIcon(String iconKey) async {
    if (isChatIconUnlocked(ref, iconKey)) {
      Navigator.of(context).pop(iconKey);
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.unlockIconDialogTitle),
        content: Text(l10n.unlockIconDialogBody),
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

    setState(() => _loadingIconKey = iconKey);
    final earned = await RewardedAdService.instance.show();
    if (!mounted) return;
    setState(() => _loadingIconKey = null);

    if (earned) {
      await unlockChatIcon(ref, iconKey);
      if (!mounted) return;
      Navigator.of(context).pop(iconKey);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.unlockIconFailedMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Re-evaluate lock state on every rebuild -- watching these keeps the
    // grid in sync the instant an icon gets unlocked (or ads get removed).
    ref.watch(unlockedChatIconsProvider);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(l10n.pickChatIconTitle),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.pickChatIconLockedHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final entry in chatIconOptions.entries)
                    _IconOption(
                      iconKey: entry.key,
                      icon: entry.value,
                      selected: entry.key ==
                          (widget.currentIconKey ?? defaultChatIconKey),
                      unlocked: isChatIconUnlocked(ref, entry.key),
                      loading: _loadingIconKey == entry.key,
                      onTap: () => _onTapIcon(entry.key),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _IconOption extends StatelessWidget {
  const _IconOption({
    required this.iconKey,
    required this.icon,
    required this.selected,
    required this.unlocked,
    required this.loading,
    required this.onTap,
  });

  final String iconKey;
  final IconData icon;
  final bool selected;
  final bool unlocked;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: loading ? null : onTap,
      borderRadius: BorderRadius.circular(32),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              backgroundColor: selected ? scheme.primary : scheme.primaryContainer,
              child: loading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: selected ? scheme.onPrimary : scheme.onPrimaryContainer,
                      ),
                    )
                  : Icon(
                      icon,
                      color: unlocked
                          ? (selected ? scheme.onPrimary : scheme.onPrimaryContainer)
                          : (selected ? scheme.onPrimary : scheme.onPrimaryContainer)
                              .withValues(alpha: 0.4),
                    ),
            ),
            if (!unlocked && !loading)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.lock, size: 12, color: scheme.onSurfaceVariant),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
