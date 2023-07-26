import 'package:bitattendance/model/studentsData.dart';
import 'package:bitattendance/screens/searchDate.dart';
import 'package:flutter/material.dart';

class studentsDescScreen extends StatelessWidget {
  StudentsData studentsData;
  studentsDescScreen({super.key, required this.studentsData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "${studentsData.name}(${studentsData.rollNo})",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => searchDate(
                              studentsData: studentsData,
                            )));
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: Container(
        child: ListView.separated(
            itemBuilder: ((context, index) {
              var dataList = studentsData.isPresent.entries.toList();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: (index == 0)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Date",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                "Status",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(dataList[index - 1].key),
                              (dataList[index - 1].value)
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
            itemCount: studentsData.isPresent.length + 1),
      ),
    );
  }
}
