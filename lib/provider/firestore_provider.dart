import 'dart:io';

import 'package:bachelor_room/model/myRooms.dart';
import 'package:bachelor_room/model/room_info.dart';
import 'package:bachelor_room/provider/application_provider.dart';
import 'package:bachelor_room/provider/auth_provider.dart';
import 'package:bachelor_room/services/cloud_services.dart';
import 'package:bachelor_room/services/firestore_services.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:bachelor_room/utils/String_utils.dart';

class FirestoreProvider extends GetxController {
  final FirestoreServ _firestoreServ = FirestoreServ();

  final _appProvider = Get.find<AppProvider>();

  ///prperties when searched
  List<DocumentSnapshot> _userSnapshot = <DocumentSnapshot>[];

  List<RoomInfo> _properties = [];
  List<RoomInfo> get properties => _properties;
  set addProperties(List<RoomInfo> value) {
    //here i no long need to add a dummy item to replace with adwidget in
    //listview.builder , instead i used listview.seperator.
    _properties = List.from(_properties)..addAll(value);
    favoritesSet = value.length;
    update();
  }

  //favorites
  List<bool> _favorites = [];
  List<bool> get favorites => _favorites;
  set favoritesSet(int length) {
    List<bool> _list = List.generate(length, (index) => false);
    _favorites = List.from(_favorites)..addAll(_list);
  }

  toggleFavorite(int index) {
    _favorites[index] = !_favorites[index];
    update();
  }

  set clearProperties(List<RoomInfo> value) {
    clearFavorites = [];
    _properties = value;
  }

  set clearFavorites(List<bool> value) {
    _favorites = value;
  }

  ///this function is to add favorite options to rooms
  List<bool> _isFavorite = [];
  List<bool> get isFavorite => _isFavorite;

  ///collection when used to search and adding the property
  String _collection;
  String get collection => _collection;
  set collectionSet(String value) {
    _collection = value;
  }

  ///locality
  String _locality;
  String get locality => _locality;
  set localitySet(String value) {
    _locality = value;
  }

  ///address
  String _address;
  String get address => _address;
  set addressSet(String value) {
    _address = value;
  }

  ///search by
  ///here i think idont need search by i can directly pass the search by to
  ///both searchbylocation and searchbyname but because of Homeowner/realtor i need to change
  ///it to owners because the collection name is owners.
  ///
  ///search by and collection
  /// iam using search by when property searchin and collecion when property posting.
  String _searchBy = 'Owners';
  String get searchBy => _searchBy;
  set searchBySet(String value) {
    if (value == 'Homeowner/Realtor') {
      _searchBy = 'Owners';
    } else if (value == 'Individual') {
      _searchBy = 'Individual';
    } else {
      return;
    }
  }

  // bool get isBengaluru => _isBengaluru;

  //getter for My Profile
  ///iam
  String _iam;
  String get iam => _iam;
  set iamSet(String value) {
    _iam = value;
    collectionSet = 'Owners';
  }

  ///phone No
  String _phoneNo;
  String get phoneNo => _phoneNo;
  set phoneNoSet(String value) {
    _phoneNo = value;
  }

  ///image url
  String _propertyImgUrl;
  String get propertyImgUrl => _propertyImgUrl;
  set propertyImgUrlSet(String value) {
    _propertyImgUrl = value;
  }

  ///plus code
  String _plusCode;
  String get plusCode => _plusCode;
  set plusCodeSet(String value) {
    _plusCode = value;
  }

  ///rent
  String _rent;
  String get rent => _rent;
  set rentSet(String value) {
    _rent = value;
  }

  ///deposit
  String _deposit;
  String get deposit => _deposit;
  set depositSet(String value) {
    _deposit = value;
  }

  ///call from
  String _clFrom;
  String get clFrom => _clFrom;
  set clFromSet(String value) {
    _clFrom = value;
    update();
  }

  ///call to
  String _clTo;
  String get clTo => _clTo;
  set clToSet(String value) {
    _clTo = value;
    update();
  }

