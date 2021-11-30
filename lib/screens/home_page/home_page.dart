import 'package:bachelor_room/provider/application_provider.dart';
import 'package:bachelor_room/provider/auth_provider.dart';
import 'package:bachelor_room/screens/home_page/home_page_widget.dart';
import 'package:bachelor_room/screens/home_page/show_rooms.dart';
import 'package:bachelor_room/screens/side_drawer/side_drawer.dart';
import 'package:bachelor_room/widget/app_widgets.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _appProv = Get.find<AppProvider>();
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
                  Icons.search,
                  MColors.redButtonColor,
                  MColors.whiteColor,
                  55,
                  () {
                    _appProv.openSearchBarSet();
                  },
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
          painter: HomeBackGroundPainter(),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GetBuilder<AppProvider>(
                  builder: (controller) {
                    if (controller.openSearchBar) {
                      return SearchBar();
                    }
                    return SizedBox();
                  },
                ),
                ShowRoomsResult(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeBackGroundPainter extends CustomPainter {
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
  bool shouldRepaint(HomeBackGroundPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(HomeBackGroundPainter oldDelegate) =>
      oldDelegate != this;
}
