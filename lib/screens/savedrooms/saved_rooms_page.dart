import 'package:bachelor_room/model/saved_rooms.dart';
import 'package:bachelor_room/provider/application_provider.dart';
import 'package:bachelor_room/screens/savedrooms/saved_rooms_widget.dart';
import 'package:bachelor_room/widget/app_widgets.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedRoomsPage extends StatefulWidget {
  @override
  _SavedRoomsPageState createState() => _SavedRoomsPageState();
}

class _SavedRoomsPageState extends State<SavedRoomsPage> {
  Future _loadSavedRooms;
  @override
  void initState() {
    super.initState();
    _loadSavedRooms = Get.find<AppProvider>().getSavedRooms();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MColors.swipeColor,
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
                  MColors.darkColor,
                  55,
                  () => Get.back(),
                ),
                Expanded(
                  child: Text(
                    'Saved Rooms',
                    style: MTextStyle.darkheaderText,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: CustomPaint(
          painter: SavedBackGround(),
          child: FutureBuilder<Object>(
            future: _loadSavedRooms,
            builder: (context, snapshot) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: GetBuilder<AppProvider>(
                  builder: (controller) {
                    List<SavedRooms> _savedRoomsget = controller.savedRoomsGet;
                    if (_savedRoomsget.length == 0) {
                      return Center(
                        child: Text(
                          'There are no saved Rooms',
                          style: MTextStyle.darkTitleText,
                        ),
                      );
                    }
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return SavedRoomsCard(
                          _savedRoomsget[index],
                          index,
                        );
                      },
                      itemCount: _savedRoomsget.length,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SavedBackGround extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path ovalPath = Path();
    ovalPath.moveTo(0, height);
    ovalPath.lineTo(0, height * 0.7);
    ovalPath.quadraticBezierTo(width * 0.4, height * 0.9, width, height * 0.5);
    ovalPath.lineTo(width, height);
    ovalPath.close();
    paint.color = MColors.backgroundColor;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(SavedBackGround oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(SavedBackGround oldDelegate) =>
      oldDelegate != this;
}
