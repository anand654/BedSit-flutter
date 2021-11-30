import 'package:bachelor_room/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.cardColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/app_logo.png'),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Please wait',
                  style: const TextStyle(
                    color: MColors.backgroundColor,
                    fontSize: 22,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Loading profile...',
                  style: const TextStyle(
                    color: MColors.backgroundColor,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
