import 'package:bitattendance/model/studentsData.dart';
import 'package:bitattendance/widgets/studentListTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/database_services.dart';
import '../widgets/loading.dart';

class searchScreen extends StatefulWidget {
  searchScreen({super.key});

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  TextEditingController _searchController = TextEditingController();
  Stream? students;
  List<DocumentSnapshot> documents = [];

  getItemsData() async {
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getStudentsData()
        .then((value) {
      setState(() {
        students = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItemsData();
  }

  String searchText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Search",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    controller: _searchController,
                    decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                StreamBuilder(
                  stream: students,
                  builder: (ctx, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
                      return loading();
                    }

                    documents = snapshot.data.docs;

                    if (searchText.length > 0) {
                      documents = documents.where((element) {
                        return element
                            .get('name')
                            .toString()
                            .toLowerCase()
                            .contains(searchText.toLowerCase());
                      }).toList();
                    }

                    return ListView.separated(
                      padding: EdgeInsets.only(top: 10),
                      reverse: true,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: documents.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                      itemBuilder: (context, index) {
                        final data = documents[index];
                        return studentListTile(
                          studentsData: StudentsData(
                              id: data['studentId'],
                              name: data['name'],
                              rollNo: data['rollNo'],
                              isPresent:
                                  data['isPresent'].cast<String, bool>()),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
