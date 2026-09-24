import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _lastSeenBuildKey = 'whats_new_last_seen_build';

/// Whether the update dialog should be shown right now: true only when the
/// app's build number is different from the one recorded on a previous
/// launch (i.e. an existing install was just updated) -- never on a brand
/// new install, since there is nothing to have "just changed" from.
///
/// Records the current build as seen as a side effect, so this must be
/// called at most once per app start (see [WhatsNewAutoPopup]).
Future<bool> checkShouldShowWhatsNew() async {
  final info = await PackageInfo.fromPlatform();
  final prefs = await SharedPreferences.getInstance();
  final lastSeen = prefs.getString(_lastSeenBuildKey);
  await prefs.setString(_lastSeenBuildKey, info.buildNumber);
  return lastSeen != null && lastSeen != info.buildNumber;
}
