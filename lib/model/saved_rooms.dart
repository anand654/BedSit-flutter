import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'saved_rooms.g.dart';

@HiveType(typeId: 0)
class SavedRooms extends HiveObject {
  @HiveField(0)
  DateTime timeOfPost;
  @HiveField(1)
  String iam;
  @HiveField(2)
  String phoneNo;
  @HiveField(3)
  String propertyImgUrl;
  @HiveField(4)
  String plusCode;
  @HiveField(5)
  String address;
  @HiveField(6)
  String rent;
  @HiveField(7)
  String deposit;
  @HiveField(8)
  String clFrom;
  @HiveField(9)
  String clTo;
  @HiveField(10)
  bool bikePark;

  SavedRooms({
    @required this.timeOfPost,
    @required this.iam,
    // @required this.preferedT,
    @required this.phoneNo,
    @required this.propertyImgUrl,
    @required this.plusCode,
    this.address,
    this.rent,
    this.deposit,
    this.clFrom,
    this.clTo,
    this.bikePark,
  });
}
