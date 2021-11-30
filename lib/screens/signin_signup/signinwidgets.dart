import 'package:bachelor_room/provider/auth_provider.dart';
import 'package:bachelor_room/widget/app_widgets.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CSignFormField extends StatelessWidget {
  final double width;
  final String hint;
  final Function(String) onsave;
  final Function(String) onchange;
  final bool obTxt;
  final String Function(String) validator;
  const CSignFormField(
    this.width,
    this.hint,
    this.onsave,
    this.onchange,
    this.obTxt,
    this.validator,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        style: TextStyle(fontSize: 14),
        keyboardType: hint == 'email'
            ? TextInputType.emailAddress
            : TextInputType.visiblePassword,
        decoration: InputDecoration(
          prefixIcon:
              hint == 'email' ? Icon(Icons.person_outline) : Icon(Icons.lock),
          filled: true,
          fillColor: MColors.textFieldColor,
          isDense: true,
          hintText: hint,
          hintStyle: MTextStyle.hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MConstants.descBorRad),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MConstants.descBorRad),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MConstants.descBorRad),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MConstants.descBorRad),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
        ),
        validator: validator,
        onSaved: onsave,
        onChanged: onchange,
        obscureText: obTxt,
      ),
    );
  }
}

class CCPSignFormField extends StatefulWidget {
  final double width;
  final String hint;
  final Function(String) onsave;
  final Function(String) onchange;
  final String Function(String) validator;
  const CCPSignFormField(
    this.width,
    this.hint,
    this.onsave,
    this.onchange,
    this.validator,
  );

  @override
  _CCPSignFormFieldState createState() => _CCPSignFormFieldState();
}

class _CCPSignFormFieldState extends State<CCPSignFormField> {
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        style: TextStyle(fontSize: 14),
        keyboardType: widget.hint == 'email'
            ? TextInputType.emailAddress
            : TextInputType.visiblePassword,
        decoration: InputDecoration(
          prefixIcon: widget.hint == 'email'
              ? Icon(Icons.person_outline)
              : Icon(Icons.lock),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
            icon: _showPassword
                ? Icon(
                    Icons.visibility,
                    size: 20,
                  )
                : Icon(
                    Icons.visibility_off,
                    size: 20,
                  ),
          ),
          filled: true,
          fillColor: MColors.textFieldColor,
          isDense: true,
          hintText: widget.hint,
          hintStyle: MTextStyle.hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MConstants.descBorRad),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MConstants.descBorRad),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MConstants.descBorRad),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MConstants.descBorRad),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
        ),
        validator: widget.validator,
        onSaved: widget.onsave,
        onChanged: widget.onchange,
        obscureText: !_showPassword,
      ),
    );
  }
}

Widget cSigninGoogleBtn(
    VoidCallback onpressed, String title, TextStyle text, Color color) {
  return Container(
    width: 180,
    child: ElevatedButton(
      onPressed: onpressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.google,
            color: Colors.red,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: text,
          ),
        ],
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MConstants.descBorRad),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          color,
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            vertical: 12,
          ),
        ),
      ),
    ),
  );
}

class CForgotPasswordBtn extends StatelessWidget {
  final TextEditingController _resetEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _authProvider = Get.find<AuthProvider>();
    return Container(
      child: TextButton(
        onPressed: () {
          Get.defaultDialog(
            title: 'Forgot Password',
            titleStyle: MTextStyle.darkheaderText,
            content: Container(
              width: 350,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: TextField(
                controller: _resetEmailController,
                decoration: InputDecoration(
                  hintText: 'email',
                  hintStyle: MTextStyle.hintText,
                  contentPadding: const EdgeInsets.all(14),
                  filled: true,
                  fillColor: MColors.textFieldColor,
                  enabledBorder: MInputDecoration.borderdec,
                  focusedBorder: MInputDecoration.borderdec,
                  errorBorder: MInputDecoration.borderdec,
                  focusedErrorBorder: MInputDecoration.borderdec,
                  errorText: !_authProvider.resetPswdSent
                      ? 'Please Enter a Valid Email Address.'
                      : null,
                ),
              ),
            ),
            actions: [
              !_authProvider.resetPswdSent
                  ? CElevatedBtn(
                      'Forgot Password',
                      10,
                      10,
                      MTextStyle.whiteButtonText,
                      MColors.redButtonColor,
                      () async {
                        if (_resetEmailController.text.isEmail) {
                          _authProvider
                              .sendResetPswdEmail(_resetEmailController.text);
                          Get.back();
                        }
                      },
                    )
                  : Text(
                      'We have emailed your password reset link.',
                      style: MTextStyle.greenText,
                    ),
            ],
          );
        },
        child: Text('forgot password', style: MTextStyle.titleText),
      ),
    );
  }
}
