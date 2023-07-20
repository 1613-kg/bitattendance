import 'package:flutter/material.dart';

class mySettingsList extends StatelessWidget {
  String title;
  IconData icon;
  mySettingsList({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 35,
      leading: Icon(
        icon,
        size: 27,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
      ),
    );
  }
}
