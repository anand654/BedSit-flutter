import 'package:bachelor_room/screens/home_page/home_page.dart';
import 'package:bachelor_room/screens/intro_page/check_model.dart';
import 'package:bachelor_room/screens/my_profile/my_profile.dart';
import 'package:bachelor_room/screens/post_property/image_page.dart';
import 'package:bachelor_room/screens/post_property/post_property.dart';
import 'package:bachelor_room/screens/post_property/quick_post_page.dart';
import 'package:bachelor_room/screens/savedrooms/saved_rooms_page.dart';
import 'package:bachelor_room/screens/signin_signup/signinup_page.dart';
import 'package:bachelor_room/provider/getx_bindings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: CheckModel(),
      initialBinding: GetxBinding(),
      getPages: [
        GetPage(name: '/homePage', page: () => HomePage()),
        GetPage(name: '/postProperty', page: () => PostProperty()),
        GetPage(name: '/signup', page: () => SignInUp()),
        GetPage(name: '/imagePage', page: () => ImagePage()),
        GetPage(name: '/myProfile', page: () => MyProfile()),
        GetPage(name: '/quickPost', page: () => QuickPost()),
        GetPage(name: '/savedRoomsPage', page: () => SavedRoomsPage()),
      ],
    );
  }
}
