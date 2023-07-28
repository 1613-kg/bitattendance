import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bitattendance/screens/homeScreen.dart';
import 'package:bitattendance/screens/profileRegisterScreen.dart';
import 'package:flutter/material.dart';

class successScreen extends StatelessWidget {
  bool isExists;
  successScreen({super.key, required this.isExists});

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.sizeOf(context).height;
    var w = MediaQuery.sizeOf(context).width;
    return Scaffold(
        body: AnimatedSplashScreen(
      duration: 1200,
      backgroundColor: Colors.green,
      splashIconSize: h,
      splash: Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                "assets/images/success.jpg",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Success".toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ],
        )),
      ),
      nextScreen: (isExists) ? homeScreen() : profileRegisterScreen(),
    ));
  }
}
