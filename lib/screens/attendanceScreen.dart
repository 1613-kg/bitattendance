import 'package:bitattendance/constants.dart';
import 'package:bitattendance/model/studentsData.dart';
import 'package:bitattendance/widgets/emptyText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/database_services.dart';
import '../widgets/loading.dart';

class attendanceScreen extends StatefulWidget {
  String sectionId;

  attendanceScreen({super.key, required this.sectionId});

  @override
  State<attendanceScreen> createState() => _attendanceScreenState();
}

class _attendanceScreenState extends State<attendanceScreen> {
  DateTime _attendanceDate = DateTime.now();
  List<StudentsData> _updated = [];
  Stream? section;
  bool isLoading = false;
  List<bool> _value = [];
  getsectionData() async {
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getSectionId(widget.sectionId)
        .then((value) {
      setState(() {
        section = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsectionData();
    _value = List.filled(1000, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          DateFormat.yMd().format(_attendanceDate),
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
      ),
      body: (isLoading)
          ? loading()
          : Column(
              children: [
                // Container(
                //   padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                //   width: double.infinity,
                //   child: ElevatedButton(
                //       onPressed: () {
                //         datepicker();
                //       },
                //       child: Text("Change Date")),
                // ),
                StreamBuilder(
                  stream: section,
                  builder: ((context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var dataList = snapshot.data['students'];
                      if (snapshot.data['students'] != null) {
                        if (dataList.length != 0) {
                          return ListView.separated(
                            padding: EdgeInsets.all(10),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 10,
                              );
                            },
                            itemCount: dataList.length,
                            itemBuilder: (context, index) {
                              String studentId = dataList[index];
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("students")
                                      .doc(studentId)
                                      .snapshots(),
                                  builder: ((context, AsyncSnapshot snapshot2) {
                                    if (snapshot2.hasData) {
                                      if (snapshot2.data != null) {
                                        var data2 = snapshot2.data;
                                        Map<String, bool> isPresent =
                                            data2['isPresent']
                                                .cast<String, bool>();
                                        // if (!isPresent.containsKey(
                                        //     DateFormat.yMd()
                                        //         .format(_attendanceDate))) {
                                        isPresent[DateFormat.yMd()
                                                .format(_attendanceDate)] =
                                            _value[index];
                                        _updated.add(StudentsData(
                                            id: data2['studentId'],
                                            name: data2['name'],
                                            rollNo: data2['rollNo'],
                                            isPresent: isPresent));
                                        // }

                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.purpleAccent
                                                .withOpacity(0.1),
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: Colors.black54,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ListTile(
                                            title: Text(data2['name']),
                                            leading: CircleAvatar(
                                              child: Text(data2['name'][0]),
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.3),
                                              radius: 30,
                                            ),
                                            subtitle: Text(data2['rollNo']),
                                            trailing: Checkbox(
                                                value: _value[index],
                                                onChanged: (bool? val) {
                                                  setState(() {
                                                    _value[index] = val!;

                                                    isPresent[DateFormat.yMd()
                                                            .format(
                                                                _attendanceDate)] =
                                                        _value[index];
                                                    _updated[index] =
                                                        (StudentsData(
                                                            id: data2[
                                                                'studentId'],
                                                            name: data2['name'],
                                                            rollNo:
                                                                data2['rollNo'],
                                                            isPresent:
                                                                isPresent));
                                                  });
                                                }),
                                          ),
                                        );
                                      } else
                                        return emptyText();
                                    } else
                                      return emptyText();
                                  }));
                            },
                          );
                        } else
                          return emptyText();
                      } else
                        return emptyText();
                    } else
                      return loading();
                  }),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: ElevatedButton(
                      onPressed: () {
                        _updateStudentAttendance();
                      },
                      child: Text("Save attendance")),
                ),
              ],
            ),
    );
  }

  _updateStudentAttendance() async {
    for (int i = 0; i < _updated.length; i++) {
      _updateData(_updated[i]);
    }
    showSnackbar(context, Colors.green, "Attendance saved Successfully");
    Navigator.pop(context);
  }

  _updateData(StudentsData studentsData) async {
    setState(() {
      isLoading = true;
    });
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .updatingStudentsData(studentsData)
        .whenComplete(() => isLoading = false);
  }

  void datepicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) return;
      setState(() {
        _attendanceDate = value;
      });
    });
  }
}
