import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/db/app_database.dart';

final chatListProvider = StreamProvider<List<Chat>>((ref) {
  return ref.watch(chatRepositoryProvider).watchAllChats();
});
