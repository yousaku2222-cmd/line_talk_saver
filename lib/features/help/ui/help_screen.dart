import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final sections = <({IconData icon, String title, String body})>[
      (
        icon: Icons.file_download_outlined,
        title: l10n.helpImportTitle,
        body: l10n.helpImportBody,
      ),
      (
        icon: Icons.forum_outlined,
        title: l10n.helpChatListTitle,
        body: l10n.helpChatListBody,
      ),
      (
        icon: Icons.chat_bubble_outline,
        title: l10n.helpChatDetailTitle,
        body: l10n.helpChatDetailBody,
      ),
      (
        icon: Icons.image_outlined,
        title: l10n.helpAttachTitle,
        body: l10n.helpAttachBody,
      ),
      (
        icon: Icons.lock_outline,
        title: l10n.helpLockTitle,
        body: l10n.helpLockBody,
      ),
      (
        icon: Icons.backup_outlined,
        title: l10n.helpBackupTitle,
        body: l10n.helpBackupBody,
      ),
      (
        icon: Icons.shield_outlined,
        title: l10n.helpPrivacyTitle,
        body: l10n.helpPrivacyBody,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.helpScreenTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.x3,
          AppSpacing.screen,
          AppSpacing.x6,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, AppSpacing.x4),
            child: Text(
              l10n.helpAboutBody,
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.7,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: scheme.outline),
              boxShadow: AppShadows.card,
            ),
            clipBehavior: Clip.antiAlias,
            child: Theme(
              // Hide ExpansionTile's own top/bottom dividers; we draw our
              // own hairlines between sections.
              data: Theme.of(context)
                  .copyWith(dividerColor: Colors.transparent),
              child: Column(
                children: [
                  for (var i = 0; i < sections.length; i++) ...[
                    if (i != 0)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: scheme.outline,
                        indent: 16,
                      ),
                    ExpansionTile(
                      initiallyExpanded: i == 0,
                      leading: Icon(
                        sections[i].icon,
                        color: scheme.onPrimaryContainer,
                      ),
                      title: Text(
                        sections[i].title,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      expandedAlignment: Alignment.centerLeft,
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sections[i].body,
                          style: textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            height: 1.8,
                          ),
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
    );
  }
}
