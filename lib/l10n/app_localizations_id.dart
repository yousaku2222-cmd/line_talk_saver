// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Penyimpan Obrolan';

  @override
  String get cancel => 'Batal';

  @override
  String get delete => 'Hapus';

  @override
  String get unknownSender => 'Tidak diketahui';

  @override
  String loadErrorWithMessage(Object error) {
    return 'Gagal memuat: $error';
  }

  @override
  String get settingsTooltip => 'Pengaturan';

  @override
  String get importButtonLabel => 'Impor obrolan';

  @override
  String get createChatRoomTitle => 'Buat ruang obrolan baru';

  @override
  String get createChatRoomHint => 'Nama ruang obrolan';

  @override
  String get createChatRoomButton => 'Buat';

  @override
  String get deleteChatConfirmTitle => 'Hapus obrolan ini?';

  @override
  String get pickChatIconTitle => 'Pilih ikon';

  @override
  String get pickChatIconLockedHint =>
      'Ikon dengan 🔒 akan terbuka permanen setelah menonton satu iklan.';

  @override
  String get unlockIconDialogTitle => 'Buka kunci ikon ini?';

  @override
  String get unlockIconDialogBody =>
      'Tonton satu iklan untuk membuka ikon ini selamanya.';

  @override
  String get unlockIconWatchAdButton => 'Tonton iklan';

  @override
  String get unlockIconFailedMessage =>
      'Iklan tidak dapat diputar. Coba lagi sebentar lagi.';

  @override
  String get renameChatTitle => 'Ganti nama obrolan';

  @override
  String get renameChatButton => 'Ganti nama';

  @override
  String get renameChatTooltip => 'Ganti nama';

  @override
  String get chatLockTooltip => 'Kunci obrolan ini';

  @override
  String get chatUnlockTooltip => 'Buka kunci';

  @override
  String get chatLockAuthReason => 'Autentikasi untuk melihat obrolan ini';

  @override
  String get chatLockPaywallTitle => 'Tentang kunci per obrolan';

  @override
  String get chatLockPaywallBody =>
      'Mengunci obrolan satu per satu terbuka dengan pembelian \"Hilangkan iklan\".';

  @override
  String get purchaseButton => 'Beli';

  @override
  String createdAtLabel(Object datetime) {
    return 'Dibuat: $datetime';
  }

  @override
  String get manualRoomBadgeLabel => 'Ruang foto';

  @override
  String get deletePlaceholderConfirmTitle => 'Hapus pesan ini?';

  @override
  String get deletePlaceholderConfirmBody =>
      'Pesan ini akan dihapus, beserta foto atau video yang dilampirkan jika ada. Tindakan ini tidak dapat dibatalkan.';

  @override
  String get deleteChatConfirmBody =>
      'Data yang tersimpan untuk obrolan ini akan dihapus. Tindakan ini tidak dapat dibatalkan.';

  @override
  String get detachSelectedTooltip =>
      'Hapus foto/video dari pesan yang dipilih saja';

  @override
  String get detachMessagesConfirmTitle => 'Hapus foto/video?';

  @override
  String detachMessagesConfirmBody(Object count) {
    return 'Foto atau video yang dilampirkan pada $count pesan yang dipilih akan dihapus. Pesannya sendiri akan tetap ada. Tindakan ini tidak dapat dibatalkan.';
  }

  @override
  String get deleteAttachmentTooltip => 'Hapus';

  @override
  String get deleteAttachmentConfirmTitle => 'Hapus ini?';

  @override
  String get deleteAttachmentConfirmBody =>
      'Foto atau video ini akan dihapus. Tindakan ini tidak dapat dibatalkan.';

  @override
  String deleteAttachmentFailedMessage(Object error) {
    return 'Gagal menghapus: $error';
  }

  @override
  String get saveToDeviceTooltip => 'Simpan ke perangkat';

  @override
  String get saveToDeviceSuccessMessage => 'Tersimpan ke perangkat';

  @override
  String saveToDeviceFailedMessage(Object error) {
    return 'Gagal menyimpan: $error';
  }

  @override
  String get emptyChatListMessage =>
      'Belum ada obrolan yang diimpor.\nDi LINE, gunakan \"Kirim Obrolan sebagai Teks\", lalu muat file yang tersimpan lewat tombol di kanan bawah.';

  @override
  String importedAtLabel(Object datetime) {
    return 'Diimpor: $datetime';
  }

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get appLockToggleTitle => 'Kunci saat dibuka';

  @override
  String get appLockToggleSubtitle =>
      'Melindungi dengan PIN, pola, atau biometrik perangkat (atau PIN Aplikasi di bawah, jika diatur, yang diprioritaskan)';

  @override
  String get appLockUnsupportedMessage =>
      'Perangkat ini belum mengatur kunci layar (PIN, pola, biometrik, dll.). Atur PIN Aplikasi di bawah untuk tetap bisa menggunakan penguncian.';

  @override
  String get appPinSectionTitle => 'PIN Aplikasi';

  @override
  String get appPinSetSubtitle =>
      'Sudah diatur. Kunci tetap berfungsi meski tanpa kunci layar perangkat.';

  @override
  String get appPinNotSetSubtitle =>
      'Belum diatur. Atur agar kunci tetap berfungsi meski tanpa kunci layar perangkat.';

  @override
  String get setAppPinButton => 'Atur';

  @override
  String get changeAppPinButton => 'Ubah';

  @override
  String get setAppPinTitle => 'Atur PIN aplikasi';

  @override
  String get appPinHint => 'PIN (4-6 digit)';

  @override
  String get appPinConfirmHint => 'Masukkan lagi';

  @override
  String get appPinTooShortMessage => 'PIN minimal 4 digit';

  @override
  String get appPinMismatchMessage => 'PIN tidak cocok';

  @override
  String get enterAppPinTitle => 'Masukkan PIN';

  @override
  String get appPinIncorrectMessage => 'PIN salah';

  @override
  String get appPinManageAuthReason =>
      'Autentikasi untuk mengubah atau menghapus PIN';

  @override
  String get removeAppPinWarningTitle => 'Hapus PIN aplikasi?';

  @override
  String get removeAppPinWarningBody =>
      'Perangkat ini tidak memiliki metode autentikasi lain yang berfungsi. Jika Anda memiliki chat yang terkunci atau kunci aplikasi aktif, Anda tidak akan bisa membukanya lagi setelah menghapus PIN.';

  @override
  String get purchaseUnavailableMessage =>
      'Pembelian tidak tersedia di perangkat ini.';

  @override
  String get purchaseFetchFailedMessage =>
      'Gagal mengambil info pembelian. Coba lagi nanti.';

  @override
  String get restoringPurchasesMessage => 'Memeriksa riwayat pembelian…';

  @override
  String get removeAdsTitle => 'Hilangkan iklan';

  @override
  String get removeAdsPurchasedSubtitle =>
      'Sudah dibeli. Terima kasih atas dukungannya!';

  @override
  String get removeAdsSubtitle =>
      'Pembelian sekali untuk menghilangkan iklan selamanya';

  @override
  String get restorePurchaseTitle => 'Pulihkan pembelian';

  @override
  String get restorePurchaseSubtitle =>
      'Jika berganti perangkat, pulihkan pembelian Anda di sini';

  @override
  String get backupTitle => 'Buat cadangan';

  @override
  String get backupSubtitle =>
      'Simpan semua data Anda sebagai satu file (untuk berganti perangkat)';

  @override
  String backupCreateFailedMessage(Object error) {
    return 'Gagal membuat cadangan: $error';
  }

  @override
  String get restoreBackupTitle => 'Pulihkan dari cadangan';

  @override
  String get restoreBackupSubtitle =>
      'Muat file cadangan yang pernah Anda buat';

  @override
  String get restoreBackupConfirmTitle => 'Pulihkan cadangan ini?';

  @override
  String get restoreBackupConfirmBody =>
      'Semua data saat ini akan ditimpa. Tindakan ini tidak dapat dibatalkan.';

  @override
  String get restoreBackupSuccessMessage => 'Pemulihan selesai';

  @override
  String get restoreBackupInvalidFileMessage =>
      'Ini bukan file cadangan yang valid';

  @override
  String restoreBackupFailedMessage(Object error) {
    return 'Pemulihan gagal: $error';
  }

  @override
  String get languageSettingTitle => 'Bahasa';

  @override
  String get languageSystemDefault => 'Ikuti bahasa perangkat';

  @override
  String get lockedMessage => 'Terkunci';

  @override
  String get unlockButtonLabel => 'Autentikasi untuk membuka';

  @override
  String get appLockAuthReason => 'Autentikasi untuk melihat isi obrolan';

  @override
  String get filterTitle => 'Filter';

  @override
  String get textSearchLabel => 'Cari teks';

  @override
  String get keywordHint => 'Masukkan kata kunci';

  @override
  String get senderLabel => 'Pengirim';

  @override
  String get periodLabel => 'Rentang tanggal';

  @override
  String get periodPickerButton => 'Pilih rentang tanggal';

  @override
  String periodRangeFormat(Object start, Object end) {
    return '$start – $end';
  }

  @override
  String get clearButton => 'Bersihkan';

  @override
  String get applyButton => 'Terapkan';

  @override
  String get loadingTitle => 'Memuat...';

  @override
  String get copySelectedTooltip => 'Salin pesan yang dipilih';

  @override
  String copiedMessage(Object label) {
    return '$label disalin';
  }

  @override
  String selectedCountLabel(Object count) {
    return '$count dipilih';
  }

  @override
  String get photosTooltip => 'Foto';

  @override
  String get filterTooltip => 'Filter berdasarkan pengirim atau tanggal';

  @override
  String get copyAllTooltip => 'Salin semua';

  @override
  String allCountLabel(Object count) {
    return 'Semua $count';
  }

  @override
  String get exportTooltip => 'Ekspor';

  @override
  String get defaultChatTitleForExport => 'Obrolan';

  @override
  String get noMessagesFiltered =>
      'Tidak ada pesan yang cocok dengan filter ini';

  @override
  String get noMessagesAtAll => 'Tidak ada pesan';

  @override
  String tapToAttachPhoto(Object placeholder) {
    return '$placeholder Ketuk untuk melampirkan foto';
  }

  @override
  String tapToAttachVideo(Object placeholder) {
    return '$placeholder Ketuk untuk melampirkan video';
  }

  @override
  String tapToAttachFile(Object placeholder) {
    return '$placeholder Ketuk untuk melampirkan file';
  }

  @override
  String get photosTitle => 'Foto';

  @override
  String get noPhotosMessage =>
      'Belum ada foto di obrolan ini.\nTambahkan lewat tombol di kanan bawah.';

  @override
  String get addPhotoTooltip => 'Tambah foto';

  @override
  String get addVideoLabel => 'Tambah video';

  @override
  String get addFileLabel => 'Tambah file';

  @override
  String openFileFailedMessage(Object error) {
    return 'Gagal membuka file ini: $error';
  }

  @override
  String get addMediaTooltip => 'Tambah foto atau video';

  @override
  String get pickChatForPhotoTitle => 'Pilih chat untuk foto ini';

  @override
  String get noChatsForPhotoMessage =>
      'Belum ada chat. Impor chat LINE terlebih dahulu.';

  @override
  String attachPendingPhotoBannerMessage(Object count) {
    return 'Ketuk pesan untuk melampirkannya (sisa $count)';
  }

  @override
  String get photoAttachedMessage => 'Foto berhasil dilampirkan';

  @override
  String get fileAttachedMessage => 'File berhasil dilampirkan';

  @override
  String get attachPendingDirectlyButton => 'Tambah langsung ke chat';

  @override
  String pendingAttachedToRoomMessage(Object count) {
    return '$count item ditambahkan ke ruang obrolan ini';
  }

  @override
  String get exportFormatTitle => 'Pilih format ekspor';

  @override
  String get excelOption => 'Excel (.xlsx)';

  @override
  String get pdfOption => 'PDF';

  @override
  String get wordOption => 'Word (.docx)';

  @override
  String exportFailedMessage(Object error) {
    return 'Ekspor gagal: $error';
  }

  @override
  String get excelSheetName => 'Obrolan';

  @override
  String get columnDate => 'Tanggal';

  @override
  String get columnTime => 'Waktu';

  @override
  String get columnSender => 'Pengirim';

  @override
  String get columnBody => 'Pesan';

  @override
  String get systemSender => 'Sistem';

  @override
  String get excelGenerationFailed => 'Gagal membuat file Excel';

  @override
  String get docxGenerationFailed => 'Gagal membuat file Word';

  @override
  String get importScreenTitle => 'Impor obrolan';

  @override
  String get idleImportInstruction =>
      'Di LINE, buka obrolan lalu pilih \"Kirim Obrolan sebagai Teks\",\nlalu muat file .txt yang tersimpan di sini.';

  @override
  String get openLineButton => 'Buka LINE';

  @override
  String get lineNotInstalledMessage => 'LINE belum terpasang';

  @override
  String get selectFileButton => 'Pilih file';

  @override
  String get retrySelectFileButton => 'Pilih lagi';

  @override
  String get sharedTextFallbackTitle => 'Obrolan LINE (dibagikan)';

  @override
  String sharedContentLoadFailed(Object error) {
    return 'Gagal memuat konten yang dibagikan: $error';
  }

  @override
  String fileLoadFailed(Object error) {
    return 'Gagal memuat file: $error';
  }

  @override
  String saveFailedMessage(Object error) {
    return 'Gagal menyimpan: $error';
  }

  @override
  String get previewLabelTitle => 'Judul';

  @override
  String get previewLabelMessageCount => 'Jumlah pesan';

  @override
  String get previewLabelParticipantCount => 'Jumlah peserta';

  @override
  String get previewNoTitleDetected => '(tidak terdeteksi)';

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
      'Tidak ada pesan yang dapat dikenali. Pastikan ini adalah file .txt hasil ekspor langsung dari LINE.';

  @override
  String previewUnrecognizedLinesMessage(Object count) {
    return '$count baris digabungkan ke pesan sebelumnya.';
  }

  @override
  String get saveButton => 'Simpan';

  @override
  String get helpMenuTitle => 'Panduan Pengguna';

  @override
  String get helpMenuSubtitle => 'Lihat cara menggunakan fitur aplikasi';

  @override
  String get helpScreenTitle => 'Panduan Pengguna';

  @override
  String get helpAboutTitle => 'Tentang aplikasi ini';

  @override
  String get helpAboutBody =>
      'Talk Saver adalah aplikasi untuk menyimpan riwayat obrolan LINE ke perangkat Anda dalam format yang mudah dibaca kembali. Aplikasi ini tidak pernah mengoperasikan LINE secara otomatis — aplikasi ini bekerja dengan mengimpor file .txt yang Anda ekspor menggunakan fitur \"Kirim obrolan sebagai teks\" milik LINE sendiri.';

  @override
  String get helpImportTitle => 'Mengimpor obrolan';

  @override
  String get helpImportBody =>
      '1. Di LINE, buka obrolan, ketuk menu (≡) → \"Kirim riwayat obrolan\" → \"Kirim sebagai teks\"\n2. Pilih \"Talk Saver\" dari lembar berbagi untuk mengimpornya secara otomatis\n3. Jika tidak muncul, simpan sebagai file .txt terlebih dahulu, lalu gunakan \"Impor obrolan\" → \"Pilih file\" di aplikasi ini\n\nAnda juga bisa langsung membuka LINE menggunakan tombol \"Buka LINE\" di layar impor.';

  @override
  String get helpChatListTitle => 'Mengelola daftar obrolan';

  @override
  String get helpChatListBody =>
      '• Ketuk ikon di sebelah kiri obrolan untuk menggantinya dengan ikon pilihan Anda\n• Ketuk ikon pensil untuk mengganti nama obrolan\n• Gunakan tombol + di kanan atas untuk membuat ruang baru khusus foto, video, dan file\n• Ketuk ikon gembok untuk mengunci satu obrolan secara individual (memerlukan pembelian)';

  @override
  String get helpChatDetailTitle => 'Menggunakan layar obrolan';

  @override
  String get helpChatDetailBody =>
      '• Tekan lama atau pilih beberapa pesan untuk menyalinnya\n• Saring berdasarkan pengirim, rentang tanggal, atau kata kunci\n• Ekspor ke Excel, PDF, atau Word dari ikon di kanan atas\n• Gunakan ikon galeri untuk melihat semua foto yang dilampirkan pada obrolan itu';

  @override
  String get helpAttachTitle => 'Melampirkan foto, video, dan file';

  @override
  String get helpAttachBody =>
      'Ketuk placeholder [Foto] atau [Stiker] untuk melampirkan foto atau video dari perangkat Anda. Ekspor LINE tidak menyertakan gambar aslinya, jadi tidak bisa dipulihkan secara otomatis.';

  @override
  String get helpLockTitle => 'Tentang penguncian';

  @override
  String get helpLockBody =>
      'Di Pengaturan, Anda bisa mewajibkan autentikasi biometrik, PIN perangkat, atau PIN dalam aplikasi untuk membuka aplikasi. Jika Anda mengatur PIN dalam aplikasi, PIN ini akan diutamakan dibandingkan autentikasi biometrik perangkat.\n\nMengunci obrolan individual termasuk dalam pembelian yang sama dengan menghapus iklan.';

  @override
  String get helpBackupTitle => 'Cadangan dan pemulihan';

  @override
  String get helpBackupBody =>
      'Gunakan \"Buat cadangan\" di Pengaturan untuk menyimpan semua obrolan dan lampiran yang diimpor ke dalam satu file. Gunakan \"Pulihkan dari cadangan\" untuk membawa data yang sama ke perangkat baru. Cara ini juga berfungsi saat berpindah antara iPhone dan Android.';

  @override
  String get helpPrivacyTitle => 'Tentang data Anda';

  @override
  String get helpPrivacyBody =>
      'Semua yang Anda impor atau lampirkan hanya disimpan di perangkat ini. Tidak ada yang pernah dikirim ke server.';

  @override
  String get feedbackMenuTitle => 'Masukan & laporan bug';

  @override
  String get feedbackMenuSubtitle =>
      'Kirimkan hal apa pun yang Anda temukan lewat email';

  @override
  String get feedbackEmailSubject => '[Talk Saver] Masukan';

  @override
  String get feedbackEmailBody =>
      'Silakan tulis masukan, permintaan, atau bug Anda di bawah ini.\n(Untuk bug, sertakan langkah saat terjadi dan model perangkat Anda.)\n\n';

  @override
  String get feedbackLaunchFailedMessage =>
      'Tidak dapat membuka aplikasi email. Hubungi talk-hozon-testers@googlegroups.com.';

  @override
  String get appVersionTitle => 'Versi aplikasi';
}
