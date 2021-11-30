import 'package:bachelor_room/utils/utils.dart';

extension StringUtils on String {
  bool get isPlusCode1 => Utils.isPlusCode1(this);
  // i dont know may be this means the string that is extended.
  // tried changing this to String value but it is not taking idont know why

  bool get isPlusCode2 => Utils.isPlusCode2(this);

  String get removeAllBlankspace => Utils.removeAllBlankspace(this);
}
