import 'package:bitattendance/model/batchesData.dart';
import 'package:bitattendance/screens/sectionScreen.dart';
import 'package:flutter/material.dart';

class batchListTile extends StatelessWidget {
  BatchesData batchesData;
  batchListTile({super.key, required this.batchesData});

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
                  builder: (context) => sectionScreen(
                        batchesData: batchesData,
                      )));
        },
        title: Text(batchesData.batch),
        leading: Icon(Icons.group),
      ),
    );
  }
}
