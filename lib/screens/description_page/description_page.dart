import 'package:bachelor_room/model/room_info.dart';
import 'package:bachelor_room/provider/application_provider.dart';
import 'package:bachelor_room/provider/auth_provider.dart';
import 'package:bachelor_room/provider/firestore_provider.dart';
import 'package:bachelor_room/screens/description_page/maps.dart';
import 'package:bachelor_room/screens/description_page/description_page_widgets.dart';
import 'package:bachelor_room/widget/app_widgets.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DescriptionPage extends StatelessWidget {
  final RoomInfo room;
  final int index;

  DescriptionPage({
    @required this.room,
    @required this.index,
  });

  bool _canCallNow(String cclfrom, String cclto) {
    DateTime _clFromDate = DateFormat("h:mm a").parse(cclfrom);
    DateTime _clToDate = DateFormat("h:mm a").parse(cclto);
    double _from = _clFromDate.hour + _clFromDate.minute / 60;
    double _to = _clToDate.hour + _clToDate.minute / 60;
    TimeOfDay _timeOfDay = TimeOfDay.now();
    double _now = _timeOfDay.hour + _timeOfDay.minute / 60;
    if (_from <= _now && _now <= _to) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MColors.backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 80),
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.bottomCenter,
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                CIconButton(
                  Icons.chevron_left,
                  MColors.lightButtonColor,
                  MColors.whiteColor,
                  55,
                  () => Get.back(),
                ),
                Expanded(
                  child: Text(
                    'Room Description',
                    style: MTextStyle.headerText,
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
        body: CustomPaint(
          painter: DescBackGroundPainter(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(
              left: 20,
              right: 10,
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: _size.width * 0.73,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(MConstants.descBorRad),
                          color: MColors.sideDrawerColor,
                        ),
                        child: AspectRatio(
                          aspectRatio: 0.8,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(MConstants.descBorRad),
                            child: CachedNetworkImage(
                              imageUrl: room.propertyImgUrl,
                              placeholder: (context, url) => Image.asset(
                                'assets/images/room.png',
                                fit: BoxFit.fill,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Column(
                        children: [
                          GetBuilder<FirestoreProvider>(builder: (controller) {
                            return CIconButton(
                                controller.favorites[index]
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                MColors.redButtonColor,
                                MColors.whiteColor,
                                55, () {
                              if (!controller.favorites[index])
                                Get.find<AppProvider>().saveRooms(room);
                              controller.toggleFavorite(index);
                            });
                          }),
                          const SizedBox(
                            height: 20,
                          ),
                          CIconButton(
                            Icons.map_outlined,
                            MColors.redButtonColor,
                            MColors.whiteColor,
                            55,
                            () {
                              MapUtils.openMap(
                                room.plusCode,
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                  DescriptionInfo(
                    rent: room.rent,
                    deposit: room.deposit,
                    address: room.address,
                  ),
                  contactTime(room.clFrom, room.clTo),
                  Row(
                    children: [
                      Expanded(
                        child: CDescOverView(
                          parking: room.bikePark,
                          nonVeg: true,
                        ),
                      ),
                      CCallBtn(
                        title: 'call',
                        onpressed: () async {
                          if (room.clFrom != null || room.clTo != null) {
                            if (_canCallNow(room.clFrom, room.clTo)) {
                              await FlutterPhoneDirectCaller.callNumber(
                                  room.phoneNo);
                            } else {
                              Get.snackbar('',
                                  'You can only contact in between ${room.clFrom} - ${room.clTo}');
                            }
                          } else {
                            Get.snackbar(
                                'Unable to call', 'Phone Number not found,');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DescBackGroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path ovalPath = Path();
    ovalPath.moveTo(0, height);
    ovalPath.lineTo(0, height * 0.2);
    ovalPath.quadraticBezierTo(
        width * 0.85, height * 0.35, width, height * 0.55);
    ovalPath.lineTo(width, height);
    ovalPath.close();
    paint.color = MColors.swipeColor;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(DescBackGroundPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(DescBackGroundPainter oldDelegate) =>
      oldDelegate != this;
}
