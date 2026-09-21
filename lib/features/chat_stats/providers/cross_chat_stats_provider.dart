import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/db/app_database.dart';

final allChatsForDashboardProvider = StreamProvider<List<Chat>>((ref) {
  return ref.watch(chatRepositoryProvider).watchAllChats();
});

final allMessagesForDashboardProvider = StreamProvider<List<Message>>((ref) {
  return ref.watch(chatRepositoryProvider).watchAllMessages();
});
