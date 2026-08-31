import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import 'purchase_service.dart';

/// Starts a one-time non-consumable purchase flow. Shared between the
/// settings screen (where the purchases are offered directly) and any
/// paywall prompt for a gated feature -- the matching provider update
/// (`adsRemovedProvider` / `backupUnlockedProvider`) arrives later,
/// asynchronously, via the app-wide PurchaseListener's own subscription,
/// not from here.
Future<void> _purchase(
  BuildContext context,
  WidgetRef ref,
  String productId,
) async {
  final l10n = AppLocalizations.of(context)!;
  final service = PurchaseService(onPurchased: (_) {});
  final available = await service.start();
  if (!available) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.purchaseUnavailableMessage)));
    }
    service.dispose();
    return;
  }

  final product = await service.fetchProduct(productId);
  if (product == null) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.purchaseFetchFailedMessage)));
    }
    service.dispose();
    return;
  }

  await service.buyNonConsumable(product);
  service.dispose();
}

/// Starts the one-time "広告を非表示にする" purchase flow.
Future<void> purchaseRemoveAds(BuildContext context, WidgetRef ref) =>
    _purchase(context, ref, ProductIds.removeAds);

/// Starts the one-time "バックアップ機能" purchase flow.
Future<void> purchaseBackupUnlock(BuildContext context, WidgetRef ref) =>
    _purchase(context, ref, ProductIds.backupUnlock);
