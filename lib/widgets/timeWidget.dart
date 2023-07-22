import 'package:flutter/material.dart';

class timeWidget extends StatefulWidget {
  String title;
  TimeOfDay time;
  timeWidget({super.key, required this.time, required this.title});

  @override
  State<timeWidget> createState() => _timeWidgetState();
}

class _timeWidgetState extends State<timeWidget> {
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
                widget.time.format(context),
                style: TextStyle(fontSize: 17),
              ),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        )
      ],
    );
  }
}
