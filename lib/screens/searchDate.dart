import 'package:bitattendance/model/studentsData.dart';

import 'package:flutter/material.dart';

class searchDate extends StatefulWidget {
  StudentsData studentsData;
  searchDate({super.key, required this.studentsData});

  @override
  State<searchDate> createState() => _searchDateState();
}

class _searchDateState extends State<searchDate> {
  TextEditingController _searchController = TextEditingController();
  Map<String, bool?> documents = {};
  String searchText = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    documents = widget.studentsData.isPresent;
  }

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
                        widget.studentsData.isPresent.containsKey(searchText)
                            ? documents = {
                                searchText:
                                    widget.studentsData.isPresent[searchText]
                              }
                            : documents = {};
                      });
                    },
                    controller: _searchController,
                    decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search Date",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                Container(
                  child: (documents.length == 0)
                      ? Center(
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "No data for entered date,please check your date carefully.",
                                textAlign: TextAlign.center,
                              )),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 2),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(documents.keys.toString()),
                                      (documents == true)
                                          ? Text(
                                              "Present",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              "Absent",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                          separatorBuilder: ((context, index) {
                            return SizedBox(
                              height: 0,
                            );
                          }),
                          itemCount: documents.length),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
