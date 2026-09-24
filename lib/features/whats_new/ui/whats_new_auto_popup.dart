import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../whats_new_prefs.dart';

/// Invisible; on first build after an app update (not a fresh install) it
/// shows a one-time dialog summarizing the latest version's release notes.
/// Placed inside [ChatListScreen] so `context` has a Navigator ancestor for
/// `showDialog` (unlike the app-wide gates in app.dart's MaterialApp.builder,
/// which sit above the Navigator -- see AppLockGate's doc comment).
class WhatsNewAutoPopup extends StatefulWidget {
  const WhatsNewAutoPopup({super.key});

  @override
  State<WhatsNewAutoPopup> createState() => _WhatsNewAutoPopupState();
}

class _WhatsNewAutoPopupState extends State<WhatsNewAutoPopup> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShow());
  }

  Future<void> _maybeShow() async {
    final shouldShow = await checkShouldShowWhatsNew();
    if (!shouldShow || !mounted) return;
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.whatsNewDialogTitle),
        content: SingleChildScrollView(child: Text(l10n.whatsNewV120Body)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.whatsNewDialogOkButton),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
