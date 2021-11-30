import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  //it is a private constructor or its a singleton
  MapUtils._();

  static Future<void> openMap(String plusCode) async {
    String _googleUrl;
    //pluscode = 7J4VXH94+FV
    //in url %2b is equal to +
    if (plusCode.contains('+')) {
      String _plusCode = plusCode.replaceFirst('+', '%2b');
      _googleUrl = 'https://www.google.com/maps/search/?api=1&query=$_plusCode';
    } else {
      _googleUrl = 'https://www.google.com/maps/search/?api=1&query=$plusCode';
    }

    // String googleUrl = "https://www.google.com/maps/dir/?api=1&origin=" +
    //     _myLoc +
    //     "&destination=" +
    //     _plusCode +
    //     "&travelmode=driving&dir_action=navigate";
    if (await canLaunch(_googleUrl)) {
      await launch(_googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
