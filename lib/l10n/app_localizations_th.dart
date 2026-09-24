// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'บันทึกแชท';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get delete => 'ลบ';

  @override
  String get unknownSender => 'ไม่ทราบ';

  @override
  String loadErrorWithMessage(Object error) {
    return 'โหลดไม่สำเร็จ: $error';
  }

  @override
  String get settingsTooltip => 'ตั้งค่า';

  @override
  String get importButtonLabel => 'นำเข้าแชท';

  @override
  String get createChatRoomTitle => 'สร้างห้องแชทใหม่';

  @override
  String get createChatRoomHint => 'ชื่อห้องแชท';

  @override
  String get createChatRoomButton => 'สร้าง';

  @override
  String get deleteChatConfirmTitle => 'ลบแชทนี้หรือไม่?';

  @override
  String get pickChatIconTitle => 'เลือกไอคอน';

  @override
  String get pickChatIconLockedHint =>
      'ไอคอนที่มี 🔒 จะปลดล็อกถาวรหลังจากดูโฆษณาหนึ่งครั้ง';

  @override
  String get unlockIconDialogTitle => 'ปลดล็อกไอคอนนี้หรือไม่?';

  @override
  String get unlockIconDialogBody =>
      'ดูโฆษณาหนึ่งครั้งเพื่อปลดล็อกไอคอนนี้ถาวร';

  @override
  String get unlockIconWatchAdButton => 'ดูโฆษณา';

  @override
  String get unlockIconFailedMessage =>
      'ไม่สามารถเล่นโฆษณาได้ กรุณาลองใหม่อีกครั้งในภายหลัง';

  @override
  String get themePickerLockedHint =>
      'ธีมที่มี 🔒 จะปลดล็อกถาวรหลังจากดูโฆษณาหนึ่งครั้ง';

  @override
  String get unlockThemeDialogTitle => 'ปลดล็อกธีมนี้หรือไม่?';

  @override
  String get unlockThemeDialogBody => 'ดูโฆษณาหนึ่งครั้งเพื่อปลดล็อกธีมนี้ถาวร';

  @override
  String get chatStatsTooltip => 'สถิติแชท';

  @override
  String get chatStatsScreenTitle => 'สถิติแชท';

  @override
  String get chatStatsGateDialogTitle => 'ใช้สิทธิ์ฟรีวันนี้ครบแล้ว';

  @override
  String get chatStatsGateDialogBody =>
      'ดูโฆษณาหนึ่งครั้งเพื่อดูสถิติแชทอีกครั้ง';

  @override
  String get chatStatsSectionHeatmapTitle => 'กราฟความถี่ในการพูดคุย';

  @override
  String get statsShareImageTooltip => 'แชร์เป็นรูปภาพ';

  @override
  String get statsShareAllTooltip => 'แชร์สถิติทั้งหมดเป็นภาพเดียว';

  @override
  String chatStatsPeakMonthLabel(Object month) {
    return '$month เป็นเดือนที่คุยกันมากที่สุด';
  }

  @override
  String get chatStatsSectionCompatibilityTitle => 'วิเคราะห์ความเข้ากัน';

  @override
  String get chatStatsSectionShareTitle => 'สัดส่วนข้อความ';

  @override
  String get chatStatsAvgReplyTimeLabel => 'เวลาตอบกลับเฉลี่ย';

  @override
  String get chatStatsInitiatedCountLabel => 'จำนวนครั้งที่เริ่มทัก';

  @override
  String get chatStatsStampRatioLabel => 'อัตราการใช้สติกเกอร์';

  @override
  String get chatStatsMessageCountLabel => 'จำนวนข้อความ';

  @override
  String chatStatsDurationMinutes(Object minutes) {
    return '$minutes นาที';
  }

  @override
  String get chatStatsNoReplyDataLabel => 'ไม่มีข้อมูล';

  @override
  String chatStatsFasterReplyLabel(Object name) {
    return '$name มักตอบกลับเร็วกว่า';
  }

  @override
  String chatStatsMoreInitiationsLabel(Object name) {
    return '$name มักเป็นฝ่ายเริ่มทักมากกว่า';
  }

  @override
  String get chatStatsNoDataMessage => 'ไม่มีข้อมูลสำหรับแสดงสถิติ';

  @override
  String get chatStatsSectionTimeOfDayTitle => 'แนวโน้มช่วงเวลาส่งข้อความ';

  @override
  String get chatStatsTimeSegmentLateNight => 'สายนอนดึก';

  @override
  String get chatStatsTimeSegmentMorning => 'สายเช้า';

  @override
  String get chatStatsTimeSegmentDay => 'สายกลางวัน';

  @override
  String get chatStatsTimeSegmentEvening => 'สายกลางคืน';

  @override
  String get chatStatsSectionQuestionCatchTitle => 'ระดับการโต้ตอบบทสนทนา';

  @override
  String chatStatsQuestionCatchRateValue(
    Object rate,
    Object answered,
    Object asked,
  ) {
    return 'อัตราการตอบคำถาม $rate%（$answered/$asked ข้อความ）';
  }

  @override
  String get chatStatsSectionWordsTitle => 'คำที่ใช้บ่อย';

  @override
  String get chatStatsSectionWeekdayHeatmapTitle => 'แนวโน้มตามวันและช่วงเวลา';

  @override
  String get chatStatsSectionTriviaTitle => 'เกร็ดเล็กเกร็ดน้อยของแชท';

  @override
  String get chatStatsTabOverview => 'ภาพรวม';

  @override
  String get chatStatsTabTrends => 'แนวโน้ม';

  @override
  String get chatStatsTabTrivia => 'เกร็ดเล็กเกร็ดน้อย';

  @override
  String chatStatsStreakLabel(Object days) {
    return 'วันต่อเนื่องยาวนานที่สุด: $days วัน';
  }

  @override
  String get chatStatsTopDaysLabel => '5 วันที่คึกคักที่สุด';

  @override
  String chatStatsSilenceGapLabel(Object duration, Object start, Object end) {
    return 'ช่วงเงียบที่นานที่สุด: $duration（$start ถึง $end）';
  }

  @override
  String chatStatsDurationDays(Object days) {
    return '$days วัน';
  }

  @override
  String chatStatsDurationHours(Object hours) {
    return '$hours ชั่วโมง';
  }

  @override
  String chatStatsEmojiRateLabel(Object rate) {
    return 'ข้อความที่มีอิโมจิ: $rate%';
  }

  @override
  String get chatStatsOneLinerLabel => 'สายข้อความสั้น';

  @override
  String get chatStatsLongFormLabel => 'สายข้อความยาว';

  @override
  String chatStatsAvgLengthLabel(Object name, Object length, Object label) {
    return '$name: เฉลี่ย $length ตัวอักษร（$label）';
  }

  @override
  String get chatDashboardTooltip => 'แดชบอร์ดภาพรวม';

  @override
  String get chatDashboardScreenTitle => 'แดชบอร์ดภาพรวม';

  @override
  String get chatDashboardGateDialogTitle => 'ใช้สิทธิ์ฟรีวันนี้ครบแล้ว';

  @override
  String get chatDashboardGateDialogBody =>
      'ดูโฆษณาหนึ่งครั้งเพื่อดูแดชบอร์ดอีกครั้ง';

  @override
  String get chatDashboardNoDataMessage => 'ไม่มีข้อมูลสำหรับแสดงสถิติ';

  @override
  String get chatDashboardSectionSummaryTitle => 'สถานะการบันทึก';

  @override
  String chatDashboardSummaryValue(Object chats, Object messages) {
    return 'บันทึกไว้ $chats แชท รวม $messages ข้อความ';
  }

  @override
  String get chatDashboardSectionRankingTitle => 'อันดับคนที่คุยด้วยบ่อยที่สุด';

  @override
  String get renameChatTitle => 'เปลี่ยนชื่อแชท';

  @override
  String get renameChatButton => 'เปลี่ยนชื่อ';

  @override
  String get renameChatTooltip => 'เปลี่ยนชื่อ';

  @override
  String get chatLockTooltip => 'ล็อกแชทนี้';

  @override
  String get chatUnlockTooltip => 'ปลดล็อก';

  @override
  String get chatFavoriteTooltip => 'เพิ่มในรายการโปรด';

  @override
  String get chatUnfavoriteTooltip => 'นำออกจากรายการโปรด';

  @override
  String get crossSearchTooltip => 'ค้นหาทุกแชท';

  @override
  String get crossSearchHint => 'ค้นหาคำสำคัญในทุกแชท';

  @override
  String get crossSearchPrompt =>
      'ป้อนคำสำคัญเพื่อค้นหาในแชทที่บันทึกไว้ทั้งหมด';

  @override
  String get crossSearchNoResults => 'ไม่พบข้อความที่ตรงกัน';

  @override
  String get chatLockAuthReason => 'ยืนยันตัวตนเพื่อดูแชทนี้';

  @override
  String get chatLockPaywallTitle => 'เกี่ยวกับการล็อกรายแชท';

  @override
  String get chatLockPaywallBody =>
      'ฟีเจอร์ล็อกแชทแต่ละรายการจะปลดล็อกเมื่อซื้อ \"ปิดการแสดงโฆษณา\"';

  @override
  String get purchaseButton => 'ซื้อ';

  @override
  String createdAtLabel(Object datetime) {
    return 'สร้างเมื่อ: $datetime';
  }

  @override
  String get manualRoomBadgeLabel => 'ห้องรูปภาพ';

  @override
  String get deletePlaceholderConfirmTitle => 'ลบข้อความนี้หรือไม่?';

  @override
  String get deletePlaceholderConfirmBody =>
      'จะลบข้อความนี้ รวมถึงรูปภาพหรือวิดีโอที่แนบไว้ (ถ้ามี) และไม่สามารถกู้คืนได้';

  @override
  String get deleteChatConfirmBody =>
      'ข้อมูลที่บันทึกไว้ของแชทนี้จะถูกลบ และไม่สามารถกู้คืนได้';

  @override
  String get detachSelectedTooltip => 'ลบเฉพาะรูปภาพ/วิดีโอของข้อความที่เลือก';

  @override
  String get detachMessagesConfirmTitle => 'ลบรูปภาพ/วิดีโอหรือไม่?';

  @override
  String detachMessagesConfirmBody(Object count) {
    return 'จะลบรูปภาพหรือวิดีโอที่แนบไว้ในข้อความที่เลือก $count รายการ ตัวข้อความจะยังคงอยู่ และไม่สามารถกู้คืนได้';
  }

  @override
  String get deleteAttachmentTooltip => 'ลบ';

  @override
  String get deleteAttachmentConfirmTitle => 'ลบรายการนี้หรือไม่?';

  @override
  String get deleteAttachmentConfirmBody =>
      'รูปภาพหรือวิดีโอนี้จะถูกลบ และไม่สามารถกู้คืนได้';

  @override
  String deleteAttachmentFailedMessage(Object error) {
    return 'ลบไม่สำเร็จ: $error';
  }

  @override
  String get saveToDeviceTooltip => 'บันทึกลงเครื่อง';

  @override
  String get saveToDeviceSuccessMessage => 'บันทึกลงเครื่องแล้ว';

  @override
  String saveToDeviceFailedMessage(Object error) {
    return 'บันทึกไม่สำเร็จ: $error';
  }

  @override
  String get emptyChatListMessage =>
      'ยังไม่มีแชทที่นำเข้า\nใน LINE ใช้ฟังก์ชัน \"ส่งแชทเป็นข้อความ\" แล้วโหลดไฟล์ที่บันทึกไว้ด้วยปุ่มด้านล่างขวา';

  @override
  String importedAtLabel(Object datetime) {
    return 'นำเข้าเมื่อ: $datetime';
  }

  @override
  String get settingsTitle => 'ตั้งค่า';

  @override
  String get reminderToggleTitle => 'การแจ้งเตือนบันทึก';

  @override
  String get reminderToggleSubtitle =>
      'ส่งการแจ้งเตือนทุกวันอาทิตย์เวลา 10 โมงเช้า เพื่อเตือนให้คุณบันทึกแชท';

  @override
  String get reminderPermissionDeniedMessage =>
      'ไม่สามารถตั้งค่าการแจ้งเตือนได้เนื่องจากไม่ได้รับอนุญาต โปรดอนุญาตการแจ้งเตือนในการตั้งค่าเครื่อง';

  @override
  String get reminderNotificationTitle => 'บันทึกแชท';

  @override
  String get reminderNotificationBody => 'ถึงเวลาบันทึกแชทล่าสุดของคุณหรือยัง?';

  @override
  String get appLockToggleTitle => 'ล็อกเมื่อเปิดแอป';

  @override
  String get appLockToggleSubtitle =>
      'ป้องกันด้วย PIN ลายรูปแบบ หรือไบโอเมตริกซ์ของเครื่อง (หรือ PIN แอปด้านล่างหากตั้งค่าไว้ ซึ่งจะมีความสำคัญกว่า)';

  @override
  String get appLockUnsupportedMessage =>
      'เครื่องนี้ยังไม่ได้ตั้งค่าการล็อกหน้าจอ (PIN ลายรูปแบบ ไบโอเมตริกซ์ ฯลฯ) ตั้งค่า PIN แอปด้านล่างเพื่อใช้ฟีเจอร์ล็อกได้';

  @override
  String get appPinSectionTitle => 'PIN แอป';

  @override
  String get appPinSetSubtitle =>
      'ตั้งค่าแล้ว ใช้ล็อกได้แม้เครื่องไม่มีการล็อกหน้าจอ';

  @override
  String get appPinNotSetSubtitle =>
      'ยังไม่ได้ตั้งค่า ตั้งไว้เพื่อใช้ล็อกได้แม้เครื่องไม่มีการล็อกหน้าจอ';

  @override
  String get setAppPinButton => 'ตั้งค่า';

  @override
  String get changeAppPinButton => 'เปลี่ยน';

  @override
  String get setAppPinTitle => 'ตั้งค่า PIN แอป';

  @override
  String get appPinHint => 'PIN (4-6 หลัก)';

  @override
  String get appPinConfirmHint => 'ป้อนอีกครั้ง';

  @override
  String get appPinTooShortMessage => 'PIN ต้องมีอย่างน้อย 4 หลัก';

  @override
  String get appPinMismatchMessage => 'PIN ไม่ตรงกัน';

  @override
  String get enterAppPinTitle => 'ป้อน PIN';

  @override
  String get appPinIncorrectMessage => 'PIN ไม่ถูกต้อง';

  @override
  String get appPinManageAuthReason => 'ยืนยันตัวตนเพื่อเปลี่ยนหรือลบ PIN';

  @override
  String get removeAppPinWarningTitle => 'ลบ PIN แอปหรือไม่?';

  @override
  String get removeAppPinWarningBody =>
      'เครื่องนี้ไม่มีวิธียืนยันตัวตนอื่นที่ใช้งานได้ หากมีแชทที่ล็อกอยู่หรือเปิดใช้การล็อกทั้งแอป คุณจะไม่สามารถปลดล็อกได้อีกหลังจากลบ PIN';

  @override
  String get purchaseUnavailableMessage =>
      'ไม่สามารถใช้งานการซื้อในแอปบนเครื่องนี้ได้';

  @override
  String get purchaseFetchFailedMessage =>
      'ไม่สามารถดึงข้อมูลการซื้อได้ โปรดลองใหม่อีกครั้งภายหลัง';

  @override
  String get restoringPurchasesMessage => 'กำลังตรวจสอบประวัติการซื้อ…';

  @override
  String get removeAdsTitle => 'ปิดการแสดงโฆษณา';

  @override
  String get removeAdsPurchasedSubtitle => 'ซื้อแล้ว ขอบคุณที่สนับสนุน';

  @override
  String get removeAdsSubtitle => 'ซื้อครั้งเดียว ไม่แสดงโฆษณาอีกต่อไป';

  @override
  String get restorePurchaseTitle => 'กู้คืนการซื้อ';

  @override
  String get restorePurchaseSubtitle =>
      'หากเปลี่ยนเครื่อง ให้กู้คืนการซื้อที่นี่';

  @override
  String get backupTitle => 'สร้างไฟล์สำรองข้อมูล';

  @override
  String get backupSubtitle =>
      'บันทึกข้อมูลทั้งหมดเป็นไฟล์เดียว (สำหรับตอนเปลี่ยนเครื่อง)';

  @override
  String backupCreateFailedMessage(Object error) {
    return 'สร้างไฟล์สำรองข้อมูลไม่สำเร็จ: $error';
  }

  @override
  String get restoreBackupTitle => 'กู้คืนจากไฟล์สำรองข้อมูล';

  @override
  String get restoreBackupSubtitle =>
      'โหลดไฟล์สำรองข้อมูลที่สร้างไว้ก่อนหน้านี้';

  @override
  String get restoreBackupConfirmTitle => 'กู้คืนข้อมูลนี้หรือไม่?';

  @override
  String get restoreBackupConfirmBody =>
      'ข้อมูลปัจจุบันทั้งหมดจะถูกเขียนทับ และไม่สามารถย้อนกลับได้';

  @override
  String get restoreBackupSuccessMessage => 'กู้คืนข้อมูลเรียบร้อยแล้ว';

  @override
  String get restoreBackupInvalidFileMessage =>
      'ไฟล์นี้ไม่ใช่ไฟล์สำรองข้อมูลที่ถูกต้อง';

  @override
  String restoreBackupFailedMessage(Object error) {
    return 'กู้คืนข้อมูลไม่สำเร็จ: $error';
  }

  @override
  String get backupUnlockTitle => 'ฟีเจอร์สำรองข้อมูล';

  @override
  String get backupUnlockSubtitle =>
      'ซื้อครั้งเดียว ใช้สร้างและกู้คืนข้อมูลได้ตลอด';

  @override
  String get backupPaywallTitle => 'ปลดล็อกฟีเจอร์สำรองข้อมูลหรือไม่?';

  @override
  String get backupPaywallBody =>
      'ซื้อครั้งเดียวเพื่อสร้างและกู้คืนข้อมูลสำรองได้ตลอดเวลา';

  @override
  String get languageSettingTitle => 'ภาษา';

  @override
  String get languageSystemDefault => 'ตามการตั้งค่าเครื่อง';

  @override
  String get lockedMessage => 'ล็อกอยู่';

  @override
  String get unlockButtonLabel => 'ยืนยันตัวตนเพื่อปลดล็อก';

  @override
  String get appLockAuthReason => 'ยืนยันตัวตนเพื่อดูเนื้อหาแชท';

  @override
  String get filterTitle => 'ตัวกรอง';

  @override
  String get textSearchLabel => 'ค้นหาข้อความ';

  @override
  String get keywordHint => 'ป้อนคำค้นหา';

  @override
  String get senderLabel => 'ผู้ส่ง';

  @override
  String get periodLabel => 'ช่วงเวลา';

  @override
  String get periodPickerButton => 'เลือกช่วงเวลา';

  @override
  String periodRangeFormat(Object start, Object end) {
    return '$start – $end';
  }

  @override
  String get clearButton => 'ล้างค่า';

  @override
  String get applyButton => 'นำไปใช้';

  @override
  String get loadingTitle => 'กำลังโหลด...';

  @override
  String get copySelectedTooltip => 'คัดลอกข้อความที่เลือก';

  @override
  String copiedMessage(Object label) {
    return 'คัดลอก$labelแล้ว';
  }

  @override
  String selectedCountLabel(Object count) {
    return 'เลือกแล้ว $count รายการ';
  }

  @override
  String get photosTooltip => 'รูปภาพ';

  @override
  String get filterTooltip => 'กรองตามผู้ส่งหรือช่วงเวลา';

  @override
  String get copyAllTooltip => 'คัดลอกทั้งหมด';

  @override
  String allCountLabel(Object count) {
    return 'ทั้งหมด $count รายการ';
  }

  @override
  String get exportTooltip => 'ส่งออก';

  @override
  String get defaultChatTitleForExport => 'แชท';

  @override
  String get noMessagesFiltered => 'ไม่พบข้อความที่ตรงกับเงื่อนไข';

  @override
  String get noMessagesAtAll => 'ไม่มีข้อความ';

  @override
  String tapToAttachPhoto(Object placeholder) {
    return '$placeholder แตะเพื่อแนบรูปภาพ';
  }

  @override
  String tapToAttachVideo(Object placeholder) {
    return '$placeholder แตะเพื่อแนบวิดีโอ';
  }

  @override
  String tapToAttachFile(Object placeholder) {
    return '$placeholder แตะเพื่อแนบไฟล์';
  }

  @override
  String get photosTitle => 'รูปภาพ';

  @override
  String get noPhotosMessage =>
      'แชทนี้ยังไม่มีรูปภาพ\nเพิ่มได้ด้วยปุ่มด้านล่างขวา';

  @override
  String get addPhotoTooltip => 'เพิ่มรูปภาพ';

  @override
  String get addVideoLabel => 'เพิ่มวิดีโอ';

  @override
  String get addFileLabel => 'เพิ่มไฟล์';

  @override
  String openFileFailedMessage(Object error) {
    return 'เปิดไฟล์นี้ไม่สำเร็จ: $error';
  }

  @override
  String get addMediaTooltip => 'เพิ่มรูปภาพหรือวิดีโอ';

  @override
  String get pickChatForPhotoTitle => 'เลือกแชทสำหรับรูปนี้';

  @override
  String get noChatsForPhotoMessage => 'ยังไม่มีแชท กรุณานำเข้าแชท LINE ก่อน';

  @override
  String attachPendingPhotoBannerMessage(Object count) {
    return 'แตะข้อความที่ต้องการแนบ (เหลืออีก $count รายการ)';
  }

  @override
  String get photoAttachedMessage => 'แนบรูปภาพแล้ว';

  @override
  String get fileAttachedMessage => 'แนบไฟล์แล้ว';

  @override
  String get attachPendingDirectlyButton => 'เพิ่มเข้าแชทโดยตรง';

  @override
  String pendingAttachedToRoomMessage(Object count) {
    return 'เพิ่ม $count รายการเข้าห้องแชทนี้แล้ว';
  }

  @override
  String get exportFormatTitle => 'เลือกรูปแบบไฟล์ส่งออก';

  @override
  String get excelOption => 'Excel (.xlsx)';

  @override
  String get pdfOption => 'PDF';

  @override
  String get wordOption => 'Word (.docx)';

  @override
  String exportFailedMessage(Object error) {
    return 'ส่งออกไม่สำเร็จ: $error';
  }

  @override
  String get exportIncludeStatsLabel => 'รวมข้อมูลสถิติ';

  @override
  String get exportStatsSectionTitle => 'สถิติแชท';

  @override
  String exportStatsTotalMessagesLabel(Object count) {
    return 'จำนวนข้อความทั้งหมด: $count';
  }

  @override
  String get excelSheetName => 'แชท';

  @override
  String get columnDate => 'วันที่';

  @override
  String get columnTime => 'เวลา';

  @override
  String get columnSender => 'ผู้ส่ง';

  @override
  String get columnBody => 'ข้อความ';

  @override
  String get systemSender => 'ระบบ';

  @override
  String get excelGenerationFailed => 'สร้างไฟล์ Excel ไม่สำเร็จ';

  @override
  String get docxGenerationFailed => 'สร้างไฟล์ Word ไม่สำเร็จ';

  @override
  String get importScreenTitle => 'นำเข้าแชท';

  @override
  String get idleImportInstruction =>
      'ในแอป LINE เปิดหน้าแชทแล้วเลือก \"ส่งแชทเป็นข้อความ\"\nจากนั้นโหลดไฟล์ .txt ที่บันทึกไว้ที่นี่';

  @override
  String get openLineButton => 'เปิด LINE';

  @override
  String get lineNotInstalledMessage => 'ยังไม่ได้ติดตั้ง LINE';

  @override
  String get selectFileButton => 'เลือกไฟล์';

  @override
  String get retrySelectFileButton => 'เลือกอีกครั้ง';

  @override
  String get sharedTextFallbackTitle => 'แชท LINE (แชร์มา)';

  @override
  String sharedContentLoadFailed(Object error) {
    return 'โหลดเนื้อหาที่แชร์มาไม่สำเร็จ: $error';
  }

  @override
  String fileLoadFailed(Object error) {
    return 'โหลดไฟล์ไม่สำเร็จ: $error';
  }

  @override
  String saveFailedMessage(Object error) {
    return 'บันทึกไม่สำเร็จ: $error';
  }

  @override
  String get previewLabelTitle => 'ชื่อ';

  @override
  String get previewLabelMessageCount => 'จำนวนข้อความ';

  @override
  String get previewLabelParticipantCount => 'จำนวนผู้ร่วมแชท';

  @override
  String get previewNoTitleDetected => '(ไม่พบ)';

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
      'ไม่สามารถระบุข้อความได้ โปรดตรวจสอบว่าเป็นไฟล์ .txt ที่ส่งออกจาก LINE โดยตรง';

  @override
  String previewUnrecognizedLinesMessage(Object count) {
    return '$count บรรทัดถูกรวมเข้ากับข้อความก่อนหน้า';
  }

  @override
  String get saveButton => 'บันทึก';

  @override
  String get helpMenuTitle => 'คู่มือการใช้งาน';

  @override
  String get helpMenuSubtitle => 'ดูวิธีใช้งานและคำอธิบายฟีเจอร์';

  @override
  String get helpScreenTitle => 'คู่มือการใช้งาน';

  @override
  String get whatsNewMenuTitle => 'มีอะไรใหม่';

  @override
  String get whatsNewMenuSubtitle => 'ดูการเปลี่ยนแปลงในอัปเดตล่าสุด';

  @override
  String get whatsNewScreenTitle => 'มีอะไรใหม่';

  @override
  String whatsNewVersionLabel(Object version) {
    return 'เวอร์ชัน $version';
  }

  @override
  String get whatsNewDialogTitle => 'แอปได้รับการอัปเดตแล้ว';

  @override
  String get whatsNewDialogOkButton => 'ตกลง';

  @override
  String get whatsNewV120Body =>
      'เราได้ขยายฟีเจอร์สถิติแชท\n\n• ดูแนวโน้มช่วงเวลาที่คุณส่งข้อความ (กลางคืน กลางวัน ฯลฯ)\n• ดูอัตราการตอบคำถาม (ความราบรื่นของบทสนทนา)\n• เพิ่มแดชบอร์ดเพื่อดูสถิติของแชทที่บันทึกไว้ทั้งหมด\n• ตอนนี้สามารถรวมข้อมูลสถิติเมื่อส่งออกเป็น PDF/Excel/Word ได้แล้ว';

  @override
  String get helpAboutTitle => 'เกี่ยวกับแอปนี้';

  @override
  String get helpAboutBody =>
      '「บันทึกแชท」เป็นแอปสำหรับบันทึกประวัติแชท LINE ลงในเครื่องของคุณในรูปแบบที่ดูย้อนหลังได้ง่าย แอปนี้จะไม่ควบคุม LINE โดยอัตโนมัติ แต่จะทำงานโดยการนำเข้าไฟล์ .txt ที่คุณส่งออกด้วยฟีเจอร์「ส่งแชทเป็นข้อความ」ของ LINE เอง';

  @override
  String get helpImportTitle => 'การนำเข้าแชท';

  @override
  String get helpImportBody =>
      '1. ในหน้าแชทของ LINE แตะเมนู (≡) → 「ส่งประวัติแชท」→「ส่งเป็นข้อความ」\n2. เลือก「บันทึกแชท」จากรายการแชร์เพื่อนำเข้าโดยอัตโนมัติ\n3. หากไม่ปรากฏในรายการ ให้บันทึกเป็นไฟล์ .txt ก่อน แล้วใช้「นำเข้าแชท」→「เลือกไฟล์」ในแอปนี้\n\nคุณยังสามารถเปิด LINE ได้ทันทีด้วยปุ่ม「เปิด LINE」ในหน้านำเข้า';

  @override
  String get helpChatListTitle => 'การจัดการรายการแชท';

  @override
  String get helpChatListBody =>
      '• แตะไอคอนทางซ้ายของแชทเพื่อเปลี่ยนเป็นไอคอนที่ต้องการ\n• แตะไอคอนดินสอเพื่อเปลี่ยนชื่อแชท\n• ใช้ปุ่ม + ที่มุมขวาบนเพื่อสร้างห้องใหม่สำหรับรูปภาพ วิดีโอ และไฟล์โดยเฉพาะ\n• แตะไอคอนกุญแจเพื่อล็อกแชทแต่ละรายการ (ต้องซื้อ)\n• แตะไอคอนดาวเพื่อเพิ่มแชทลงในรายการโปรด แชทโปรดจะถูกปักหมุดไว้ด้านบนสุดของรายการ\n• ใช้ไอคอนค้นหาที่มุมขวาบนเพื่อค้นหาคำสำคัญในแชทที่บันทึกไว้ทั้งหมดพร้อมกัน';

  @override
  String get helpChatDetailTitle => 'การใช้งานหน้าจอแชท';

  @override
  String get helpChatDetailBody =>
      '• กดค้างหรือเลือกหลายข้อความเพื่อคัดลอก\n• กรองตามผู้ส่ง ช่วงวันที่ หรือคำสำคัญ\n• ส่งออกเป็น Excel, PDF หรือ Word จากไอคอนที่มุมขวาบน\n• ใช้ไอคอนแกลเลอรีเพื่อดูรูปภาพทั้งหมดที่แนบในแชทนั้น';

  @override
  String get helpStatsTitle => 'วิธีดูสถิติแชท';

  @override
  String get helpStatsBody =>
      '• ดูกราฟจำนวนข้อความรายเดือน\n• สำหรับแชทแบบ 1 ต่อ 1 จะวินิจฉัยความเข้ากันได้จากความเร็วในการตอบกลับ สัดส่วนสติกเกอร์ และอื่นๆ\n• สำหรับกลุ่มตั้งแต่ 3 คนขึ้นไป จะแสดงกราฟวงกลมสัดส่วนข้อความ\n• ดูแนวโน้มช่วงเวลาที่คุณแอคทีฟที่สุด (กลางคืน กลางวัน ฯลฯ)\n• ดูอัตราการตอบคำถาม (ความราบรื่นของบทสนทนา)\n• เปิดไอคอนแดชบอร์ดจากรายการแชทเพื่อดูสถิติของแชทที่บันทึกไว้ทั้งหมด\n• สามารถรวมข้อมูลสถิติเมื่อส่งออกเป็น Excel, PDF หรือ Word ได้เช่นกัน';

  @override
  String get helpAttachTitle => 'การแนบรูปภาพ วิดีโอ และไฟล์';

  @override
  String get helpAttachBody =>
      'แตะที่ตำแหน่ง [รูปภาพ] หรือ [สติกเกอร์] เพื่อแนบรูปภาพหรือวิดีโอจากเครื่องของคุณ ไฟล์ส่งออกของ LINE ไม่มีรูปภาพจริงรวมอยู่ด้วย จึงไม่สามารถกู้คืนโดยอัตโนมัติได้';

  @override
  String get helpLockTitle => 'เกี่ยวกับการล็อก';

  @override
  String get helpLockBody =>
      'ในหน้าตั้งค่า คุณสามารถตั้งค่าให้ต้องยืนยันตัวตนด้วยไบโอเมตริก, PIN ของเครื่อง หรือ PIN ภายในแอปเพื่อเปิดแอป หากตั้งค่า PIN ภายในแอป จะมีความสำคัญเหนือกว่าการยืนยันตัวตนไบโอเมตริกของเครื่อง\n\nการล็อกแชทแต่ละรายการรวมอยู่ในการซื้อเดียวกับการลบโฆษณา';

  @override
  String get helpBackupTitle => 'การสำรองและกู้คืนข้อมูล';

  @override
  String get helpBackupBody =>
      'ใช้「สร้างข้อมูลสำรอง」ในหน้าตั้งค่าเพื่อบันทึกแชทและไฟล์แนบทั้งหมดที่นำเข้าไว้เป็นไฟล์เดียว ใช้「กู้คืนจากข้อมูลสำรอง」เพื่อนำข้อมูลเดียวกันไปยังเครื่องใหม่ วิธีนี้ใช้ได้แม้เปลี่ยนเครื่องระหว่าง iPhone และ Android';

  @override
  String get helpPrivacyTitle => 'เกี่ยวกับข้อมูลของคุณ';

  @override
  String get helpPrivacyBody =>
      'ทุกอย่างที่คุณนำเข้าหรือแนบจะถูกจัดเก็บไว้ในเครื่องนี้เท่านั้น ไม่มีการส่งข้อมูลใด ๆ ไปยังเซิร์ฟเวอร์';

  @override
  String get feedbackMenuTitle => 'ความคิดเห็นและรายงานปัญหา';

  @override
  String get feedbackMenuSubtitle => 'พบสิ่งใดโปรดส่งอีเมลมาบอกเรา';

  @override
  String get privacyOptionsTitle => 'ตัวเลือกความเป็นส่วนตัวของโฆษณา';

  @override
  String get privacyOptionsSubtitle =>
      'เปลี่ยนการยินยอมสำหรับโฆษณาที่ปรับตามบุคคล';

  @override
  String get feedbackEmailSubject => '[Talk Saver] ความคิดเห็น';

  @override
  String get feedbackEmailBody =>
      'โปรดเขียนความคิดเห็น คำขอ หรือปัญหาที่พบไว้ด้านล่าง\n(หากเป็นปัญหา โปรดระบุขั้นตอนที่เกิดและรุ่นเครื่องของคุณด้วย)\n\n';

  @override
  String get feedbackLaunchFailedMessage =>
      'ไม่สามารถเปิดแอปอีเมลได้ โปรดติดต่อ talk-hozon-testers@googlegroups.com';

  @override
  String get appVersionTitle => 'เวอร์ชันแอป';
}
