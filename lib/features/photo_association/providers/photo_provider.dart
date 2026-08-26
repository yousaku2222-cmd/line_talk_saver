import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/db/app_database.dart';

final chatImageAttachmentsProvider =
    StreamProvider.family<List<ImageAttachment>, int>((ref, chatId) {
  return ref.watch(chatRepositoryProvider).watchImageAttachments(chatId);
});
