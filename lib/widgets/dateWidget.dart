import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class dateWidget extends StatefulWidget {
  String title;

  DateTime date;

  dateWidget({
    super.key,
    required this.title,
    required this.date,
  });

  @override
  State<dateWidget> createState() => _dateWidgetState();
}

class _dateWidgetState extends State<dateWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: 150,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black26, width: 1)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat.yMd().format(widget.date),
                style: TextStyle(fontSize: 17),
              ),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ],
    );
  }
}
