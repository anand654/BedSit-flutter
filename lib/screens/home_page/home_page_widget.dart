import 'dart:async';
import 'package:bachelor_room/provider/application_provider.dart';
import 'package:bachelor_room/services/add_helper.dart';
import 'package:bachelor_room/widget/app_widgets.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:bachelor_room/provider/firestore_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchPlace = TextEditingController();

  String _searchBy = 'Homeowner/Realtor';
  String _errorText;
  Timer searchOnStoppedTyping;

  void _inputSearchPlaceFrmAC(String value) {
    //this function is to change the textfield value when tap on autocomplete address
    // i was doing this by sending the texteditingcontroller but it was giving an error.
    //now iam passing the instance of this function.
    _searchPlace.text = value;
  }

  @override
  void dispose() {
    super.dispose();
    _searchPlace.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _fsProvider = Get.find<FirestoreProvider>();
    final Size _size = MediaQuery.of(context).size;
    final _appProvider = Get.find<AppProvider>();
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: _size.width * 0.6,
              child: SearchBySelector(
                _searchBy,
                (newValue) {
                  setState(
                    () {
                      _searchBy = newValue;
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SearchField(
            _searchPlace,
            () async {
              _fsProvider.searchBySet = _searchBy;
              await _fsProvider.searchPropertyByLocation();
              if (_fsProvider.searchResult == null) {
                _appProvider.openSearchBarSet();
              }
              setState(
                () {
                  _errorText = _fsProvider.searchResult;
                },
              );
            },
            (newValue) {
              _appProvider.localityFrmAutoCmpltSet = false;
              const duration = Duration(milliseconds: 2000);
              _appProvider.placemarkLoadingSet = true;
              if (searchOnStoppedTyping != null) {
                setState(
                  () => searchOnStoppedTyping.cancel(),
                ); // clear timer
              }
              setState(
                () => searchOnStoppedTyping = new Timer(
                  duration,
                  () => _appProvider.getPlacemark(_searchPlace.text),
                ),
              );
            },
            _errorText,
          ),
          const SizedBox(
            height: 5,
          ),
          GetBuilder<AppProvider>(
            builder: (controller) {
              return controller.placeMarkLoading
                  ? SpinKitThreeBounce(
                      color: MColors.flatBtnColor,
                      size: 25,
                    )
                  : SizedBox();
            },
          ),
          PlacesSearchList(_inputSearchPlaceFrmAC),
          const SizedBox(
            height: 5,
          ),
          CElevatedBtn(
            'search',
            50,
            10,
            MTextStyle.whiteButtonText,
            MColors.redButtonColor,
            () async {
              _fsProvider.searchBySet = _searchBy;
              await _fsProvider.searchPropertyByName(_searchPlace.text);
              if (_fsProvider.searchResult == null) {
                // _appProvider.placemarksSet = [];
                _appProvider.openSearchBarSet();
              }
              setState(
                () {
                  _errorText = _fsProvider.searchResult;
                },
              );
            },
          ),
          Divider(
            thickness: 1,
            height: 10,
            color: const Color(0xFFD6D6D6),
            indent: 10,
            endIndent: 10,
          ),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final TextEditingController searchPlace;
  final VoidCallback locBtnPressed;
  final Function(String) onchanged;
  final String error;
  const SearchField(
    this.searchPlace,
    this.locBtnPressed,
    this.onchanged,
    this.error,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: TextField(
        controller: searchPlace,
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'search room',
          hintStyle: MTextStyle.hintText,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 13),
          suffixIcon: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(MConstants.descBorRad),
                  bottomRight: Radius.circular(MConstants.descBorRad),
                ),
                border: Border.all(
                  color: MColors.sideDrawerColor,
                ),
                color: MColors.sideDrawerColor),
            child: IconButton(
              iconSize: 22,
              color: MColors.whiteColor,
              icon: Icon(Icons.location_on_outlined),
              onPressed: locBtnPressed,
            ),
          ),
          errorText: error,
          errorMaxLines: 2,
          filled: true,
          fillColor: MColors.cardColor,
          enabledBorder: MInputDecoration.borderdec,
          focusedBorder: MInputDecoration.borderdec,
          errorBorder: MInputDecoration.borderdec,
          focusedErrorBorder: MInputDecoration.borderdec,
        ),
        onChanged: onchanged,
      ),
    );
  }
}

class SearchBySelector extends StatelessWidget {
  final String searchBy;
  final void Function(dynamic) onchanged;
  const SearchBySelector(this.searchBy, this.onchanged);

  @override
  Widget build(BuildContext context) {
    final List iamAList = ['Homeowner/Realtor', 'Individual'];
    return Container(
      height: 45,
      margin: const EdgeInsets.only(
        right: 15,
        top: 10,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(MConstants.descBorRad),
        ),
        color: MColors.cardColor,
      ),
      child: DropdownButton(
        underline: SizedBox.shrink(),
        isExpanded: true,
        value: searchBy,
        items: iamAList
            .map(
              (iam) => DropdownMenuItem(
                value: iam,
                child: Text(
                  iam,
                  style: MTextStyle.darkhintText,
                ),
              ),
            )
            .toList(),
        onChanged: onchanged,
      ),
    );
  }
}

Widget bengaluruButton() {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      height: 45,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(MConstants.descBorRad),
        ),
        color: MColors.cardColor,
      ),
      child: Center(
        child: Text(
          'Bengaluru',
          style: MTextStyle.darkhintText,
        ),
      ),
    ),
  );
}

class PlacesSearchList extends StatelessWidget {
  final Function changeTextfieldInput;
  const PlacesSearchList(this.changeTextfieldInput);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetBuilder<AppProvider>(
        builder: (controller) {
          List _places = controller.placemarks.reversed.toList();
          return Column(
            children: List.generate(
              _places.length,
              (index) {
                return _places[index].subLocality == ''
                    ? SizedBox()
                    : ListTile(
                        dense: true,
                        tileColor: Colors.white38,
                        title: Text(
                          '${_places[index].street},${_places[index].subLocality}',
                          style: MTextStyle.titleText,
                        ),
                        subtitle: Text(
                          '${_places[index].locality}',
                          style: MTextStyle.subtitleText,
                        ),
                        onTap: () {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          changeTextfieldInput(_places[index].subLocality);
                          controller.placemarksSet = [];
                          controller.localityFrmAutoCmpltSet = true;
                        },
                      );
              },
            ),
          );
        },
      ),
    );
  }
}

class NativeAdsShow extends StatefulWidget {
  @override
  _NativeAdsShowState createState() => _NativeAdsShowState();
}

class _NativeAdsShowState extends State<NativeAdsShow> {
  final _controller = NativeAdmobController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10.0),
      child: NativeAdmob(
        adUnitID: AdHelper.nativeAddUnitId,
        controller: _controller,
        numberAds: 2,
      ),
    );
  }
}
