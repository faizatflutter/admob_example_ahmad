// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class QuizView extends StatelessWidget {
  QuizView({Key? key}) : super(key: key) {
    _initAd();
  }

  late InterstitialAd _interstitialAd;
  bool _isAdLoaded = false;

  void _initAd() {
    print('Initializing add');
    InterstitialAd.load(
        adUnitId: InterstitialAd.testAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: onAdLoaded,
          onAdFailedToLoad: (error) {},
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  if (_isAdLoaded) {
                    _interstitialAd.show();
                  }
                },
                child: Text('Submit Quiz'))
          ],
        ),
      ),
    );
  }

  void onAdLoaded(InterstitialAd ad) {
    _interstitialAd = ad;
    _isAdLoaded = true;

    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _initAd();
      }
    );
  }
}
