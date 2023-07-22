import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bitattendance/screens/homeScreen.dart';
import 'package:bitattendance/screens/loginScreen.dart';
import 'package:bitattendance/screens/sliderScreen.dart';
import 'package:bitattendance/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/loginData.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  bool isSigned = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await LoginData.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          isSigned = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.sizeOf(context).height;
    var w = MediaQuery.sizeOf(context).width;
    return Scaffold(
        body: AnimatedSplashScreen(
      duration: 1200,
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      splashIconSize: h,
      splash: Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              child: Image.asset("assets/images/logo.jpg"),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "BIT Attendance Management".toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        )),
      ),
      nextScreen: (isSigned == true) ? homeScreen() : sliderScreen(),
    ));
  }
}
