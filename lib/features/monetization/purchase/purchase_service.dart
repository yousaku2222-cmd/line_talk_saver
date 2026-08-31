import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

/// The Google Play Console / App Store Connect product IDs for this app's
/// one-time (non-consumable) unlocks. Each ID must be created as a real
/// in-app product in the store console before purchases will work -- it
/// does not exist anywhere until the developer creates it there.
class ProductIds {
  ProductIds._();

  /// "広告を非表示にする" unlock.
  static const removeAds = 'remove_ads';

  /// "バックアップ機能" unlock -- gates creating and restoring backups.
  static const backupUnlock = 'backup_unlock';

  /// Every product this app knows how to grant. The purchase stream is
  /// filtered against this so an unknown product ID is never acted on.
  static const all = {removeAds, backupUnlock};
}

/// Wraps `in_app_purchase` for the non-consumable unlocks this app sells
/// (see [ProductIds]).
class PurchaseService {
  PurchaseService({required this.onPurchased});

  /// Called with the product ID whenever a purchase or restore delivers one
  /// of [ProductIds.all].
  final void Function(String productId) onPurchased;

  final _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  Future<bool> start() async {
    final available = await _iap.isAvailable();
    if (!available) return false;
    _subscription =
        _iap.purchaseStream.listen(_onPurchaseUpdate, onError: (_) {});
    return true;
  }

  void dispose() {
    _subscription?.cancel();
  }

  Future<ProductDetails?> fetchProduct(String id) async {
    final response = await _iap.queryProductDetails({id});
    if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
      return null;
    }
    return response.productDetails.first;
  }

  Future<void> buyNonConsumable(ProductDetails product) {
    return _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
  }

  Future<void> restorePurchases() => _iap.restorePurchases();

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        if (ProductIds.all.contains(purchase.productID)) {
          onPurchased(purchase.productID);
        }
      }
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }
}
