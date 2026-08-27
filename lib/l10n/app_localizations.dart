import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_th.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('ja'),
    Locale('ko'),
    Locale('th'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ja, this message translates to:
  /// **'トーク保存'**
  String get appTitle;

  /// No description provided for @cancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get delete;

  /// No description provided for @unknownSender.
  ///
  /// In ja, this message translates to:
  /// **'不明'**
  String get unknownSender;

  /// No description provided for @loadErrorWithMessage.
  ///
  /// In ja, this message translates to:
  /// **'読み込みエラー: {error}'**
  String loadErrorWithMessage(Object error);

  /// No description provided for @settingsTooltip.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settingsTooltip;

  /// No description provided for @importButtonLabel.
  ///
  /// In ja, this message translates to:
  /// **'トークを取り込む'**
  String get importButtonLabel;

  /// No description provided for @createChatRoomTitle.
  ///
  /// In ja, this message translates to:
  /// **'新しいトークルームを作成'**
  String get createChatRoomTitle;

  /// No description provided for @createChatRoomHint.
  ///
  /// In ja, this message translates to:
  /// **'トークルーム名'**
  String get createChatRoomHint;

  /// No description provided for @createChatRoomButton.
  ///
  /// In ja, this message translates to:
  /// **'作成'**
  String get createChatRoomButton;

  /// No description provided for @deleteChatConfirmTitle.
  ///
  /// In ja, this message translates to:
  /// **'削除しますか？'**
  String get deleteChatConfirmTitle;

  /// No description provided for @pickChatIconTitle.
  ///
  /// In ja, this message translates to:
  /// **'アイコンを選択'**
  String get pickChatIconTitle;

  /// No description provided for @renameChatTitle.
  ///
  /// In ja, this message translates to:
  /// **'トーク名を変更'**
  String get renameChatTitle;

  /// No description provided for @renameChatButton.
  ///
  /// In ja, this message translates to:
  /// **'変更'**
  String get renameChatButton;

  /// No description provided for @renameChatTooltip.
  ///
  /// In ja, this message translates to:
  /// **'名称を変更'**
  String get renameChatTooltip;

  /// No description provided for @chatLockTooltip.
  ///
  /// In ja, this message translates to:
  /// **'このトークをロック'**
  String get chatLockTooltip;

  /// No description provided for @chatUnlockTooltip.
  ///
  /// In ja, this message translates to:
  /// **'ロックを解除'**
  String get chatUnlockTooltip;

  /// No description provided for @chatLockAuthReason.
  ///
  /// In ja, this message translates to:
  /// **'このトークを表示するには認証してください'**
  String get chatLockAuthReason;

  /// No description provided for @chatLockPaywallTitle.
  ///
  /// In ja, this message translates to:
  /// **'個別ロックについて'**
  String get chatLockPaywallTitle;

  /// No description provided for @chatLockPaywallBody.
  ///
  /// In ja, this message translates to:
  /// **'個別ロック機能は「広告を非表示にする」を購入すると使えるようになります。'**
  String get chatLockPaywallBody;

  /// No description provided for @purchaseButton.
  ///
  /// In ja, this message translates to:
  /// **'購入する'**
  String get purchaseButton;

  /// No description provided for @createdAtLabel.
  ///
  /// In ja, this message translates to:
  /// **'作成日時: {datetime}'**
  String createdAtLabel(Object datetime);

  /// No description provided for @manualRoomBadgeLabel.
  ///
  /// In ja, this message translates to:
  /// **'写真ルーム'**
  String get manualRoomBadgeLabel;

  /// No description provided for @deletePlaceholderConfirmTitle.
  ///
  /// In ja, this message translates to:
  /// **'削除しますか？'**
  String get deletePlaceholderConfirmTitle;

  /// No description provided for @deletePlaceholderConfirmBody.
  ///
  /// In ja, this message translates to:
  /// **'このメッセージを削除します。添付した写真・動画があればそれも削除されます。元には戻せません。'**
  String get deletePlaceholderConfirmBody;

  /// No description provided for @deleteChatConfirmBody.
  ///
  /// In ja, this message translates to:
  /// **'このトークの保存済みデータを削除します。元には戻せません。'**
  String get deleteChatConfirmBody;

  /// No description provided for @detachSelectedTooltip.
  ///
  /// In ja, this message translates to:
  /// **'選択したメッセージの写真・動画だけ削除'**
  String get detachSelectedTooltip;

  /// No description provided for @detachMessagesConfirmTitle.
  ///
  /// In ja, this message translates to:
  /// **'写真・動画を削除しますか？'**
  String get detachMessagesConfirmTitle;

  /// No description provided for @detachMessagesConfirmBody.
  ///
  /// In ja, this message translates to:
  /// **'選択した{count}件のメッセージから、添付した写真・動画だけを削除します。メッセージ自体は残ります。元には戻せません。'**
  String detachMessagesConfirmBody(Object count);

  /// No description provided for @deleteAttachmentTooltip.
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get deleteAttachmentTooltip;

  /// No description provided for @deleteAttachmentConfirmTitle.
  ///
  /// In ja, this message translates to:
  /// **'削除しますか？'**
  String get deleteAttachmentConfirmTitle;

  /// No description provided for @deleteAttachmentConfirmBody.
  ///
  /// In ja, this message translates to:
  /// **'この写真・動画を削除します。元には戻せません。'**
  String get deleteAttachmentConfirmBody;

  /// No description provided for @deleteAttachmentFailedMessage.
  ///
  /// In ja, this message translates to:
  /// **'削除に失敗しました: {error}'**
  String deleteAttachmentFailedMessage(Object error);

  /// No description provided for @saveToDeviceTooltip.
  ///
  /// In ja, this message translates to:
  /// **'端末に保存'**
  String get saveToDeviceTooltip;

  /// No description provided for @saveToDeviceSuccessMessage.
  ///
  /// In ja, this message translates to:
  /// **'端末に保存しました'**
  String get saveToDeviceSuccessMessage;

  /// No description provided for @saveToDeviceFailedMessage.
  ///
  /// In ja, this message translates to:
  /// **'保存に失敗しました: {error}'**
  String saveToDeviceFailedMessage(Object error);

  /// No description provided for @emptyChatListMessage.
  ///
  /// In ja, this message translates to:
  /// **'まだトークが取り込まれていません。\nLINEで「トークをテキストで送信」したファイルを右下のボタンから読み込んでください。'**
  String get emptyChatListMessage;

  /// No description provided for @importedAtLabel.
  ///
  /// In ja, this message translates to:
  /// **'取込日時: {datetime}'**
  String importedAtLabel(Object datetime);

  /// No description provided for @settingsTitle.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settingsTitle;

  /// No description provided for @appLockToggleTitle.
  ///
  /// In ja, this message translates to:
  /// **'起動時にロックする'**
  String get appLockToggleTitle;

  /// No description provided for @appLockToggleSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'端末のPIN・パターン・生体認証で保護します（下の「アプリPIN」設定時はそちらを優先使用）'**
  String get appLockToggleSubtitle;

  /// No description provided for @appLockUnsupportedMessage.
  ///
  /// In ja, this message translates to:
  /// **'この端末では画面ロック（PIN・パターン・生体認証など）が設定されていません。下の「アプリPIN」を設定するとロック機能を使えます。'**
  String get appLockUnsupportedMessage;

  /// No description provided for @appPinSectionTitle.
  ///
  /// In ja, this message translates to:
  /// **'アプリPIN'**
  String get appPinSectionTitle;

  /// No description provided for @appPinSetSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'設定済み。端末に画面ロックが無くてもロック機能を使えます'**
  String get appPinSetSubtitle;

  /// No description provided for @appPinNotSetSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'未設定。設定すると端末の画面ロックが無くてもロック機能を使えます'**
  String get appPinNotSetSubtitle;

  /// No description provided for @setAppPinButton.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get setAppPinButton;

  /// No description provided for @changeAppPinButton.
  ///
  /// In ja, this message translates to:
  /// **'変更'**
  String get changeAppPinButton;

  /// No description provided for @setAppPinTitle.
  ///
  /// In ja, this message translates to:
  /// **'アプリPINを設定'**
  String get setAppPinTitle;

  /// No description provided for @appPinHint.
  ///
  /// In ja, this message translates to:
  /// **'PIN（4〜6桁の数字）'**
  String get appPinHint;

  /// No description provided for @appPinConfirmHint.
  ///
  /// In ja, this message translates to:
  /// **'もう一度入力'**
  String get appPinConfirmHint;

  /// No description provided for @appPinTooShortMessage.
  ///
  /// In ja, this message translates to:
  /// **'PINは4桁以上で入力してください'**
  String get appPinTooShortMessage;

  /// No description provided for @appPinMismatchMessage.
  ///
  /// In ja, this message translates to:
  /// **'PINが一致しません'**
  String get appPinMismatchMessage;

  /// No description provided for @enterAppPinTitle.
  ///
  /// In ja, this message translates to:
  /// **'PINを入力'**
  String get enterAppPinTitle;

  /// No description provided for @appPinIncorrectMessage.
  ///
  /// In ja, this message translates to:
  /// **'PINが違います'**
  String get appPinIncorrectMessage;

  /// No description provided for @appPinManageAuthReason.
  ///
  /// In ja, this message translates to:
  /// **'PINを変更・削除するには認証してください'**
  String get appPinManageAuthReason;

  /// No description provided for @removeAppPinWarningTitle.
  ///
  /// In ja, this message translates to:
  /// **'アプリPINを削除しますか？'**
  String get removeAppPinWarningTitle;

  /// No description provided for @removeAppPinWarningBody.
  ///
  /// In ja, this message translates to:
  /// **'この端末には他に使える認証方法がありません。ロック中のトークやアプリロックがある場合、PINを削除すると解除できなくなります。'**
  String get removeAppPinWarningBody;

  /// No description provided for @purchaseUnavailableMessage.
  ///
  /// In ja, this message translates to:
  /// **'この端末では購入機能を利用できません。'**
  String get purchaseUnavailableMessage;

  /// No description provided for @purchaseFetchFailedMessage.
  ///
  /// In ja, this message translates to:
  /// **'購入情報を取得できませんでした。時間をおいて再度お試しください。'**
  String get purchaseFetchFailedMessage;

  /// No description provided for @restoringPurchasesMessage.
  ///
  /// In ja, this message translates to:
  /// **'購入情報を確認しています…'**
  String get restoringPurchasesMessage;

  /// No description provided for @removeAdsTitle.
  ///
  /// In ja, this message translates to:
  /// **'広告を非表示にする'**
  String get removeAdsTitle;

  /// No description provided for @removeAdsPurchasedSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'購入済みです。ご利用ありがとうございます。'**
  String get removeAdsPurchasedSubtitle;

  /// No description provided for @removeAdsSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'一度購入すると、以降ずっと広告が表示されなくなります'**
  String get removeAdsSubtitle;

  /// No description provided for @restorePurchaseTitle.
  ///
  /// In ja, this message translates to:
  /// **'購入を復元'**
  String get restorePurchaseTitle;

  /// No description provided for @restorePurchaseSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'機種変更などで再度購入済みの状態にする場合はこちら'**
  String get restorePurchaseSubtitle;

  /// No description provided for @backupTitle.
  ///
  /// In ja, this message translates to:
  /// **'バックアップを作成'**
  String get backupTitle;

  /// No description provided for @backupSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'全データを1つのファイルにまとめて保存します(機種変更などに)'**
  String get backupSubtitle;

  /// No description provided for @backupCreateFailedMessage.
  ///
  /// In ja, this message translates to:
  /// **'バックアップの作成に失敗しました: {error}'**
  String backupCreateFailedMessage(Object error);

  /// No description provided for @restoreBackupTitle.
  ///
  /// In ja, this message translates to:
  /// **'バックアップから復元'**
  String get restoreBackupTitle;

  /// No description provided for @restoreBackupSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'以前作成したバックアップファイルを読み込みます'**
  String get restoreBackupSubtitle;

  /// No description provided for @restoreBackupConfirmTitle.
  ///
  /// In ja, this message translates to:
  /// **'復元しますか？'**
  String get restoreBackupConfirmTitle;

  /// No description provided for @restoreBackupConfirmBody.
  ///
  /// In ja, this message translates to:
  /// **'現在のデータはすべて上書きされます。この操作は元に戻せません。'**
  String get restoreBackupConfirmBody;

  /// No description provided for @restoreBackupSuccessMessage.
  ///
  /// In ja, this message translates to:
  /// **'復元が完了しました'**
  String get restoreBackupSuccessMessage;

  /// No description provided for @restoreBackupInvalidFileMessage.
  ///
  /// In ja, this message translates to:
  /// **'有効なバックアップファイルではありません'**
  String get restoreBackupInvalidFileMessage;

  /// No description provided for @restoreBackupFailedMessage.
  ///
  /// In ja, this message translates to:
  /// **'復元に失敗しました: {error}'**
  String restoreBackupFailedMessage(Object error);

  /// No description provided for @languageSettingTitle.
  ///
  /// In ja, this message translates to:
  /// **'言語'**
  String get languageSettingTitle;

  /// No description provided for @languageSystemDefault.
  ///
  /// In ja, this message translates to:
  /// **'端末の設定に従う'**
  String get languageSystemDefault;

  /// No description provided for @lockedMessage.
  ///
  /// In ja, this message translates to:
  /// **'ロックされています'**
  String get lockedMessage;

  /// No description provided for @unlockButtonLabel.
  ///
  /// In ja, this message translates to:
  /// **'認証してロック解除'**
  String get unlockButtonLabel;

  /// No description provided for @appLockAuthReason.
  ///
  /// In ja, this message translates to:
  /// **'トーク内容を表示するには認証してください'**
  String get appLockAuthReason;

  /// No description provided for @filterTitle.
  ///
  /// In ja, this message translates to:
  /// **'絞り込み'**
  String get filterTitle;

  /// No description provided for @textSearchLabel.
  ///
  /// In ja, this message translates to:
  /// **'本文検索'**
  String get textSearchLabel;

  /// No description provided for @keywordHint.
  ///
  /// In ja, this message translates to:
  /// **'キーワードを入力'**
  String get keywordHint;

  /// No description provided for @senderLabel.
  ///
  /// In ja, this message translates to:
  /// **'発言者'**
  String get senderLabel;

  /// No description provided for @periodLabel.
  ///
  /// In ja, this message translates to:
  /// **'期間'**
  String get periodLabel;

  /// No description provided for @periodPickerButton.
  ///
  /// In ja, this message translates to:
  /// **'期間を選択'**
  String get periodPickerButton;

  /// No description provided for @periodRangeFormat.
  ///
  /// In ja, this message translates to:
  /// **'{start} 〜 {end}'**
  String periodRangeFormat(Object start, Object end);

  /// No description provided for @clearButton.
  ///
  /// In ja, this message translates to:
  /// **'クリア'**
  String get clearButton;

  /// No description provided for @applyButton.
  ///
  /// In ja, this message translates to:
  /// **'適用'**
  String get applyButton;

  /// No description provided for @loadingTitle.
  ///
  /// In ja, this message translates to:
  /// **'読み込み中...'**
  String get loadingTitle;

  /// No description provided for @copySelectedTooltip.
  ///
  /// In ja, this message translates to:
  /// **'選択したメッセージをコピー'**
  String get copySelectedTooltip;

  /// No description provided for @copiedMessage.
  ///
  /// In ja, this message translates to:
  /// **'{label}をコピーしました'**
  String copiedMessage(Object label);

  /// No description provided for @selectedCountLabel.
  ///
  /// In ja, this message translates to:
  /// **'選択した{count}件'**
  String selectedCountLabel(Object count);

  /// No description provided for @photosTooltip.
  ///
  /// In ja, this message translates to:
  /// **'写真'**
  String get photosTooltip;

  /// No description provided for @filterTooltip.
  ///
  /// In ja, this message translates to:
  /// **'発言者・期間で絞り込み'**
  String get filterTooltip;

  /// No description provided for @copyAllTooltip.
  ///
  /// In ja, this message translates to:
  /// **'すべてコピー'**
  String get copyAllTooltip;

  /// No description provided for @allCountLabel.
  ///
  /// In ja, this message translates to:
  /// **'全{count}件'**
  String allCountLabel(Object count);

  /// No description provided for @exportTooltip.
  ///
  /// In ja, this message translates to:
  /// **'エクスポート'**
  String get exportTooltip;

  /// No description provided for @defaultChatTitleForExport.
  ///
  /// In ja, this message translates to:
  /// **'トーク'**
  String get defaultChatTitleForExport;

  /// No description provided for @noMessagesFiltered.
  ///
  /// In ja, this message translates to:
  /// **'条件に一致するメッセージがありません'**
  String get noMessagesFiltered;

  /// No description provided for @noMessagesAtAll.
  ///
  /// In ja, this message translates to:
  /// **'メッセージがありません'**
  String get noMessagesAtAll;

  /// No description provided for @tapToAttachPhoto.
  ///
  /// In ja, this message translates to:
  /// **'{placeholder} タップして写真を添付'**
  String tapToAttachPhoto(Object placeholder);

  /// No description provided for @tapToAttachVideo.
  ///
  /// In ja, this message translates to:
  /// **'{placeholder} タップして動画を添付'**
  String tapToAttachVideo(Object placeholder);

  /// No description provided for @tapToAttachFile.
  ///
  /// In ja, this message translates to:
  /// **'{placeholder} タップしてファイルを添付'**
  String tapToAttachFile(Object placeholder);

  /// No description provided for @photosTitle.
  ///
  /// In ja, this message translates to:
  /// **'写真'**
  String get photosTitle;

  /// No description provided for @noPhotosMessage.
  ///
  /// In ja, this message translates to:
  /// **'このトークにはまだ写真がありません。\n右下のボタンから追加できます。'**
  String get noPhotosMessage;

  /// No description provided for @addPhotoTooltip.
  ///
  /// In ja, this message translates to:
  /// **'写真を追加'**
  String get addPhotoTooltip;

  /// No description provided for @addVideoLabel.
  ///
  /// In ja, this message translates to:
  /// **'動画を追加'**
  String get addVideoLabel;

  /// No description provided for @addFileLabel.
  ///
  /// In ja, this message translates to:
  /// **'ファイルを追加'**
  String get addFileLabel;

  /// No description provided for @openFileFailedMessage.
  ///
  /// In ja, this message translates to:
  /// **'ファイルを開けませんでした: {error}'**
  String openFileFailedMessage(Object error);

  /// No description provided for @addMediaTooltip.
  ///
  /// In ja, this message translates to:
  /// **'写真・動画を追加'**
  String get addMediaTooltip;

  /// No description provided for @pickChatForPhotoTitle.
  ///
  /// In ja, this message translates to:
  /// **'写真を追加するトークを選択'**
  String get pickChatForPhotoTitle;

  /// No description provided for @noChatsForPhotoMessage.
  ///
  /// In ja, this message translates to:
  /// **'トークがありません。先にLINEのトークを取り込んでください。'**
  String get noChatsForPhotoMessage;

  /// No description provided for @attachPendingPhotoBannerMessage.
  ///
  /// In ja, this message translates to:
  /// **'追加するメッセージをタップしてください(残り{count}件)'**
  String attachPendingPhotoBannerMessage(Object count);

  /// No description provided for @photoAttachedMessage.
  ///
  /// In ja, this message translates to:
  /// **'写真を追加しました'**
  String get photoAttachedMessage;

  /// No description provided for @fileAttachedMessage.
  ///
  /// In ja, this message translates to:
  /// **'ファイルを追加しました'**
  String get fileAttachedMessage;

  /// No description provided for @attachPendingDirectlyButton.
  ///
  /// In ja, this message translates to:
  /// **'トークに直接追加'**
  String get attachPendingDirectlyButton;

  /// No description provided for @pendingAttachedToRoomMessage.
  ///
  /// In ja, this message translates to:
  /// **'{count}件をこのトークルームに追加しました'**
  String pendingAttachedToRoomMessage(Object count);

  /// No description provided for @exportFormatTitle.
  ///
  /// In ja, this message translates to:
  /// **'エクスポート形式を選択'**
  String get exportFormatTitle;

  /// No description provided for @excelOption.
  ///
  /// In ja, this message translates to:
  /// **'Excel (.xlsx)'**
  String get excelOption;

  /// No description provided for @pdfOption.
  ///
  /// In ja, this message translates to:
  /// **'PDF'**
  String get pdfOption;

  /// No description provided for @wordOption.
  ///
  /// In ja, this message translates to:
  /// **'Word (.docx)'**
  String get wordOption;

  /// No description provided for @exportFailedMessage.
  ///
  /// In ja, this message translates to:
  /// **'エクスポートに失敗しました: {error}'**
  String exportFailedMessage(Object error);

  /// No description provided for @excelSheetName.
  ///
  /// In ja, this message translates to:
  /// **'トーク'**
  String get excelSheetName;

  /// No description provided for @columnDate.
  ///
  /// In ja, this message translates to:
  /// **'日付'**
  String get columnDate;

  /// No description provided for @columnTime.
  ///
  /// In ja, this message translates to:
  /// **'時刻'**
  String get columnTime;

  /// No description provided for @columnSender.
  ///
  /// In ja, this message translates to:
  /// **'発言者'**
  String get columnSender;

  /// No description provided for @columnBody.
  ///
  /// In ja, this message translates to:
  /// **'本文'**
  String get columnBody;

  /// No description provided for @systemSender.
  ///
  /// In ja, this message translates to:
  /// **'システム'**
  String get systemSender;

  /// No description provided for @excelGenerationFailed.
  ///
  /// In ja, this message translates to:
  /// **'Excelファイルの生成に失敗しました'**
  String get excelGenerationFailed;

  /// No description provided for @docxGenerationFailed.
  ///
  /// In ja, this message translates to:
  /// **'Wordファイルの生成に失敗しました'**
  String get docxGenerationFailed;

  /// No description provided for @importScreenTitle.
  ///
  /// In ja, this message translates to:
  /// **'トークを取り込む'**
  String get importScreenTitle;

  /// No description provided for @idleImportInstruction.
  ///
  /// In ja, this message translates to:
  /// **'LINEアプリのトーク画面で「トークをテキストで送信」を選び、\n保存した.txtファイルをここから読み込んでください。'**
  String get idleImportInstruction;

  /// No description provided for @openLineButton.
  ///
  /// In ja, this message translates to:
  /// **'LINEを開く'**
  String get openLineButton;

  /// No description provided for @lineNotInstalledMessage.
  ///
  /// In ja, this message translates to:
  /// **'LINEがインストールされていません'**
  String get lineNotInstalledMessage;

  /// No description provided for @selectFileButton.
  ///
  /// In ja, this message translates to:
  /// **'ファイルを選択'**
  String get selectFileButton;

  /// No description provided for @retrySelectFileButton.
  ///
  /// In ja, this message translates to:
  /// **'もう一度選択'**
  String get retrySelectFileButton;

  /// No description provided for @sharedTextFallbackTitle.
  ///
  /// In ja, this message translates to:
  /// **'LINEトーク（共有）'**
  String get sharedTextFallbackTitle;

  /// No description provided for @sharedContentLoadFailed.
  ///
  /// In ja, this message translates to:
  /// **'共有内容の読み込みに失敗しました: {error}'**
  String sharedContentLoadFailed(Object error);

  /// No description provided for @fileLoadFailed.
  ///
  /// In ja, this message translates to:
  /// **'ファイルの読み込みに失敗しました: {error}'**
  String fileLoadFailed(Object error);

  /// No description provided for @saveFailedMessage.
  ///
  /// In ja, this message translates to:
  /// **'保存に失敗しました: {error}'**
  String saveFailedMessage(Object error);

  /// No description provided for @previewLabelTitle.
  ///
  /// In ja, this message translates to:
  /// **'タイトル'**
  String get previewLabelTitle;

  /// No description provided for @previewLabelMessageCount.
  ///
  /// In ja, this message translates to:
  /// **'メッセージ数'**
  String get previewLabelMessageCount;

  /// No description provided for @previewLabelParticipantCount.
  ///
  /// In ja, this message translates to:
  /// **'参加者数'**
  String get previewLabelParticipantCount;

  /// No description provided for @previewNoTitleDetected.
  ///
  /// In ja, this message translates to:
  /// **'(検出なし)'**
  String get previewNoTitleDetected;

  /// No description provided for @previewMessageCountValue.
  ///
  /// In ja, this message translates to:
  /// **'{count}件'**
  String previewMessageCountValue(Object count);

  /// No description provided for @previewParticipantCountValue.
  ///
  /// In ja, this message translates to:
  /// **'{count}人'**
  String previewParticipantCountValue(Object count);

  /// No description provided for @previewSuspiciousMessage.
  ///
  /// In ja, this message translates to:
  /// **'メッセージとして認識できませんでした。LINEの標準エクスポート形式の.txtファイルか確認してください。'**
  String get previewSuspiciousMessage;

  /// No description provided for @previewUnrecognizedLinesMessage.
  ///
  /// In ja, this message translates to:
  /// **'{count}行は直前のメッセージの続きとして解析されました。'**
  String previewUnrecognizedLinesMessage(Object count);

  /// No description provided for @saveButton.
  ///
  /// In ja, this message translates to:
  /// **'保存する'**
  String get saveButton;

  /// No description provided for @helpMenuTitle.
  ///
  /// In ja, this message translates to:
  /// **'取扱説明書'**
  String get helpMenuTitle;

  /// No description provided for @helpMenuSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'使い方や機能の説明を見る'**
  String get helpMenuSubtitle;

  /// No description provided for @helpScreenTitle.
  ///
  /// In ja, this message translates to:
  /// **'取扱説明書'**
  String get helpScreenTitle;

  /// No description provided for @helpAboutTitle.
  ///
  /// In ja, this message translates to:
  /// **'このアプリについて'**
  String get helpAboutTitle;

  /// No description provided for @helpAboutBody.
  ///
  /// In ja, this message translates to:
  /// **'「トーク保存」は、LINEのトーク履歴をあとから見返しやすい形で端末に保存するためのアプリです。LINE本体を自動操作することはなく、LINE標準の「トークをテキストで送信」機能で書き出した.txtファイルを取り込んで使います。'**
  String get helpAboutBody;

  /// No description provided for @helpImportTitle.
  ///
  /// In ja, this message translates to:
  /// **'トークを取り込む'**
  String get helpImportTitle;

  /// No description provided for @helpImportBody.
  ///
  /// In ja, this message translates to:
  /// **'1. LINEのトーク画面で「その他」→「トーク履歴を送信」→「テキストで送信」を選ぶ\n2. 共有先の一覧から「トーク保存」を選ぶと自動で取り込まれます\n3. 一覧に出ない場合は、いったん.txtとして保存し、本アプリの「トークを取り込む」→「ファイルを選択」から読み込んでください\n\n「トークを取り込む」画面の「LINEを開く」ボタンから、LINEアプリへすぐに切り替えることもできます。'**
  String get helpImportBody;

  /// No description provided for @helpChatListTitle.
  ///
  /// In ja, this message translates to:
  /// **'トーク一覧の操作'**
  String get helpChatListTitle;

  /// No description provided for @helpChatListBody.
  ///
  /// In ja, this message translates to:
  /// **'・鉛筆アイコンでトーク名を変更できます\n・右上の＋ボタンから、写真・動画・ファイルだけをまとめる専用ルームを新規作成できます\n・鍵アイコンでトークごとに個別ロックを設定できます(要購入)'**
  String get helpChatListBody;

  /// No description provided for @helpChatDetailTitle.
  ///
  /// In ja, this message translates to:
  /// **'トーク詳細の使い方'**
  String get helpChatDetailTitle;

  /// No description provided for @helpChatDetailBody.
  ///
  /// In ja, this message translates to:
  /// **'・メッセージの長押し、または複数選択でコピーできます\n・発言者・期間・キーワードで絞り込み検索ができます\n・右上のアイコンからExcel・PDF・Wordへの書き出しができます\n・ギャラリーアイコンで、そのトークに添付した写真をまとめて確認できます'**
  String get helpChatDetailBody;

  /// No description provided for @helpAttachTitle.
  ///
  /// In ja, this message translates to:
  /// **'写真・動画・ファイルの添付'**
  String get helpAttachTitle;

  /// No description provided for @helpAttachBody.
  ///
  /// In ja, this message translates to:
  /// **'[写真][スタンプ]などのプレースホルダー部分をタップすると、端末から写真や動画を選んで添付できます。LINEのエクスポート機能には画像本体が含まれないため、自動で復元することはできません。'**
  String get helpAttachBody;

  /// No description provided for @helpLockTitle.
  ///
  /// In ja, this message translates to:
  /// **'ロック機能について'**
  String get helpLockTitle;

  /// No description provided for @helpLockBody.
  ///
  /// In ja, this message translates to:
  /// **'設定画面から、アプリ起動時のロック(生体認証・端末PIN・アプリ内PIN)を設定できます。アプリ内PINを設定すると、端末の生体認証よりも優先して使われます。\n\nトークルームごとの個別ロックは、広告非表示と同じアプリ内購入に含まれています。'**
  String get helpLockBody;

  /// No description provided for @helpBackupTitle.
  ///
  /// In ja, this message translates to:
  /// **'バックアップと復元'**
  String get helpBackupTitle;

  /// No description provided for @helpBackupBody.
  ///
  /// In ja, this message translates to:
  /// **'設定画面の「バックアップを作成」から、保存済みのすべてのトーク・添付ファイルを1つのファイルにまとめて書き出せます。機種変更の際などは、「バックアップから復元」で同じ内容を新しい端末に読み込めます。'**
  String get helpBackupBody;

  /// No description provided for @helpPrivacyTitle.
  ///
  /// In ja, this message translates to:
  /// **'データの保存場所について'**
  String get helpPrivacyTitle;

  /// No description provided for @helpPrivacyBody.
  ///
  /// In ja, this message translates to:
  /// **'取り込んだトークや添付した写真は、すべてこの端末内にのみ保存されます。サーバーへの送信は一切行っていません。'**
  String get helpPrivacyBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'id',
    'ja',
    'ko',
    'th',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'th':
      return AppLocalizationsTh();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
