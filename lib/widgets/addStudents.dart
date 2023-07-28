import 'package:bitattendance/model/studentsData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../services/database_services.dart';
import 'loading.dart';

class addStudents extends StatefulWidget {
  String sectionId;
  addStudents({super.key, required this.sectionId});

  @override
  State<addStudents> createState() => _addStudentsState();
}

class _addStudentsState extends State<addStudents> {
  @override
  final formKey = GlobalKey<FormState>();
  String name = "";
  String rollNo = "";
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: (isLoading)
          ? loading()
          : SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty)
                          return "Field cannot be empty";
                        else
                          return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          hintText: "Enter student name",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  width: 2))),
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    TextFormField(
                      onChanged: (val) {
                        setState(() {
                          rollNo = val;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty)
                          return "Field cannot be empty";
                        else
                          return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: "Enter Roll Number",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  width: 2))),
                    ),

                    SizedBox(
                      height: 25,
                    ),
                    //(widget.data.id == null)

                    ElevatedButton(
                        onPressed: () {
                          _addStudentsData();
                        },
                        child: Text("Save")),
                  ],
                ),
              ),

              //),
            ),
    );
  }

  _addStudentsData() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
          .savingStudentsData(
              StudentsData(id: '', name: name, rollNo: rollNo, isPresent: {}),
              widget.sectionId)
          .whenComplete(() => isLoading = false);
      Navigator.pop(context);
      showSnackbar(context, Colors.green, "Data saved Successfully");
    }
  }
}
