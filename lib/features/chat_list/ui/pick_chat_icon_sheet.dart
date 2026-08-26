import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../chat_icon_options.dart';

/// Shows a grid of [chatIconOptions] and returns the key the user picked,
/// or null if they dismissed the sheet without choosing.
Future<String?> showPickChatIconSheet(
  BuildContext context, {
  required String? currentIconKey,
}) {
  final l10n = AppLocalizations.of(context)!;
  return showModalBottomSheet<String>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(l10n.pickChatIconTitle),
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
                      selected: entry.key == (currentIconKey ?? defaultChatIconKey),
                      onTap: () => Navigator.of(sheetContext).pop(entry.key),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}

class _IconOption extends StatelessWidget {
  const _IconOption({
    required this.iconKey,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String iconKey;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor: selected ? scheme.primary : scheme.primaryContainer,
          child: Icon(
            icon,
            color: selected ? scheme.onPrimary : scheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}
