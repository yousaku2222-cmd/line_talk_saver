import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/db/app_database.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/repositories/import_repository.dart';

/// Overridden in `main()` with the awaited [SharedPreferences] instance
/// before `runApp` -- reading prefs is synchronous once loaded.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main()');
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(appDatabaseProvider));
});

final importRepositoryProvider = Provider<ImportRepository>((ref) {
  return ImportRepository(ref.watch(appDatabaseProvider));
});
