import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/navigation/root_navigator_key.dart';
import 'core/theme/app_theme.dart';
import 'features/app_lock/ui/app_lock_gate.dart';
import 'features/chat_detail/ui/chat_detail_screen.dart';
import 'features/chat_detail/ui/chat_detail_screen_args.dart';
import 'features/chat_list/ui/chat_list_screen.dart';
import 'features/help/ui/help_screen.dart';
import 'features/import/ui/import_screen.dart';
import 'features/import/ui/import_screen_args.dart';
import 'features/monetization/purchase/purchase_listener.dart';
import 'features/photo_association/ui/pending_photo_args.dart';
import 'features/photo_association/ui/photo_gallery_screen.dart';
import 'features/photo_association/ui/photo_gallery_screen_args.dart';
import 'features/photo_association/ui/pick_chat_for_photo_screen.dart';
import 'features/settings/locale/locale_prefs.dart';
import 'features/settings/ui/settings_screen.dart';
import 'l10n/app_localizations.dart';

class LineTalkSaverApp extends ConsumerWidget {
  const LineTalkSaverApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      navigatorKey: rootNavigatorKey,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      // null follows the device's system language, resolved against
      // supportedLocales below; the user can override it in Settings.
      locale: locale,
      supportedLocales: supportedAppLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => PurchaseListener(
        child: AppLockGate(child: child ?? const SizedBox.shrink()),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const ChatListScreen());
          case '/import':
            final args = settings.arguments as ImportScreenArgs?;
            return MaterialPageRoute(
              builder: (_) => ImportScreen(initialShare: args),
            );
          case '/chat':
            final args = settings.arguments;
            final chatArgs = args is ChatDetailScreenArgs
                ? args
                : ChatDetailScreenArgs(chatId: args as int);
            return MaterialPageRoute(
              builder: (_) => ChatDetailScreen(
                chatId: chatArgs.chatId,
                pendingPhotoPaths: chatArgs.pendingPhotoPaths,
              ),
            );
          case '/pick-chat-for-photo':
            final args = settings.arguments as PendingPhotoArgs;
            return MaterialPageRoute(
              builder: (_) => PickChatForPhotoScreen(args: args),
            );
          case '/photos':
            final args = settings.arguments;
            final photoArgs = args is PhotoGalleryScreenArgs
                ? args
                : PhotoGalleryScreenArgs(chatId: args as int);
            return MaterialPageRoute(
              builder: (_) => PhotoGalleryScreen(
                chatId: photoArgs.chatId,
                pendingPhotoPaths: photoArgs.pendingPhotoPaths,
              ),
            );
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsScreen());
          case '/help':
            return MaterialPageRoute(builder: (_) => const HelpScreen());
          default:
            return MaterialPageRoute(builder: (_) => const ChatListScreen());
        }
      },
    );
  }
}
