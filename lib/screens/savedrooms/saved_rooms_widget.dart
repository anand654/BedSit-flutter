import 'package:bachelor_room/model/saved_rooms.dart';
import 'package:bachelor_room/provider/application_provider.dart';
import 'package:bachelor_room/screens/description_page/description_page_widgets.dart';
import 'package:bachelor_room/screens/description_page/maps.dart';
import 'package:bachelor_room/widget/app_widgets.dart';
import 'package:bachelor_room/widget/background_painter.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SavedRoomsCard extends StatelessWidget {
  final SavedRooms room;
  final int index;
  SavedRoomsCard(
    this.room,
    this.index,
  );
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width * 0.45;
    return AspectRatio(
      aspectRatio: 1.6,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MConstants.descBorRad),
        ),
        color: MColors.cardColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: _width,
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(MConstants.descBorRad),
                child: CachedNetworkImage(
                  imageUrl: room.propertyImgUrl,
                  placeholder: (context, url) => Image.asset(
                    'assets/images/room.png',
                    fit: BoxFit.fill,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: CIconButton(
                        Icons.delete_outline,
                        MColors.flatBtnColor,
                        MColors.redButtonColor,
                        55,
                        () async {
                          await Get.defaultDialog(
                            title: 'Are you sure ?',
                            titleStyle: MTextStyle.darkheaderText,
                            content: Text(
                              'You won\'t be able to revert this!',
                              style: MTextStyle.subtitleText,
                            ),
                            actions: [
                              CWideElevatedBtn(
                                'Cancel',
                                100,
                                const EdgeInsets.all(0),
                                MTextStyle.darkbuttonText,
                                MColors.lightButtonColor,
                                0,
                                10,
                                () => Get.back(),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              CWideElevatedBtn(
                                'delete',
                                100,
                                const EdgeInsets.all(0),
                                MTextStyle.whiteButtonText,
                                MColors.redButtonColor,
                                0,
                                10,
                                () async {
                                  await Get.find<AppProvider>()
                                      .deleteSavedRooms(index);
                                  Get.back();
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  CCardInfo('${room.iam ?? ''}'),
                  CCardInfo('rent : ${room.rent ?? ''}/-'),
                  CCardInfo('deposit : ${room.deposit ?? ''}/-'),
                  CCardInfo('address : ${room.address ?? ''}'),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CWideElevatedBtn(
                      'view',
                      100,
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                      MTextStyle.darkbuttonText,
                      MColors.flatBtnColor,
                      0,
                      0,
                      () {
                        Get.to(
                          () => SavedRoomsDescPage(
                            this.room,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CCardInfo extends StatelessWidget {
  final String text;
  const CCardInfo(
    this.text,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text(
        text,
        style: MTextStyle.subtitleText,
        softWrap: true,
        overflow: TextOverflow.fade,
        maxLines: 2,
      ),
    );
  }
}

class SavedRoomsDescPage extends StatelessWidget {
  final SavedRooms room;
  SavedRoomsDescPage(this.room);

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
              ],
            ),
          ),
        ),
        body: CustomPaint(
          painter: BackGroundPainter(
            secondPtHeight: 0.2,
            color: MColors.swipeColor,
            qx1: 0.85,
            qy1: 0.35,
            qy2: 0.55,
          ),
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
                          CIconButton(
                            Icons.map_outlined,
                            MColors.redButtonColor,
                            MColors.whiteColor,
                            55,
                            () {
                              // Position _position =
                              //     await _fsProvider.determinePosition();
                              MapUtils.openMap(
                                room.plusCode,
                                // _position,
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
