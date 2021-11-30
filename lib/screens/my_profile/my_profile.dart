import 'package:bachelor_room/provider/auth_provider.dart';
import 'package:bachelor_room/screens/my_profile/my_profile_widget.dart';
import 'package:bachelor_room/screens/my_profile/my_room_list.dart';
import 'package:bachelor_room/widget/app_widgets.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final _authProvider = Get.find<AuthProvider>();
    final _user = _authProvider.isLoggedIn;
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
                    'My Profile',
                    style: MTextStyle.darkheaderText,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: CustomPaint(
          painter: MyProfBackGroundPainter(),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            height: _size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                myInfo(
                  _user.photoURL ?? 'assets/image/room.png',
                  _user.displayName ?? 'Me',
                  _user.email,
                  _size.width * 0.27,
                ),
                titleText('Email Address'),
                emailVerified(_user.emailVerified, () {}),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CWideElevatedBtn(
                      'logout',
                      110,
                      const EdgeInsets.all(0),
                      MTextStyle.whiteButtonText,
                      MColors.redButtonColor,
                      15,
                      10,
                      () {
                        _authProvider.signOut();
                        Get.back();
                      },
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                  ],
                ),
                myRooms('My Rooms', _size.width * 0.27),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CWideElevatedBtn(
                      'MyRooms',
                      110,
                      const EdgeInsets.all(0),
                      MTextStyle.whiteButtonText,
                      MColors.redButtonColor,
                      15,
                      10,
                      () => Get.to(
                        () => MyRoomsList(),
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyProfBackGroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path ovalPath = Path();
    ovalPath.moveTo(0, height);
    ovalPath.lineTo(0, height * 0.58);
    ovalPath.quadraticBezierTo(
        width * 0.43, height * 0.97, width, height * 0.32);
    ovalPath.lineTo(width, height);
    ovalPath.close();
    paint.color = MColors.backgroundColor;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(MyProfBackGroundPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(MyProfBackGroundPainter oldDelegate) =>
      oldDelegate != this;
}
