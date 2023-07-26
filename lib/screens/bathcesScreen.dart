import 'package:bitattendance/model/batchesData.dart';
import 'package:bitattendance/model/departmentData.dart';
import 'package:bitattendance/widgets/addBatch.dart';
import 'package:bitattendance/widgets/batchListTile.dart';
import 'package:bitattendance/widgets/emptyText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/database_services.dart';
import '../widgets/loading.dart';

class bathcesScreen extends StatefulWidget {
  DepartmentData departmentData;
  bathcesScreen({super.key, required this.departmentData});

  @override
  State<bathcesScreen> createState() => _bathcesScreenState();
}

class _bathcesScreenState extends State<bathcesScreen> {
  Stream? department;

  getDepartmentData() async {
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getDepartmentId(widget.departmentData.id)
        .then((value) {
      setState(() {
        department = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDepartmentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Batches",
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
          _addBatchData(context);
        },
        child: Icon(Icons.add),
        isExtended: true,
      ),
      body: StreamBuilder(
        stream: department,
        builder: ((context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var dataList = snapshot.data['batches'];
            if (snapshot.data['batches'] != null) {
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
                            .collection("batch")
                            .doc(batchId)
                            .snapshots(),
                        builder: ((context, AsyncSnapshot snapshot2) {
                          if (snapshot2.hasData) {
                            if (snapshot2.data != null) {
                              var data2 = snapshot2.data;
                              return batchListTile(
                                  batchesData: BatchesData(
                                      id: data2['batchId'],
                                      batch: data2['name'],
                                      sections:
                                          data2['sections'].cast<String>()));
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

  void _addBatchData(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          child: addBatch(deptId: widget.departmentData.id),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }
}