  ///bike park
  bool _bikePark = false;
  bool get bikePark => _bikePark;
  set bikeParkSet(bool value) {
    _bikePark = value;
    update();
  }

  ///search results
  String _searchResult = '';
  String get searchResult => _searchResult;
  set searchResultSet(String value) {
    _searchResult = value;
  }

  ///search results
  String _adrsResPost = '';
  String get adrsResPost => _adrsResPost;
  set adrsResPostSet(String value) {
    _adrsResPost = value;
  }

  ///here instead of disable button iam using isfntriggered
  bool _isFnTriggered = false;
  bool get isFnTriggered => _isFnTriggered;
  set isFnTriggeredSet(bool value) {
    _isFnTriggered = value;
  }

  ///owners post loading
  bool _loadingIndicator = false;
  bool get loadingIndicator => _loadingIndicator;
  set loadingIndicatorSet(bool value) {
    _loadingIndicator = value;
    update();
  }
////// actions like button disabling, loading indicator
  //////on pressed functions

  ///moving to image page.
  Future moveToImagePage(String code) async {
    if (code.isEmpty) {
      adrsResPostSet = 'address is empty';
      return;
    }
    if (isFnTriggered) return;
    isFnTriggeredSet = true;
    bool _internetConnection = await _isInternetConnected();
    if (_internetConnection) {
      loadingIndicatorSet = true;
      if (code.length > 4) {
        final String _editedCode = code.removeAllBlankspace.toUpperCase();
        final int _plusIndex = _editedCode.indexOf('+') + 3;
        final String _plusCodeEdit = _editedCode.substring(0, _plusIndex);
        if (_plusCodeEdit.isPlusCode1) {
          await _addressWhenPosting(_plusCodeEdit);
        } else if (_plusCodeEdit.isPlusCode2) {
          String _code = '$_plusCodeEdit Bengaluru';
          await _addressWhenPosting(_code);
        } else {
          adrsResPostSet = 'we could\'t rec ';
        }
      }
      loadingIndicatorSet = false;
    } else {
      Get.snackbar('No internet connection ',
          'Please check your internet connetion and try again.');
    }
    isFnTriggeredSet = false;
  }

  Future _addressWhenPosting(String code) async {
    List<Address> _addressPost;
    try {
      List<Address> _location =
          await Geocoder.local.findAddressesFromQuery(code);
      // double _lat = _location.first.latitude;
      // double _lng = _location.first.longitude;
      Coordinates _coordinates = _location.first.coordinates;
      _addressPost =
          await Geocoder.local.findAddressesFromCoordinates(_coordinates);
    } catch (e) {
      adrsResPostSet =
          'we could\'t recognise this address code, try changing the code ';
      return;
    }
    Address _adrsWhereSubLocl =
        _addressPost.firstWhere((adr) => adr.subLocality != '', orElse: null);
    if (_adrsWhereSubLocl != null) {
      String _bnglr = _adrsWhereSubLocl.locality;
      if (_bnglr == 'Bengaluru') {
        addressSet = _adrsWhereSubLocl.addressLine;
        plusCodeSet = code;
        localitySet = _adrsWhereSubLocl.subLocality;
        adrsResPostSet = null;
        return;
      } else {
        adrsResPostSet = 'address is not in Bengaluru';
        return;
      }
    } else {
      adrsResPostSet = 'we could\'t recognise this address code,';
      return;
    }
  }

  ///post property from image page
  ///image show
  File _showPickedImage;
  File get showPickedImage => _showPickedImage;
  set showPickedImageSet(File value) {
    _showPickedImage = value;
    update();
  }

  //image upload error
  String _imageError = '';
  String get imageError => _imageError;
  set imageErrorSet(String value) {
    _imageError = value;
    update();
  }

  //image upload error
  String _locationError;
  String get locationError => _locationError;
  set locationErroret(String value) {
    _locationError = value;
    update();
  }

