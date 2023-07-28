import 'package:auto_size_text/auto_size_text.dart';
import 'package:bitattendance/model/blogData.dart';
import 'package:bitattendance/screens/blogDetails.dart';
import 'package:bitattendance/screens/updateBlogData.dart';
import 'package:bitattendance/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../services/database_services.dart';

class blogPreview extends StatefulWidget {
  BlogData blogData;
  blogPreview({super.key, required this.blogData});

  @override
  State<blogPreview> createState() => _blogPreviewState();
}

class _blogPreviewState extends State<blogPreview> {
  String userName = "";

  getUser(String id) async {
    QuerySnapshot snapshot =
        await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
            .gettingUserIdData(id);

    setState(() {
      userName = snapshot.docs[0]['firstName'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser(widget.blogData.addedBy);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => blogDetails(
                    blogData: widget.blogData, userName: userName)));
      },
      child: Container(
        width: double.infinity,
        height: 330,
        child: Card(
          child: Stack(children: [
            Image.network(
              widget.blogData.images[0],
              fit: BoxFit.cover,
              width: double.infinity,
              height: 235,
            ),
            Positioned(
              bottom: 50,
              left: 10,
              child: SizedBox(
                width: 200,
                child: AutoSizeText(
                  "Title: ${widget.blogData.title}",
                  //textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  softWrap: true,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: SizedBox(
                width: 200,
                child: AutoSizeText(
                  "Label: ${widget.blogData.label}",
                  //textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  softWrap: true,
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              right: 10,
              child: Text(
                "Date: ${DateFormat.yMd().format(widget.blogData.date)}",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Text(
                "Author: ${userName}",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
