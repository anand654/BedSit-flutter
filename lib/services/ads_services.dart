import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdsShow extends StatefulWidget {
  final String adUnitId;
  BannerAdsShow({@required this.adUnitId});
  @override
  _BannerAdsShowState createState() => _BannerAdsShowState();
}

class _BannerAdsShowState extends State<BannerAdsShow> {
  BannerAd _ad;
  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      adUnitId: this.widget.adUnitId,
      size: AdSize.fullBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {},
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
        },
      ),
    );
    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AdWidget(ad: _ad),
      width: _ad.size.width.toDouble(),
      height: 72.0,
      alignment: Alignment.center,
    );
  }
}
