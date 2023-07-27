import 'package:bitattendance/constants.dart';
import 'package:bitattendance/model/eventData.dart';
import 'package:bitattendance/screens/addEvents.dart';
import 'package:bitattendance/screens/eventDetailsScreen.dart';
import 'package:bitattendance/screens/updateEventScreen.dart';
import 'package:bitattendance/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class eventPreview extends StatelessWidget {
  EventData eventData;

  eventPreview({super.key, required this.eventData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final offset = renderBox.localToGlobal(Offset.zero);
        final left = offset.dx + renderBox.size.width;
        final top = offset.dy;
        final right = left + renderBox.size.width;
        showMenu(
            context: context,
            position: RelativeRect.fromLTRB(left, top, right, 0.0),
            items: [
              PopupMenuItem<int>(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => updateEventScreen(
                                eventData: eventData,
                              )));
                },
                value: 0,
                child: Text('Update'),
              ),
              PopupMenuItem<int>(
                onTap: () async {
                  await DatabaseServices(
                          uid: FirebaseAuth.instance.currentUser!.uid)
                      .deletingEventData(eventData)
                      .whenComplete(() {
                    showSnackbar(
                        context, Colors.red, "Event deleted successfully");
                  });
                },
                value: 1,
                child: Text('Delete'),
              ),
            ]);
      },
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
