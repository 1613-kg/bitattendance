import 'package:bitattendance/model/departmentData.dart';
import 'package:bitattendance/screens/bathcesScreen.dart';
import 'package:flutter/material.dart';

class departmentListTile extends StatelessWidget {
  DepartmentData departmentData;
  departmentListTile({
    super.key,
    required this.departmentData,
  });

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
                  builder: (context) => bathcesScreen(
                        departmentData: departmentData,
                      )));
        },
        title: Text(departmentData.name),
        subtitle: Text(departmentData.head),
        leading: Icon(Icons.category_outlined),
      ),
    );
  }
}
