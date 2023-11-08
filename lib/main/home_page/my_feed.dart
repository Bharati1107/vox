import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/constant.dart';
import '../../widgets/image_inside_icons.dart';
import '../timestamp.dart';

class NewsFlash extends StatefulWidget {
  const NewsFlash({super.key});

  @override
  State<NewsFlash> createState() => _NewsFlashState();
}

class _NewsFlashState extends State<NewsFlash> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('NEWS')
            .orderBy('Timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              ? const Center(child: Text("No More Post To Show"))
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: PageView.builder(
                    controller: PageController(
                      initialPage: 0,
                    ),
                    scrollDirection: Axis.vertical,
                    itemCount: feeds.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool isAllowSharing = feeds[index]["Sharing_Allow"];

                      String? formattedTimestamp =
                          formatTimestamp(feeds[index]["Timestamp"]);
                      return Column(
                        children: [
                          // ClipRRect(
                          //     borderRadius: BorderRadius.circular(10),
                          //     child: Image.network('${feeds[index]["Image"]}')),

                          imageInsideIcons(
                            260.0,
                            '${feeds[index]["Image"]}',
                            white,
                          ),
                          Text(
                            '${feeds[index]["Headline"]}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '${feeds[index]["Content"]}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          height10,

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Posted $formattedTimestamp',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                FutureBuilder<String>(
                                  future: fetchUserName(
                                      uid), // Call the fetchUserName function.
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // While waiting for the future to complete, you can show a loading indicator.
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      // Handle errors here.
                                      return Text("Error: ${snapshot.error}");
                                    } else {
                                      // The future has completed successfully. Display the user's name.
                                      return Text(
                                        "${snapshot.data}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      );
                                    }
                                  },
                                ),
                                isAllowSharing == false
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          final shareText =
                                              'Check out this post: ${feeds[index]["Headline"]}\n\n${feeds[index]["Content"]}\n\nImage Link: ${feeds[index]["Image"]}';
                                          Share.share(
                                            shareText,
                                          );
                                        },
                                        child: Icon(
                                          Icons.share,
                                          size: 14,
                                          color: black,
                                        )),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ));
        });
  }

  Future<String> fetchUserName(String userId) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('USERS').doc(userId).get();
    if (userDoc.exists) {
      final Map<String, dynamic> userData =
          userDoc.data() as Map<String, dynamic>;
      String firstName = userData['first_name'];
      String lastName = userData['last_name'];
      return '$firstName $lastName';
    } else {
      return "User not found"; // Handle the case when the user doesn't exist.
    }
  }
}
