import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';

const _pinHashKey = 'app_pin_hash';
const _pinSaltKey = 'app_pin_salt';

/// Whether an app-level PIN has been set -- the fallback authentication
/// method used when the device itself has no screen lock configured, so
/// locking (app-wide or per-chat) still works regardless of device settings.
final appPinSetProvider = StateProvider<bool>((ref) {
  return ref.watch(sharedPreferencesProvider).containsKey(_pinHashKey);
});

String _saltedHash(String pin, String salt) {
  return sha256.convert(utf8.encode('$salt:$pin')).toString();
}

String _generateSalt() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  return base64UrlEncode(bytes);
}

Future<void> setAppPin(WidgetRef ref, String pin) async {
  final prefs = ref.read(sharedPreferencesProvider);
  final salt = _generateSalt();
  await prefs.setString(_pinSaltKey, salt);
  await prefs.setString(_pinHashKey, _saltedHash(pin, salt));
  ref.read(appPinSetProvider.notifier).state = true;
}

Future<void> clearAppPin(WidgetRef ref) async {
  final prefs = ref.read(sharedPreferencesProvider);
  await prefs.remove(_pinHashKey);
  await prefs.remove(_pinSaltKey);
  ref.read(appPinSetProvider.notifier).state = false;
}

bool verifyAppPin(WidgetRef ref, String pin) {
  final prefs = ref.read(sharedPreferencesProvider);
  final salt = prefs.getString(_pinSaltKey);
  final storedHash = prefs.getString(_pinHashKey);
  if (salt == null || storedHash == null) return false;
  return _saltedHash(pin, salt) == storedHash;
}
