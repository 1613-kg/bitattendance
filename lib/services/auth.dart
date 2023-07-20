import 'dart:io';

import 'package:bitattendance/constants.dart';
import 'package:bitattendance/model/userData.dart';
import 'package:bitattendance/screens/otp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthProvider() {
    chechSignIn();
  }

  void chechSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedIn") ?? false;
    notifyListeners();
  }

  void signInWithPhone(String phone, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: ((verificationId, forceResendingToken) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => otpScreen(
                          verificationId: verificationId,
                        )));
          }),
          codeAutoRetrievalTimeout: (verificationID) {});
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, Colors.red, e.message);
    }
  }

  void verifyOtp(
      {required BuildContext context,
      required String verificatonId,
      required String otp,
      required Function onSuccess}) async {
    _isLoading = true;
    notifyListeners();
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificatonId, smsCode: otp);
      User user = (await _firebaseAuth.signInWithCredential(credential)).user!;
      if (user != null) {
        _uid = user.uid;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, Colors.red, e.message);
    }
  }

  Future<String> uploadProPic(File? image) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('profilePics')
        .child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image!);
    TaskSnapshot snapshot = await uploadTask;
    String imageDwnUrl = await snapshot.ref.getDownloadURL();
    return imageDwnUrl;
  }

  void signOut() async {
    await _firebaseAuth.signOut();
  }
}
