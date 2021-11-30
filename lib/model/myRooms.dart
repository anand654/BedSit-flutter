import 'package:bachelor_room/model/room_info.dart';
import 'package:flutter/material.dart';

class MyRoom {
  String docId;
  RoomInfo roomInfo;

  MyRoom({
    @required this.docId,
    @required this.roomInfo,
  });

  factory MyRoom.fromJson(Map<String, dynamic> room, String doc) {
    return MyRoom(
      docId: doc,
      roomInfo: RoomInfo.fromJson(room),
    );
  }
}
