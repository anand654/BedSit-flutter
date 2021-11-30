import 'package:bachelor_room/provider/firestore_provider.dart';
import 'package:bachelor_room/screens/post_property/post_property_widgets.dart';
import 'package:bachelor_room/widget/app_widgets.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostProperty extends StatefulWidget {
  @override
  _PostPropertyState createState() => _PostPropertyState();
}

class _PostPropertyState extends State<PostProperty> {
  TextEditingController _addressController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String _errorText;

  @override
  void dispose() {
    super.dispose();
    _addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _fsProvider = Get.find<FirestoreProvider>();
    final double width = MediaQuery.of(context).size.width;
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
                    '  Post',
                    style: MTextStyle.darkheaderText,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: CustomPaint(
          painter: PostBackground(),
          child: Container(
            padding: const EdgeInsets.only(left: 20),
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: DropDownForm(),
                    ),
                    CCustomFormField(
                      'phone no *',
                      width * 0.8,
                      'ex: +91 9876543210',
                      (value) => _fsProvider.phoneNoSet = value,
                      (value) {
                        if (value.isEmpty) {
                          return 'please enter phone number';
                        }
                        if (value.length < 10) {
                          return 'phone number should be atleast 10 digit';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'address *',
                        style: MTextStyle.darkTitleText,
                      ),
                    ),
                    CAddressField(width, _addressController, _errorText),
                    Row(
                      children: [
                        CCustomFormField(
                          'Rent *',
                          width * 0.4,
                          'ex: 5000 / -',
                          (value) => _fsProvider.rentSet = value,
                          (value) {
                            if (value.isEmpty) {
                              return 'please enter rent amount';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        CCustomFormField(
                          'Deposit *',
                          width * 0.4,
                          'ex: 50000 / -',
                          (value) => _fsProvider.depositSet = value,
                          (value) {
                            if (value.isEmpty) {
                              return 'please enter deposit amount';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Contact time',
                        style: MTextStyle.titleText,
                      ),
                    ),
                    Row(
                      children: [
                        ContactTime(
                          title: 'from',
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        ContactTime(
                          title: 'to',
                        ),
                      ],
                    ),
                    OverviewToggle(
                      title: 'Bike Parking',
                      onchanged: (bool newValue) {
                        _fsProvider.bikeParkSet = newValue;
                      },
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      child: GetBuilder<FirestoreProvider>(
                        builder: (controller) {
                          if (controller.loadingIndicator) {
                            return CircularProgressIndicator(
                              color: MColors.redButtonColor,
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton:
            // Visibility(
            //   //to hide fab button when keyboard is opened
            //   visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
            //   child:
            CWideElevatedBtn(
          'upload image',
          150,
          const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          MTextStyle.whiteButtonText,
          MColors.redButtonColor,
          0,
          12,
          () async {
            if (_fsProvider.iam != null) {
              if (_formkey.currentState.validate()) {
                await _fsProvider.moveToImagePage(_addressController.text);
                if (_fsProvider.adrsResPost == null) {
                  _formkey.currentState.save();
                  Get.offAndToNamed('/imagePage');
                }
                setState(
                  () {
                    _errorText = _fsProvider.adrsResPost;
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}

class PostBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path ovalPath = Path();
    ovalPath.moveTo(0, height);
    ovalPath.lineTo(0, height * 0.65);
    ovalPath.quadraticBezierTo(
        width * 0.25, height * 0.82, width, height * 0.75);
    ovalPath.lineTo(width, height);
    ovalPath.close();
    paint.color = MColors.backgroundColor;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(PostBackground oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(PostBackground oldDelegate) =>
      oldDelegate != this;
}
