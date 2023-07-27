import 'package:bitattendance/model/blogData.dart';
import 'package:bitattendance/screens/addBlog.dart';
import 'package:bitattendance/widgets/blogPreview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/database_services.dart';
import '../widgets/loading.dart';

class blog extends StatefulWidget {
  const blog({super.key});

  @override
  State<blog> createState() => _blogState();
}

class _blogState extends State<blog> {
  Stream? blog;

  getAllBlogData() async {
    await DatabaseServices(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ).getBlogData().then((snapshots) {
      setState(() {
        blog = snapshots;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllBlogData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blogs",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => addBlog()));
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: blog,
          builder: ((context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var dataList = snapshot.data.docs;
              // if (snapshot.data['stocks'] != null) {
              if (dataList.length != 0) {
                return ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: ((context, index) {
                      final data = dataList[index].data();
                      return blogPreview(
                          blogData: BlogData(
                              addedBy: data['addedBy'],
                              title: data['title'],
                              label: data['label'],
                              date: data['date'].toDate(),
                              description: data['description'],
                              blogId: data['blogId'],
                              images: data['images'].cast<String>()));
                    }));
              } else
                return Container();
              // } else
              //   return Container();
            } else
              return loading();
          }),
        ),
      ),
    );
  }
}
