import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../app_pin_prefs.dart';

/// Prompts the user to enter a new PIN twice, returning it once confirmed
/// (or null if cancelled). Doesn't persist it -- callers pass the result to
/// [setAppPin] themselves.
Future<String?> showSetPinDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final pinController = TextEditingController();
  final confirmController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (dialogContext) {
      String? error;
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(l10n.setAppPinTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: pinController,
                  autofocus: true,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 6,
                  decoration: InputDecoration(hintText: l10n.appPinHint),
                ),
                TextField(
                  controller: confirmController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 6,
                  decoration: InputDecoration(hintText: l10n.appPinConfirmHint),
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () {
                  final pin = pinController.text.trim();
                  final confirm = confirmController.text.trim();
                  if (pin.length < 4) {
                    setState(() => error = l10n.appPinTooShortMessage);
                    return;
                  }
                  if (pin != confirm) {
                    setState(() => error = l10n.appPinMismatchMessage);
                    return;
                  }
                  Navigator.of(dialogContext).pop(pin);
                },
                child: Text(l10n.saveButton),
              ),
            ],
          );
        },
      );
    },
  );
}

/// Prompts for the existing PIN and verifies it against [verifyAppPin].
Future<bool> showVerifyPinDialog(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context)!;
  final controller = TextEditingController();

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      String? error;
      return StatefulBuilder(
        builder: (context, setState) {
          void submit() {
            if (verifyAppPin(ref, controller.text.trim())) {
              Navigator.of(dialogContext).pop(true);
            } else {
              setState(() => error = l10n.appPinIncorrectMessage);
            }
          }

          return AlertDialog(
            title: Text(l10n.enterAppPinTitle),
            content: TextField(
              controller: controller,
              autofocus: true,
              obscureText: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 6,
              decoration: InputDecoration(
                hintText: l10n.appPinHint,
                errorText: error,
              ),
              onSubmitted: (_) => submit(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancel),
              ),
              TextButton(onPressed: submit, child: Text(l10n.unlockButtonLabel)),
            ],
          );
        },
      );
    },
  );
  return result ?? false;
}
