import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../monetization/ads/rewarded_ad_service.dart';
import '../chat_icon_options.dart';
import '../unlocked_icons_prefs.dart';

/// Shows a categorised grid of [chatIconOptions] and returns the key the
/// user picked, or null if they dismissed the sheet without choosing.
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
    builder: (sheetContext) =>
        _PickChatIconSheet(ref: ref, currentIconKey: currentIconKey),
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.unlockIconFailedMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    // Re-evaluate lock state on every rebuild -- watching these keeps the
    // grid in sync the instant an icon gets unlocked (or ads get removed).
    ref.watch(unlockedChatIconsProvider);
    final selectedKey = widget.currentIconKey ?? defaultChatIconKey;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.72,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                4,
                AppSpacing.screen,
                AppSpacing.x1,
              ),
              child: Text(l10n.pickChatIconTitle, style: textTheme.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                AppSpacing.x3,
              ),
              child: Text(
                l10n.pickChatIconLockedHint,
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  0,
                  AppSpacing.screen,
                  AppSpacing.x5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final entry in chatIconCategories.entries) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          4,
                          AppSpacing.x3,
                          4,
                          AppSpacing.x2,
                        ),
                        child: Text(
                          entry.key,
                          style: textTheme.labelSmall?.copyWith(
                            color: scheme.onPrimaryContainer,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      GridView.count(
                        crossAxisCount: 5,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: [
                          for (final key in entry.value)
                            _IconOption(
                              icon: chatIconOptions[key]!,
                              selected: key == selectedKey,
                              unlocked: isChatIconUnlocked(ref, key),
                              loading: _loadingIconKey == key,
                              onTap: () => _onTapIcon(key),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconOption extends StatelessWidget {
  const _IconOption({
    required this.icon,
    required this.selected,
    required this.unlocked,
    required this.loading,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final bool unlocked;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = selected ? scheme.onPrimary : scheme.onPrimaryContainer;
    return InkWell(
      onTap: loading ? null : onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: selected ? scheme.primary : scheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: selected ? null : Border.all(color: scheme.outline),
            ),
            child: Center(
              child: loading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: fg,
                      ),
                    )
                  : Icon(
                      icon,
                      size: 26,
                      color: fg.withValues(alpha: unlocked ? 1.0 : 0.5),
                    ),
            ),
          ),
          if (!unlocked && !loading)
            Positioned(
              right: -4,
              bottom: -4,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: scheme.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: scheme.surface, width: 2),
                ),
                child: const Icon(Icons.lock, size: 10, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
