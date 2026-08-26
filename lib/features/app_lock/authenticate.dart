import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_lock_service.dart';
import 'app_pin_prefs.dart';
import 'ui/pin_entry_dialog.dart';

/// True if some form of authentication is available at all -- the app's own
/// PIN (see app_pin_prefs.dart), or the device's own biometrics/PIN.
Future<bool> canAuthenticate(WidgetRef ref) async {
  if (ref.read(appPinSetProvider)) return true;
  return AppLockService().isSupported();
}

/// Authenticates via the app's own PIN (set in Settings) when one is
/// configured -- taking priority over the device's own biometrics/PIN even
/// if the device has a screen lock, since the app PIN is what the user
/// explicitly chose to gate this app with. Falls back to the device's
/// biometrics/PIN only when no app PIN is set. Returns false if
/// authentication fails, is cancelled, or neither method is available.
Future<bool> requestAuthentication(
  BuildContext context,
  WidgetRef ref, {
  required String reason,
}) async {
  if (ref.read(appPinSetProvider)) {
    if (!context.mounted) return false;
    return showVerifyPinDialog(context, ref);
  }
  if (await AppLockService().isSupported()) {
    try {
      return await AppLockService().authenticate(reason: reason);
    } catch (_) {
      return false;
    }
  }
  return false;
}
