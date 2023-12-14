import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdsUtils {
  static BannerAd? _bannerAd;

  static void initBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-8029832693124619/9287345114",
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    );
  }

  static void loadBannerAd() {
    _bannerAd?.load();
  }

  static void disposeBannerAd() {
    _bannerAd?.dispose();
  }

  static Widget buildBannerAd() {
    return SizedBox(
      height: _bannerAd?.size.height.toDouble(),
      width: _bannerAd?.size.width.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
