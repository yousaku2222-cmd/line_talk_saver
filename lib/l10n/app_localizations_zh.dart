// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '聊天記錄保存';

  @override
  String get cancel => '取消';

  @override
  String get delete => '刪除';

  @override
  String get unknownSender => '不明';

  @override
  String loadErrorWithMessage(Object error) {
    return '讀取失敗：$error';
  }

  @override
  String get settingsTooltip => '設定';

  @override
  String get importButtonLabel => '匯入聊天記錄';

  @override
  String get createChatRoomTitle => '建立新聊天室';

  @override
  String get createChatRoomHint => '聊天室名稱';

  @override
  String get createChatRoomButton => '建立';

  @override
  String get deleteChatConfirmTitle => '要刪除嗎？';

  @override
  String get pickChatIconTitle => '選擇圖示';

  @override
  String get pickChatIconLockedHint => '帶🔒的圖示,觀看一次廣告即可永久解鎖';

  @override
  String get unlockIconDialogTitle => '要解鎖這個圖示嗎?';

  @override
  String get unlockIconDialogBody => '觀看一次廣告,即可永久使用這個圖示。';

  @override
  String get unlockIconWatchAdButton => '觀看廣告';

  @override
  String get unlockIconFailedMessage => '廣告播放失敗,請稍後再試。';

  @override
  String get renameChatTitle => '變更聊天名稱';

  @override
  String get renameChatButton => '變更';

  @override
  String get renameChatTooltip => '變更名稱';

  @override
  String get chatLockTooltip => '鎖定此聊天';

  @override
  String get chatUnlockTooltip => '解除鎖定';

  @override
  String get chatLockAuthReason => '請驗證身分以檢視此聊天';

  @override
  String get chatLockPaywallTitle => '關於個別鎖定';

  @override
  String get chatLockPaywallBody => '購買「隱藏廣告」後即可使用個別聊天鎖定功能。';

  @override
  String get purchaseButton => '購買';

  @override
  String createdAtLabel(Object datetime) {
    return '建立時間：$datetime';
  }

  @override
  String get manualRoomBadgeLabel => '照片室';

  @override
  String get deletePlaceholderConfirmTitle => '要刪除這則訊息嗎？';

  @override
  String get deletePlaceholderConfirmBody => '將刪除這則訊息，若有附加的照片或影片也會一併刪除，且無法復原。';

  @override
  String get deleteChatConfirmBody => '將刪除此聊天已儲存的資料，且無法復原。';

  @override
  String get detachSelectedTooltip => '只刪除所選訊息的照片・影片';

  @override
  String get detachMessagesConfirmTitle => '要刪除照片・影片嗎？';

  @override
  String detachMessagesConfirmBody(Object count) {
    return '將只刪除所選$count則訊息中附加的照片・影片，訊息本身會保留，且無法復原。';
  }

  @override
  String get deleteAttachmentTooltip => '刪除';

  @override
  String get deleteAttachmentConfirmTitle => '要刪除嗎？';

  @override
  String get deleteAttachmentConfirmBody => '這張照片或影片將被刪除，且無法復原。';

  @override
  String deleteAttachmentFailedMessage(Object error) {
    return '刪除失敗: $error';
  }

  @override
  String get saveToDeviceTooltip => '儲存到裝置';

  @override
  String get saveToDeviceSuccessMessage => '已儲存到裝置';

  @override
  String saveToDeviceFailedMessage(Object error) {
    return '儲存失敗: $error';
  }

  @override
  String get emptyChatListMessage =>
      '尚未匯入任何聊天記錄。\n請在LINE中使用「以文字傳送聊天記錄」，再從右下角的按鈕載入已儲存的檔案。';

  @override
  String importedAtLabel(Object datetime) {
    return '匯入時間：$datetime';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get appLockToggleTitle => '啟動時鎖定';

  @override
  String get appLockToggleSubtitle =>
      '以裝置的PIN碼、圖形或生物辨識進行保護（若已設定下方的應用程式PIN，將優先使用該PIN）';

  @override
  String get appLockUnsupportedMessage =>
      '此裝置尚未設定螢幕鎖定（PIN碼、圖形、生物辨識等）。在下方設定應用程式PIN即可使用鎖定功能。';

  @override
  String get appPinSectionTitle => '應用程式PIN';

  @override
  String get appPinSetSubtitle => '已設定。即使裝置沒有畫面鎖定，也能使用鎖定功能';

  @override
  String get appPinNotSetSubtitle => '尚未設定。設定後即使裝置沒有畫面鎖定，也能使用鎖定功能';

  @override
  String get setAppPinButton => '設定';

  @override
  String get changeAppPinButton => '變更';

  @override
  String get setAppPinTitle => '設定應用程式PIN';

  @override
  String get appPinHint => 'PIN（4～6位數字）';

  @override
  String get appPinConfirmHint => '再次輸入';

  @override
  String get appPinTooShortMessage => 'PIN至少需要4位數';

  @override
  String get appPinMismatchMessage => 'PIN不一致';

  @override
  String get enterAppPinTitle => '輸入PIN';

  @override
  String get appPinIncorrectMessage => 'PIN錯誤';

  @override
  String get appPinManageAuthReason => '請驗證身分以變更或刪除PIN';

  @override
  String get removeAppPinWarningTitle => '要刪除應用程式PIN嗎？';

  @override
  String get removeAppPinWarningBody =>
      '此裝置沒有其他可用的驗證方式。如果有已鎖定的聊天室或已啟用應用程式鎖定，刪除PIN後將無法再次解鎖。';

  @override
  String get purchaseUnavailableMessage => '此裝置無法使用購買功能。';

  @override
  String get purchaseFetchFailedMessage => '無法取得購買資訊，請稍後再試。';

  @override
  String get restoringPurchasesMessage => '正在確認購買紀錄…';

  @override
  String get removeAdsTitle => '隱藏廣告';

  @override
  String get removeAdsPurchasedSubtitle => '已購買，感謝您的支持。';

  @override
  String get removeAdsSubtitle => '購買一次即可永久隱藏廣告';

  @override
  String get restorePurchaseTitle => '還原購買';

  @override
  String get restorePurchaseSubtitle => '如果更換了裝置，可在此還原已購買的項目';

  @override
  String get backupTitle => '建立備份';

  @override
  String get backupSubtitle => '將所有資料打包成單一檔案(供更換裝置時使用)';

  @override
  String backupCreateFailedMessage(Object error) {
    return '建立備份失敗: $error';
  }

  @override
  String get restoreBackupTitle => '從備份還原';

  @override
  String get restoreBackupSubtitle => '載入先前建立的備份檔案';

  @override
  String get restoreBackupConfirmTitle => '要還原這個備份嗎？';

  @override
  String get restoreBackupConfirmBody => '目前的所有資料都會被覆蓋，且無法復原。';

  @override
  String get restoreBackupSuccessMessage => '還原完成';

  @override
  String get restoreBackupInvalidFileMessage => '這不是有效的備份檔案';

  @override
  String restoreBackupFailedMessage(Object error) {
    return '還原失敗: $error';
  }

  @override
  String get languageSettingTitle => '語言';

  @override
  String get languageSystemDefault => '跟隨裝置設定';

  @override
  String get lockedMessage => '已鎖定';

  @override
  String get unlockButtonLabel => '驗證以解鎖';

  @override
  String get appLockAuthReason => '請驗證身分以檢視聊天內容';

  @override
  String get filterTitle => '篩選';

  @override
  String get textSearchLabel => '內文搜尋';

  @override
  String get keywordHint => '輸入關鍵字';

  @override
  String get senderLabel => '發言者';

  @override
  String get periodLabel => '期間';

  @override
  String get periodPickerButton => '選擇期間';

  @override
  String periodRangeFormat(Object start, Object end) {
    return '$start 〜 $end';
  }

  @override
  String get clearButton => '清除';

  @override
  String get applyButton => '套用';

  @override
  String get loadingTitle => '載入中...';

  @override
  String get copySelectedTooltip => '複製已選取的訊息';

  @override
  String copiedMessage(Object label) {
    return '已複製$label';
  }

  @override
  String selectedCountLabel(Object count) {
    return '已選取$count則';
  }

  @override
  String get photosTooltip => '照片';

  @override
  String get filterTooltip => '依發言者、期間篩選';

  @override
  String get copyAllTooltip => '複製全部';

  @override
  String allCountLabel(Object count) {
    return '共$count則';
  }

  @override
  String get exportTooltip => '匯出';

  @override
  String get defaultChatTitleForExport => '聊天記錄';

  @override
  String get noMessagesFiltered => '沒有符合條件的訊息';

  @override
  String get noMessagesAtAll => '沒有訊息';

  @override
  String tapToAttachPhoto(Object placeholder) {
    return '$placeholder 點一下以附加照片';
  }

  @override
  String tapToAttachVideo(Object placeholder) {
    return '$placeholder 點一下以附加影片';
  }

  @override
  String tapToAttachFile(Object placeholder) {
    return '$placeholder 點一下以附加檔案';
  }

  @override
  String get photosTitle => '照片';

  @override
  String get noPhotosMessage => '此聊天尚無照片。\n可從右下角的按鈕新增。';

  @override
  String get addPhotoTooltip => '新增照片';

  @override
  String get addVideoLabel => '新增影片';

  @override
  String get addFileLabel => '新增檔案';

  @override
  String openFileFailedMessage(Object error) {
    return '無法開啟此檔案: $error';
  }

  @override
  String get addMediaTooltip => '新增照片或影片';

  @override
  String get pickChatForPhotoTitle => '選擇要加入這張照片的對話';

  @override
  String get noChatsForPhotoMessage => '目前沒有任何對話，請先匯入LINE對話。';

  @override
  String attachPendingPhotoBannerMessage(Object count) {
    return '請點選要加入的訊息(剩餘$count個)';
  }

  @override
  String get photoAttachedMessage => '已加入照片';

  @override
  String get fileAttachedMessage => '已加入檔案';

  @override
  String get attachPendingDirectlyButton => '直接加入聊天室';

  @override
  String pendingAttachedToRoomMessage(Object count) {
    return '已將$count項加入此聊天室';
  }

  @override
  String get exportFormatTitle => '選擇匯出格式';

  @override
  String get excelOption => 'Excel (.xlsx)';

  @override
  String get pdfOption => 'PDF';

  @override
  String get wordOption => 'Word (.docx)';

  @override
  String exportFailedMessage(Object error) {
    return '匯出失敗：$error';
  }

  @override
  String get excelSheetName => '聊天記錄';

  @override
  String get columnDate => '日期';

  @override
  String get columnTime => '時間';

  @override
  String get columnSender => '發言者';

  @override
  String get columnBody => '內文';

  @override
  String get systemSender => '系統';

  @override
  String get excelGenerationFailed => 'Excel檔案產生失敗';

  @override
  String get docxGenerationFailed => 'Word檔案產生失敗';

  @override
  String get importScreenTitle => '匯入聊天記錄';

  @override
  String get idleImportInstruction =>
      '在LINE應用程式的聊天畫面中選擇「以文字傳送聊天記錄」，\n再從這裡載入已儲存的.txt檔案。';

  @override
  String get openLineButton => '開啟LINE';

  @override
  String get lineNotInstalledMessage => '尚未安裝LINE';

  @override
  String get selectFileButton => '選擇檔案';

  @override
  String get retrySelectFileButton => '重新選擇';

  @override
  String get sharedTextFallbackTitle => 'LINE聊天記錄（分享）';

  @override
  String sharedContentLoadFailed(Object error) {
    return '讀取分享內容失敗：$error';
  }

  @override
  String fileLoadFailed(Object error) {
    return '讀取檔案失敗：$error';
  }

  @override
  String saveFailedMessage(Object error) {
    return '儲存失敗：$error';
  }

  @override
  String get previewLabelTitle => '標題';

  @override
  String get previewLabelMessageCount => '訊息數';

  @override
  String get previewLabelParticipantCount => '參與人數';

  @override
  String get previewNoTitleDetected => '（未偵測到）';

  @override
  String previewMessageCountValue(Object count) {
    return '$count則';
  }

  @override
  String previewParticipantCountValue(Object count) {
    return '$count人';
  }

  @override
  String get previewSuspiciousMessage => '無法辨識任何訊息，請確認這是LINE標準匯出格式的.txt檔案。';

  @override
  String previewUnrecognizedLinesMessage(Object count) {
    return '$count行已併入前一則訊息中解析。';
  }

  @override
  String get saveButton => '儲存';

  @override
  String get helpMenuTitle => '使用說明書';

  @override
  String get helpMenuSubtitle => '查看使用方法與功能說明';

  @override
  String get helpScreenTitle => '使用說明書';

  @override
  String get helpAboutTitle => '關於本應用程式';

  @override
  String get helpAboutBody =>
      '「聊天記錄保存」是一款將LINE聊天記錄以便於日後查看的形式保存到裝置中的應用程式。本應用程式不會自動操作LINE本體,而是透過匯入您使用LINE自帶的「以文字形式傳送聊天記錄」功能匯出的.txt檔案來使用。';

  @override
  String get helpImportTitle => '匯入聊天記錄';

  @override
  String get helpImportBody =>
      '1. 在LINE聊天畫面點擊選單(≡)→「傳送聊天記錄」→「以文字形式傳送」\n2. 從分享清單中選擇「聊天記錄保存」即可自動匯入\n3. 如果清單中沒有顯示,請先儲存為.txt檔案,然後在本應用程式中透過「匯入聊天記錄」→「選擇檔案」讀取\n\n您也可以在匯入畫面透過「開啟LINE」按鈕直接切換到LINE應用程式。';

  @override
  String get helpChatListTitle => '聊天清單操作';

  @override
  String get helpChatListBody =>
      '• 點擊聊天左側的圖示可以更換成喜歡的圖示\n• 點擊鉛筆圖示可以修改聊天名稱\n• 使用右上角的+按鈕可以新增一個專門用於存放照片、影片和檔案的房間\n• 點擊鎖頭圖示可以為單一聊天設定個別鎖定(需購買)';

  @override
  String get helpChatDetailTitle => '聊天詳情頁的使用方法';

  @override
  String get helpChatDetailBody =>
      '• 長按或多選訊息即可複製\n• 可依發言人、時間段、關鍵字進行篩選搜尋\n• 可透過右上角圖示匯出為Excel、PDF或Word格式\n• 點擊圖庫圖示可檢視該聊天中新增的所有照片';

  @override
  String get helpAttachTitle => '新增照片、影片和檔案';

  @override
  String get helpAttachBody =>
      '點擊[照片][貼圖]等預留位置,即可從裝置中選擇照片或影片進行新增。由於LINE的匯出功能不包含圖片本體,因此無法自動還原。';

  @override
  String get helpLockTitle => '關於鎖定功能';

  @override
  String get helpLockBody =>
      '在設定頁面,您可以設定啟動應用程式時需要生物辨識、裝置PIN碼或應用程式內PIN碼驗證。設定應用程式內PIN碼後,將優先於裝置的生物辨識驗證使用。\n\n單一聊天鎖定功能與移除廣告包含在同一項內購中。';

  @override
  String get helpBackupTitle => '備份與還原';

  @override
  String get helpBackupBody =>
      '在設定頁面的「建立備份」中,可以將所有已儲存的聊天記錄和附件彙總匯出為一個檔案。更換裝置時,可透過「從備份還原」將相同內容讀取到新裝置中。即使在iPhone和Android之間更換裝置,也能以同樣方式轉移資料。';

  @override
  String get helpPrivacyTitle => '關於資料儲存位置';

  @override
  String get helpPrivacyBody => '匯入的聊天記錄和新增的照片,均僅儲存在本裝置中,絕不會傳送至任何伺服器。';

  @override
  String get feedbackMenuTitle => '意見回饋與問題回報';

  @override
  String get feedbackMenuSubtitle => '如有任何發現,請透過電子郵件告訴我們';

  @override
  String get feedbackEmailSubject => '【聊天保存】意見回饋';

  @override
  String get feedbackEmailBody =>
      '請在下方填寫您的意見、需求或遇到的問題。\n(若為問題,請一併說明在哪一步操作時發生,以及您的裝置型號。)\n\n';

  @override
  String get feedbackLaunchFailedMessage =>
      '無法開啟郵件應用程式。請聯絡 talk-hozon-testers@googlegroups.com。';

  @override
  String get appVersionTitle => '應用程式版本';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => '聊天記錄保存';

  @override
  String get cancel => '取消';

  @override
  String get delete => '刪除';

  @override
  String get unknownSender => '不明';

  @override
  String loadErrorWithMessage(Object error) {
    return '讀取失敗：$error';
  }

  @override
  String get settingsTooltip => '設定';

  @override
  String get importButtonLabel => '匯入聊天記錄';

  @override
  String get createChatRoomTitle => '建立新聊天室';

  @override
  String get createChatRoomHint => '聊天室名稱';

  @override
  String get createChatRoomButton => '建立';

  @override
  String get deleteChatConfirmTitle => '要刪除嗎？';

  @override
  String get pickChatIconTitle => '選擇圖示';

  @override
  String get pickChatIconLockedHint => '帶🔒的圖示,觀看一次廣告即可永久解鎖';

  @override
  String get unlockIconDialogTitle => '要解鎖這個圖示嗎?';

  @override
  String get unlockIconDialogBody => '觀看一次廣告,即可永久使用這個圖示。';

  @override
  String get unlockIconWatchAdButton => '觀看廣告';

  @override
  String get unlockIconFailedMessage => '廣告播放失敗,請稍後再試。';

  @override
  String get renameChatTitle => '變更聊天名稱';

  @override
  String get renameChatButton => '變更';

  @override
  String get renameChatTooltip => '變更名稱';

  @override
  String get chatLockTooltip => '鎖定此聊天';

  @override
  String get chatUnlockTooltip => '解除鎖定';

  @override
  String get chatLockAuthReason => '請驗證身分以檢視此聊天';

  @override
  String get chatLockPaywallTitle => '關於個別鎖定';

  @override
  String get chatLockPaywallBody => '購買「隱藏廣告」後即可使用個別聊天鎖定功能。';

  @override
  String get purchaseButton => '購買';

  @override
  String createdAtLabel(Object datetime) {
    return '建立時間：$datetime';
  }

  @override
  String get manualRoomBadgeLabel => '照片室';

  @override
  String get deletePlaceholderConfirmTitle => '要刪除這則訊息嗎？';

  @override
  String get deletePlaceholderConfirmBody => '將刪除這則訊息，若有附加的照片或影片也會一併刪除，且無法復原。';

  @override
  String get deleteChatConfirmBody => '將刪除此聊天已儲存的資料，且無法復原。';

  @override
  String get detachSelectedTooltip => '只刪除所選訊息的照片・影片';

  @override
  String get detachMessagesConfirmTitle => '要刪除照片・影片嗎？';

  @override
  String detachMessagesConfirmBody(Object count) {
    return '將只刪除所選$count則訊息中附加的照片・影片，訊息本身會保留，且無法復原。';
  }

  @override
  String get deleteAttachmentTooltip => '刪除';

  @override
  String get deleteAttachmentConfirmTitle => '要刪除嗎？';

  @override
  String get deleteAttachmentConfirmBody => '這張照片或影片將被刪除，且無法復原。';

  @override
  String deleteAttachmentFailedMessage(Object error) {
    return '刪除失敗: $error';
  }

  @override
  String get saveToDeviceTooltip => '儲存到裝置';

  @override
  String get saveToDeviceSuccessMessage => '已儲存到裝置';

  @override
  String saveToDeviceFailedMessage(Object error) {
    return '儲存失敗: $error';
  }

  @override
  String get emptyChatListMessage =>
      '尚未匯入任何聊天記錄。\n請在LINE中使用「以文字傳送聊天記錄」，再從右下角的按鈕載入已儲存的檔案。';

  @override
  String importedAtLabel(Object datetime) {
    return '匯入時間：$datetime';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get appLockToggleTitle => '啟動時鎖定';

  @override
  String get appLockToggleSubtitle =>
      '以裝置的PIN碼、圖形或生物辨識進行保護（若已設定下方的應用程式PIN，將優先使用該PIN）';

  @override
  String get appLockUnsupportedMessage =>
      '此裝置尚未設定螢幕鎖定（PIN碼、圖形、生物辨識等）。在下方設定應用程式PIN即可使用鎖定功能。';

  @override
  String get appPinSectionTitle => '應用程式PIN';

  @override
  String get appPinSetSubtitle => '已設定。即使裝置沒有畫面鎖定，也能使用鎖定功能';

  @override
  String get appPinNotSetSubtitle => '尚未設定。設定後即使裝置沒有畫面鎖定，也能使用鎖定功能';

  @override
  String get setAppPinButton => '設定';

  @override
  String get changeAppPinButton => '變更';

  @override
  String get setAppPinTitle => '設定應用程式PIN';

  @override
  String get appPinHint => 'PIN（4～6位數字）';

  @override
  String get appPinConfirmHint => '再次輸入';

  @override
  String get appPinTooShortMessage => 'PIN至少需要4位數';

  @override
  String get appPinMismatchMessage => 'PIN不一致';

  @override
  String get enterAppPinTitle => '輸入PIN';

  @override
  String get appPinIncorrectMessage => 'PIN錯誤';

  @override
  String get appPinManageAuthReason => '請驗證身分以變更或刪除PIN';

  @override
  String get removeAppPinWarningTitle => '要刪除應用程式PIN嗎？';

  @override
  String get removeAppPinWarningBody =>
      '此裝置沒有其他可用的驗證方式。如果有已鎖定的聊天室或已啟用應用程式鎖定，刪除PIN後將無法再次解鎖。';

  @override
  String get purchaseUnavailableMessage => '此裝置無法使用購買功能。';

  @override
  String get purchaseFetchFailedMessage => '無法取得購買資訊，請稍後再試。';

  @override
  String get restoringPurchasesMessage => '正在確認購買紀錄…';

  @override
  String get removeAdsTitle => '隱藏廣告';

  @override
  String get removeAdsPurchasedSubtitle => '已購買，感謝您的支持。';

  @override
  String get removeAdsSubtitle => '購買一次即可永久隱藏廣告';

  @override
  String get restorePurchaseTitle => '還原購買';

  @override
  String get restorePurchaseSubtitle => '如果更換了裝置，可在此還原已購買的項目';

  @override
  String get backupTitle => '建立備份';

  @override
  String get backupSubtitle => '將所有資料打包成單一檔案(供更換裝置時使用)';

  @override
  String backupCreateFailedMessage(Object error) {
    return '建立備份失敗: $error';
  }

  @override
  String get restoreBackupTitle => '從備份還原';

  @override
  String get restoreBackupSubtitle => '載入先前建立的備份檔案';

  @override
  String get restoreBackupConfirmTitle => '要還原這個備份嗎？';

  @override
  String get restoreBackupConfirmBody => '目前的所有資料都會被覆蓋，且無法復原。';

  @override
  String get restoreBackupSuccessMessage => '還原完成';

  @override
  String get restoreBackupInvalidFileMessage => '這不是有效的備份檔案';

  @override
  String restoreBackupFailedMessage(Object error) {
    return '還原失敗: $error';
  }

  @override
  String get languageSettingTitle => '語言';

  @override
  String get languageSystemDefault => '跟隨裝置設定';

  @override
  String get lockedMessage => '已鎖定';

  @override
  String get unlockButtonLabel => '驗證以解鎖';

  @override
  String get appLockAuthReason => '請驗證身分以檢視聊天內容';

  @override
  String get filterTitle => '篩選';

  @override
  String get textSearchLabel => '內文搜尋';

  @override
  String get keywordHint => '輸入關鍵字';

  @override
  String get senderLabel => '發言者';

  @override
  String get periodLabel => '期間';

  @override
  String get periodPickerButton => '選擇期間';

  @override
  String periodRangeFormat(Object start, Object end) {
    return '$start 〜 $end';
  }

  @override
  String get clearButton => '清除';

  @override
  String get applyButton => '套用';

  @override
  String get loadingTitle => '載入中...';

  @override
  String get copySelectedTooltip => '複製已選取的訊息';

  @override
  String copiedMessage(Object label) {
    return '已複製$label';
  }

  @override
  String selectedCountLabel(Object count) {
    return '已選取$count則';
  }

  @override
  String get photosTooltip => '照片';

  @override
  String get filterTooltip => '依發言者、期間篩選';

  @override
  String get copyAllTooltip => '複製全部';

  @override
  String allCountLabel(Object count) {
    return '共$count則';
  }

  @override
  String get exportTooltip => '匯出';

  @override
  String get defaultChatTitleForExport => '聊天記錄';

  @override
  String get noMessagesFiltered => '沒有符合條件的訊息';

  @override
  String get noMessagesAtAll => '沒有訊息';

  @override
  String tapToAttachPhoto(Object placeholder) {
    return '$placeholder 點一下以附加照片';
  }

  @override
  String tapToAttachVideo(Object placeholder) {
    return '$placeholder 點一下以附加影片';
  }

  @override
  String tapToAttachFile(Object placeholder) {
    return '$placeholder 點一下以附加檔案';
  }

  @override
  String get photosTitle => '照片';

  @override
  String get noPhotosMessage => '此聊天尚無照片。\n可從右下角的按鈕新增。';

  @override
  String get addPhotoTooltip => '新增照片';

  @override
  String get addVideoLabel => '新增影片';

  @override
  String get addFileLabel => '新增檔案';

  @override
  String openFileFailedMessage(Object error) {
    return '無法開啟此檔案: $error';
  }

  @override
  String get addMediaTooltip => '新增照片或影片';

  @override
  String get pickChatForPhotoTitle => '選擇要加入這張照片的對話';

  @override
  String get noChatsForPhotoMessage => '目前沒有任何對話，請先匯入LINE對話。';

  @override
  String attachPendingPhotoBannerMessage(Object count) {
    return '請點選要加入的訊息(剩餘$count個)';
  }

  @override
  String get photoAttachedMessage => '已加入照片';

  @override
  String get fileAttachedMessage => '已加入檔案';

  @override
  String get attachPendingDirectlyButton => '直接加入聊天室';

  @override
  String pendingAttachedToRoomMessage(Object count) {
    return '已將$count項加入此聊天室';
  }

  @override
  String get exportFormatTitle => '選擇匯出格式';

  @override
  String get excelOption => 'Excel (.xlsx)';

  @override
  String get pdfOption => 'PDF';

  @override
  String get wordOption => 'Word (.docx)';

  @override
  String exportFailedMessage(Object error) {
    return '匯出失敗：$error';
  }

  @override
  String get excelSheetName => '聊天記錄';

  @override
  String get columnDate => '日期';

  @override
  String get columnTime => '時間';

  @override
  String get columnSender => '發言者';

  @override
  String get columnBody => '內文';

  @override
  String get systemSender => '系統';

  @override
  String get excelGenerationFailed => 'Excel檔案產生失敗';

  @override
  String get docxGenerationFailed => 'Word檔案產生失敗';

  @override
  String get importScreenTitle => '匯入聊天記錄';

  @override
  String get idleImportInstruction =>
      '在LINE應用程式的聊天畫面中選擇「以文字傳送聊天記錄」，\n再從這裡載入已儲存的.txt檔案。';

  @override
  String get openLineButton => '開啟LINE';

  @override
  String get lineNotInstalledMessage => '尚未安裝LINE';

  @override
  String get selectFileButton => '選擇檔案';

  @override
  String get retrySelectFileButton => '重新選擇';

  @override
  String get sharedTextFallbackTitle => 'LINE聊天記錄（分享）';

  @override
  String sharedContentLoadFailed(Object error) {
    return '讀取分享內容失敗：$error';
  }

  @override
  String fileLoadFailed(Object error) {
    return '讀取檔案失敗：$error';
  }

  @override
  String saveFailedMessage(Object error) {
    return '儲存失敗：$error';
  }

  @override
  String get previewLabelTitle => '標題';

  @override
  String get previewLabelMessageCount => '訊息數';

  @override
  String get previewLabelParticipantCount => '參與人數';

  @override
  String get previewNoTitleDetected => '（未偵測到）';

  @override
  String previewMessageCountValue(Object count) {
    return '$count則';
  }

  @override
  String previewParticipantCountValue(Object count) {
    return '$count人';
  }

  @override
  String get previewSuspiciousMessage => '無法辨識任何訊息，請確認這是LINE標準匯出格式的.txt檔案。';

  @override
  String previewUnrecognizedLinesMessage(Object count) {
    return '$count行已併入前一則訊息中解析。';
  }

  @override
  String get saveButton => '儲存';

  @override
  String get helpMenuTitle => '使用說明書';

  @override
  String get helpMenuSubtitle => '查看使用方法與功能說明';

  @override
  String get helpScreenTitle => '使用說明書';

  @override
  String get helpAboutTitle => '關於本應用程式';

  @override
  String get helpAboutBody =>
      '「聊天記錄保存」是一款將LINE聊天記錄以便於日後查看的形式保存到裝置中的應用程式。本應用程式不會自動操作LINE本體,而是透過匯入您使用LINE自帶的「以文字形式傳送聊天記錄」功能匯出的.txt檔案來使用。';

  @override
  String get helpImportTitle => '匯入聊天記錄';

  @override
  String get helpImportBody =>
      '1. 在LINE聊天畫面點擊選單(≡)→「傳送聊天記錄」→「以文字形式傳送」\n2. 從分享清單中選擇「聊天記錄保存」即可自動匯入\n3. 如果清單中沒有顯示,請先儲存為.txt檔案,然後在本應用程式中透過「匯入聊天記錄」→「選擇檔案」讀取\n\n您也可以在匯入畫面透過「開啟LINE」按鈕直接切換到LINE應用程式。';

  @override
  String get helpChatListTitle => '聊天清單操作';

  @override
  String get helpChatListBody =>
      '• 點擊聊天左側的圖示可以更換成喜歡的圖示\n• 點擊鉛筆圖示可以修改聊天名稱\n• 使用右上角的+按鈕可以新增一個專門用於存放照片、影片和檔案的房間\n• 點擊鎖頭圖示可以為單一聊天設定個別鎖定(需購買)';

  @override
  String get helpChatDetailTitle => '聊天詳情頁的使用方法';

  @override
  String get helpChatDetailBody =>
      '• 長按或多選訊息即可複製\n• 可依發言人、時間段、關鍵字進行篩選搜尋\n• 可透過右上角圖示匯出為Excel、PDF或Word格式\n• 點擊圖庫圖示可檢視該聊天中新增的所有照片';

  @override
  String get helpAttachTitle => '新增照片、影片和檔案';

  @override
  String get helpAttachBody =>
      '點擊[照片][貼圖]等預留位置,即可從裝置中選擇照片或影片進行新增。由於LINE的匯出功能不包含圖片本體,因此無法自動還原。';

  @override
  String get helpLockTitle => '關於鎖定功能';

  @override
  String get helpLockBody =>
      '在設定頁面,您可以設定啟動應用程式時需要生物辨識、裝置PIN碼或應用程式內PIN碼驗證。設定應用程式內PIN碼後,將優先於裝置的生物辨識驗證使用。\n\n單一聊天鎖定功能與移除廣告包含在同一項內購中。';

  @override
  String get helpBackupTitle => '備份與還原';

  @override
  String get helpBackupBody =>
      '在設定頁面的「建立備份」中,可以將所有已儲存的聊天記錄和附件彙總匯出為一個檔案。更換裝置時,可透過「從備份還原」將相同內容讀取到新裝置中。即使在iPhone和Android之間更換裝置,也能以同樣方式轉移資料。';

  @override
  String get helpPrivacyTitle => '關於資料儲存位置';

  @override
  String get helpPrivacyBody => '匯入的聊天記錄和新增的照片,均僅儲存在本裝置中,絕不會傳送至任何伺服器。';

  @override
  String get feedbackMenuTitle => '意見回饋與問題回報';

  @override
  String get feedbackMenuSubtitle => '如有任何發現,請透過電子郵件告訴我們';

  @override
  String get feedbackEmailSubject => '【聊天保存】意見回饋';

  @override
  String get feedbackEmailBody =>
      '請在下方填寫您的意見、需求或遇到的問題。\n(若為問題,請一併說明在哪一步操作時發生,以及您的裝置型號。)\n\n';

  @override
  String get feedbackLaunchFailedMessage =>
      '無法開啟郵件應用程式。請聯絡 talk-hozon-testers@googlegroups.com。';

  @override
  String get appVersionTitle => '應用程式版本';
}
