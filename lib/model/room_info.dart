import 'package:flutter/material.dart';

class RoomInfo {
  String userId;
  DateTime timeOfPost;
  String iam;
  String phoneNo;
  String propertyImgUrl;
  String plusCode;
  String address;
  String locality;
  String rent;
  String deposit;
  String clFrom;
  String clTo;
  bool bikePark;

  RoomInfo({
    @required this.userId,
    @required this.timeOfPost,
    @required this.iam,
    @required this.phoneNo,
    @required this.propertyImgUrl,
    @required this.plusCode,
    @required this.locality,
    this.address,
    this.rent = '0',
    this.deposit = '0',
    this.clFrom,
    this.clTo,
    this.bikePark,
  });

  factory RoomInfo.fromJson(Map<String, dynamic> data) {
    return RoomInfo(
      userId: data['userId'],
      timeOfPost: data['timeOfPost'].toDate(),
      iam: data['iam'],
      // preferedT: data['prefered'],
      phoneNo: data['phoneNo'],
      propertyImgUrl: data['imgUrl'],
      plusCode: data['plusCode'],
      locality: data['locality'],
      address: data['address'],
      rent: data['rent'],
      deposit: data['deposit'],
      clFrom: data['clFrom'],
      clTo: data['clTo'],
      bikePark: data['bikePark'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'timeOfPost': timeOfPost,
      'iam': iam,
      // 'preferedT': preferedT,
      'phoneNo': phoneNo,
      'imgUrl': propertyImgUrl,
      'plusCode': plusCode,
      'address': address,
      'locality': locality,
      'rent': rent,
      'deposit': deposit,
      'clFrom': clFrom,
      'clTo': clTo,
      'bikePark': bikePark,
    };
  }
}
