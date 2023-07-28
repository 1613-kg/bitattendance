import 'package:auto_size_text/auto_size_text.dart';

import 'package:bitattendance/model/eventData.dart';

import 'package:bitattendance/screens/eventDetailsScreen.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

class eventPreview extends StatelessWidget {
  EventData eventData;

  eventPreview({super.key, required this.eventData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
            CachedNetworkImage(
              height: 235,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(
                Icons.image,
                size: 150,
              ),
              //radius: 150,
              imageUrl: eventData.images[0],
            ),
            // Image.network(
            //   eventData.images[0],
            //   fit: BoxFit.cover,
            //   width: double.infinity,
            //   height: 235,
            // ),
            Positioned(
              bottom: 50,
              left: 10,
              child: SizedBox(
                width: 200,
                child: AutoSizeText(
                  "Name: ${eventData.name}",
                  //textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  softWrap: true,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: SizedBox(
                width: 200,
                child: AutoSizeText(
                  "Venue: ${eventData.location}",
                  //textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  softWrap: true,
                ),
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
