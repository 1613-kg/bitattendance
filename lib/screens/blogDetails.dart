import 'package:bitattendance/model/blogData.dart';
import 'package:bitattendance/widgets/blogDetailsWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widgets/imageSlider.dart';

class blogDetails extends StatelessWidget {
  BlogData blogData;
  String userName;
  blogDetails({super.key, required this.blogData, required this.userName});

  @override
  Widget build(BuildContext context) {
    final data = blogData;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          data.title,
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
          child: Container(
        child: Column(
          children: [
            imageSlider(images: data.images),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  blogDetailsWidget(title: "Title", content: "${data.title}"),
                  SizedBox(
                    height: 20,
                  ),
                  blogDetailsWidget(title: "Label", content: "${data.label}"),
                  SizedBox(
                    height: 20,
                  ),
                  blogDetailsWidget(title: "Author", content: "${userName}"),
                  SizedBox(
                    height: 20,
                  ),
                  blogDetailsWidget(
                      title: "Description", content: "${data.description}"),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
