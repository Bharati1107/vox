import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/constant.dart';
import '../../widgets/carousel_image.dart';
import '../../widgets/latest_news_widgets.dart';

class Highlights extends StatelessWidget {
  const Highlights({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('NEWS')
                .orderBy('Timestamp', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                debugPrint('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final List feeds = [];
              snapshot.data?.docs.map((DocumentSnapshot document) {
                Map a = document.data() as Map<String, dynamic>;
                feeds.add(a);
              }).toList();

              return feeds.isEmpty
                  ? const Center(
                      child: Text("Your uploaded post will be see here."))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height20,
                        ImageCarousel(feeds),
                        Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Latest News",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: feeds.length,
                              itemBuilder: (context, index) {
                                var headline = feeds[index];
                                return LatestNewsWidget(headline);
                              }),
                        )
                      ],
                    );
            }),
      ),
    );
  }
}
