class Utils {
  Utils._();

  static bool hasMatch(String value, String pattern) {
    return (value == null)
        ? false
        : RegExp(pattern, caseSensitive: false).hasMatch(value);
    // : RegExp(pattern, caseSensitive: false).allMatches(value);
    // : RegExp(pattern, caseSensitive: false).firstMatch(value);
    // : RegExp(pattern, caseSensitive: false).stringMatch(value);
    // : RegExp(pattern, caseSensitive: false).matchAsPrefix(value);
  }

  static bool isPlusCode1(String value) => hasMatch(
      value, r'^[23456789CFGHJMPQRVWX]{8}[\+][23456789CFGHJMPQRVWX]{2}$');

  static bool isPlusCode2(String value) => hasMatch(
      value, r'^[23456789CFGHJMPQRVWX]{4}[\+][23456789CFGHJMPQRVWX]{2}$');

  static String removeAllBlankspace(String value) {
    return value.replaceAll(' ', '');
  }
}
