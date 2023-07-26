import 'package:bitattendance/model/batchesData.dart';
import 'package:bitattendance/model/departmentData.dart';
import 'package:bitattendance/model/sectionsData.dart';
import 'package:bitattendance/widgets/addBatch.dart';
import 'package:bitattendance/widgets/addSection.dart';
import 'package:bitattendance/widgets/batchListTile.dart';
import 'package:bitattendance/widgets/emptyText.dart';
import 'package:bitattendance/widgets/sectionListTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/database_services.dart';
import '../widgets/loading.dart';

class sectionScreen extends StatefulWidget {
  BatchesData batchesData;
  sectionScreen({super.key, required this.batchesData});

  @override
  State<sectionScreen> createState() => _sectionScreen();
}

class _sectionScreen extends State<sectionScreen> {
  Stream? batch;

  getbatchData() async {
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getBatchId(widget.batchesData.id)
        .then((value) {
      setState(() {
        batch = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getbatchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Sections",
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
          _addSectionData(context);
        },
        child: Icon(Icons.add),
        isExtended: true,
      ),
      body: StreamBuilder(
        stream: batch,
        builder: ((context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var dataList = snapshot.data['sections'];
            if (snapshot.data['sections'] != null) {
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
                    String batchId = dataList[index];

                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("section")
                            .doc(batchId)
                            .snapshots(),
                        builder: ((context, AsyncSnapshot snapshot2) {
                          if (snapshot2.hasData) {
                            if (snapshot2.data != null) {
                              var data2 = snapshot2.data;
                              return sectionListTile(
                                  sectionsData: SectionsData(
                                      id: data2['sectionId'],
                                      name: data2['name'],
                                      students:
                                          data2['students'].cast<String>()));
                            } else
                              return emptyText();
                          } else
                            return emptyText();
                        }));
                    // int reverseIndex = dataList.length - index - 1;
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
    );
  }

  void _addSectionData(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          child: addSection(batchId: widget.batchesData.id),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }
}
