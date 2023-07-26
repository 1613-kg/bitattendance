import 'package:bitattendance/model/studentsData.dart';
import 'package:bitattendance/screens/studentsDescScreen.dart';
import 'package:flutter/material.dart';

class studentListTile extends StatelessWidget {
  StudentsData studentsData;
  studentListTile({super.key, required this.studentsData});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  builder: (context) =>
                      studentsDescScreen(studentsData: studentsData)));
        },
        title: Text(studentsData.name),
        leading: CircleAvatar(
          child: Text(studentsData.name[0]),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
          radius: 30,
        ),
        subtitle: Text(studentsData.rollNo),
      ),
    );
  }
}
