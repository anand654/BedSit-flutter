import 'package:bachelor_room/model/room_info.dart';
import 'package:bachelor_room/model/saved_rooms.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AppProvider extends GetxController {
  bool _openSearchBar = false;
  bool get openSearchBar => _openSearchBar;
  openSearchBarSet() {
    _openSearchBar = !_openSearchBar;
    update();
  }

  ///address autocomplete
  ///placemarks

  bool _placeMarkLoading = false;
  bool get placeMarkLoading => _placeMarkLoading;
  set placemarkLoadingSet(bool value) {
    if (_placeMarkLoading != value) {
      _placeMarkLoading = value;
      update();
    }
  }

  List<Placemark> _placemarks = [];
  List<Placemark> get placemarks => _placemarks;
  set placemarksSet(List<Placemark> value) {
    _placemarks = value;
    update();
  }

  Future getPlacemark(String address) async {
    List<Location> _locations;
    if (isFnTriggered) return;
    isFnTriggeredSet = true;
    bool _internetConnection = await _isInternetConnected();
    if (address.length >= 4) {
      if (_internetConnection) {
        try {
          _locations = await locationFromAddress('$address Bengaluru');
          double _lat = _locations.first.latitude;
          double _lng = _locations.first.longitude;
          //most of the time it returns only on element in the list
          placemarksSet = await placemarkFromCoordinates(
            _lat,
            _lng,
          );
          //iam taking only first result
          //_locations.first   is equals to  _loctions[0]
        } catch (e) {
          placemarksSet = [];
        }
      } else {
        Get.snackbar('No internet connection ',
            'Please check your internet connetion and try again.');
      }
    } else {
      placemarksSet = [];
    }
    placemarkLoadingSet = false;
    isFnTriggeredSet = false;
  }

//it helps to not to execute _adrsfrmsearching because we already got the locality with autocomplete.
//but what id autocomplete is from other than bangalore pls check.
  bool _localityFrmAutoCmplt;
  bool get localityFrmAutoCmplt => _localityFrmAutoCmplt;
  set localityFrmAutoCmpltSet(bool value) {
    if (value != _localityFrmAutoCmplt) _localityFrmAutoCmplt = value;
  }

  Future<bool> _isInternetConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  bool _isFnTriggered = false;
  bool get isFnTriggered => _isFnTriggered;
  set isFnTriggeredSet(bool value) {
    _isFnTriggered = value;
  }

  /// Hive saved rooms
  static const String _roomBox = 'savedRoomsData';

  List<SavedRooms> _savedRooms = [];
  List<SavedRooms> get savedRoomsGet {
    return _savedRooms;
  }

  set _deleteSavedRooms(int index) {
    _savedRooms.removeAt(index);
    update();
  }

  Future<void> saveRooms(RoomInfo value) async {
    var box = await Hive.openBox<SavedRooms>(_roomBox);
    var _key = value.propertyImgUrl.split('token=');
    SavedRooms _room = SavedRooms(
      timeOfPost: value.timeOfPost,
      iam: value.iam,
      phoneNo: value.phoneNo,
      propertyImgUrl: value.propertyImgUrl,
      plusCode: value.plusCode,
      address: value.address,
      rent: value.rent,
      deposit: value.deposit,
      clFrom: value.clFrom,
      clTo: value.clTo,
      bikePark: value.bikePark,
    );
    await box.put(_key.last, _room);
    box.close();
  }

  Future<void> deleteSavedRooms(int index) async {
    var box = await Hive.openBox<SavedRooms>(_roomBox);
    await box.deleteAt(index);
    _deleteSavedRooms = index;
    box.close();
  }

  Future<void> getSavedRooms() async {
    var box = await Hive.openBox<SavedRooms>(_roomBox);
    _savedRooms = box.values.toList();
    box.close();
  }
}
