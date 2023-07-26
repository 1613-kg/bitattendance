import 'package:bitattendance/model/sectionsData.dart';
import 'package:bitattendance/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../services/database_services.dart';

class addSection extends StatefulWidget {
  String batchId;
  addSection({super.key, required this.batchId});

  @override
  State<addSection> createState() => _addSection();
}

class _addSection extends State<addSection> {
  final formKey = GlobalKey<FormState>();
  String name = "";
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: (isLoading)
            ? loading()
            : Form(
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
                          hintText: "Enter section name",
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
                          _addSectionData();
                        },
                        child: Text("Save")),
                  ],
                ),
              ),

        //),
      ),
    );
  }

  _addSectionData() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
          .savingSectionData(
              SectionsData(id: '', name: name, students: []), widget.batchId)
          .whenComplete(() => isLoading = false);
      Navigator.pop(context);
      showSnackbar(context, Colors.green, "Data saved Successfully");
    }
  }
}
