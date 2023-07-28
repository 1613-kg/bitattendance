import 'package:bitattendance/model/eventData.dart';
import 'package:bitattendance/screens/updateEventScreen.dart';
import 'package:bitattendance/widgets/eventDetailsWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../services/auth.dart';
import '../services/database_services.dart';
import '../widgets/imageSlider.dart';

class eventDetailsScreen extends StatelessWidget {
  EventData eventData;
  eventDetailsScreen({super.key, required this.eventData});

  @override
  Widget build(BuildContext context) {
    bool canEdit =
        (FirebaseAuth.instance.currentUser!.uid == eventData.addedBy);
    final data = eventData;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          data.name,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.purple,
        actions: [
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 0,
                child: Text("Update"),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text("Delete"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              (canEdit)
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              updateEventScreen(eventData: eventData)))
                  : showSnackbar(context, Colors.red, "Only author has rights");
            } else if (value == 1) {
              final ap = Provider.of<AuthProvider>(context, listen: false);
              (canEdit)
                  ? ap
                      .deleteEventPic(eventData.timeStamp)
                      .whenComplete(() async {
                      await DatabaseServices(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .deletingEventData(eventData)
                          .whenComplete(() {
                        showSnackbar(
                            context, Colors.red, "Event deleted successfully");
                        Navigator.pop(context);
                      });
                    })
                  : showSnackbar(context, Colors.red, "Only author has rights");
            }
          }),
        ],
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
