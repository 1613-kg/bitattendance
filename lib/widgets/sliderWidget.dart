import 'package:flutter/material.dart';

class sliderWidget extends StatelessWidget {
  String imagePath;
  String title;
  String description;
  sliderWidget(
      {super.key,
      required this.title,
      required this.description,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Container(
      color: Color.fromARGB(255, 209, 108, 227),
      //margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(10),
      height: h,
      width: w,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 130,
              width: 200,
              child: Image.asset(imagePath),
            ),
            SizedBox(
              height: 0,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w100),
            )
          ],
        ),
      ),
    );
  }
}