  Future postProperty() async {
    if (isFnTriggered) return;
    isFnTriggeredSet = true;
    if (showPickedImage != null) {
      // i can delete internet connection checker here because i put this when user
      //coming to image page/ post page.
      bool _internetConnection = await _isInternetConnected();
      if (_internetConnection) {
        _loadingScreen('Posting Room...');
        String _downloadableUrl = await CloudStorageServ.instance
            .uploadImage(showPickedImage, 'owners');
        if (_downloadableUrl != null) {
          imageErrorSet = null;
          propertyImgUrlSet = _downloadableUrl;
          bool _roomSaved = await _saveProperty();
          if (_roomSaved) {
            Get.offAndToNamed('/homePage');
          } else {
            Get.back();
            imageErrorSet =
                'could\'nt upload the property pls try again later.';
          }
        } else {
          imageErrorSet = 'could\'nt upload the property pls try again';
          Get.back();
        }
      } else {
        Get.snackbar('No internet connection ',
            'Please check your internet connetion and try again.');
      }
    } else {
      imageErrorSet = 'please select an Image to upload';
    }
    isFnTriggeredSet = false;
  }

  ///quick post property
  String _addressFromLoc;
  String get addressFromLoc => _addressFromLoc;
  set addressFromLocSet(String value) {
    _addressFromLoc = value;
  }

  Future quickPostProperty(String phNo, Position pos) async {
    if (isFnTriggered) return;
    isFnTriggeredSet = true;
    if (pos != null) {
      if (phNo.length == 10 || phNo.length == 0) {
        phoneNoSet = phNo;
        await _adrsfrmMyLoc(pos);
        if (addressFromLoc == null) {
          if (showPickedImage != null) {
            _loadingScreen('Posting Room...');
            String _downloadableUrl = await CloudStorageServ.instance
                .uploadImage(showPickedImage, 'individual');
            if (_downloadableUrl != null) {
              imageErrorSet = null;
              propertyImgUrlSet = _downloadableUrl;
              bool _roomSaved = await _saveProperty();
              if (_roomSaved) {
                Get.back();
                Get.offAndToNamed('/homePage');
              } else {
                Get.back();
                imageErrorSet =
                    'could\'nt upload the property pls try again later.';
              }
            } else {
              imageErrorSet = 'could\'nt upload the property pls try again';
              Get.back();
            }
          } else {
            imageErrorSet = 'please select an Image to upload';
          }
        } else {
          imageErrorSet = addressFromLoc;
        }
      }
    } else {
      imageErrorSet =
          'There might be a problem with selecting the image,\n please try again and select an image.';
    }
    isFnTriggeredSet = false;
  }

  //to get address from the location
  Future _adrsfrmMyLoc(Position position) async {
    var _addressSearch;
    double _lat = position.latitude;
    double _lng = position.longitude;
    Coordinates coordinates = Coordinates(_lat, _lng);
    bool _internetConnection = await _isInternetConnected();
    if (!_internetConnection) {
      Get.snackbar('No internet connection ',
          'Please check your internet connetion and try again.');
      addressFromLocSet = ' ';
      return;
    }
    try {
      _addressSearch =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
    } catch (e) {
      addressFromLocSet =
          'we could\'t recognise this location, please try again ';
      return;
    }
    if (_addressSearch != null) {
      String _bnglr = _addressSearch.first?.locality;
      if (_bnglr == 'Bengaluru') {
        //i thought i need this function only for when searching rooms .
        //but it also need when quick posting.
        addressSet = _addressSearch.first?.addressLine;
        iamSet = 'Individual';
        collectionSet = 'Individual';
        localitySet = _addressSearch.first.subLocality;
        plusCodeSet = '$_lat,$_lng';
        addressFromLocSet = null;
        return;
      }
      addressFromLocSet = 'Your location address is not in Bengaluru';
      return;
    }
    return;
  }

  Future<bool> _isInternetConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  void resetSavedData() {
    showPickedImageSet = null;
    propertyImgUrlSet = null;
    clFromSet = null;
    clToSet = null;
    iamSet = null;
    phoneNoSet = null;
    plusCodeSet = null;
    localitySet = null;
    addressSet = null;
    rentSet = null;
    depositSet = null;
    bikeParkSet = false;
  }

