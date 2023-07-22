import 'package:bitattendance/screens/eventScreen.dart';
import 'package:bitattendance/screens/settingsScreen.dart';
import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 25),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month, size: 25), label: 'Event'),
          BottomNavigationBarItem(
              icon: Icon(Icons.device_unknown, size: 25), label: 'Dummy'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 25), label: 'My Settings'),
        ],
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        currentIndex: pageIndex,
      ),
      body: Center(
        child: pageList[pageIndex],
      ),
    );
  }

  var pageList = [
    Text("Home"),
    eventScreen(),
    Text("Dummy"),
    settingsScreen(),
  ];
}
