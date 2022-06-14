// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobHelper extends ChangeNotifier{
  static String get nativeUnit => 'ca-app-pub-1448876594370491~4335758265';
    bool isAdLoaded = false;
  late NativeAd nativeAd;
  List<String> listTileData = [];
  List<Object> tileDataWithAds = [];
  Container? adContent;

  static initialization() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

   NativeAd getNativeAd() {
    NativeAd nativeAd = NativeAd(
        factoryId: "listTile",
        adUnitId: NativeAd.testAdUnitId,
        request: const AdRequest(),
        listener: NativeAdListener(onAdLoaded: (_) {
          print('Hey i have loaded the Native ad');
          isAdLoaded = true;
          notifyListeners();
        }, onAdFailedToLoad: (ad, error) {
           ad.dispose();
          print('This is error while loading $error');
        }));
    nativeAd.load();
    return nativeAd;
  }


  Future laodNativeAdAndList() async {
       for (int i = 0; i <= 20; i++) {
      listTileData.add('List item $i');
    }
    tileDataWithAds = List.from(listTileData);
    for (int i = 1; i <= 5; i++) {
      var minimumNumber = 1;
      var randomNumber = Random();
      var randomNoForAd = minimumNumber + randomNumber.nextInt(20);
      tileDataWithAds.insert(randomNoForAd, getNativeAd()..load());
    }
    notifyListeners();
  }


}
