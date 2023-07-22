import 'package:bitattendance/model/eventData.dart';
import 'package:bitattendance/widgets/eventDetailsWidget.dart';
import 'package:flutter/material.dart';

import '../widgets/imageSlider.dart';

class eventDetailsScreen extends StatefulWidget {
  EventData eventData;
  eventDetailsScreen({super.key, required this.eventData});

  @override
  State<eventDetailsScreen> createState() => _eventDetailsScreenState();
}

class _eventDetailsScreenState extends State<eventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final data = widget.eventData;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          data.name,
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
          child: Container(
        child: Column(
          children: [
            imageSlider(images: data.images),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  eventDetailsWidget(title: "Name", content: "${data.name}"),
                  SizedBox(
                    height: 20,
                  ),
                  eventDetailsWidget(title: "Type", content: "${data.type}"),
                  SizedBox(
                    height: 20,
                  ),
                  eventDetailsWidget(
                      title: "Venue", content: "${data.location}"),
                  SizedBox(
                    height: 20,
                  ),
                  eventDetailsWidget(
                      title: "Start Date", content: "${data.startDate}"),
                  SizedBox(
                    height: 20,
                  ),
                  eventDetailsWidget(
                      title: "Start Time", content: "${data.startTime}"),
                  SizedBox(
                    height: 20,
                  ),
                  eventDetailsWidget(
                      title: "End Date", content: "${data.endDate}"),
                  SizedBox(
                    height: 20,
                  ),
                  eventDetailsWidget(
                      title: "End Time", content: "${data.endTime}"),
                  SizedBox(
                    height: 20,
                  ),
                  eventDetailsWidget(
                      title: "About", content: "${data.description}"),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
