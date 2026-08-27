import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sections = <(String, String)>[
      (l10n.helpAboutTitle, l10n.helpAboutBody),
      (l10n.helpImportTitle, l10n.helpImportBody),
      (l10n.helpChatListTitle, l10n.helpChatListBody),
      (l10n.helpChatDetailTitle, l10n.helpChatDetailBody),
      (l10n.helpAttachTitle, l10n.helpAttachBody),
      (l10n.helpLockTitle, l10n.helpLockBody),
      (l10n.helpBackupTitle, l10n.helpBackupBody),
      (l10n.helpPrivacyTitle, l10n.helpPrivacyBody),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.helpScreenTitle)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sections.length,
        separatorBuilder: (_, _) => const Divider(height: 32),
        itemBuilder: (context, index) {
          final (title, body) = sections[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(body, style: Theme.of(context).textTheme.bodyMedium),
            ],
          );
        },
      ),
    );
  }
}
