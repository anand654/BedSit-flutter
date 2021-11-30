import 'package:bachelor_room/screens/signin_signup/signinwidgets.dart';
import 'package:bachelor_room/provider/auth_provider.dart';
import 'package:bachelor_room/widget/app_widgets.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class SignInUp extends StatefulWidget {
  @override
  _SignInUpState createState() => _SignInUpState();
}

class _SignInUpState extends State<SignInUp> {
  final _formkey = GlobalKey<FormState>();
  bool isSignin = true;
  String _email;
  String _password;
  String _confirmPassword;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final AuthProvider _authProvider = AuthProvider();
    final passwordValidator = MultiValidator(
      [
        RequiredValidator(errorText: 'password is required'),
        MinLengthValidator(6,
            errorText: 'password must be at least 6 digits long'),
      ],
    );
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MColors.backgroundColor,
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
                    'SignIn / SignUp',
                    style: MTextStyle.headerText,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: CustomPaint(
          painter: SignBackGround(),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              reverse: true,
              physics: BouncingScrollPhysics(),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CSignFormField(
                      _size.width * 0.9,
                      'email',
                      (value) => _email = value,
                      (value) => _email = value,
                      false,
                      EmailValidator(errorText: 'enter a valid email address'),
                    ),
                    CSignFormField(
                      _size.width * 0.9,
                      'password',
                      (value) => _password = value,
                      (value) => _password = value,
                      true,
                      passwordValidator,
                    ),
                    if (!isSignin)
                      CCPSignFormField(
                        _size.width * 0.9,
                        'password',
                        (value) => _confirmPassword = value,
                        (value) => _confirmPassword = value,
                        (val) => MatchValidator(
                          errorText: 'passwords do not match',
                        ).validateMatch(
                          val,
                          _password,
                        ),
                      ),
                    const SizedBox(
                      height: 8,
                    ),
                    CWideElevatedBtn(
                      isSignin ? 'sign in' : 'sign up',
                      180,
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      MTextStyle.whiteButtonText,
                      MColors.redButtonColor,
                      0,
                      14,
                      () async {
                        print(_confirmPassword);
                        if (_formkey.currentState.validate()) {
                          _formkey.currentState.save();
                          if (isSignin) {
                            await _authProvider.signin(
                                _email.trim(), _password.trim());
                          } else {
                            bool _signedUp = await _authProvider.signUp(
                                _email.trim(), _password.trim());
                            if (_signedUp) {
                              await Get.defaultDialog(
                                title: 'A email has been sent',
                                titleStyle: MTextStyle.darkheaderText,
                                content: Text(
                                  'please check your mailbox\nto verify the account',
                                  textAlign: TextAlign.center,
                                  style: MTextStyle.subtitleText,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Get.back(closeOverlays: true),
                                    child: Text(
                                      'close',
                                      style: MTextStyle.darkheaderText,
                                    ),
                                  ),
                                  // CElevatedBtn(
                                  //   'send verification email',
                                  //   0,
                                  //   10,
                                  //   MTextStyle.whiteButtonText,
                                  //   MColors.redButtonColor,
                                  //   () {
                                  //     _authProvider.sendEmailVarification();
                                  //     _authProvider.verifyEmailSentSet = true;
                                  //   },
                                  // )
                                ],
                              );
                            }
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    cSigninGoogleBtn(
                      () {
                        _authProvider.googleLogin();
                      },
                      'sign in with Google',
                      MTextStyle.darkbuttonText,
                      MColors.whiteColor,
                    ),
                    if (isSignin) CForgotPasswordBtn(),
                    // Divider(
                    //   thickness: 1,
                    // ),
                    if (!isSignin)
                      const SizedBox(
                        height: 10,
                      ),
                    CWideElevatedBtn(
                      isSignin ? 'sign up' : 'sign in',
                      180,
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      MTextStyle.darkbuttonText,
                      MColors.lightButtonColor,
                      0,
                      14,
                      () {
                        setState(() {
                          isSignin = !isSignin;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 14,
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
      ),
    );
  }
}

class SignBackGround extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path ovalPath = Path();
    ovalPath.moveTo(0, height);
    ovalPath.lineTo(0, height * 0.45);
    ovalPath.quadraticBezierTo(width * 0.5, height * 0.01, width, height * 0.3);
    ovalPath.lineTo(width, height);
    ovalPath.close();
    paint.color = MColors.swipeColor;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(SignBackGround oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(SignBackGround oldDelegate) =>
      oldDelegate != this;
}
