import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class eventDetailsWidget extends StatelessWidget {
  String title;
  String content;
  eventDetailsWidget({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black38, width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$title: ",
              style: TextStyle(fontSize: 15),
            ),
            AutoSizeText(
              content,
              softWrap: true,
              style: TextStyle(fontSize: 10),
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              //overflowReplacement: Text('Sorry String too long'),
            ),
          ],
        ));
  }
}
