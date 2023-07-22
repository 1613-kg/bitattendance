import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class imageSlider extends StatefulWidget {
  List<String> images;
  imageSlider({super.key, required this.images});

  @override
  State<imageSlider> createState() => _imageSlider();
}

class _imageSlider extends State<imageSlider> {
  List<String> _images = [];
  List<Widget> item = [];

  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _images = widget.images;
    for (int i = 0; i < _images.length; i++) {
      item.add(
        Container(
          padding: EdgeInsets.all(10),
          //decoration: BoxDecoration(color: Colors.amber),
          child: Image.network(
            _images[i],
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Stack(children: [
        CarouselSlider(
          items: item,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1,
              aspectRatio: 1.0,
              initialPage: 2,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              }),
        ),
        Positioned(
          right: 160,
          bottom: 10,
          child: DotsIndicator(
            dotsCount: item.length,
            position: currentIndex.toDouble(),
          ),
        ),
      ]),
    );
  }
}
