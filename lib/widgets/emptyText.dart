import 'package:flutter/material.dart';

class emptyText extends StatelessWidget {
  const emptyText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 50,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "No data has been added yet,click the add button to add data",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
