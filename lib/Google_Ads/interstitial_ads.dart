import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdsUtils {
  static InterstitialAd? _interstitialAd;

  static const int maxFailedLoadAttempts = 3;
  static int _interstitialLoadAttempts = 0;

  static void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: "ca-app-pub-8029832693124619/5156528417",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
            createInterstitialAd();
          }
        },
      ),
    );
  }

  static void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          createInterstitialAd();
        },
      );
      _interstitialAd!.show();
    }
  }

  static void disposeInterstitialAd() {
    _interstitialAd?.dispose();
  }
}
