// ignore_for_file: avoid_print, avoid_unnecessary_containers, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'ad_service/ad_services.dart';

class NativeAddScreen extends StatefulWidget {
  const NativeAddScreen({Key? key}) : super(key: key);

  @override
  _NativeAddScreenState createState() => _NativeAddScreenState();
}

class _NativeAddScreenState extends State<NativeAddScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('this is init state');
    scheduleMicrotask(() {
      loadAdds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AdMobHelper>(
        builder: (context, adVm, _) {
          return Scaffold(
              body: ListView.builder(
                  itemCount: adVm.tileDataWithAds.length,
                  itemBuilder: (context, index) {
                    // print('This is ad ${}');
                    if (adVm.tileDataWithAds[index] is String) {
                      return ListTile(
                        title: Text(adVm.tileDataWithAds[index].toString()),
                      );
                    } else {
                      final Container adContent = Container(
                        child: AdWidget(
                          ad: adVm.tileDataWithAds[index] as NativeAd,
                          key: UniqueKey(),
                        ),
                        height: 60,
                      );
                      return adVm.isAdLoaded
                          ? adContent
                          : Center(
                              child: CircularProgressIndicator(),
                            );
                    }
                  }));
        },
      ),
    );
  }

  void loadAdds() async {
    await Future.delayed(Duration(seconds: 4)).whenComplete(() async => {
          await Provider.of<AdMobHelper>(context, listen: false).loadNativeAdAndList(),
        });
    // await Future.delayed(Duration(seconds: 2));
  }
}
