import 'package:firebase_ml_custom/firebase_ml_custom.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:bachelor_room/provider/firestore_provider.dart';
import 'package:bachelor_room/screens/post_property/post_property_widgets.dart';
import 'package:bachelor_room/widget/app_widgets.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';

class QuickPost extends StatefulWidget {
  @override
  _QuickPostState createState() => _QuickPostState();
}

class _QuickPostState extends State<QuickPost> {
  TextEditingController _phoneNoController = TextEditingController();
  Position _position;

  @override
  void initState() {
    _loadModel();
    super.initState();
  }

  _loadModel() async {
    File _labelsFile;
    final model = FirebaseCustomRemoteModel('nsfwjsbr');
    final modelManager = FirebaseModelManager.instance;
    var modelFile = await modelManager.getLatestModelFile(model);
    assert(modelFile != null);
    // final int size = await modelFile.length();
    final appDirectory = await getApplicationDocumentsDirectory();
    bool _isFileExists =
        await File('${appDirectory.path}/_class_labels.txt').exists();
    if (!_isFileExists) {
      final labelsData =
          await rootBundle.load('assets/nsfwjs/class_labels.txt');
      _labelsFile = await File('${appDirectory.path}/_class_labels.txt')
          .writeAsBytes(labelsData.buffer
              .asUint8List(labelsData.offsetInBytes, labelsData.lengthInBytes));
    } else {
      _labelsFile = File('${appDirectory.path}/_class_labels.txt');
    }
    await Tflite.loadModel(
      model: modelFile.path,
      labels: _labelsFile.path,
      isAsset: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _phoneNoController.dispose();
    _closeModel();
  }

  _closeModel() async {
    await Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    final _fsProvider = Get.find<FirestoreProvider>();
    final Size _size = MediaQuery.of(context).size;
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
                    'Quick Post',
                    style: MTextStyle.darkheaderText,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: CustomPaint(
          painter: QuickPostPainter(),
          child: Container(
            height: _size.height,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: _size.width * 0.6,
                      height: _size.width * 0.6,
                      child: Card(
                        color: MColors.cardColor,
                        // margin: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(MConstants.descBorRad),
                          side: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        elevation: MConstants.noelevation,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            GetBuilder<FirestoreProvider>(
                              builder: (controller) {
                                if (controller.showPickedImage != null) {
                                  return Image.file(controller.showPickedImage);
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            IconButton(
                              iconSize: 60,
                              color: MColors.sideDrawerColor,
                              icon: Icon(Icons.add_a_photo),
                              onPressed: () async {
                                Position _pos =
                                    await _fsProvider.determinePosition();
                                if (_pos != null)
                                  await _pickImageAndNsfw(
                                      ImageSource.camera, _fsProvider);
                                setState(() {
                                  _position = _pos;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GetBuilder<FirestoreProvider>(
                    builder: (controller) => Text(
                      controller.imageError ?? '',
                      style: MTextStyle.errorText,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Phone Number *',
                      style: MTextStyle.darkTitleText,
                      softWrap: true,
                    ),
                  ),
                  phoneNumberQP(
                    _size.width * 0.7,
                    _phoneNoController,
                    _phoneNoController.text.length < 10 &&
                            _phoneNoController.text.length > 0
                        ? 'phone number should be atleast 10 digit'
                        : null,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom,
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: CWideElevatedBtn(
          'post',
          150,
          const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          MTextStyle.whiteButtonText,
          MColors.redButtonColor,
          0,
          12,
          () async {
            await _fsProvider.quickPostProperty(
                _phoneNoController.text, _position);
            if (_fsProvider.propertyImgUrl != null) {
              _fsProvider.resetSavedData();
            }
          },
        ),
      ),
    );
  }

  Future _pickImageAndNsfw(
      ImageSource sources, FirestoreProvider fsProvider) async {
    //check permission
    var _permissionStatus = await Permission.photos.status;
    if (_permissionStatus.isGranted) {
      final _picker = ImagePicker();
      PickedFile _image = await _picker.getImage(
        source: sources,
      );
      if (_image != null) {
        bool safe = await predict(_image.path);
        if (safe) {
          fsProvider.imageErrorSet = null;
          fsProvider.showPickedImageSet = File(_image.path);
          return;
        } else {
          fsProvider.imageErrorSet =
              'you may be trying to upload an InAppropriate image';
          return;
        }
      } else {
        fsProvider.imageErrorSet = 'please select an Image to upload';
        return;
      }
    } else {
      await Permission.photos.request();
      return;
    }
  }

  Future<bool> predict(String imagepath) async {
    bool _isSafe = false;
    List<dynamic> _predictions = await Tflite.runModelOnImage(
      path: imagepath,
      imageMean: 0.0,
      imageStd: 224.0,
      numResults: 1,
      threshold: 0.5,
    );
    if (_predictions[0]['label'] == 'neutral' ||
        _predictions[0]['label'] == 'drawings') {
      _isSafe = true;
      return _isSafe;
    } else
      return _isSafe;
  }
}

class QuickPostPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path ovalPath = Path();
    ovalPath.moveTo(0, height);
    ovalPath.lineTo(0, height * 0.47);
    ovalPath.quadraticBezierTo(width * 0.7, height * 0.8, width, height * 0.65);
    ovalPath.lineTo(width, height);
    ovalPath.close();
    paint.color = MColors.backgroundColor;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(QuickPostPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(QuickPostPainter oldDelegate) =>
      oldDelegate != this;
}
