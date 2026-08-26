import 'package:local_auth/local_auth.dart';

/// Wraps the device's own biometric/PIN/pattern authentication (via
/// local_auth) so the app can gate access without implementing and storing
/// a custom passcode itself.
class AppLockService {
  final _auth = LocalAuthentication();

  Future<bool> isSupported() => _auth.isDeviceSupported();

  /// [reason] is shown in the OS's own biometric/PIN prompt, which isn't a
  /// Flutter widget -- callers pass in an already-localized string (see
  /// AppLocalizations.appLockAuthReason) since this class has no
  /// BuildContext of its own.
  Future<bool> authenticate({String reason = 'Authenticate to continue'}) {
    return _auth.authenticate(
      localizedReason: reason,
      // Allow falling back to the device's PIN/pattern/password, not just
      // biometrics, since not every device has biometrics enrolled.
      biometricOnly: false,
    );
  }
}
