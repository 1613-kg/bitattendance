import 'package:bitattendance/model/eventData.dart';
import 'package:bitattendance/screens/addEvents.dart';
import 'package:bitattendance/widgets/emptyText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/database_services.dart';
import '../widgets/eventPreview.dart';
import '../widgets/loading.dart';

class eventScreen extends StatefulWidget {
  const eventScreen({super.key});

  @override
  State<eventScreen> createState() => _eventScreenState();
}

class _eventScreenState extends State<eventScreen> {
  Stream? eventData;

  getAllEventData() async {
    await DatabaseServices(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ).getEventData().then((snapshots) {
      setState(() {
        eventData = snapshots;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Events",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => addEvents()));
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: eventData,
          builder: ((context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var dataList = snapshot.data.docs;
              // if (snapshot.data['stocks'] != null) {
              if (dataList.length != 0) {
                return ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: ((context, index) {
                      final data = dataList[index].data();
                      return eventPreview(
                        eventData: EventData(
                            timeStamp: data['timeStamp'].toDate(),
                            eventId: data['eventId'],
                            name: data['eventName'],
                            description: data['description'],
                            type: data['eventType'],
                            location: data['eventVenue'],
                            endDate: data['endDate'],
                            startDate: data['startDate'],
                            images: data['images'].cast<String>(),
                            startTime: data['startTime'],
                            endTime: data['endTime'],
                            addedBy: data['addedBy']),
                      );
                    }));
              } else
                return emptyText();
              // } else
              //   return Container();
            } else
              return loading();
          }),
        ),
      ),
    );
  }
}
