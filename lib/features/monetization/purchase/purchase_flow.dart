import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import 'purchase_service.dart';

/// Starts the one-time "広告を非表示にする" purchase flow. Shared between
/// the settings screen (where the purchase is offered directly) and any
/// paywall prompt for a feature bundled with it (e.g. per-chat lock) --
/// the actual `adsRemovedProvider` update arrives later, asynchronously,
/// via the app-wide PurchaseListener's own subscription, not from here.
Future<void> purchaseRemoveAds(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context)!;
  final service = PurchaseService(onAdsRemoved: () {});
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

  final product = await service.fetchRemoveAdsProduct();
  if (product == null) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.purchaseFetchFailedMessage)));
    }
    service.dispose();
    return;
  }

  await service.buyRemoveAds(product);
  service.dispose();
}
