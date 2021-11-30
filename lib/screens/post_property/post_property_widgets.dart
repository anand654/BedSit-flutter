import 'package:bachelor_room/provider/firestore_provider.dart';
import 'package:bachelor_room/widget/app_widgets.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DropDownForm extends StatelessWidget {
  final List<String> iamAList = ['Homeowner', 'Realtor'];
  @override
  Widget build(BuildContext context) {
    final _fsProvider = Get.find<FirestoreProvider>();
    final _width = MediaQuery.of(context).size.width * 0.6;
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(vertical: 4),
      width: _width,
      child: DropdownButtonFormField(
        value: null,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(14.0),
          hintText: 'iam *',
          hintStyle: MTextStyle.hintText,
          filled: true,
          fillColor: MColors.textFieldColor,
          enabledBorder: MInputDecoration.borderdec,
          focusedBorder: MInputDecoration.borderdec,
          errorBorder: MInputDecoration.borderdec,
          focusedErrorBorder: MInputDecoration.borderdec,
        ),
        elevation: 0,
        items: iamAList
            .map(
              (iam) => DropdownMenuItem(
                value: iam,
                child: Text(
                  iam,
                  style: MTextStyle.titleText,
                ),
              ),
            )
            .toList(),
        validator: (value) {
          if (value == null) return 'select iam';
          return null;
        },
        onChanged: (newValue) {
          _fsProvider.iamSet = newValue;
        },
      ),
    );
  }
}

class ContactTime extends StatelessWidget {
  final String title;
  ContactTime({this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: GetBuilder<FirestoreProvider>(
        builder: (controller) {
          return ElevatedButton(
            child: title == 'from'
                ? Text(
                    'from ${controller.clFrom ?? ''}',
                    style: MTextStyle.hintText,
                  )
                : Text(
                    'to ${controller.clTo ?? ''}',
                    style: MTextStyle.hintText,
                  ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                MColors.textFieldColor,
              ),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              ),
              elevation: MaterialStateProperty.all(0.0),
            ),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              TimeOfDay _timePicked = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());
              if (_timePicked != null) {
                title == 'from'
                    ? controller.clFromSet = _timePicked.format(context)
                    : controller.clToSet = _timePicked.format(context);
              }
            },
          );
        },
      ),
    );
  }
}

class OverviewToggle extends StatelessWidget {
  final String title;
  final ValueChanged<bool> onchanged;
  OverviewToggle({
    this.title,
    @required this.onchanged,
  });
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FirestoreProvider>(
      builder: (controller) {
        bool _value = controller.bikePark;
        return ListTile(
          title: Text(
            _value ? '$title - Allowed' : '$title - Not Allowed',
            style: MTextStyle.titleText,
          ),
          trailing: Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              activeColor: MColors.redButtonColor,
              value: _value,
              onChanged: onchanged,
            ),
          ),
        );
      },
    );
  }
}

class CCustomFormField extends StatelessWidget {
  final String title;
  final double width;
  final String hint;
  final Function(String) onsaved;
  final String Function(String) validator;
  const CCustomFormField(
    this.title,
    this.width,
    this.hint,
    this.onsaved,
    this.validator,
  );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: MTextStyle.darkTitleText,
              ),
            ),
            Container(
              height: 45,
              child: TextFormField(
                maxLines: 1,
                keyboardType: title == 'address *'
                    ? TextInputType.text
                    : TextInputType.number,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(14.0),
                  hintText: hint,
                  hintStyle: MTextStyle.hintText,
                  filled: true,
                  fillColor: MColors.textFieldColor,
                  focusColor: MColors.cardColor,
                  focusedBorder: MInputDecoration.borderdec,
                  enabledBorder: MInputDecoration.borderdec,
                  errorBorder: MInputDecoration.borderdec,
                  focusedErrorBorder: MInputDecoration.borderdec,
                ),
                validator: validator,
                onSaved: onsaved,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CAddressField extends StatelessWidget {
  final double width;
  final TextEditingController addressController;
  final String errorText;
  const CAddressField(
    this.width,
    this.addressController,
    this.errorText,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // padding: const EdgeInsets.symmetric(vertical: 4),
            height: 45,
            width: width * 0.7,
            child: TextField(
              controller: addressController,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'ex: 7J4VXHHC+4X',
                hintStyle: MTextStyle.hintText,
                contentPadding: const EdgeInsets.all(14),
                filled: true,
                fillColor: MColors.textFieldColor,
                enabledBorder: MInputDecoration.borderdec,
                focusedBorder: MInputDecoration.borderdec,
                errorBorder: MInputDecoration.borderdec,
                focusedErrorBorder: MInputDecoration.borderdec,
                errorText: errorText,
                errorMaxLines: 2,
              ),
            ),
          ),
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            onPressed: () async => await Get.defaultDialog(
              title: 'Plus Codes',
              titleStyle: MTextStyle.darkheaderText,
              content: Column(
                children: [
                  Text(
                    'Plus Codes are based on latitude and longitude, and displayed as numbers and letters.',
                    style: MTextStyle.subtitleText,
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () =>
                        _whatIsPlusCode('https://maps.google.com/pluscodes/'),
                    child: Text('What are Plus Codes?'),
                  ),
                  TextButton(
                    onPressed: () => _whatIsPlusCode(
                        'https://storage.googleapis.com/madebygoog.appspot.com/grow-ext-cloud-images-uploads/plus_codes_demo_6E7C25B2.mp4'),
                    child: Text('How to find your plus codes?'),
                  ),
                  Text(
                    'Tap on PlusCode to copy it.',
                    style: MTextStyle.subtitleText,
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  CWideElevatedBtn(
                    'Cancel',
                    100,
                    const EdgeInsets.all(0),
                    MTextStyle.darkbuttonText,
                    MColors.lightButtonColor,
                    0,
                    10,
                    () => Get.back(),
                  ),
                ],
              ),
            ),
            icon: Icon(
              Icons.help,
              color: MColors.backgroundColor,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _whatIsPlusCode(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open the map.';
    }
  }
}

Widget phoneNumberQP(
  double width,
  TextEditingController addressController,
  String errorText,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        width: width,
        child: TextField(
          controller: addressController,
          decoration: InputDecoration(
            hintText: 'ex: 9876543210',
            hintStyle: MTextStyle.hintText,
            contentPadding: const EdgeInsets.all(14),
            filled: true,
            fillColor: MColors.textFieldColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MConstants.descBorRad),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MConstants.descBorRad),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MConstants.descBorRad),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MConstants.descBorRad),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            errorText: errorText,
          ),
        ),
      ),
    ],
  );
}
