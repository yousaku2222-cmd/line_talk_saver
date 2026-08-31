import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/ui/brand_logo.dart';
import '../../../core/ui/settings_group.dart';
import '../../../l10n/app_localizations.dart';
import '../../theming/theme_prefs.dart';
import '../../app_lock/app_lock_prefs.dart';
import '../../app_lock/app_lock_service.dart';
import '../../app_lock/app_pin_prefs.dart';
import '../../app_lock/authenticate.dart';
import '../../app_lock/ui/pin_entry_dialog.dart';
import '../../backup/backup_service.dart';
import '../../chat_list/providers/chat_list_provider.dart';
import '../../monetization/ads/banner_ad_widget.dart';
import '../../monetization/purchase/backup_unlock_prefs.dart';
import '../../monetization/purchase/purchase_flow.dart';
import '../../monetization/purchase/purchase_prefs.dart';
import '../../monetization/purchase/purchase_service.dart';
import '../locale/locale_prefs.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  /// Closed-test feedback goes to the tester Google Group.
  static const _feedbackEmail = 'talk-hozon-testers@googlegroups.com';

  Future<void> _sendFeedback(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final info = await PackageInfo.fromPlatform();
    final footer =
        '\n----------\n'
        'App: ${info.version} (build ${info.buildNumber})\n'
        'OS: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
    final uri = Uri.parse(
      'mailto:$_feedbackEmail'
      '?subject=${Uri.encodeComponent(l10n.feedbackEmailSubject)}'
      '&body=${Uri.encodeComponent(l10n.feedbackEmailBody + footer)}',
    );
    final launched = await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.feedbackLaunchFailedMessage)));
    }
  }

  Future<void> _onToggleLock(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    if (value) {
      final available = await canAuthenticate(ref);
      if (!available) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.appLockUnsupportedMessage)));
        return;
      }
      // Confirm the device credential (or app PIN) actually works before
      // turning the lock on, so the user can't accidentally lock themselves
      // out.
      if (!context.mounted) return;
      final ok = await requestAuthentication(
        context,
        ref,
        reason: l10n.appLockAuthReason,
      );
      if (!ok) return;
    }
    await setAppLockEnabled(ref, value);
  }

  Future<void> _setAppPin(BuildContext context, WidgetRef ref) async {
    final pin = await showSetPinDialog(context);
    if (pin == null) return;
    await setAppPin(ref, pin);
  }

  Future<void> _changeAppPin(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final verified = await requestAuthentication(
      context,
      ref,
      reason: l10n.appPinManageAuthReason,
    );
    if (!verified || !context.mounted) return;
    final pin = await showSetPinDialog(context);
    if (pin == null) return;
    await setAppPin(ref, pin);
  }

  Future<void> _removeAppPin(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final verified = await requestAuthentication(
      context,
      ref,
      reason: l10n.appPinManageAuthReason,
    );
    if (!verified || !context.mounted) return;

    // Removing the PIN falls back to the device's own auth for anything
    // still locked (app-wide lock, or individual chats). If this device
    // has no working auth of its own, that would leave them permanently
    // stuck locked, so warn first rather than let that happen silently.
    final deviceSupported = await AppLockService().isSupported();
    if (!deviceSupported) {
      final chats = ref.read(chatListProvider).valueOrNull ?? const [];
      final hasLockedChat = chats.any((c) => c.isLocked);
      final appLockOn = ref.read(appLockEnabledProvider);
      if (hasLockedChat || appLockOn) {
        if (!context.mounted) return;
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(l10n.removeAppPinWarningTitle),
            content: Text(l10n.removeAppPinWarningBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(l10n.delete),
              ),
            ],
          ),
        );
        if (confirmed != true) return;
      }
    }
    if (!context.mounted) return;
    await clearAppPin(ref);
  }

  Future<void> _restorePurchases(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final service = PurchaseService(onPurchased: (_) {});
    final available = await service.start();
    if (available) {
      await service.restorePurchases();
    }
    service.dispose();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.restoringPurchasesMessage)));
  }

  /// Backup create/restore are gated behind the one-time [ProductIds.backupUnlock]
  /// purchase. Tapping either row while locked lands here.
  Future<void> _promptBackupPurchase(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.backupPaywallTitle),
        content: Text(l10n.backupPaywallBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.purchaseButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await purchaseBackupUnlock(context, ref);
  }

  Future<void> _createBackup(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final file = await BackupService(ref).createBackup();
      final bytes = await file.readAsBytes();
      final fileName = file.path.split(RegExp(r'[\\/]')).last;
      if (!context.mounted) return;
      Navigator.of(context).pop();
      final savedUri = await FilePicker.saveFile(
        fileName: fileName,
        bytes: bytes,
        mimeType: 'application/zip',
      );
      if (savedUri == null) return;
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.saveToDeviceSuccessMessage)));
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.backupCreateFailedMessage(e))),
      );
    }
  }

  Future<void> _restoreBackup(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.restoreBackupConfirmTitle),
        content: Text(l10n.restoreBackupConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.restoreBackupTitle),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (picked.isEmpty) return;
    final bytes = await picked.single.readAsBytes();

    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await BackupService(ref).restoreBackup(bytes);
      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.restoreBackupSuccessMessage)));
    } on InvalidBackupFileException {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.restoreBackupInvalidFileMessage)),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.restoreBackupFailedMessage(e))),
      );
    }
  }

  Future<void> _pickLanguage(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final current = ref.read(localeProvider);
    final chosen = await showModalBottomSheet<Object>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: RadioGroup<Object>(
          groupValue: current ?? 'system',
          onChanged: (v) => Navigator.of(sheetContext).pop(v),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<Object>(
                title: Text(l10n.languageSystemDefault),
                value: 'system',
              ),
              for (final locale in supportedAppLocales)
                RadioListTile<Object>(
                  title: Text(_languageDisplayName(locale)),
                  value: locale,
                ),
            ],
          ),
        ),
      ),
    );
    if (chosen == null) return;
    await setAppLocale(ref, chosen == 'system' ? null : chosen as Locale);
  }

  String _languageDisplayName(Locale locale) {
    // Each language's own name for itself, so it's recognizable even to a
    // user who can't currently read the app's active language.
    if (locale.scriptCode == 'Hant') return '繁體中文';
    switch (locale.languageCode) {
      case 'ja':
        return '日本語';
      case 'en':
        return 'English';
      case 'th':
        return 'ไทย';
      case 'id':
        return 'Bahasa Indonesia';
      case 'ko':
        return '한국어';
      default:
        return locale.languageCode;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lockEnabled = ref.watch(appLockEnabledProvider);
    final pinSet = ref.watch(appPinSetProvider);
    final adsRemoved = ref.watch(adsRemovedProvider);
    final backupUnlocked = ref.watch(backupUnlockedProvider);
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.x3,
          AppSpacing.screen,
          AppSpacing.x6,
        ),
        children: [
          SettingsGroup(
            children: [
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text('着せ替え'),
                subtitle: Text(ref.watch(themeIdProvider).label),
                onTap: () => Navigator.of(context).pushNamed('/theme'),
              ),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(l10n.languageSettingTitle),
                subtitle: Text(
                  locale == null
                      ? l10n.languageSystemDefault
                      : _languageDisplayName(locale),
                ),
                onTap: () => _pickLanguage(context, ref),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          SettingsGroup(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.lock_outline),
                title: Text(l10n.appLockToggleTitle),
                subtitle: Text(l10n.appLockToggleSubtitle),
                value: lockEnabled,
                onChanged: (value) => _onToggleLock(context, ref, value),
              ),
              ListTile(
                leading: const Icon(Icons.pin_outlined),
                title: Text(l10n.appPinSectionTitle),
                subtitle: Text(
                  pinSet ? l10n.appPinSetSubtitle : l10n.appPinNotSetSubtitle,
                ),
                trailing: pinSet
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () => _changeAppPin(context, ref),
                            child: Text(l10n.changeAppPinButton),
                          ),
                          TextButton(
                            onPressed: () => _removeAppPin(context, ref),
                            child: Text(l10n.delete),
                          ),
                        ],
                      )
                    : TextButton(
                        onPressed: () => _setAppPin(context, ref),
                        child: Text(l10n.setAppPinButton),
                      ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          SettingsGroup(
            children: [
              if (adsRemoved)
                ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: Text(l10n.removeAdsTitle),
                  subtitle: Text(l10n.removeAdsPurchasedSubtitle),
                )
              else
                ListTile(
                  leading: const Icon(Icons.block_outlined),
                  title: Text(l10n.removeAdsTitle),
                  subtitle: Text(l10n.removeAdsSubtitle),
                  onTap: () => purchaseRemoveAds(context, ref),
                ),
              if (backupUnlocked)
                ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: Text(l10n.backupUnlockTitle),
                  subtitle: Text(l10n.removeAdsPurchasedSubtitle),
                )
              else
                ListTile(
                  leading: const Icon(Icons.cloud_download_outlined),
                  title: Text(l10n.backupUnlockTitle),
                  subtitle: Text(l10n.backupUnlockSubtitle),
                  onTap: () => purchaseBackupUnlock(context, ref),
                ),
              ListTile(
                leading: const Icon(Icons.restore_outlined),
                title: Text(l10n.restorePurchaseTitle),
                subtitle: Text(l10n.restorePurchaseSubtitle),
                onTap: () => _restorePurchases(context, ref),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          SettingsGroup(
            children: [
              ListTile(
                leading: const Icon(Icons.backup_outlined),
                title: Text(l10n.backupTitle),
                subtitle: Text(l10n.backupSubtitle),
                trailing: backupUnlocked
                    ? null
                    : const Icon(Icons.lock_outline, size: 18),
                onTap: () => backupUnlocked
                    ? _createBackup(context, ref)
                    : _promptBackupPurchase(context, ref),
              ),
              ListTile(
                leading: const Icon(Icons.settings_backup_restore_outlined),
                title: Text(l10n.restoreBackupTitle),
                subtitle: Text(l10n.restoreBackupSubtitle),
                trailing: backupUnlocked
                    ? null
                    : const Icon(Icons.lock_outline, size: 18),
                onTap: () => backupUnlocked
                    ? _restoreBackup(context, ref)
                    : _promptBackupPurchase(context, ref),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          SettingsGroup(
            children: [
              ListTile(
                leading: const Icon(Icons.menu_book_outlined),
                title: Text(l10n.helpMenuTitle),
                subtitle: Text(l10n.helpMenuSubtitle),
                onTap: () => Navigator.of(context).pushNamed('/help'),
              ),
              ListTile(
                leading: const Icon(Icons.feedback_outlined),
                title: Text(l10n.feedbackMenuTitle),
                subtitle: Text(l10n.feedbackMenuSubtitle),
                onTap: () => _sendFeedback(context, ref),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          const _SettingsFooter(),
        ],
      ),
      bottomNavigationBar: const SafeArea(child: DismissibleBannerAd()),
    );
  }
}

class _SettingsFooter extends StatelessWidget {
  const _SettingsFooter();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        const BrandLogo(),
        const SizedBox(height: AppSpacing.x1),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            final info = snapshot.data;
            return Text(
              info == null
                  ? ''
                  : '${l10n.appVersionTitle}  ${info.version} (${info.buildNumber})',
              style: Theme.of(context).textTheme.labelSmall,
            );
          },
        ),
      ],
    );
  }
}
