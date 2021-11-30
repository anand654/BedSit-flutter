import 'package:bachelor_room/provider/firestore_provider.dart';
import 'package:bachelor_room/screens/home_page/loading_room_card.dart';
import 'package:bachelor_room/screens/my_profile/my_profile_widget.dart';
import 'package:bachelor_room/widget/app_widgets.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyRoomsList extends StatefulWidget {
  @override
  _MyRoomsListState createState() => _MyRoomsListState();
}

class _MyRoomsListState extends State<MyRoomsList> {
  @override
  void initState() {
    _loadMyRooms();
    super.initState();
  }

  Future _loadMyRooms() async {
    await Get.find<FirestoreProvider>().fetchMyRooms();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MColors.backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 80),
          child: Container(
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
                  child: Text('My Rooms'),
                ),
              ],
            ),
          ),
        ),
        body: CustomPaint(
          painter: MyRoomBackGroundPainter(),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            height: MediaQuery.of(context).size.height,
            child: GetBuilder<FirestoreProvider>(
              builder: (controller) {
                if (controller.myRooms.length == 0) {
                  return Center(
                    child: Text('there are no properties listed in by you,'),
                  );
                }
                int _listLength = controller.myRooms.length;
                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                        controller.myRoomHasNext) controller.fetchMoreMyRooms();
                    return true;
                  },
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == _listLength) {
                        return !controller.hasNext
                            ? Text(
                                ' \n No more rooms...',
                                textAlign: TextAlign.center,
                              )
                            : LoadingRoomCard();
                      }
                      return MyRoomCard(
                        room: controller.myRooms[index].roomInfo,
                        docId: controller.myRooms[index].docId,
                        index: index,
                      );
                    },
                    itemCount: _listLength + 1,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MyRoomBackGroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path ovalPath = Path();
    ovalPath.moveTo(0, height);
    ovalPath.lineTo(0, height * 0.4);
    ovalPath.quadraticBezierTo(width * 0.6, height * 0.01, width, height * 0.2);
    ovalPath.lineTo(width, height);
    ovalPath.close();
    paint.color = MColors.swipeColor;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(MyRoomBackGroundPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(MyRoomBackGroundPainter oldDelegate) =>
      oldDelegate != this;
}
