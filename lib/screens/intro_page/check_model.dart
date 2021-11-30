import 'dart:io';

import 'package:bachelor_room/screens/home_page/initial_page.dart';
import 'package:bachelor_room/screens/intro_page/intro_pages.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_ml_custom/firebase_ml_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckModel extends StatelessWidget {
  static Future<String> _checkModel() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.snackbar('No internet connection!',
          'Please connect to the internet to continue.');
      return null;
    } else {
      final modelFile = await loadModelFromFirebase();
      return modelFile;
    }
  }

  static Future<String> loadModelFromFirebase() async {
    try {
      final model = FirebaseCustomRemoteModel('nsfwjsbr');
      final conditions = FirebaseModelDownloadConditions();
      final modelManager = FirebaseModelManager.instance;
      await modelManager.download(model, conditions);
      final isModelDwnld = await modelManager.isModelDownloaded(model);
      if (isModelDwnld == true) {
        return 'Model is downloaded';
      } else {
        return null;
      }
    } catch (exception) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkModel(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return exit(0);
        }
        if (snapshot.hasData) {
          return InitialPage();
        }
        return IntroPage();
      },
    );
  }
}
