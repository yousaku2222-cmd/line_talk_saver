import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

/// The Google Play Console / App Store Connect product ID for the
/// one-time "広告を非表示にする" unlock. This ID must be created as a
/// real in-app product in the store console before purchases will work --
/// it does not exist anywhere until the developer creates it there.
class ProductIds {
  ProductIds._();

  static const removeAds = 'remove_ads';
}

/// Wraps `in_app_purchase` for the single "remove ads" non-consumable
/// product this app sells.
class PurchaseService {
  PurchaseService({required this.onAdsRemoved});

  /// Called whenever a purchase or restore delivers the remove-ads product.
  final void Function() onAdsRemoved;

  final _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  Future<bool> start() async {
    final available = await _iap.isAvailable();
    if (!available) return false;
    _subscription = _iap.purchaseStream.listen(_onPurchaseUpdate, onError: (_) {});
    return true;
  }

  void dispose() {
    _subscription?.cancel();
  }

  Future<ProductDetails?> fetchRemoveAdsProduct() async {
    final response = await _iap.queryProductDetails({ProductIds.removeAds});
    if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
      return null;
    }
    return response.productDetails.first;
  }

  Future<void> buyRemoveAds(ProductDetails product) {
    return _iap.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: product));
  }

  Future<void> restorePurchases() => _iap.restorePurchases();

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        if (purchase.productID == ProductIds.removeAds) {
          onAdsRemoved();
        }
      }
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }
}
