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

/// [senders] with the user's own name ([selfName]) passed through [label]
/// (e.g. "山田（自分）"), for exports and stats that show names as text.
Map<int, String> markSelfSender(
  Map<int, String> senders,
  String? selfName,
  String Function(String name) label,
) {
  if (selfName == null || selfName.isEmpty) return senders;
  // A sender literally named the bare word ("自分", "me") needs no mark.
  final bareWord = label('').replaceAll(RegExp(r'[\s()（）]'), '');
  if (selfName == bareWord) return senders;
  return {
    for (final e in senders.entries)
      e.key: e.value == selfName ? label(e.value) : e.value,
  };
}
