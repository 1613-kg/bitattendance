import 'package:bitattendance/model/batchesData.dart';
import 'package:bitattendance/model/sectionsData.dart';
import 'package:bitattendance/screens/sectionScreen.dart';
import 'package:flutter/material.dart';

import '../screens/studentsScreen.dart';

class sectionListTile extends StatelessWidget {
  SectionsData sectionsData;
  sectionListTile({super.key, required this.sectionsData});

  @override
  Widget build(BuildContext context) {
    return Container(
        //padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.purpleAccent.withOpacity(0.1),
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.black54, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => studentsScreen(
                            sectionsData: sectionsData,
                          )));
            },
            title: Text("Section ${sectionsData.name}"),
            leading: CircleAvatar(
              child: Text(sectionsData.name[0]),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
              radius: 22,
            )));
  }
}
