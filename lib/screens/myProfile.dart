import 'dart:io';

import 'package:bitattendance/services/auth.dart';
import 'package:bitattendance/services/database_services.dart';
import 'package:bitattendance/services/loginData.dart';
import 'package:bitattendance/widgets/loading.dart';
import 'package:bitattendance/widgets/myProfileInfo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class myProfile extends StatefulWidget {
  myProfile({super.key});

  @override
  State<myProfile> createState() => _myProfileState();
}

class _myProfileState extends State<myProfile> {
  Stream? userData;

  getUserData() async {
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserData()
        .then((value) {
      setState(() {
        userData = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  File? img;
  void pickImage(ImageSource src, BuildContext context) async {
    final file = await ImagePicker().pickImage(source: src);
    File image = File(file!.path);
    File compressedImage = await customCompressed(image);

    setState(() {
      img = compressedImage;
    });
  }

  Future<File> customCompressed(File imagePath) async {
    var path = await FlutterNativeImage.compressImage(imagePath.absolute.path,
        quality: 100, percentage: 10);
    return path;
  }

  showDialogOpt(BuildContext context, String imageUrl) {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    pickImage(ImageSource.camera, context);
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.camera),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Camera"),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    pickImage(ImageSource.gallery, context);
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.album),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Gallery"),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    setState(() async {
                      final ap =
                          Provider.of<AuthProvider>(context, listen: false);
                      await ap.deleteProPic(imageUrl);
                      await LoginData.saveUserProfilePicSF("");
                    });

                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.remove),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Remove profile"),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.close),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Close"),
                    ],
                  ),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "My Profile",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
      ),
      body: StreamBuilder(
          stream: userData,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                final data = snapshot.data;
                return SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.purpleAccent.withOpacity(0.7)),
                          child: CachedNetworkImage(
                            height: 250,
                            width: 250,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(
                              Icons.person,
                              size: 150,
                            ),
                            filterQuality: FilterQuality.high,
                            imageUrl: data['profilePic'],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                            onPressed: () async {
                              showDialogOpt(context, data['profilePic']);
                              // final ap = Provider.of<AuthProvider>(context,
                              //     listen: false);
                              // await ap.updateProPic(img,data['profilePic']);
                            },
                            child: Text("Change Profile")),
                        Divider(
                          thickness: 2,
                          indent: 20,
                          endIndent: 20,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        myProfileInfo(
                          icon: Icons.person,
                          title:
                              "Username : ${data['firstName']} ${data['lastName']}",
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        myProfileInfo(
                          icon: Icons.email,
                          title: "Email : ${data['email']}",
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        myProfileInfo(
                          icon: Icons.category_outlined,
                          title: "Department : ${data['department']}",
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        myProfileInfo(
                          icon: Icons.contact_emergency,
                          title: "Phone number : ${data['phoneNumber']}",
                        ),
                      ],
                    ),
                  ),
                );
              } else
                return Container();
            } else
              return loading();
          }),
    );
  }
}
