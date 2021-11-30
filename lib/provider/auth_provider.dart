import 'package:bachelor_room/services/auth_services.dart';
import 'package:bachelor_room/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthProvider extends GetxController {
  AuthServices _authServices = AuthServices();
  Rxn<User> _user = Rxn<User>();

  String get authState => _user.value?.email;

  @override
  void onInit() {
    _user.bindStream(_authServices.authStateChange());
    super.onInit();
  }

  // /// sign in loading
  // bool _isSigningIn = false;
  // // //dont know why he declared _isSigningIn like this
  // // AuthProvider() {
  // //   _isSigningIn = false;
  // // }
  // bool get isSigningIn => _isSigningIn;
  // //observed this both getter and setter is of same name
  // //if i delete update(); line it is giving me an error,
  // set isSigningIn(bool value) {
  //   _isSigningIn = value;
  //   update();
  // }

  /// sign in loading

  /// sign in messege
  String _signInMsg = '';
  String get signInMsg => _signInMsg;
  set signInMsg(String msg) {
    _signInMsg = msg;
    update();
  }

  bool _isFnTriggered = false;
  bool get isFnTriggered => _isFnTriggered;
  set isFnTriggeredSet(bool value) {
    _isFnTriggered = value;
  }

  Future _loadingScreen(String loading) {
    return Get.dialog(
      Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: MColors.redButtonColor,
            ),
            Text(
              loading,
              style: MTextStyle.loadingText,
            )
          ],
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black12.withOpacity(0.6),
    );
  }

  /// sign in message

  ///google signin
  Future googleLogin() async {
    //dont know why/how he is setting the isSigningIn like this,
    if (isFnTriggered) return;
    isFnTriggeredSet = true;
    signInMsg = await _authServices.googleLogin();
    isFnTriggeredSet = false;
  }

  void googleLogout() async {
    _authServices.googleLogout();
  }

  ///google signin

  ///regular sign in operations

  ///sign in
  Future signin(String email, String password) async {
    if (isFnTriggered) return;
    isFnTriggeredSet = true;
    _loadingScreen('Signing in');
    await _authServices.signInP(email, password);
    isFnTriggeredSet = false;
  }

  ///sign up
  Future signUp(String email, String password) async {
    if (isFnTriggered) return;
    isFnTriggeredSet = true;
    _loadingScreen('Signing Up');
    bool signInMsg = await _authServices.signUpP(email, password);
    isFnTriggeredSet = false;
    return signInMsg;
  }

  ///sign out
  Future<void> signOut() async {
    if (isFnTriggered) return;
    isFnTriggeredSet = true;
    await _authServices.signOutP();
    isFnTriggeredSet = false;
  }

  ///get user id
  Future<String> get getCurrentUID async {
    String _currentUid = await _authServices.getCurrentUidP();
    return _currentUid;
  }

  ///find if user is already logged in
  User get isLoggedIn => _authServices.isLoggedIn;

  ///check if email is veerified

// it is to disable the button once verification mail sent.
  bool _verificationEmailSent = false;
  bool get verifyEmailSent => _verificationEmailSent;
  set verifyEmailSentSet(bool value) {
    _verificationEmailSent = value;
  }

  Future<bool> get isEmailVarified async {
    bool _emailVerified = await _authServices.isEmailVerifiedP();
    return _emailVerified;
  }

  /// Stream<User> get authState => _auth.authStateChanges();
  void sendEmailVarification() {
    _authServices.sendEmailVerificationP();
    Get.back();
    Get.snackbar('Verification email sent',
        'we have sent an email to your registered email address,\n please click the link included to verify your email address.');
  }

  ///email Id
  String get emailId {
    return _authServices.emailIdP;
  }

  bool _resetPswdSent = false;
  bool get resetPswdSent => _resetPswdSent;
  set resetPswdSentSet(bool value) {
    if (value != _resetPswdSent) _resetPswdSent = value;
  }

  ///regular sign in operations
  void sendResetPswdEmail(String email) {
    _authServices.sendResetPasswordRequest(email);
    resetPswdSentSet = true;
  }
}
