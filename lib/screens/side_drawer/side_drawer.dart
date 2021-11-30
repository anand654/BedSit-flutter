import 'dart:math';
import 'package:bachelor_room/screens/side_drawer/side_drawer_widget.dart';
import 'package:bachelor_room/provider/auth_provider.dart';
import 'package:bachelor_room/widget/app_widgets.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SideDrawer extends StatelessWidget {
  Future _checkUserVerified(String toNamed) async {
    final _authProvider = Get.find<AuthProvider>();
    if (_authProvider.isLoggedIn != null) {
      bool _emailVerified = await _authProvider.isEmailVarified;
      if (_emailVerified) {
        Get.toNamed(toNamed);
      } else {
        await Get.defaultDialog(
          title: 'your email is not verified',
          titleStyle: MTextStyle.darkheaderText,
          content: Text(
            'you need to varify your email\n for further process.',
            textAlign: TextAlign.center,
            style: MTextStyle.subtitleText,
          ),
          actions: [
            _authProvider.verifyEmailSent
                ? CElevatedBtn(
                    'send verification email',
                    0,
                    10,
                    MTextStyle.whiteButtonText,
                    MColors.redButtonColor,
                    () {
                      _authProvider.sendEmailVarification();
                      _authProvider.verifyEmailSentSet = true;
                    },
                  )
                : Text(
                    'Verification email has sent.',
                    style: MTextStyle.darkTitleText,
                  ),
          ],
        );
      }
    } else {
      Get.toNamed('/signup');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = Get.find<AuthProvider>();
    final String _email = _authProvider.emailId;
    final int random = Random().nextInt(7);
    return Drawer(
      child: CustomPaint(
        painter: SideDrawPainter(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'bachelor rooms',
                      style: MTextStyle.darkheaderText,
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      foregroundImage:
                          AssetImage('assets/images/Asset$random.png'),
                      radius: 25,
                    ),
                    title: _email != null
                        ? Text(
                            _email.substring(
                              0,
                              _email.indexOf("@"),
                            ),
                            style: MTextStyle.darkTitleText,
                          )
                        : Text(
                            'Welcome',
                            style: MTextStyle.darkTitleText,
                          ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Obx(
                      () {
                        return _authProvider.authState == null
                            ? CElevatedBtn(
                                'sign in / sign up',
                                15,
                                10,
                                MTextStyle.whiteButtonText,
                                MColors.redButtonColor,
                                () => Get.toNamed('/signup'),
                              )
                            : CElevatedBtn(
                                'edit profile',
                                15,
                                10,
                                MTextStyle.whiteButtonText,
                                MColors.redButtonColor,
                                () => Get.toNamed('/myProfile'),
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              indent: 5,
              endIndent: 5,
            ),
            CSideDrawerTile(
              'My Profile',
              Icon(
                Icons.account_circle_outlined,
                color: MColors.darkColor,
                size: 22,
              ),
              () => _authProvider.isLoggedIn != null
                  ? Get.toNamed('/myProfile')
                  : Get.toNamed('/signup'),
            ),
            CSideDrawerTile(
              'Saved List',
              Icon(
                Icons.favorite_border_outlined,
                color: MColors.darkColor,
                size: 22,
              ),
              () => _authProvider.isLoggedIn != null
                  ? Get.toNamed('/savedRoomsPage')
                  : Get.toNamed('/signup'),
            ),
            CSideDrawerTile(
              'Quick Post',
              SvgPicture.asset(
                'assets/images/quickpost.svg',
                width: 20,
              ),
              () => _checkUserVerified('/quickPost'),
            ),
            CSideDrawerTile(
              'Post Property',
              SvgPicture.asset(
                'assets/images/post.svg',
                width: 20,
              ),
              () => _checkUserVerified('/postProperty'),
            ),
          ],
        ),
      ),
    );
  }
}

class SideDrawPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path ovalPath = Path();
    ovalPath.moveTo(0, 0);
    ovalPath.lineTo(0, height * 0.27);
    ovalPath.quadraticBezierTo(width * 0.6, height * 0.2, width, height * 0.4);

    ovalPath.lineTo(width, 0);
    ovalPath.close();
    paint.color = MColors.sideDrawerColor;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(SideDrawPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(SideDrawPainter oldDelegate) =>
      oldDelegate != this;
}
