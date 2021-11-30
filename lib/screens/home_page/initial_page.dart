import 'dart:async';

import 'package:bachelor_room/provider/application_provider.dart';
import 'package:bachelor_room/provider/auth_provider.dart';
import 'package:bachelor_room/provider/firestore_provider.dart';
import 'package:bachelor_room/screens/home_page/home_page_widget.dart';
import 'package:bachelor_room/screens/side_drawer/side_drawer.dart';
import 'package:bachelor_room/widget/app_widgets.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class InitialPage extends StatefulWidget {
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchPlace = TextEditingController();
  String _searchBy = 'Homeowner/Realtor';
  String _errorText;
  Timer searchOnStoppedTyping;

  @override
  void dispose() {
    super.dispose();
    _searchPlace.dispose();
  }

  void _inputSearchPlaceFrmAC(String value) {
    //_inputSearchPlaceFrmAC AC means auto complete
    _searchPlace.text = value;
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    final _fsProvider = Get.find<FirestoreProvider>();
    //this is because to set the initial search type of homeowner, the below line,
    final _appProvider = Get.find<AppProvider>();
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: MColors.backgroundColor,
        drawer: SideDrawer(),
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 80),
          child: Container(
            alignment: Alignment.bottomCenter,
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                CIconButton(
                  Icons.menu,
                  MColors.lightButtonColor,
                  MColors.whiteColor,
                  55,
                  () => _scaffoldKey.currentState.openDrawer(),
                ),
                Expanded(
                  child: Text(
                    'Bachelor Rooms',
                    style: MTextStyle.darkheaderText,
                  ),
                ),
                CIconButton(
                  Icons.account_circle_outlined,
                  MColors.redButtonColor,
                  MColors.whiteColor,
                  55,
                  () {
                    final _authProvider = Get.find<AuthProvider>();
                    _authProvider.isLoggedIn != null
                        ? Get.toNamed('/myProfile')
                        : Get.toNamed('/signup');
                  },
                ),
              ],
            ),
          ),
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: _size.width * 0.15,
                ),
                child: SvgPicture.asset(
                  'assets/images/home.svg',
                  width: _size.width * 0.5,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: _size.width * 0.1,
                  left: _size.width * 0.4,
                ),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/images/home.svg',
                      width: _size.width * 0.25,
                      fit: BoxFit.cover,
                    ),
                    _searchText('Search   '),
                    _searchText('Rooms'),
                    _searchText('for           '),
                    _searchText('Rent      '),
                  ],
                ),
              ),
              Container(
                height: _size.height,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  reverse: true,
                  child: Column(
                    children: [
                      bengaluruButton(),
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
                          //this line was there at the beginning of the build
                          //changing to here where user actually presses the button
                          //this is where user search by location
                          _fsProvider.searchBySet = _searchBy;
                          await _fsProvider.searchPropertyByLocation();
                          if (_fsProvider.searchResult == null) {
                            Get.offAndToNamed('/homePage');
                          }
                          //here why not put setstate in else statement, what if the searchResult is null
                          //and the _errorText is with previous memory with error,
                          setState(() {
                            _errorText = _fsProvider.searchResult;
                          });
                        },
                        (newValue) {
                          _appProvider.localityFrmAutoCmpltSet = false;
                          const duration = Duration(milliseconds: 2000);
                          _appProvider.placemarkLoadingSet = true;
                          if (searchOnStoppedTyping != null) {
                            setState(() {
                              searchOnStoppedTyping.cancel();
                            }); // clear timer
                          }
                          setState(
                            () {
                              searchOnStoppedTyping = new Timer(
                                duration,
                                () {
                                  _appProvider.getPlacemark(_searchPlace.text);
                                },
                              );
                            },
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
                                  color: MColors.redButtonColor,
                                  size: 23,
                                )
                              : SizedBox();
                        },
                      ),
                      PlacesSearchList(_inputSearchPlaceFrmAC),
                      Divider(
                        thickness: 1,
                        height: 60,
                        color: const Color(0xFFD6D6D6),
                        indent: 20,
                        endIndent: 20,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: CElevatedBtn(
          'search',
          100,
          12,
          MTextStyle.whiteButtonText.copyWith(fontSize: 14),
          MColors.redButtonColor,
          () async {
            //this line was there at the beginning of the build
            //changing to here where user actually presses the button
            //this is where user search by name
            _fsProvider.searchBySet = _searchBy;
            _appProvider.placemarksSet = [];
            await _fsProvider.searchPropertyByName(_searchPlace.text);
            if (_fsProvider.searchResult == null) {
              Get.offAndToNamed('/homePage');
            }
            setState(
              () {
                _errorText = _fsProvider.searchResult;
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }

  Widget _searchText(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: const TextStyle(
          color: const Color(0xFFD6D6D6),
          fontSize: 45,
          fontWeight: FontWeight.bold,
          height: 1.1,
        ),
      ),
    );
  }
}
