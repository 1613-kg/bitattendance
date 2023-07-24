import 'package:bitattendance/model/sectionsData.dart';
import 'package:bitattendance/model/studentsData.dart';
import 'package:bitattendance/widgets/addStudents.dart';
import 'package:bitattendance/widgets/studentListTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/database_services.dart';
import '../widgets/loading.dart';

class studentsScreen extends StatefulWidget {
  SectionsData sectionsData;
  studentsScreen({super.key, required this.sectionsData});

  @override
  State<studentsScreen> createState() => _studentsScreenState();
}

class _studentsScreenState extends State<studentsScreen> {
  Stream? section;

  getsectionData() async {
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getSectionId(widget.sectionsData.id)
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Students",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addStudentsData(context);
        },
        child: Icon(Icons.add),
        isExtended: true,
      ),
      body: StreamBuilder(
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
                    String sectionId = dataList[index];

                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("students")
                            .doc(sectionId)
                            .snapshots(),
                        builder: ((context, AsyncSnapshot snapshot2) {
                          if (snapshot2.hasData) {
                            if (snapshot2.data != null) {
                              var data2 = snapshot2.data;
                              return studentListTile(
                                  studentsData: StudentsData(
                                      id: data2['studentId'],
                                      name: data2['name'],
                                      rollNo: data2['rollNo'],
                                      isPresent: data2['isPresent']
                                          .cast<String, bool>()));
                            } else
                              return Container();
                          } else
                            return loading();
                        }));
                    // int reverseIndex = dataList.length - index - 1;
                  },
                );
              } else
                return Container();
            } else
              return Container();
          } else
            return loading();
        }),
      ),
    );
  }

  void _addStudentsData(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          child: addStudents(
            sectionId: widget.sectionsData.id,
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }
}
