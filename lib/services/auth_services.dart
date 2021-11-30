import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  Stream<User> authStateChange() {
    return _auth.authStateChanges();
  }

  ///google signin///
  Future<String> googleLogin() async {
    //dont know why/how he is setting the isSigningIn like this,
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return 'Couldn\'t sign in now';
    } else {
      try {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
        Get.back();
        return 'Successfully Signed in with Google';
      } catch (e) {
        return e.toString();
      }
    }
  }

  void googleLogout() async {
    try {
      await _googleSignIn.disconnect();
      await _auth.signOut();
    } catch (e) {}
  }

  ///google signin///

  ///regular sign in and sign up///
  ///signIn
  Future signInP(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.back(closeOverlays: true);
    } catch (e) {
      Get.back();
      Get.snackbar(
        'error logging in',
        'User doesn\'t exist. Login with different email or try SigningUp',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 5),
      );
    }
  }

  ///signUp
  Future<bool> signUpP(String email, String password) async {
    try {
      dynamic result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result != null) {
        _auth.currentUser.sendEmailVerification();
      }
      return true;
    } catch (e) {
      Get.back();
      Get.snackbar('error creating account', e.message,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  ///signOut
  Future<void> signOutP() async {
    try {
      await _auth.signOut();
    } catch (e) {}
  }

  ///getCurrentUserId
  Future<String> getCurrentUidP() async {
    if (_auth.currentUser.uid == null) {
      //its important to reload the current user to know the email is varified or not
      //i first thougnt of using stream but emailverified is a variable type of bool
      //so i cannot use the method i learned in authstate changed above
      await _auth.currentUser.reload();
      return _auth.currentUser?.uid;
    }
    return _auth.currentUser?.uid;
  }

  /// check if email is verified
  Future<bool> isEmailVerifiedP() async {
    if (!_auth.currentUser.emailVerified) {
      await _auth.currentUser.reload();
      return _auth.currentUser.emailVerified;
    }
    return true;
  }

  ///send email verification message
  void sendEmailVerificationP() {
    _auth.currentUser.sendEmailVerification();
  }

  ///get email id
  String get emailIdP {
    String _email = _auth.currentUser?.email;
    return _email;
  }

  ///is user logged in
  User get isLoggedIn => _auth.currentUser;

  //send password reset email
  void sendResetPasswordRequest(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }
}
