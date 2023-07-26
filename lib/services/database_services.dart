import 'package:bitattendance/model/batchesData.dart';
import 'package:bitattendance/model/departmentData.dart';
import 'package:bitattendance/model/eventData.dart';
import 'package:bitattendance/model/sectionsData.dart';
import 'package:bitattendance/model/studentsData.dart';

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

  final CollectionReference departmentCollection =
      FirebaseFirestore.instance.collection("department");

  final CollectionReference batchCollection =
      FirebaseFirestore.instance.collection("batch");

  final CollectionReference sectionCollection =
      FirebaseFirestore.instance.collection("section");

  final CollectionReference studentCollection =
      FirebaseFirestore.instance.collection("students");

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

  Future savingDepartmentData(DepartmentData departmentData) async {
    DocumentReference departmentDocumentReference =
        await departmentCollection.add({
      "deptId": '',
      "name": departmentData.name,
      "head": departmentData.head,
      "addedBy": uid,
      "batches": departmentData.batches,
    });
    await departmentDocumentReference.update({
      "deptId": departmentDocumentReference.id,
    });
  }

  getDepartmentData() async {
    return departmentCollection.where('addedBy', isEqualTo: uid).snapshots();
  }

  getDepartmentId(String deptId) async {
    return departmentCollection.doc(deptId).snapshots();
  }

  Future savingBatchData(BatchesData batchesData, String deptId) async {
    DocumentReference batchDocumentReference = await batchCollection.add({
      "batchId": '',
      "name": batchesData.batch,
      "sections": batchesData.sections,
    });
    await batchDocumentReference.update({
      "batchId": batchDocumentReference.id,
    });

    DocumentReference departmentDocumentReference =
        departmentCollection.doc(deptId);
    return await departmentDocumentReference.update({
      "batches": FieldValue.arrayUnion(["${batchDocumentReference.id}"])
    });
  }

  getBatchId(String batchID) async {
    return batchCollection.doc(batchID).snapshots();
  }

  Future savingSectionData(SectionsData sectionsData, String batchId) async {
    DocumentReference sectionDocumentReference = await sectionCollection.add({
      "sectionId": '',
      "name": sectionsData.name,
      "students": sectionsData.students,
    });
    await sectionDocumentReference.update({
      "sectionId": sectionDocumentReference.id,
    });

    DocumentReference batchDocumentReference = batchCollection.doc(batchId);
    return await batchDocumentReference.update({
      "sections": FieldValue.arrayUnion(["${sectionDocumentReference.id}"])
    });
  }

  getSectionId(String sectionId) async {
    return sectionCollection.doc(sectionId).snapshots();
  }

  Future savingStudentsData(StudentsData studentsData, String sectionId) async {
    DocumentReference studentDocumentReference = await studentCollection.add({
      "studentId": '',
      "name": studentsData.name,
      "rollNo": studentsData.rollNo,
      "isPresent": studentsData.isPresent,
    });
    await studentDocumentReference.update({
      "studentId": studentDocumentReference.id,
    });

    DocumentReference sectionDocumentReference =
        sectionCollection.doc(sectionId);
    return await sectionDocumentReference.update({
      "students": FieldValue.arrayUnion(["${studentDocumentReference.id}"])
    });
  }

  Future updatingStudentsData(StudentsData studentsData) async {
    await studentCollection.doc(studentsData.id).update({
      "isPresent": studentsData.isPresent,
    });

    // DocumentReference studentDocumentReference =
    //     studentCollection.doc(studentsData.id);
    // return await studentDocumentReference.update({
    //   "isPresent": FieldValue.arrayUnion(elements)
    // });
  }

  getStudentsData() async {
    return studentCollection.snapshots();
  }
}
