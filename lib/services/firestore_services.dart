import 'package:bachelor_room/model/room_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServ {
  FirebaseFirestore _db = FirebaseFirestore.instance;

//from home owners
  //create
  Future<bool> addRoom(RoomInfo propertyInfo, String collection) async {
    try {
      await _db.collection(collection).add(propertyInfo.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  //read
  Future<QuerySnapshot> getRoom(String collection, String locality, int limit,
      {DocumentSnapshot startAfter}) async {
    QuerySnapshot _querySnapshot;
    try {
      final _refRooms = _db
          .collection(collection)
          .where('locality', isEqualTo: locality)
          .limit(limit);
      if (startAfter == null) {
        _querySnapshot = await _refRooms.get();
      } else {
        _querySnapshot = await _refRooms.startAfterDocument(startAfter).get();
      }
    } catch (e) {}
    return _querySnapshot;
  }

  //read room List in My Profile
  Future<QuerySnapshot> getMyRooms(String userId, int limit,
      {DocumentSnapshot startAfter}) async {
    QuerySnapshot _querySnapshot;
    try {
      final _refRooms = _db
          .collection('Owners')
          .where('userId', isEqualTo: userId)
          .limit(limit);
      if (startAfter == null) {
        _querySnapshot = await _refRooms.get();
      } else {
        _querySnapshot = await _refRooms.startAfterDocument(startAfter).get();
      }
    } catch (e) {}
    return _querySnapshot;
  }

  //delete
  Future<void> deleteRoom(String docId) async {
    try {
      await _db.collection('Owners').doc(docId).delete();
    } catch (e) {}
  }
}
