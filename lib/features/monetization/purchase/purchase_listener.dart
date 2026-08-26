import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'purchase_prefs.dart';
import 'purchase_service.dart';

/// Wraps the whole app and subscribes to the in-app-purchase update stream
/// for the app's lifetime, per `in_app_purchase`'s own guidance to listen
/// "as soon as your app launches" so no purchase/restore update is missed.
class PurchaseListener extends ConsumerStatefulWidget {
  const PurchaseListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<PurchaseListener> createState() => _PurchaseListenerState();
}

class _PurchaseListenerState extends ConsumerState<PurchaseListener> {
  late final PurchaseService _service;

  @override
  void initState() {
    super.initState();
    _service = PurchaseService(onAdsRemoved: () => setAdsRemoved(ref, true));
    _service.start();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
