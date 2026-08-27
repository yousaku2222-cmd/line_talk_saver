import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../purchase/purchase_prefs.dart';
import 'ad_unit_ids.dart';

/// A banner ad, shown only when the user hasn't purchased "広告を非表示".
/// Renders nothing (zero height) while loading, on failure, or once ads
/// are removed, so it never leaves a visible gap.
class DismissibleBannerAd extends ConsumerStatefulWidget {
  const DismissibleBannerAd({super.key});

  @override
  ConsumerState<DismissibleBannerAd> createState() => _DismissibleBannerAdState();
}

class _DismissibleBannerAdState extends ConsumerState<DismissibleBannerAd> {
  BannerAd? _bannerAd;
  bool _loadRequested = false;

  void _load() {
    if (_loadRequested) return;
    _loadRequested = true;
    final ad = BannerAd(
      adUnitId: AdUnitIds.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() => _bannerAd = ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );
    ad.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adsRemoved = ref.watch(adsRemovedProvider);
    if (adsRemoved) return const SizedBox.shrink();

    _load();

    final ad = _bannerAd;
    if (ad == null) return const SizedBox.shrink();
    return SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
