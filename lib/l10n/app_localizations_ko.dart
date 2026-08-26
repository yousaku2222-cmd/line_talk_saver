// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '대화 저장';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get unknownSender => '알 수 없음';

  @override
  String loadErrorWithMessage(Object error) {
    return '불러오기 실패: $error';
  }

  @override
  String get settingsTooltip => '설정';

  @override
  String get importButtonLabel => '대화 가져오기';

  @override
  String get createChatRoomTitle => '새 대화방 만들기';

  @override
  String get createChatRoomHint => '대화방 이름';

  @override
  String get createChatRoomButton => '만들기';

  @override
  String get deleteChatConfirmTitle => '삭제하시겠습니까?';

  @override
  String get pickChatIconTitle => '아이콘 선택';

  @override
  String get renameChatTitle => '대화 이름 변경';

  @override
  String get renameChatButton => '변경';

  @override
  String get renameChatTooltip => '이름 변경';

  @override
  String get chatLockTooltip => '이 대화 잠금';

  @override
  String get chatUnlockTooltip => '잠금 해제';

  @override
  String get chatLockAuthReason => '이 대화를 보려면 인증하세요';

  @override
  String get chatLockPaywallTitle => '개별 잠금 안내';

  @override
  String get chatLockPaywallBody => '개별 대화 잠금 기능은 \"광고 제거\"를 구매하면 사용할 수 있습니다.';

  @override
  String get purchaseButton => '구매하기';

  @override
  String createdAtLabel(Object datetime) {
    return '생성 시간: $datetime';
  }

  @override
  String get manualRoomBadgeLabel => '사진방';

  @override
  String get deletePlaceholderConfirmTitle => '이 메시지를 삭제할까요?';

  @override
  String get deletePlaceholderConfirmBody =>
      '이 메시지가 삭제됩니다. 첨부된 사진·동영상이 있다면 함께 삭제됩니다. 되돌릴 수 없습니다.';

  @override
  String get deleteChatConfirmBody => '이 대화의 저장된 데이터가 삭제됩니다. 되돌릴 수 없습니다.';

  @override
  String get detachSelectedTooltip => '선택한 메시지의 사진·동영상만 삭제';

  @override
  String get detachMessagesConfirmTitle => '사진·동영상을 삭제할까요?';

  @override
  String detachMessagesConfirmBody(Object count) {
    return '선택한 $count개 메시지에서 첨부된 사진·동영상만 삭제됩니다. 메시지 자체는 남습니다. 되돌릴 수 없습니다.';
  }

  @override
  String get deleteAttachmentTooltip => '삭제';

  @override
  String get deleteAttachmentConfirmTitle => '삭제하시겠습니까?';

  @override
  String get deleteAttachmentConfirmBody => '이 사진 또는 동영상이 삭제됩니다. 되돌릴 수 없습니다.';

  @override
  String deleteAttachmentFailedMessage(Object error) {
    return '삭제하지 못했습니다: $error';
  }

  @override
  String get saveToDeviceTooltip => '기기에 저장';

  @override
  String get saveToDeviceSuccessMessage => '기기에 저장했습니다';

  @override
  String saveToDeviceFailedMessage(Object error) {
    return '저장하지 못했습니다: $error';
  }

  @override
  String get emptyChatListMessage =>
      '아직 가져온 대화가 없습니다.\nLINE에서 \"대화를 텍스트로 보내기\"를 사용한 후, 오른쪽 아래 버튼으로 저장된 파일을 불러오세요.';

  @override
  String importedAtLabel(Object datetime) {
    return '가져온 시간: $datetime';
  }

  @override
  String get settingsTitle => '설정';

  @override
  String get appLockToggleTitle => '실행 시 잠금';

  @override
  String get appLockToggleSubtitle =>
      '기기의 PIN, 패턴, 생체 인식으로 보호합니다(아래 앱 PIN을 설정한 경우 그것이 우선 사용됩니다)';

  @override
  String get appLockUnsupportedMessage =>
      '이 기기에는 화면 잠금(PIN, 패턴, 생체 인식 등)이 설정되어 있지 않습니다. 아래에서 앱 PIN을 설정하면 잠금 기능을 사용할 수 있습니다.';

  @override
  String get appPinSectionTitle => '앱 PIN';

  @override
  String get appPinSetSubtitle => '설정됨. 기기에 화면 잠금이 없어도 잠금 기능을 사용할 수 있습니다';

  @override
  String get appPinNotSetSubtitle =>
      '설정 안 됨. 설정하면 기기에 화면 잠금이 없어도 잠금 기능을 사용할 수 있습니다';

  @override
  String get setAppPinButton => '설정';

  @override
  String get changeAppPinButton => '변경';

  @override
  String get setAppPinTitle => '앱 PIN 설정';

  @override
  String get appPinHint => 'PIN (4~6자리 숫자)';

  @override
  String get appPinConfirmHint => '다시 입력';

  @override
  String get appPinTooShortMessage => 'PIN은 4자리 이상 입력하세요';

  @override
  String get appPinMismatchMessage => 'PIN이 일치하지 않습니다';

  @override
  String get enterAppPinTitle => 'PIN 입력';

  @override
  String get appPinIncorrectMessage => 'PIN이 틀렸습니다';

  @override
  String get appPinManageAuthReason => 'PIN을 변경·삭제하려면 인증하세요';

  @override
  String get removeAppPinWarningTitle => '앱 PIN을 삭제할까요?';

  @override
  String get removeAppPinWarningBody =>
      '이 기기에는 사용할 수 있는 다른 인증 방법이 없습니다. 잠긴 대화나 앱 전체 잠금이 있는 경우 PIN을 삭제하면 다시 해제할 수 없게 됩니다.';

  @override
  String get purchaseUnavailableMessage => '이 기기에서는 구매 기능을 사용할 수 없습니다.';

  @override
  String get purchaseFetchFailedMessage =>
      '구매 정보를 가져오지 못했습니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get restoringPurchasesMessage => '구매 내역을 확인하는 중…';

  @override
  String get removeAdsTitle => '광고 제거';

  @override
  String get removeAdsPurchasedSubtitle => '구매 완료. 이용해 주셔서 감사합니다.';

  @override
  String get removeAdsSubtitle => '한 번 구매하면 이후 광고가 표시되지 않습니다';

  @override
  String get restorePurchaseTitle => '구매 복원';

  @override
  String get restorePurchaseSubtitle => '기기를 변경한 경우 여기서 구매 내역을 복원하세요';

  @override
  String get backupTitle => '백업 만들기';

  @override
  String get backupSubtitle => '모든 데이터를 하나의 파일로 저장합니다(기기 변경 시 사용)';

  @override
  String backupCreateFailedMessage(Object error) {
    return '백업을 만들지 못했습니다: $error';
  }

  @override
  String get restoreBackupTitle => '백업에서 복원';

  @override
  String get restoreBackupSubtitle => '이전에 만든 백업 파일을 불러옵니다';

  @override
  String get restoreBackupConfirmTitle => '이 백업을 복원할까요?';

  @override
  String get restoreBackupConfirmBody =>
      '현재 데이터가 모두 덮어씌워집니다. 이 작업은 되돌릴 수 없습니다.';

  @override
  String get restoreBackupSuccessMessage => '복원이 완료되었습니다';

  @override
  String get restoreBackupInvalidFileMessage => '유효한 백업 파일이 아닙니다';

  @override
  String restoreBackupFailedMessage(Object error) {
    return '복원에 실패했습니다: $error';
  }

  @override
  String get languageSettingTitle => '언어';

  @override
  String get languageSystemDefault => '기기 설정을 따름';

  @override
  String get lockedMessage => '잠겨 있습니다';

  @override
  String get unlockButtonLabel => '인증하여 잠금 해제';

  @override
  String get appLockAuthReason => '대화 내용을 보려면 인증하세요';

  @override
  String get filterTitle => '필터';

  @override
  String get textSearchLabel => '본문 검색';

  @override
  String get keywordHint => '검색어 입력';

  @override
  String get senderLabel => '발신자';

  @override
  String get periodLabel => '기간';

  @override
  String get periodPickerButton => '기간 선택';

  @override
  String periodRangeFormat(Object start, Object end) {
    return '$start ~ $end';
  }

  @override
  String get clearButton => '지우기';

  @override
  String get applyButton => '적용';

  @override
  String get loadingTitle => '불러오는 중...';

  @override
  String get copySelectedTooltip => '선택한 메시지 복사';

  @override
  String copiedMessage(Object label) {
    return '$label 복사됨';
  }

  @override
  String selectedCountLabel(Object count) {
    return '$count개 선택됨';
  }

  @override
  String get photosTooltip => '사진';

  @override
  String get filterTooltip => '발신자·기간으로 필터링';

  @override
  String get copyAllTooltip => '전체 복사';

  @override
  String allCountLabel(Object count) {
    return '전체 $count개';
  }

  @override
  String get exportTooltip => '내보내기';

  @override
  String get defaultChatTitleForExport => '대화';

  @override
  String get noMessagesFiltered => '조건에 맞는 메시지가 없습니다';

  @override
  String get noMessagesAtAll => '메시지가 없습니다';

  @override
  String tapToAttachPhoto(Object placeholder) {
    return '$placeholder 눌러서 사진 첨부';
  }

  @override
  String tapToAttachVideo(Object placeholder) {
    return '$placeholder 눌러서 동영상 첨부';
  }

  @override
  String tapToAttachFile(Object placeholder) {
    return '$placeholder 눌러서 파일 첨부';
  }

  @override
  String get photosTitle => '사진';

  @override
  String get noPhotosMessage => '이 대화에는 아직 사진이 없습니다.\n오른쪽 아래 버튼으로 추가할 수 있습니다.';

  @override
  String get addPhotoTooltip => '사진 추가';

  @override
  String get addVideoLabel => '동영상 추가';

  @override
  String get addFileLabel => '파일 추가';

  @override
  String openFileFailedMessage(Object error) {
    return '파일을 열지 못했습니다: $error';
  }

  @override
  String get addMediaTooltip => '사진 또는 동영상 추가';

  @override
  String get pickChatForPhotoTitle => '사진을 추가할 대화 선택';

  @override
  String get noChatsForPhotoMessage => '대화가 없습니다. 먼저 LINE 대화를 가져오세요.';

  @override
  String attachPendingPhotoBannerMessage(Object count) {
    return '추가할 메시지를 탭하세요(남은 $count개)';
  }

  @override
  String get photoAttachedMessage => '사진을 추가했습니다';

  @override
  String get fileAttachedMessage => '파일을 추가했습니다';

  @override
  String get attachPendingDirectlyButton => '대화에 바로 추가';

  @override
  String pendingAttachedToRoomMessage(Object count) {
    return '$count개를 이 대화방에 추가했습니다';
  }

  @override
  String get exportFormatTitle => '내보내기 형식 선택';

  @override
  String get excelOption => 'Excel (.xlsx)';

  @override
  String get pdfOption => 'PDF';

  @override
  String get wordOption => 'Word (.docx)';

  @override
  String exportFailedMessage(Object error) {
    return '내보내기 실패: $error';
  }

  @override
  String get excelSheetName => '대화';

  @override
  String get columnDate => '날짜';

  @override
  String get columnTime => '시간';

  @override
  String get columnSender => '발신자';

  @override
  String get columnBody => '내용';

  @override
  String get systemSender => '시스템';

  @override
  String get excelGenerationFailed => 'Excel 파일 생성에 실패했습니다';

  @override
  String get docxGenerationFailed => 'Word 파일 생성에 실패했습니다';

  @override
  String get importScreenTitle => '대화 가져오기';

  @override
  String get idleImportInstruction =>
      'LINE 앱의 대화 화면에서 \"대화를 텍스트로 보내기\"를 선택한 후,\n저장된 .txt 파일을 여기서 불러오세요.';

  @override
  String get openLineButton => 'LINE 열기';

  @override
  String get lineNotInstalledMessage => 'LINE이 설치되어 있지 않습니다';

  @override
  String get selectFileButton => '파일 선택';

  @override
  String get retrySelectFileButton => '다시 선택';

  @override
  String get sharedTextFallbackTitle => 'LINE 대화 (공유됨)';

  @override
  String sharedContentLoadFailed(Object error) {
    return '공유된 내용을 불러오지 못했습니다: $error';
  }

  @override
  String fileLoadFailed(Object error) {
    return '파일을 불러오지 못했습니다: $error';
  }

  @override
  String saveFailedMessage(Object error) {
    return '저장하지 못했습니다: $error';
  }

  @override
  String get previewLabelTitle => '제목';

  @override
  String get previewLabelMessageCount => '메시지 수';

  @override
  String get previewLabelParticipantCount => '참여자 수';

  @override
  String get previewNoTitleDetected => '(감지되지 않음)';

  @override
  String previewMessageCountValue(Object count) {
    return '$count개';
  }

  @override
  String previewParticipantCountValue(Object count) {
    return '$count명';
  }

  @override
  String get previewSuspiciousMessage =>
      '메시지를 인식할 수 없습니다. LINE 표준 내보내기 형식의 .txt 파일인지 확인해 주세요.';

  @override
  String previewUnrecognizedLinesMessage(Object count) {
    return '$count줄이 이전 메시지에 이어붙여져 처리되었습니다.';
  }

  @override
  String get saveButton => '저장';
}
