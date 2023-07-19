import 'package:bitattendance/screens/loginScreen.dart';
import 'package:bitattendance/widgets/sliderWidget.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

class sliderScreen extends StatefulWidget {
  const sliderScreen({super.key});

  @override
  State<sliderScreen> createState() => _sliderScreenState();
}

class _sliderScreenState extends State<sliderScreen> {
  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      renderSkipBtn: Text(
        "Skip",
        style: TextStyle(color: Colors.white),
      ),
      renderNextBtn: Text(
        "Next",
        style: TextStyle(color: Colors.white),
      ),
      renderDoneBtn: Text(
        "Done",
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      ),
      renderPrevBtn: Text(
        "Prev",
        style: TextStyle(color: Colors.white),
      ),
      listCustomTabs: [
        sliderWidget(
            title: "Login",
            description:
                "Select your country code,then enter your phone number and click on login button",
            imagePath: "assets/images/login.png"),
        sliderWidget(
            title: "Verification",
            description:
                "Enter the verifiation code recieved on the entered phone number then click on the verify button",
            imagePath: "assets/images/otp.jpg"),
        sliderWidget(
            title: "Congratulations",
            description: "You are ready to explore the application!",
            imagePath: "assets/images/success.png")
      ],
      scrollPhysics: BouncingScrollPhysics(),
      onDonePress: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => loginScreen(),
        ),
      ),
    );
  }
}
