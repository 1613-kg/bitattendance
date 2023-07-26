import 'package:flutter/material.dart';

class myProfileInfo extends StatelessWidget {
  String title;

  IconData icon;
  myProfileInfo({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(fontSize: 15),
      ),
    );
  }
}
