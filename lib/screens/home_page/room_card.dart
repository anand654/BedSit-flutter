import 'package:bachelor_room/model/room_info.dart';
import 'package:bachelor_room/provider/application_provider.dart';
import 'package:bachelor_room/provider/firestore_provider.dart';
import 'package:bachelor_room/screens/description_page/description_page.dart';
import 'package:bachelor_room/widget/app_widgets.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomCard extends StatelessWidget {
  final RoomInfo room;
  final int index;

  RoomCard({
    @required this.room,
    @required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width * 0.45;
    String _address;
    if (room.address != null) {
      final _list = room.address.split(",");
      final int length = _list.length;
      final _removed = length >= 7
          ? _list.sublist(length - 6, length - 2)
          : _list.sublist(0, length - 2);
      _address = _removed.join(',');
    }

    int _daysAgo = DateTime.now().difference(room.timeOfPost).inDays;
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
            Stack(
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
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Colors.black26,
                  ),
                  margin: const EdgeInsets.only(top: 16, left: 16),
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    '$_daysAgo days ago',
                    style: MTextStyle.whiteButtonText.copyWith(fontSize: 8),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: GetBuilder<FirestoreProvider>(
                        builder: (controller) {
                          return CIconButton(
                            controller.favorites[index]
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            MColors.flatBtnColor,
                            MColors.redButtonColor,
                            55,
                            () {
                              if (!controller.favorites[index])
                                Get.find<AppProvider>().saveRooms(room);
                              controller.toggleFavorite(index);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  CCardInfo('${room.iam ?? ''}'),
                  CCardInfo('rent : ${room.rent ?? ''}/-'),
                  CCardInfo('deposit : ${room.deposit ?? ''}/-'),
                  CCardInfo('address : $_address'),
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
                          () => DescriptionPage(
                            room: this.room,
                            index: this.index,
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
