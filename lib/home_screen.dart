// ignore_for_file: prefer_final_fields, prefer_const_constructors, deprecated_member_use, avoid_unnecessary_containers, avoid_print

import 'package:ads_example/native_add_example.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late BannerAd _bannerAd;
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdLoaded = false;
  bool _isAdLoaded = false;

  @override
  void initState() {
    _initBannerAds();
    _initInterstitialAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ad Example'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          _isAdLoaded
              ? Container(
                  height: _bannerAd.size.height.toDouble(),
                  width: _bannerAd.size.width.toDouble(),
                  color: Colors.blue,
                  child: AdWidget(ad: _bannerAd),
                )
              : Container(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
          SizedBox(height: 150),
          ElevatedButton(
              onPressed: () {
                print('Is interstitail add loaded = $_isInterstitialAdLoaded');
                if (_isInterstitialAdLoaded) {
                  print('showing interstitail add');
                  _interstitialAd.show();
                }
              },
              child: Text('Navigate to Native Ads'
                  ''))
        ],
      ),
    );
  }

  void _initInterstitialAd() {
    print('Initializing interstitial add');
    InterstitialAd.load(
        adUnitId: InterstitialAd.testAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: onInterstitialAdLoaded,
          onAdFailedToLoad: (error) {},
        ));
  }

  void onInterstitialAdLoaded(InterstitialAd ad) {
    _interstitialAd = ad;
    _isInterstitialAdLoaded = true;
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
      _initInterstitialAd();
       Navigator.of(context).push(MaterialPageRoute(builder: (context) => NativeAddScreen()));
    });
  }

  _initBannerAds() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: BannerAd.testAdUnitId,
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          print('This is error $error');
        }),
        request: AdRequest());
    _bannerAd.load();
  }
}
