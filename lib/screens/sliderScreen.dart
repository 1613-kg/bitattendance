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
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      renderPrevBtn: Text(
        "Prev",
        style: TextStyle(color: Colors.white),
      ),
      listCustomTabs: [
        sliderWidget(
            title: "Attendance",
            description: "Take attendance just by a click",
            imagePath: "assets/images/attendance.jpg"),
        sliderWidget(
            title: "Events",
            description:
                "You can add your events and can get all events around you",
            imagePath: "assets/images/events.jpg"),
        sliderWidget(
            title: "Blogs",
            description: "You can add your blogs and can see others blogs",
            imagePath: "assets/images/blog.jpg"),
        sliderWidget(
            title: "Congratulations",
            description: "You are ready to explore the application!",
            imagePath: "assets/images/cong.jpg")
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
