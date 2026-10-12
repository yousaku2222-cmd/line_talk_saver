import 'package:shared_preferences/shared_preferences.dart';

const _knownSelfNamesKey = 'known_self_sender_names';

/// Display names the user has picked as "me" in any chat. A LINE export
/// names the user by their LINE display name, which is the same across
/// their chats, so one pick lets every other chat with that name (and any
/// imported later) place the user's messages on the right automatically.
List<String> knownSelfNames(SharedPreferences prefs) =>
    prefs.getStringList(_knownSelfNamesKey) ?? const [];

Future<void> rememberSelfName(SharedPreferences prefs, String name) async {
  final names = knownSelfNames(prefs);
  if (name.isEmpty || names.contains(name)) return;
  await prefs.setStringList(_knownSelfNamesKey, [...names, name]);
}

/// The sender in [senderNames] to treat as "me" without asking: the single
/// one whose name was picked before. null when none or several match.
String? guessSelfName(SharedPreferences prefs, Iterable<String> senderNames) {
  final known = knownSelfNames(prefs).toSet();
  final matches = senderNames.where(known.contains).toSet();
  return matches.length == 1 ? matches.single : null;
}
