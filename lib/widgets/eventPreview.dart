import 'package:bitattendance/model/eventData.dart';
import 'package:bitattendance/screens/eventDetailsScreen.dart';
import 'package:flutter/material.dart';

class eventPreview extends StatelessWidget {
  EventData eventData;

  eventPreview({super.key, required this.eventData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {},
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    eventDetailsScreen(eventData: eventData)));
      },
      child: Container(
        width: double.infinity,
        height: 330,
        child: Card(
          child: Stack(children: [
            Image.network(
              eventData.images[0],
              fit: BoxFit.cover,
              width: double.infinity,
              height: 235,
            ),
            Positioned(
              bottom: 50,
              left: 10,
              child: Text(
                "Name: ${eventData.name}",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                "Venue: ${eventData.location}",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            Positioned(
              bottom: 50,
              right: 10,
              child: Text(
                "Time: ${eventData.startTime}",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Text(
                "Date: ${eventData.startDate}",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
