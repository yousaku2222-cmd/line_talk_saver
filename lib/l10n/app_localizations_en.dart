// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Talk Saver';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get unknownSender => 'Unknown';

  @override
  String loadErrorWithMessage(Object error) {
    return 'Failed to load: $error';
  }

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get importButtonLabel => 'Import a chat';

  @override
  String get createChatRoomTitle => 'Create a new chat room';

  @override
  String get createChatRoomHint => 'Chat room name';

  @override
  String get createChatRoomButton => 'Create';

  @override
  String get deleteChatConfirmTitle => 'Delete this chat?';

  @override
  String get pickChatIconTitle => 'Choose an icon';

  @override
  String get pickChatIconLockedHint =>
      'Icons with 🔒 unlock permanently after watching one ad.';

  @override
  String get unlockIconDialogTitle => 'Unlock this icon?';

  @override
  String get unlockIconDialogBody =>
      'Watch one ad to unlock this icon for good.';

  @override
  String get unlockIconWatchAdButton => 'Watch ad';

  @override
  String get unlockIconFailedMessage =>
      'Couldn\'t play the ad. Please try again in a moment.';

  @override
  String get themePickerLockedHint =>
      'Themes with 🔒 unlock permanently after watching one ad.';

  @override
  String get unlockThemeDialogTitle => 'Unlock this theme?';

  @override
  String get unlockThemeDialogBody =>
      'Watch one ad to unlock this theme for good.';

  @override
  String get renameChatTitle => 'Rename this chat';

  @override
  String get renameChatButton => 'Rename';

  @override
  String get renameChatTooltip => 'Rename';

  @override
  String get chatLockTooltip => 'Lock this chat';

  @override
  String get chatUnlockTooltip => 'Unlock';

  @override
  String get chatLockAuthReason => 'Authenticate to view this chat';

  @override
  String get chatLockPaywallTitle => 'About per-chat lock';

  @override
  String get chatLockPaywallBody =>
      'Locking individual chats unlocks with the \"Remove ads\" purchase.';

  @override
  String get purchaseButton => 'Purchase';

  @override
  String createdAtLabel(Object datetime) {
    return 'Created: $datetime';
  }

  @override
  String get manualRoomBadgeLabel => 'Photo room';

  @override
  String get deletePlaceholderConfirmTitle => 'Delete this message?';

  @override
  String get deletePlaceholderConfirmBody =>
      'This message will be deleted, along with any attached photo or video. This cannot be undone.';

  @override
  String get deleteChatConfirmBody =>
      'This will delete the saved data for this chat. This cannot be undone.';

  @override
  String get detachSelectedTooltip =>
      'Remove photos/videos from selected messages only';

  @override
  String get detachMessagesConfirmTitle => 'Remove photos/videos?';

  @override
  String detachMessagesConfirmBody(Object count) {
    return 'This will remove the attached photos or videos from $count selected message(s). The messages themselves will stay. This cannot be undone.';
  }

  @override
  String get deleteAttachmentTooltip => 'Delete';

  @override
  String get deleteAttachmentConfirmTitle => 'Delete this?';

  @override
  String get deleteAttachmentConfirmBody =>
      'This photo or video will be deleted. This cannot be undone.';

  @override
  String deleteAttachmentFailedMessage(Object error) {
    return 'Couldn\'t delete this: $error';
  }

  @override
  String get saveToDeviceTooltip => 'Save to device';

  @override
  String get saveToDeviceSuccessMessage => 'Saved to device';

  @override
  String saveToDeviceFailedMessage(Object error) {
    return 'Couldn\'t save this: $error';
  }

  @override
  String get emptyChatListMessage =>
      'No chats have been imported yet.\nIn LINE, use \"Send Chat as Text\", then load the saved file with the button below.';

  @override
  String importedAtLabel(Object datetime) {
    return 'Imported: $datetime';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appLockToggleTitle => 'Lock on launch';

  @override
  String get appLockToggleSubtitle =>
      'Protects the app with your device\'s PIN, pattern, or biometrics (or your App PIN below, if set, which takes priority)';

  @override
  String get appLockUnsupportedMessage =>
      'This device doesn\'t have a screen lock (PIN, pattern, biometrics, etc.) set up. Set an App PIN below to use locking anyway.';

  @override
  String get appPinSectionTitle => 'App PIN';

  @override
  String get appPinSetSubtitle =>
      'Set. Locking works even without a device screen lock.';

  @override
  String get appPinNotSetSubtitle =>
      'Not set. Set one so locking works even without a device screen lock.';

  @override
  String get setAppPinButton => 'Set';

  @override
  String get changeAppPinButton => 'Change';

  @override
  String get setAppPinTitle => 'Set an app PIN';

  @override
  String get appPinHint => 'PIN (4-6 digits)';

  @override
  String get appPinConfirmHint => 'Enter again';

  @override
  String get appPinTooShortMessage => 'PIN must be at least 4 digits';

  @override
  String get appPinMismatchMessage => 'PINs don\'t match';

  @override
  String get enterAppPinTitle => 'Enter PIN';

  @override
  String get appPinIncorrectMessage => 'Incorrect PIN';

  @override
  String get appPinManageAuthReason =>
      'Authenticate to change or remove the PIN';

  @override
  String get removeAppPinWarningTitle => 'Remove the app PIN?';

  @override
  String get removeAppPinWarningBody =>
      'This device has no other working authentication method. If you have any locked chats or app-wide lock enabled, you won\'t be able to unlock them after removing the PIN.';

  @override
  String get purchaseUnavailableMessage =>
      'Purchases aren\'t available on this device.';

  @override
  String get purchaseFetchFailedMessage =>
      'Couldn\'t fetch purchase details. Please try again later.';

  @override
  String get restoringPurchasesMessage => 'Checking your purchase history…';

  @override
  String get removeAdsTitle => 'Remove ads';

  @override
  String get removeAdsPurchasedSubtitle =>
      'Purchased. Thank you for your support!';

  @override
  String get removeAdsSubtitle =>
      'A one-time purchase that removes ads permanently';

  @override
  String get restorePurchaseTitle => 'Restore purchase';

  @override
  String get restorePurchaseSubtitle =>
      'If you switched devices, restore your purchase here';

  @override
  String get backupTitle => 'Create backup';

  @override
  String get backupSubtitle =>
      'Save all your data as one file (for switching devices)';

  @override
  String backupCreateFailedMessage(Object error) {
    return 'Couldn\'t create the backup: $error';
  }

  @override
  String get restoreBackupTitle => 'Restore from backup';

  @override
  String get restoreBackupSubtitle => 'Load a backup file you created earlier';

  @override
  String get restoreBackupConfirmTitle => 'Restore this backup?';

  @override
  String get restoreBackupConfirmBody =>
      'All current data will be overwritten. This can\'t be undone.';

  @override
  String get restoreBackupSuccessMessage => 'Restore complete';

  @override
  String get restoreBackupInvalidFileMessage =>
      'This isn\'t a valid backup file';

  @override
  String restoreBackupFailedMessage(Object error) {
    return 'Restore failed: $error';
  }

  @override
  String get backupUnlockTitle => 'Backup & restore';

  @override
  String get backupUnlockSubtitle =>
      'One-time purchase to create and restore backups anytime';

  @override
  String get backupPaywallTitle => 'Unlock backup & restore?';

  @override
  String get backupPaywallBody =>
      'A one-time purchase lets you create and restore backups anytime.';

  @override
  String get languageSettingTitle => 'Language';

  @override
  String get languageSystemDefault => 'Follow device language';

  @override
  String get lockedMessage => 'Locked';

  @override
  String get unlockButtonLabel => 'Authenticate to unlock';

  @override
  String get appLockAuthReason => 'Authenticate to view your chats';

  @override
  String get filterTitle => 'Filter';

  @override
  String get textSearchLabel => 'Search text';

  @override
  String get keywordHint => 'Enter a keyword';

  @override
  String get senderLabel => 'Sender';

  @override
  String get periodLabel => 'Date range';

  @override
  String get periodPickerButton => 'Choose a date range';

  @override
  String periodRangeFormat(Object start, Object end) {
    return '$start – $end';
  }

  @override
  String get clearButton => 'Clear';

  @override
  String get applyButton => 'Apply';

  @override
  String get loadingTitle => 'Loading...';

  @override
  String get copySelectedTooltip => 'Copy selected messages';

  @override
  String copiedMessage(Object label) {
    return 'Copied $label';
  }

  @override
  String selectedCountLabel(Object count) {
    return '$count selected';
  }

  @override
  String get photosTooltip => 'Photos';

  @override
  String get filterTooltip => 'Filter by sender or date';

  @override
  String get copyAllTooltip => 'Copy all';

  @override
  String allCountLabel(Object count) {
    return 'All $count';
  }

  @override
  String get exportTooltip => 'Export';

  @override
  String get defaultChatTitleForExport => 'Chat';

  @override
  String get noMessagesFiltered => 'No messages match this filter';

  @override
  String get noMessagesAtAll => 'No messages';

  @override
  String tapToAttachPhoto(Object placeholder) {
    return '$placeholder Tap to attach a photo';
  }

  @override
  String tapToAttachVideo(Object placeholder) {
    return '$placeholder Tap to attach a video';
  }

  @override
  String tapToAttachFile(Object placeholder) {
    return '$placeholder Tap to attach a file';
  }

  @override
  String get photosTitle => 'Photos';

  @override
  String get noPhotosMessage =>
      'No photos in this chat yet.\nAdd one with the button below.';

  @override
  String get addPhotoTooltip => 'Add a photo';

  @override
  String get addVideoLabel => 'Add a video';

  @override
  String get addFileLabel => 'Add a file';

  @override
  String openFileFailedMessage(Object error) {
    return 'Couldn\'t open this file: $error';
  }

  @override
  String get addMediaTooltip => 'Add a photo or video';

  @override
  String get pickChatForPhotoTitle => 'Choose a chat for this photo';

  @override
  String get noChatsForPhotoMessage =>
      'No chats yet. Import a LINE chat first.';

  @override
  String attachPendingPhotoBannerMessage(Object count) {
    return 'Tap the message to attach this to ($count remaining)';
  }

  @override
  String get photoAttachedMessage => 'Photo attached';

  @override
  String get fileAttachedMessage => 'File attached';

  @override
  String get attachPendingDirectlyButton => 'Add straight to chat';

  @override
  String pendingAttachedToRoomMessage(Object count) {
    return 'Added $count item(s) to this chat room';
  }

  @override
  String get exportFormatTitle => 'Choose an export format';

  @override
  String get excelOption => 'Excel (.xlsx)';

  @override
  String get pdfOption => 'PDF';

  @override
  String get wordOption => 'Word (.docx)';

  @override
  String exportFailedMessage(Object error) {
    return 'Export failed: $error';
  }

  @override
  String get excelSheetName => 'Chat';

  @override
  String get columnDate => 'Date';

  @override
  String get columnTime => 'Time';

  @override
  String get columnSender => 'Sender';

  @override
  String get columnBody => 'Message';

  @override
  String get systemSender => 'System';

  @override
  String get excelGenerationFailed => 'Failed to generate the Excel file';

  @override
  String get docxGenerationFailed => 'Failed to generate the Word file';

  @override
  String get importScreenTitle => 'Import a chat';

  @override
  String get idleImportInstruction =>
      'In LINE, open the chat and choose \"Send Chat as Text\",\nthen load the saved .txt file here.';

  @override
  String get openLineButton => 'Open LINE';

  @override
  String get lineNotInstalledMessage => 'LINE isn\'t installed';

  @override
  String get selectFileButton => 'Choose a file';

  @override
  String get retrySelectFileButton => 'Choose again';

  @override
  String get sharedTextFallbackTitle => 'LINE chat (shared)';

  @override
  String sharedContentLoadFailed(Object error) {
    return 'Failed to load the shared content: $error';
  }

  @override
  String fileLoadFailed(Object error) {
    return 'Failed to load the file: $error';
  }

  @override
  String saveFailedMessage(Object error) {
    return 'Failed to save: $error';
  }

  @override
  String get previewLabelTitle => 'Title';

  @override
  String get previewLabelMessageCount => 'Messages';

  @override
  String get previewLabelParticipantCount => 'Participants';

  @override
  String get previewNoTitleDetected => '(none detected)';

  @override
  String previewMessageCountValue(Object count) {
    return '$count';
  }

  @override
  String previewParticipantCountValue(Object count) {
    return '$count';
  }

  @override
  String get previewSuspiciousMessage =>
      'No messages could be recognized. Please check that this is a .txt file exported directly from LINE.';

  @override
  String previewUnrecognizedLinesMessage(Object count) {
    return '$count line(s) were folded into the previous message.';
  }

  @override
  String get saveButton => 'Save';

  @override
  String get helpMenuTitle => 'User Guide';

  @override
  String get helpMenuSubtitle => 'See how to use the app\'s features';

  @override
  String get helpScreenTitle => 'User Guide';

  @override
  String get helpAboutTitle => 'About this app';

  @override
  String get helpAboutBody =>
      'Talk Saver is an app for saving your LINE chat history to your device in a format that\'s easy to look back on. It never operates LINE automatically — it works by importing the .txt file you export using LINE\'s own \"Send chat as text\" feature.';

  @override
  String get helpImportTitle => 'Importing a chat';

  @override
  String get helpImportBody =>
      '1. In LINE, open the chat, tap the menu (≡) → \"Send chat history\" → \"Send as text\"\n2. Choose \"Talk Saver\" from the share sheet to import it automatically\n3. If it doesn\'t appear in the list, save it as a .txt file first, then use \"Import chat\" → \"Choose file\" in this app\n\nYou can also jump straight to LINE using the \"Open LINE\" button on the import screen.';

  @override
  String get helpChatListTitle => 'Managing the chat list';

  @override
  String get helpChatListBody =>
      '• Tap the icon to the left of a chat to change it to any icon you like\n• Tap the pencil icon to rename a chat\n• Use the + button at the top right to create a new room just for photos, videos, and files\n• Tap the lock icon to lock an individual chat (requires purchase)';

  @override
  String get helpChatDetailTitle => 'Using the chat screen';

  @override
  String get helpChatDetailBody =>
      '• Long-press or multi-select messages to copy them\n• Filter by sender, date range, or keyword\n• Export to Excel, PDF, or Word from the icon at the top right\n• Use the gallery icon to view all photos attached to that chat';

  @override
  String get helpAttachTitle => 'Attaching photos, videos, and files';

  @override
  String get helpAttachBody =>
      'Tap a [Photo] or [Sticker] placeholder to attach a photo or video from your device. LINE\'s export doesn\'t include the actual images, so they can\'t be restored automatically.';

  @override
  String get helpLockTitle => 'About locking';

  @override
  String get helpLockBody =>
      'In Settings, you can require biometric authentication, a device PIN, or an in-app PIN to open the app. If you set an in-app PIN, it takes priority over your device\'s biometric authentication.\n\nLocking individual chats is included in the same purchase as removing ads.';

  @override
  String get helpBackupTitle => 'Backup and restore';

  @override
  String get helpBackupBody =>
      'Use \"Create backup\" in Settings to save all your imported chats and attachments into a single file. Use \"Restore from backup\" to bring the same data to a new device -- this works even when switching between iPhone and Android, since the backup file isn\'t tied to either platform.';

  @override
  String get helpPrivacyTitle => 'Where your data is stored';

  @override
  String get helpPrivacyBody =>
      'Everything you import or attach is stored only on this device. Nothing is ever sent to a server.';

  @override
  String get feedbackMenuTitle => 'Feedback & bug reports';

  @override
  String get feedbackMenuSubtitle => 'Send us anything you notice by email';

  @override
  String get feedbackEmailSubject => '[Talk Saver] Feedback';

  @override
  String get feedbackEmailBody =>
      'Please write your feedback, requests, or the bug below.\n(For a bug, it helps to include what you were doing and your device model.)\n\n';

  @override
  String get feedbackLaunchFailedMessage =>
      'Couldn\'t open a mail app. Please contact talk-hozon-testers@googlegroups.com.';

  @override
  String get appVersionTitle => 'App version';
}
