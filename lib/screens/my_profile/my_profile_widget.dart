import 'package:bachelor_room/model/room_info.dart';
import 'package:bachelor_room/provider/firestore_provider.dart';
import 'package:bachelor_room/widget/app_widgets.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyRoomCard extends StatelessWidget {
  final RoomInfo room;
  final String docId;
  final int index;

  MyRoomCard({
    @required this.room,
    this.docId,
    this.index,
  });
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width * 0.45;
    final _fsProvider = Get.find<FirestoreProvider>();
    final _list = room.address.split(",");
    final int length = _list.length;
    final _removed = length >= 7
        ? _list.sublist(length - 6, length - 2)
        : _list.sublist(0, length - 2);
    final String _res = _removed.join();

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
                child: FadeInImage(
                  placeholder: AssetImage(
                    'assets/images/room.png',
                  ),
                  image: room.propertyImgUrl == ''
                      ? AssetImage('assets/images/no_images.png')
                      : NetworkImage(room.propertyImgUrl),
                  imageErrorBuilder: (context, error, stackTrace) => Text(
                    ' Error Loading Image',
                    softWrap: true,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  cardInfo('${room.iam}'),
                  cardInfo('rent : ${room.rent}/-'),
                  cardInfo('deposit : ${room.deposit}/-'),
                  cardInfo('address : $_res'),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CWideElevatedBtn(
                      'delete',
                      100,
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                      MTextStyle.darkbuttonText,
                      MColors.flatBtnColor,
                      0,
                      0,
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
                                _fsProvider.deleteMyRoom(
                                    index, docId, room.propertyImgUrl);
                                Get.back();
                              },
                            ),
                          ],
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

  Widget cardInfo(String text) {
    return Text(
      text,
      style: MTextStyle.subtitleText,
      softWrap: true,
      overflow: TextOverflow.fade,
      maxLines: 3,
    );
  }
}

Widget myInfo(
  String profileImg,
  String title,
  String subtitle,
  double width,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: CachedNetworkImage(
            imageUrl: profileImg,
            placeholder: (context, url) =>
                Image.asset('assets/images/room.png'),
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/room.png'),
            width: width,
            height: width,
            fit: BoxFit.fill,
          ),
        ),
      ),
      const SizedBox(
        width: 50,
      ),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '$title\n',
              style: MTextStyle.darkTitleText.copyWith(
                fontSize: 15,
              ),
            ),
            TextSpan(
              text: subtitle,
              style: MTextStyle.subtitleText.copyWith(
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget titleText(String title) {
  return Text(
    title,
    style: MTextStyle.darkheaderText,
  );
}

Widget emailVerified(bool verified, VoidCallback onpressed) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Text(
        verified ? 'Verified' : 'Not Verified',
        style: verified ? MTextStyle.greenText : MTextStyle.errorText,
      ),
      const SizedBox(
        width: 20,
      ),
      verified
          ? SizedBox()
          : TextButton(
              onPressed: onpressed,
              child: Text(
                'Resend Verification Email',
                style: MTextStyle.errorText
                    .copyWith(decoration: TextDecoration.underline),
              ),
            ),
      const SizedBox(
        width: 20,
      ),
    ],
  );
}

Widget myRooms(
  String title,
  double width,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
            'assets/images/room.png',
            width: width,
            height: width,
            fit: BoxFit.contain,
          ),
        ),
      ),
      const SizedBox(
        width: 50,
      ),
      Text(
        title,
        style: MTextStyle.darkTitleText.copyWith(fontSize: 15),
      ),
    ],
  );
}
