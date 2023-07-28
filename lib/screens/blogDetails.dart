import 'package:bitattendance/model/blogData.dart';
import 'package:bitattendance/screens/updateBlogData.dart';
import 'package:bitattendance/widgets/blogDetailsWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../services/auth.dart';
import '../services/database_services.dart';
import '../widgets/imageSlider.dart';

class blogDetails extends StatelessWidget {
  BlogData blogData;
  String userName;
  blogDetails({super.key, required this.blogData, required this.userName});

  @override
  Widget build(BuildContext context) {
    final canEdit =
        (FirebaseAuth.instance.currentUser!.uid == blogData.addedBy);
    final data = blogData;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          data.title,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.purple,
        actions: [
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 1,
                child: Text("Update"),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text("Delete"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 1) {
              (canEdit)
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => updateBlogData(blogData: data)))
                  : showSnackbar(context, Colors.red, "Only author has rights");
            } else if (value == 2) {
              final ap = Provider.of<AuthProvider>(context, listen: false);
              (canEdit)
                  ? ap.deleteEventPic(blogData.date).whenComplete(() async {
                      await DatabaseServices(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .deletingBlogData(blogData)
                          .whenComplete(() {
                        showSnackbar(
                            context, Colors.red, "Event deleted successfully");
                        Navigator.pop(context);
                      });
                    })
                  : showSnackbar(context, Colors.red, "Only author has rights");
            }
          }),
        ],
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
