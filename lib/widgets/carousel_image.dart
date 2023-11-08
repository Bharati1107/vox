// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../utils/constant.dart';

class ImageCarousel extends StatelessWidget {
  List feeds;
  ImageCarousel(this.feeds, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: feeds.length,
          itemBuilder: (context, index, realIndex) {
            return
                // Stack(
                //   children: [
                ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: Image.network(
                  feeds[index]['Image'],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                      valueColor: AlwaysStoppedAnimation<Color>(orange),
                    ));
                  },
                ),
              ),
            );
            // Positioned(
            //   top: 30,
            //   left: 20,
            //   child: SizedBox(
            //     width: 120,
            //     child: Text(
            //       'Where is the ECONOMY Heading?', // Replace with your desired text
            //       style: TextStyle(
            //           fontSize: 18,
            //           letterSpacing: 0.15,
            //           height: 1.5,
            //           color: white),
            //     ),
            //   ),
            // ),
            //   ],
            // );
          },
          options: CarouselOptions(
            height: 220.0,
            autoPlay: false,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enableInfiniteScroll: true,
            autoPlayInterval: const Duration(seconds: 3),
            scrollDirection: Axis.horizontal,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: feeds.map((url) {
            // int index = staticImageUrls.indexOf(url);
            return Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              decoration: BoxDecoration(shape: BoxShape.circle, color: orange),
            );
          }).toList(),
        )
      ],
    );
  }
}
