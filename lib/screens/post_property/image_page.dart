import 'dart:io';

import 'package:bachelor_room/provider/firestore_provider.dart';
import 'package:bachelor_room/widget/app_widgets.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:firebase_ml_custom/firebase_ml_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';

class ImagePage extends StatefulWidget {
  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  void initState() {
    loadModel();
    super.initState();
  }

  loadModel() async {
    File _labelsFile;
    final model = FirebaseCustomRemoteModel('nsfwjsbr');
    final modelManager = FirebaseModelManager.instance;
    var modelFile = await modelManager.getLatestModelFile(model);
    assert(modelFile != null);
    final appDirectory = await getApplicationDocumentsDirectory();
    _labelsFile = File('${appDirectory.path}/_class_labels.txt');
    if (_labelsFile == null) {
      final labelsData =
          await rootBundle.load('assets/nsfwjs/class_labels.txt');
      _labelsFile = await File('${appDirectory.path}/_class_labels.txt')
          .writeAsBytes(labelsData.buffer
              .asUint8List(labelsData.offsetInBytes, labelsData.lengthInBytes));
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
    _closeModel();
  }

  _closeModel() async {
    await Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    final _fsProvider = Get.find<FirestoreProvider>();
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
                  MColors.whiteColor,
                  55,
                  () => Get.back(),
                ),
                Expanded(
                  child: Text(
                    'upload Image',
                    style: MTextStyle.darkheaderText,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: CustomPaint(
          painter: ImageUploadPainter(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1.6,
                child: Card(
                  color: MColors.cardColor,
                  margin: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MConstants.descBorRad),
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
                        onPressed: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  color: MColors.cardColor,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        'Select Image',
                                        style: MTextStyle.darkheaderText,
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                await _pickImageAndNsfw(
                                                    ImageSource.gallery,
                                                    _fsProvider);
                                                Navigator.pop(context);
                                              },
                                              icon: Image.asset(
                                                  'assets/images/addimage.png'),
                                              iconSize: 40,
                                            ),
                                            Text(
                                              'gallery',
                                              style: MTextStyle.titleText,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                await _pickImageAndNsfw(
                                                    ImageSource.camera,
                                                    _fsProvider);
                                                Navigator.pop(context);
                                              },
                                              icon: Image.asset(
                                                  'assets/images/addcamera.png'),
                                              iconSize: 40,
                                            ),
                                            Text(
                                              'camera',
                                              style: MTextStyle.titleText,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              GetBuilder<FirestoreProvider>(
                builder: (controller) => Text(
                  controller.imageError ?? '',
                  style: MTextStyle.errorText,
                ),
              ),
              Spacer(),
            ],
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
            await _fsProvider.postProperty();
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

class ImageUploadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path ovalPath = Path();
    ovalPath.moveTo(0, height);
    ovalPath.lineTo(0, height * 0.78);
    ovalPath.quadraticBezierTo(width * 0.7, height * 0.7, width, height * 0.5);
    ovalPath.lineTo(width, height);
    ovalPath.close();
    paint.color = MColors.backgroundColor;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(ImageUploadPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(ImageUploadPainter oldDelegate) =>
      oldDelegate != this;
}