  /// all functions related when searching properties
  /// from here

  //homepage search by name of the location typed by the user
  Future searchPropertyByName(
    String adrs,
  ) async {
    if (isFnTriggered) return;
    isFnTriggeredSet = true;
    _loadingScreen('Searching Rooms..');
    // here i think i dont need address when searchin because if user is searching with autocomplete.
    //i dont need this function.
    //but what if they are not choosing the auto complete thats why localityFrmautocmplt it is true when
    //selected in auto complete and false when edited
    if (_appProvider.localityFrmAutoCmplt) {
      searchResultSet = null;
      localitySet = adrs;
      clearProperties = [];
      await _readProperties(false);
    } else {
      await _addressWhenSearching('$adrs Bengaluru');
      if (searchResult == null) {
        //search result == null means it successfully got the address with null error
        clearProperties = [];
        await _readProperties(false);
      }
    }
    Get.back();
    isFnTriggeredSet = false;
  }

  //home page search by location
  Future searchPropertyByLocation() async {
    if (isFnTriggered) return;
    isFnTriggeredSet = true;
    _loadingScreen('Searching Rooms..');
    Position position = await determinePosition();
    if (position != null) {
      await _findLocality(position);
      if (searchResult == null) {
        clearProperties = [];
        await _readProperties(false);
      }
    }
    Get.back();
    isFnTriggeredSet = false;
  }

  Future fetchMoreProperties() async {
    if (isFnTriggered) return;
    isFnTriggeredSet = true;
    await _readProperties(true);
    isFnTriggeredSet = false;
  }

  Future _loadingScreen(String loading) {
    return Get.dialog(
      Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: MColors.redButtonColor,
            ),
            Text(
              loading,
              style: MTextStyle.loadingText,
            )
          ],
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black12.withOpacity(0.6),
    );
  }

  Future _addressWhenSearching(String adrs) async {
    List<Placemark> _addressSearch;
    if (adrs == ' Bengaluru') {
      searchResultSet = 'please enter address to search';
      return;
    }
    try {
      List<Location> _addressLoc = await locationFromAddress(adrs);
      double _lat = _addressLoc.first.latitude;
      double _lng = _addressLoc.first.longitude;
      _addressSearch = await placemarkFromCoordinates(_lat, _lng);
    } catch (e) {
      searchResultSet =
          'we could\'t recognise this location, try changing the address, or search by your location. ';
      return;
    }
    if (_addressSearch != null) {
      String _bnglr = _addressSearch.first?.locality;
      if (_bnglr == 'Bengaluru') {
        localitySet = _addressSearch.first.subLocality;
        searchResultSet = null;
        return;
      }
      searchResultSet = 'please enter address in bengaluru';
      return;
    }
    return;
  }

  Future _findLocality(Position position) async {
    var _addressSearch;
    try {
      _addressSearch =
          await placemarkFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      searchResultSet =
          'we could\'t recognise this location, please try again ';
      return;
    }
    if (_addressSearch != null) {
      String _bnglr = _addressSearch.first?.locality;
      if (_bnglr == 'Bengaluru') {
        _locality = _addressSearch.first.subLocality;
        searchResultSet = null;
        return;
      }
      searchResultSet = 'Your location address is not in Bengaluru';
      return;
    }
  }

  //get location
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    bool _internetConnection = await _isInternetConnected();
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location services are disabled.', '');
      return null;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Location permissions are denied', '');
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
          'Location permissions are permanently denied, we cannot request permissions.',
          '');
      return null;
    }
    if (!_internetConnection) {
      Get.snackbar('No internet connection ',
          'Please check your internet connetion and try again.');
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }

  /// to here
  /// all functions related when searching properties

  //CRUD FIRESTORE

  Future<bool> _saveProperty() async {
    String _userId = await AuthProvider().getCurrentUID;
    DateTime _timeOfPost = DateTime.now();
    RoomInfo _roomInfo = RoomInfo(
      userId: _userId,
      timeOfPost: _timeOfPost,
      iam: iam,
      phoneNo: phoneNo,
      propertyImgUrl: propertyImgUrl,
      plusCode: plusCode,
      locality: locality,
      address: address,
      rent: rent,
      deposit: deposit,
      clFrom: clFrom,
      clTo: clTo,
      bikePark: bikePark,
    );
    bool _isRoomSaved = await _firestoreServ.addRoom(_roomInfo, collection);
    return _isRoomSaved;
  }

