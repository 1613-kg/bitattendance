import 'package:bitattendance/model/batchesData.dart';
import 'package:bitattendance/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../services/database_services.dart';

class addBatch extends StatefulWidget {
  String deptId;
  addBatch({super.key, required this.deptId});

  @override
  State<addBatch> createState() => _addBatch();
}

class _addBatch extends State<addBatch> {
  final formKey = GlobalKey<FormState>();
  String name = "";
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
                          hintText: "Enter batch name",
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
                          _addBatchData();
                        },
                        child: Text("Save")),
                  ],
                ),
              ),

              //),
            ),
    );
  }

  _addBatchData() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
          .savingBatchData(
              BatchesData(id: '', batch: name, sections: []), widget.deptId)
          .whenComplete(() => isLoading = false);
      Navigator.pop(context);
      showSnackbar(context, Colors.green, "Data saved Successfully");
    }
  }
}
