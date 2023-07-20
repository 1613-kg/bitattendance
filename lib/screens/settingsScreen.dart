import 'package:bitattendance/screens/loginScreen.dart';
import 'package:bitattendance/screens/myProfile.dart';
import 'package:bitattendance/services/auth.dart';
import 'package:bitattendance/widgets/mySettingsList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/database_services.dart';

class settingsScreen extends StatelessWidget {
  const settingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Settings",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SafeArea(
        child: Card(
          shape: LinearBorder(),
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: Column(
              children: [
                InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => myProfile()));
                    },
                    child: mySettingsList(
                        icon: Icons.person, title: "My Profile")),
                Divider(
                  thickness: 2,
                  indent: 15,
                  endIndent: 15,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 10,
                ),
                mySettingsList(icon: Icons.info_outline, title: "About us"),
                Divider(
                  thickness: 2,
                  indent: 15,
                  endIndent: 15,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 10,
                ),
                mySettingsList(icon: Icons.notes, title: "Terms & Conditions"),
                Divider(
                  thickness: 2,
                  indent: 15,
                  endIndent: 15,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete"),
                          content: const Text(
                              "Once account deleted can not be recovered!"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await DatabaseServices(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .deletingUserData();

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => loginScreen()));
                              },
                              child: Text(
                                "Confirm",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: mySettingsList(
                      icon: Icons.delete_rounded, title: "Delete account"),
                ),
                Divider(
                  thickness: 2,
                  indent: 15,
                  endIndent: 15,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                    onTap: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Logout"),
                            content:
                                const Text("Are you sure you want to logout?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  final ap = Provider.of<AuthProvider>(context,
                                      listen: false);
                                  ap.signOut();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => loginScreen()));
                                },
                                child: Text(
                                  "Confirm",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: mySettingsList(
                        icon: Icons.exit_to_app, title: "Logout")),
                Divider(
                  thickness: 2,
                  indent: 15,
                  endIndent: 15,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
