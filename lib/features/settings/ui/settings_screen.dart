import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../app_lock/app_lock_prefs.dart';
import '../../app_lock/app_lock_service.dart';
import '../../app_lock/app_pin_prefs.dart';
import '../../app_lock/authenticate.dart';
import '../../app_lock/ui/pin_entry_dialog.dart';
import '../../backup/backup_service.dart';
import '../../chat_list/providers/chat_list_provider.dart';
import '../../monetization/ads/banner_ad_widget.dart';
import '../../monetization/purchase/purchase_flow.dart';
import '../../monetization/purchase/purchase_prefs.dart';
import '../../monetization/purchase/purchase_service.dart';
import '../locale/locale_prefs.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _onToggleLock(BuildContext context, WidgetRef ref, bool value) async {
    final l10n = AppLocalizations.of(context)!;
    if (value) {
      final available = await canAuthenticate(ref);
      if (!available) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.appLockUnsupportedMessage)),
        );
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
    final service = PurchaseService(onAdsRemoved: () {});
    final available = await service.start();
    if (available) {
      await service.restorePurchases();
    }
    service.dispose();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.restoringPurchasesMessage)),
    );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.saveToDeviceSuccessMessage)),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.restoreBackupSuccessMessage)),
      );
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
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(l10n.languageSettingTitle),
            subtitle: Text(
              locale == null ? l10n.languageSystemDefault : _languageDisplayName(locale),
            ),
            onTap: () => _pickLanguage(context, ref),
          ),
          const Divider(height: 1),
          SwitchListTile(
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
          const Divider(height: 1),
          if (adsRemoved)
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(l10n.removeAdsTitle),
              subtitle: Text(l10n.removeAdsPurchasedSubtitle),
            )
          else ...[
            ListTile(
              leading: const Icon(Icons.block_outlined),
              title: Text(l10n.removeAdsTitle),
              subtitle: Text(l10n.removeAdsSubtitle),
              onTap: () => purchaseRemoveAds(context, ref),
            ),
            ListTile(
              leading: const Icon(Icons.restore_outlined),
              title: Text(l10n.restorePurchaseTitle),
              subtitle: Text(l10n.restorePurchaseSubtitle),
              onTap: () => _restorePurchases(context, ref),
            ),
          ],
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: Text(l10n.backupTitle),
            subtitle: Text(l10n.backupSubtitle),
            onTap: () => _createBackup(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.settings_backup_restore_outlined),
            title: Text(l10n.restoreBackupTitle),
            subtitle: Text(l10n.restoreBackupSubtitle),
            onTap: () => _restoreBackup(context, ref),
          ),
        ],
      ),
      bottomNavigationBar: const SafeArea(child: DismissibleBannerAd()),
    );
  }
}