// this is to stop adding the properties in home page
// because every time the page is rebuild the properties is adding not when user actually ads
//i dont know why i added this lines , may be when the property info list is added in the showroom.dart
// then it was adding the properties when rebuild.

  ///read rooms
  int _documentLimit = 10;
  bool _hasNext = true;
  bool get hasNext => _hasNext;
  set hasNextSet(bool value) {
    _hasNext = value;
  }

  Future _readProperties(bool pagination) async {
    if (!pagination) hasNextSet = true;
    //has next is taken care
    //loginc is if pagination is false means we are searching that means it has next
    //if documents are over has next is set to false,
    //then the has next is set to true only when pagination is false ie when we searched again
    //and not with scrolling the list view.
    if (!hasNext) return;
    final QuerySnapshot _querySnapshot = await _firestoreServ.getRoom(
        searchBy, locality, _documentLimit,
        startAfter: pagination ? _userSnapshot.last : null);
    _userSnapshot = _querySnapshot.docs;
    final List<RoomInfo> _gottenProperties = _querySnapshot.docs
        .map((doc) => RoomInfo.fromJson(doc.data()))
        .toList();
    if (_gottenProperties.length < _documentLimit) hasNextSet = false;
    if (_gottenProperties.isNotEmpty) {
      addProperties = _gottenProperties;
    }
  }

  //rooms in My Profile

  ///rooms that user added
  List<DocumentSnapshot> _myRoomuserSnapshot = <DocumentSnapshot>[];

  List<MyRoom> _myRooms = [];
  List<MyRoom> get myRooms => _myRooms;
  set addmyRooms(List<MyRoom> value) {
    _myRooms = List.from(_myRooms)..addAll(value);
    update();
  }

  bool _myRoomHasNext = true;
  bool get myRoomHasNext => _myRoomHasNext;
  set myRoomHasNextSet(bool value) {
    _myRoomHasNext = value;
  }

  set _dltMyRoom(int index) {
    _myRooms = List.from(_myRooms)..removeAt(index);
    update();
  }

  Future fetchMyRooms() async {
    if (isFnTriggered) return;
    isFnTriggeredSet = true;
    await _readMyRoom(false);
    isFnTriggeredSet = false;
  }

  Future fetchMoreMyRooms() async {
    if (isFnTriggered) return;
    isFnTriggeredSet = true;
    await _readMyRoom(true);
    isFnTriggeredSet = false;
  }

  _readMyRoom(bool pagination) async {
    String _userId = await AuthProvider().getCurrentUID;
    if (!_myRoomHasNext) return;
    final QuerySnapshot _querySnapshot = await _firestoreServ.getMyRooms(
        _userId, _documentLimit,
        startAfter: pagination ? _myRoomuserSnapshot.last : null);
    _myRoomuserSnapshot = _querySnapshot.docs;
    final List<MyRoom> _gottenRooms = _querySnapshot.docs
        .map((doc) => MyRoom.fromJson(doc.data(), '${doc.id}'))
        .toList();
    if (_gottenRooms.length < _documentLimit) myRoomHasNextSet = false;
    if (_gottenRooms.isNotEmpty) {
      addmyRooms = _gottenRooms;
    }
  }

  //delete room
  deleteMyRoom(int index, String docId, String url) async {
    if (isFnTriggered) return;
    isFnTriggeredSet = true;
    await CloudStorageServ.instance.deleteImage(url);
    await _firestoreServ.deleteRoom(docId);
    isFnTriggeredSet = false;
    _dltMyRoom = index;
  }
}
