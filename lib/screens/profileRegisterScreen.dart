import 'dart:io';

import 'package:bitattendance/constants.dart';
import 'package:bitattendance/model/userData.dart';
import 'package:bitattendance/screens/homeScreen.dart';
import 'package:bitattendance/services/auth.dart';
import 'package:bitattendance/services/database_services.dart';
import 'package:bitattendance/services/loginData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class profileRegisterScreen extends StatefulWidget {
  const profileRegisterScreen({super.key});

  @override
  State<profileRegisterScreen> createState() => _profileRegisterScreenState();
}

class _profileRegisterScreenState extends State<profileRegisterScreen> {
  File? img;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _departmentController = TextEditingController();
  String profilePic = "";
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

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

  showDialogOpt(BuildContext context) {
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

  onContinue(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
          .saveUserData(
              _firstNameController.text.trim(),
              _lastNameController.text.trim(),
              _emailController.text.trim(),
              _departmentController.text.trim(),
              profilePic)
          .then((value) async {
        await LoginData.saveUserLoggedInStatus(true);
        await LoginData.saveFirstNameSF(_firstNameController.text.trim());
        await LoginData.saveLastNameSF(_lastNameController.text.trim());
        await LoginData.saveUserDepartmentSF(_departmentController.text.trim());
        await LoginData.saveUserEmailSF(_emailController.text.trim());
        await LoginData.saveUserPhoneNumberSF(
            FirebaseAuth.instance.currentUser!.phoneNumber.toString());
        await LoginData.saveUserProfilePicSF(profilePic);
      });
      setState(() {
        isLoading = false;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => homeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    showDialogOpt(context);
                  },
                  child: (img == null)
                      ? CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 60,
                          child: Icon(
                            Icons.account_circle,
                            size: 60,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(img!),
                          radius: 60,
                        ),
                ),
                SizedBox(
                  height: 50,
                ),
                textField(
                    validate: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return "Name cannot be empty";
                      }
                    },
                    hintText: "First name",
                    icon: Icons.person,
                    inputType: TextInputType.multiline,
                    controller: _firstNameController),
                SizedBox(
                  height: 10,
                ),
                textField(
                    validate: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return "Name cannot be empty";
                      }
                    },
                    hintText: "Last name",
                    icon: Icons.person,
                    inputType: TextInputType.multiline,
                    controller: _lastNameController),
                SizedBox(
                  height: 10,
                ),
                textField(
                    validate: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val!)
                          ? null
                          : "Please enter a valid email";
                    },
                    hintText: "Email",
                    icon: Icons.email,
                    inputType: TextInputType.emailAddress,
                    controller: _emailController),
                SizedBox(
                  height: 10,
                ),
                textField(
                    validate: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return "Feild cannot be empty";
                      }
                    },
                    hintText: "Department",
                    icon: Icons.category_outlined,
                    inputType: TextInputType.multiline,
                    controller: _departmentController),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (img != null) {
                          await ap.uploadProPic(img).then((value) {
                            setState(() {
                              profilePic = value;
                            });
                          });
                        }
                        onContinue(context);
                      },
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    )),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget textField(
      {required String hintText,
      required IconData icon,
      required TextInputType inputType,
      required TextEditingController controller,
      required final validate}) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        validator: validate,
        cursorColor: Colors.purpleAccent,
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(
              icon,
              color: Colors.purple,
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.purple)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.purple),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.purple),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.purple),
            ),
            border: InputBorder.none),
      ),
    );
  }
}
