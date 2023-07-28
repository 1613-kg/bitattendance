import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class blogDetailsWidget extends StatelessWidget {
  String title;
  String content;
  blogDetailsWidget({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$title: ",
          style: TextStyle(fontSize: 15),
        ),
        Container(
          width: 230,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.white30, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          // child: SizedBox(
          //   width: 120.0,
          //   child: Text(
          //     content,
          //     maxLines: 5,
          //     overflow: TextOverflow.ellipsis,
          //     softWrap: false,
          //     style: TextStyle(
          //         color: Colors.black,
          //         fontWeight: FontWeight.bold,
          //         fontSize: 15.0),
          //   ),
          // ),
          child: AutoSizeText(
            content,
            //textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
