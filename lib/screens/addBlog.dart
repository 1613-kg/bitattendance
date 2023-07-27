import 'dart:io';

import 'package:bitattendance/model/blogData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../services/auth.dart';
import '../services/database_services.dart';
import '../widgets/loading.dart';

class addBlog extends StatefulWidget {
  addBlog({super.key});

  @override
  State<addBlog> createState() => _addBlogState();
}

class _addBlogState extends State<addBlog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _labelController = TextEditingController();
  List<File> _image = [];
  List<String> _imageUrl = [];
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  DateTime startDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Create",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
        ),
        body: SingleChildScrollView(
          child: (isLoading)
              ? loading()
              : Container(
                  margin: EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Blog Name",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            textField(
                                inputType: TextInputType.multiline,
                                controller: _nameController,
                                maxLine: 1),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Blog Description",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            textField(
                                inputType: TextInputType.multiline,
                                controller: _descController,
                                maxLine: 4),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Blog Label",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            textField(
                                inputType: TextInputType.multiline,
                                controller: _labelController,
                                maxLine: 2),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Images",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GridView.builder(
                          itemCount: _image.length + 1,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: ((context, index) {
                            return (index == 0)
                                ? IconButton(
                                    onPressed: () {
                                      showDialogOpt(context);
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      size: 30,
                                    ),
                                  )
                                : Stack(
                                    children: [
                                      Positioned(
                                        top: 25,
                                        right: 25,
                                        child: Container(
                                          height: 95,
                                          width: 95,
                                          child: Image.file(
                                            _image[index - 1],
                                            height: 95,
                                            width: 95,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              showSnackbar(context, Colors.red,
                                                  "Removed image at ${index}");
                                              _image.removeAt(index - 1);
                                            });
                                          },
                                          child: Icon(
                                            Icons.cancel_outlined,
                                            size: 35,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  _addBlogData();
                                },
                                child: Text("Save"))),
                      ],
                    ),
                  ),
                ),
        ));
  }

  Widget textField({
    required TextInputType inputType,
    required TextEditingController controller,
    required int maxLine,
  }) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: TextFormField(
        validator: (val) {
          if (val!.isNotEmpty) {
            return null;
          } else {
            return "Field cannot be empty";
          }
        },
        maxLines: maxLine,
        cursorColor: Colors.purpleAccent,
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
            //helperText: titleText,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.black26)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black26),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red),
            ),
            border: InputBorder.none),
      ),
    );
  }

  void pickImage(BuildContext context) async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);
    File image = File(file!.path);
    File compressedImage = await customCompressed(image);
    setState(() {
      _image.add(compressedImage);
    });
  }

  void pickMultipleImage(BuildContext context) async {
    final file = await ImagePicker().pickMultiImage();
    for (int i = 0; i < file.length; i++) {
      if (file[i] != null) {
        File image = File(file[i].path);
        File compressedImage = await customCompressed(image);
        setState(() {
          _image.add(compressedImage);
        });
      }
    }
  }

  Future<File> customCompressed(File imagePath) async {
    var path = await FlutterNativeImage.compressImage(imagePath.absolute.path,
        quality: 100, percentage: 10);
    return path;
  }

  showDialogOpt(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    pickImage(context);
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
                    pickMultipleImage(context);
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

  _addBlogData() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final ap = Provider.of<AuthProvider>(context, listen: false);
      if (_image == null || _image.length == 0) {
        showSnackbar(context, Colors.red, "Please upload 1 or more images");
        setState(() {
          isLoading = false;
        });
      } else {
        ap.uploadEventPictures(_image).then((value) {
          setState(() {
            _imageUrl = value;
          });
          DatabaseServices(
            uid: FirebaseAuth.instance.currentUser!.uid,
          )
              .savingBlogData(BlogData(
                  blogId: '',
                  date: DateTime.now(),
                  description: _descController.text.trim(),
                  label: _labelController.text.trim(),
                  title: _nameController.text.trim(),
                  addedBy: '',
                  images: _imageUrl))
              .whenComplete(() => isLoading = false);
          Navigator.pop(context);
          showSnackbar(context, Colors.green, "Data Uploaded Successfully");
        });
      }
    }
  }
}
