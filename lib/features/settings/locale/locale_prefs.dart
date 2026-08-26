import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';

const _localeKey = 'app_locale';

/// The languages the app's own UI can be switched to, in the order they're
/// offered in Settings. Each must also be listed in AppLocalizations.supportedLocales
/// (see lib/l10n/*.arb) or Flutter will silently fall back to the app's
/// default locale instead of the one the user picked.
const supportedAppLocales = <Locale>[
  Locale('ja'),
  Locale('en'),
  Locale('th'),
  Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  Locale('id'),
  Locale('ko'),
];

String _encodeLocale(Locale locale) {
  final script = locale.scriptCode;
  return script == null ? locale.languageCode : '${locale.languageCode}_$script';
}

Locale? _decodeLocale(String? code) {
  if (code == null || code.isEmpty) return null;
  final parts = code.split('_');
  if (parts.length == 2) {
    return Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1]);
  }
  return Locale(parts[0]);
}

/// The user's chosen in-app UI language, or null to follow the device's
/// system language (resolved against [supportedAppLocales] by Flutter).
final localeProvider = StateProvider<Locale?>((ref) {
  final stored = ref.watch(sharedPreferencesProvider).getString(_localeKey);
  return _decodeLocale(stored);
});

Future<void> setAppLocale(WidgetRef ref, Locale? locale) async {
  ref.read(localeProvider.notifier).state = locale;
  final prefs = ref.read(sharedPreferencesProvider);
  if (locale == null) {
    await prefs.remove(_localeKey);
  } else {
    await prefs.setString(_localeKey, _encodeLocale(locale));
  }
}
