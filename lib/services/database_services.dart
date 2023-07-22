import 'package:bitattendance/model/eventData.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class DatabaseServices extends ChangeNotifier {
  String uid;
  DatabaseServices({required this.uid});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection("events");

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

  Future savingEventData(EventData data) async {
    DocumentReference eventDocumentReference = await eventCollection.add({
      "eventType": data.type,
      "eventId": '',
      "eventName": data.name,
      "eventVenue": data.location,
      "startDate": data.startDate,
      "startTime": data.startTime,
      "endDate": data.endDate,
      "endTime": data.endTime,
      "description": data.description,
      "images": data.images,
      "addedBy": uid,
    });
    await eventDocumentReference.update({
      "eventId": eventDocumentReference.id,
    });
  }

  Future updatingEventData(EventData eventData) async {
    await eventCollection.doc(eventData.eventId).update({
      "eventType": eventData.type,
      "eventId": eventData.eventId,
      "eventName": eventData.name,
      "eventVenue": eventData.location,
      "startDate": eventData.startDate,
      "startTime": eventData.startTime,
      "endDate": eventData.endDate,
      "endTime": eventData.endTime,
      "description": eventData.description,
      "images": eventData.images,
      "addedBy": uid,
    });
  }

  getEventData() async {
    return eventCollection.snapshots();
  }

  Future deletingEventData(EventData eventData) async {
    await eventCollection.doc(eventData.eventId).delete();
  }
}
