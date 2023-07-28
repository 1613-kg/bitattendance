import 'package:bitattendance/model/departmentData.dart';
import 'package:bitattendance/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../services/database_services.dart';

class addDepartment extends StatefulWidget {
  const addDepartment({super.key});

  @override
  State<addDepartment> createState() => _addDepartmentState();
}

class _addDepartmentState extends State<addDepartment> {
  final formKey = GlobalKey<FormState>();
  String name = "";
  String head = "";
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
                          hintText: "Enter department name",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      onChanged: (val) {
                        setState(() {
                          head = val;
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
                          hintText: "Enter head of department",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2))),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    //(widget.data.id == null)

                    ElevatedButton(
                        onPressed: () {
                          _addDepartmentData();
                        },
                        child: Text("Save")),
                  ],
                ),
              ),

              //),
            ),
    );
  }

  _addDepartmentData() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
          .savingDepartmentData(DepartmentData(
              id: '',
              name: name,
              head: head,
              batches: [],
              addedBy: FirebaseAuth.instance.currentUser!.uid))
          .whenComplete(() => isLoading = false);
      Navigator.pop(context);
      showSnackbar(context, Colors.green, "Data saved Successfully");
    }
  }
}
