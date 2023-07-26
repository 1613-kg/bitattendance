import 'package:bitattendance/model/departmentData.dart';
import 'package:bitattendance/services/database_services.dart';
import 'package:bitattendance/widgets/departmentListTile.dart';
import 'package:bitattendance/widgets/emptyText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/addDepartment.dart';
import '../widgets/loading.dart';

class departmentScreen extends StatefulWidget {
  const departmentScreen({super.key});

  @override
  State<departmentScreen> createState() => _departmentScreenState();
}

class _departmentScreenState extends State<departmentScreen> {
  Stream? department;

  getDepartmentData() async {
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getDepartmentData()
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
          "Departments",
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
          _addDepartmentData(context);
        },
        child: Icon(Icons.add),
        isExtended: true,
      ),
      body: StreamBuilder(
        stream: department,
        builder: ((context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              var dataList = snapshot.data.docs;
              if (dataList.length != 0) {
                return ListView.separated(
                    padding: EdgeInsets.all(10),
                    itemBuilder: ((context, index) {
                      final data = dataList[index];
                      return departmentListTile(
                        departmentData: DepartmentData(
                            id: data['deptId'],
                            name: data['name'],
                            head: data['head'],
                            batches: data['batches'].cast<String>(),
                            addedBy: data['addedBy']),
                      );
                    }),
                    separatorBuilder: ((context, index) {
                      return SizedBox(
                        height: 10,
                      );
                    }),
                    itemCount: dataList.length);
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

  void _addDepartmentData(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          child: addDepartment(),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }
}
