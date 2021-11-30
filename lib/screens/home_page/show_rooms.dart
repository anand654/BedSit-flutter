import 'package:bachelor_room/provider/firestore_provider.dart';
import 'package:bachelor_room/screens/home_page/loading_room_card.dart';
import 'package:bachelor_room/screens/home_page/room_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowRoomsResult extends StatelessWidget {
  Future _fetchMoreProperties() async {
    await Get.find<FirestoreProvider>().fetchMoreProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetBuilder<FirestoreProvider>(
        builder: (controller) {
          // final List<RoomInfo> _properties = controller.properties;
          if (controller.properties.length == 0) {
            return Center(
              child: Text(controller.locality == null
                  ? 'search for properties.'
                  : 'there are no properties listed in ${controller.locality}.'),
            );
          }
          int _listLength = controller.properties.length;
          return Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) _fetchMoreProperties();
                return true;
              },
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  if (i == _listLength) {
                    return !controller.hasNext
                        ? Text(
                            ' \n No more rooms...',
                            textAlign: TextAlign.center,
                          )
                        : LoadingRoomCard();
                  }
                  return RoomCard(
                    room: controller.properties[i],
                    index: i,
                  );
                },
                itemCount: _listLength + 1,
              ),
            ),
          );
        },
      ),
    );
  }
}
