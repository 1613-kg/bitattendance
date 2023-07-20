import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseServices extends ChangeNotifier {
  String uid;
  DatabaseServices({required this.uid});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    if (snapshot.exists)
      return true;
    else
      return false;
  }

  Future saveUserData(String firstName, String lastName, String email,
      String department, String profilePic) async {
    return await userCollection.doc(uid).set({
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phoneNumber": FirebaseAuth.instance.currentUser!.phoneNumber,
      "profilePic": profilePic,
      "uid": uid,
      "department": department,
    });
  }

  getUserData() async {
    return userCollection.doc(uid).snapshots();
  }

  Future deletingUserData() async {
    return await userCollection.doc(uid).delete();
  }
}
