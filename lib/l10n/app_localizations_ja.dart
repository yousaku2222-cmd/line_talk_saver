// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'トーク保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get unknownSender => '不明';

  @override
  String loadErrorWithMessage(Object error) {
    return '読み込みエラー: $error';
  }

  @override
  String get settingsTooltip => '設定';

  @override
  String get importButtonLabel => 'トークを取り込む';

  @override
  String get createChatRoomTitle => '新しいトークルームを作成';

  @override
  String get createChatRoomHint => 'トークルーム名';

  @override
  String get createChatRoomButton => '作成';

  @override
  String get deleteChatConfirmTitle => '削除しますか？';

  @override
  String get pickChatIconTitle => 'アイコンを選択';

  @override
  String get renameChatTitle => 'トーク名を変更';

  @override
  String get renameChatButton => '変更';

  @override
  String get renameChatTooltip => '名称を変更';

  @override
  String get chatLockTooltip => 'このトークをロック';

  @override
  String get chatUnlockTooltip => 'ロックを解除';

  @override
  String get chatLockAuthReason => 'このトークを表示するには認証してください';

  @override
  String get chatLockPaywallTitle => '個別ロックについて';

  @override
  String get chatLockPaywallBody => '個別ロック機能は「広告を非表示にする」を購入すると使えるようになります。';

  @override
  String get purchaseButton => '購入する';

  @override
  String createdAtLabel(Object datetime) {
    return '作成日時: $datetime';
  }

  @override
  String get manualRoomBadgeLabel => '写真ルーム';

  @override
  String get deletePlaceholderConfirmTitle => '削除しますか？';

  @override
  String get deletePlaceholderConfirmBody =>
      'このメッセージを削除します。添付した写真・動画があればそれも削除されます。元には戻せません。';

  @override
  String get deleteChatConfirmBody => 'このトークの保存済みデータを削除します。元には戻せません。';

  @override
  String get detachSelectedTooltip => '選択したメッセージの写真・動画だけ削除';

  @override
  String get detachMessagesConfirmTitle => '写真・動画を削除しますか？';

  @override
  String detachMessagesConfirmBody(Object count) {
    return '選択した$count件のメッセージから、添付した写真・動画だけを削除します。メッセージ自体は残ります。元には戻せません。';
  }

  @override
  String get deleteAttachmentTooltip => '削除';

  @override
  String get deleteAttachmentConfirmTitle => '削除しますか？';

  @override
  String get deleteAttachmentConfirmBody => 'この写真・動画を削除します。元には戻せません。';

  @override
  String deleteAttachmentFailedMessage(Object error) {
    return '削除に失敗しました: $error';
  }

  @override
  String get saveToDeviceTooltip => '端末に保存';

  @override
  String get saveToDeviceSuccessMessage => '端末に保存しました';

  @override
  String saveToDeviceFailedMessage(Object error) {
    return '保存に失敗しました: $error';
  }

  @override
  String get emptyChatListMessage =>
      'まだトークが取り込まれていません。\nLINEで「トークをテキストで送信」したファイルを右下のボタンから読み込んでください。';

  @override
  String importedAtLabel(Object datetime) {
    return '取込日時: $datetime';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get appLockToggleTitle => '起動時にロックする';

  @override
  String get appLockToggleSubtitle =>
      '端末のPIN・パターン・生体認証で保護します（下の「アプリPIN」設定時はそちらを優先使用）';

  @override
  String get appLockUnsupportedMessage =>
      'この端末では画面ロック（PIN・パターン・生体認証など）が設定されていません。下の「アプリPIN」を設定するとロック機能を使えます。';

  @override
  String get appPinSectionTitle => 'アプリPIN';

  @override
  String get appPinSetSubtitle => '設定済み。端末に画面ロックが無くてもロック機能を使えます';

  @override
  String get appPinNotSetSubtitle => '未設定。設定すると端末の画面ロックが無くてもロック機能を使えます';

  @override
  String get setAppPinButton => '設定';

  @override
  String get changeAppPinButton => '変更';

  @override
  String get setAppPinTitle => 'アプリPINを設定';

  @override
  String get appPinHint => 'PIN（4〜6桁の数字）';

  @override
  String get appPinConfirmHint => 'もう一度入力';

  @override
  String get appPinTooShortMessage => 'PINは4桁以上で入力してください';

  @override
  String get appPinMismatchMessage => 'PINが一致しません';

  @override
  String get enterAppPinTitle => 'PINを入力';

  @override
  String get appPinIncorrectMessage => 'PINが違います';

  @override
  String get appPinManageAuthReason => 'PINを変更・削除するには認証してください';

  @override
  String get removeAppPinWarningTitle => 'アプリPINを削除しますか？';

  @override
  String get removeAppPinWarningBody =>
      'この端末には他に使える認証方法がありません。ロック中のトークやアプリロックがある場合、PINを削除すると解除できなくなります。';

  @override
  String get purchaseUnavailableMessage => 'この端末では購入機能を利用できません。';

  @override
  String get purchaseFetchFailedMessage => '購入情報を取得できませんでした。時間をおいて再度お試しください。';

  @override
  String get restoringPurchasesMessage => '購入情報を確認しています…';

  @override
  String get removeAdsTitle => '広告を非表示にする';

  @override
  String get removeAdsPurchasedSubtitle => '購入済みです。ご利用ありがとうございます。';

  @override
  String get removeAdsSubtitle => '一度購入すると、以降ずっと広告が表示されなくなります';

  @override
  String get restorePurchaseTitle => '購入を復元';

  @override
  String get restorePurchaseSubtitle => '機種変更などで再度購入済みの状態にする場合はこちら';

  @override
  String get backupTitle => 'バックアップを作成';

  @override
  String get backupSubtitle => '全データを1つのファイルにまとめて保存します(機種変更などに)';

  @override
  String backupCreateFailedMessage(Object error) {
    return 'バックアップの作成に失敗しました: $error';
  }

  @override
  String get restoreBackupTitle => 'バックアップから復元';

  @override
  String get restoreBackupSubtitle => '以前作成したバックアップファイルを読み込みます';

  @override
  String get restoreBackupConfirmTitle => '復元しますか？';

  @override
  String get restoreBackupConfirmBody => '現在のデータはすべて上書きされます。この操作は元に戻せません。';

  @override
  String get restoreBackupSuccessMessage => '復元が完了しました';

  @override
  String get restoreBackupInvalidFileMessage => '有効なバックアップファイルではありません';

  @override
  String restoreBackupFailedMessage(Object error) {
    return '復元に失敗しました: $error';
  }

  @override
  String get languageSettingTitle => '言語';

  @override
  String get languageSystemDefault => '端末の設定に従う';

  @override
  String get lockedMessage => 'ロックされています';

  @override
  String get unlockButtonLabel => '認証してロック解除';

  @override
  String get appLockAuthReason => 'トーク内容を表示するには認証してください';

  @override
  String get filterTitle => '絞り込み';

  @override
  String get textSearchLabel => '本文検索';

  @override
  String get keywordHint => 'キーワードを入力';

  @override
  String get senderLabel => '発言者';

  @override
  String get periodLabel => '期間';

  @override
  String get periodPickerButton => '期間を選択';

  @override
  String periodRangeFormat(Object start, Object end) {
    return '$start 〜 $end';
  }

  @override
  String get clearButton => 'クリア';

  @override
  String get applyButton => '適用';

  @override
  String get loadingTitle => '読み込み中...';

  @override
  String get copySelectedTooltip => '選択したメッセージをコピー';

  @override
  String copiedMessage(Object label) {
    return '$labelをコピーしました';
  }

  @override
  String selectedCountLabel(Object count) {
    return '選択した$count件';
  }

  @override
  String get photosTooltip => '写真';

  @override
  String get filterTooltip => '発言者・期間で絞り込み';

  @override
  String get copyAllTooltip => 'すべてコピー';

  @override
  String allCountLabel(Object count) {
    return '全$count件';
  }

  @override
  String get exportTooltip => 'エクスポート';

  @override
  String get defaultChatTitleForExport => 'トーク';

  @override
  String get noMessagesFiltered => '条件に一致するメッセージがありません';

  @override
  String get noMessagesAtAll => 'メッセージがありません';

  @override
  String tapToAttachPhoto(Object placeholder) {
    return '$placeholder タップして写真を添付';
  }

  @override
  String tapToAttachVideo(Object placeholder) {
    return '$placeholder タップして動画を添付';
  }

  @override
  String tapToAttachFile(Object placeholder) {
    return '$placeholder タップしてファイルを添付';
  }

  @override
  String get photosTitle => '写真';

  @override
  String get noPhotosMessage => 'このトークにはまだ写真がありません。\n右下のボタンから追加できます。';

  @override
  String get addPhotoTooltip => '写真を追加';

  @override
  String get addVideoLabel => '動画を追加';

  @override
  String get addFileLabel => 'ファイルを追加';

  @override
  String openFileFailedMessage(Object error) {
    return 'ファイルを開けませんでした: $error';
  }

  @override
  String get addMediaTooltip => '写真・動画を追加';

  @override
  String get pickChatForPhotoTitle => '写真を追加するトークを選択';

  @override
  String get noChatsForPhotoMessage => 'トークがありません。先にLINEのトークを取り込んでください。';

  @override
  String attachPendingPhotoBannerMessage(Object count) {
    return '追加するメッセージをタップしてください(残り$count件)';
  }

  @override
  String get photoAttachedMessage => '写真を追加しました';

  @override
  String get fileAttachedMessage => 'ファイルを追加しました';

  @override
  String get attachPendingDirectlyButton => 'トークに直接追加';

  @override
  String pendingAttachedToRoomMessage(Object count) {
    return '$count件をこのトークルームに追加しました';
  }

  @override
  String get exportFormatTitle => 'エクスポート形式を選択';

  @override
  String get excelOption => 'Excel (.xlsx)';

  @override
  String get pdfOption => 'PDF';

  @override
  String get wordOption => 'Word (.docx)';

  @override
  String exportFailedMessage(Object error) {
    return 'エクスポートに失敗しました: $error';
  }

  @override
  String get excelSheetName => 'トーク';

  @override
  String get columnDate => '日付';

  @override
  String get columnTime => '時刻';

  @override
  String get columnSender => '発言者';

  @override
  String get columnBody => '本文';

  @override
  String get systemSender => 'システム';

  @override
  String get excelGenerationFailed => 'Excelファイルの生成に失敗しました';

  @override
  String get docxGenerationFailed => 'Wordファイルの生成に失敗しました';

  @override
  String get importScreenTitle => 'トークを取り込む';

  @override
  String get idleImportInstruction =>
      'LINEアプリのトーク画面で「トークをテキストで送信」を選び、\n保存した.txtファイルをここから読み込んでください。';

  @override
  String get openLineButton => 'LINEを開く';

  @override
  String get lineNotInstalledMessage => 'LINEがインストールされていません';

  @override
  String get selectFileButton => 'ファイルを選択';

  @override
  String get retrySelectFileButton => 'もう一度選択';

  @override
  String get sharedTextFallbackTitle => 'LINEトーク（共有）';

  @override
  String sharedContentLoadFailed(Object error) {
    return '共有内容の読み込みに失敗しました: $error';
  }

  @override
  String fileLoadFailed(Object error) {
    return 'ファイルの読み込みに失敗しました: $error';
  }

  @override
  String saveFailedMessage(Object error) {
    return '保存に失敗しました: $error';
  }

  @override
  String get previewLabelTitle => 'タイトル';

  @override
  String get previewLabelMessageCount => 'メッセージ数';

  @override
  String get previewLabelParticipantCount => '参加者数';

  @override
  String get previewNoTitleDetected => '(検出なし)';

  @override
  String previewMessageCountValue(Object count) {
    return '$count件';
  }

  @override
  String previewParticipantCountValue(Object count) {
    return '$count人';
  }

  @override
  String get previewSuspiciousMessage =>
      'メッセージとして認識できませんでした。LINEの標準エクスポート形式の.txtファイルか確認してください。';

  @override
  String previewUnrecognizedLinesMessage(Object count) {
    return '$count行は直前のメッセージの続きとして解析されました。';
  }

  @override
  String get saveButton => '保存する';

  @override
  String get helpMenuTitle => '取扱説明書';

  @override
  String get helpMenuSubtitle => '使い方や機能の説明を見る';

  @override
  String get helpScreenTitle => '取扱説明書';

  @override
  String get helpAboutTitle => 'このアプリについて';

  @override
  String get helpAboutBody =>
      '「トーク保存」は、LINEのトーク履歴をあとから見返しやすい形で端末に保存するためのアプリです。LINE本体を自動操作することはなく、LINE標準の「トークをテキストで送信」機能で書き出した.txtファイルを取り込んで使います。';

  @override
  String get helpImportTitle => 'トークを取り込む';

  @override
  String get helpImportBody =>
      '1. LINEのトーク画面で「その他」→「トーク履歴を送信」→「テキストで送信」を選ぶ\n2. 共有先の一覧から「トーク保存」を選ぶと自動で取り込まれます\n3. 一覧に出ない場合は、いったん.txtとして保存し、本アプリの「トークを取り込む」→「ファイルを選択」から読み込んでください\n\n「トークを取り込む」画面の「LINEを開く」ボタンから、LINEアプリへすぐに切り替えることもできます。';

  @override
  String get helpChatListTitle => 'トーク一覧の操作';

  @override
  String get helpChatListBody =>
      '・トークの左のアイコンをタップすると、好きなアイコンに変更できます\n・鉛筆アイコンでトーク名を変更できます\n・右上の＋ボタンから、写真・動画・ファイルだけをまとめる専用ルームを新規作成できます\n・鍵アイコンでトークごとに個別ロックを設定できます(要購入)';

  @override
  String get helpChatDetailTitle => 'トーク詳細の使い方';

  @override
  String get helpChatDetailBody =>
      '・メッセージの長押し、または複数選択でコピーできます\n・発言者・期間・キーワードで絞り込み検索ができます\n・右上のアイコンからExcel・PDF・Wordへの書き出しができます\n・ギャラリーアイコンで、そのトークに添付した写真をまとめて確認できます';

  @override
  String get helpAttachTitle => '写真・動画・ファイルの添付';

  @override
  String get helpAttachBody =>
      '[写真][スタンプ]などのプレースホルダー部分をタップすると、端末から写真や動画を選んで添付できます。LINEのエクスポート機能には画像本体が含まれないため、自動で復元することはできません。';

  @override
  String get helpLockTitle => 'ロック機能について';

  @override
  String get helpLockBody =>
      '設定画面から、アプリ起動時のロック(生体認証・端末PIN・アプリ内PIN)を設定できます。アプリ内PINを設定すると、端末の生体認証よりも優先して使われます。\n\nトークルームごとの個別ロックは、広告非表示と同じアプリ内購入に含まれています。';

  @override
  String get helpBackupTitle => 'バックアップと復元';

  @override
  String get helpBackupBody =>
      '設定画面の「バックアップを作成」から、保存済みのすべてのトーク・添付ファイルを1つのファイルにまとめて書き出せます。機種変更の際などは、「バックアップから復元」で同じ内容を新しい端末に読み込めます。iPhoneとAndroidの間で機種変更する場合も、同じ手順でそのまま移行できます。';

  @override
  String get helpPrivacyTitle => 'データの保存場所について';

  @override
  String get helpPrivacyBody =>
      '取り込んだトークや添付した写真は、すべてこの端末内にのみ保存されます。サーバーへの送信は一切行っていません。';
}
