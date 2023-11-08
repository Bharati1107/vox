// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../provider/app_theme_provider.dart';
import '../../utils/constant.dart';
import '../timestamp.dart';
import 'new_post.dart';

class MyPosts extends ConsumerWidget {
  const MyPosts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkMode = ref.watch(appThemeProvider);

    final uid = FirebaseAuth.instance.currentUser!.uid;
    print(uid);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                      image: AssetImage('assets/images/my_post.jpg'),
                      fit: BoxFit.cover)),
            ),
            height10,
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("NEWS")
                    // .orderBy('Timestamp', descending: true)
                    .where('Uid', isEqualTo: uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("You have no uploaded posts."),
                    );
                  }

                  final List feeds =
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map a = document.data() as Map<String, dynamic>;
                    return a;
                  }).toList();

                  return feeds.isEmpty
                      ? const Center(
                          child: Text("Your uploaded post will be see here."))
                      : Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: feeds.length,
                            itemBuilder: (context, index) {
                              String? formattedTimestamp =
                                  formatTimestamp(feeds[index]['Timestamp']);

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Container(
                                  height:
                                      340, // Define a fixed height for each item
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? black : white,
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 191, 189, 189),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      userNameImage(isDarkMode, context,
                                          feeds[index], uid),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          feeds[index]['Image'] == ''
                                              ? Image.asset(
                                                  'assets/images/my_post_new.webp',
                                                  height: 100,
                                                )
                                              : Image.network(
                                                  feeds[index]['Image'],
                                                  cacheHeight: 100,
                                                ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            feeds[index]['Headline'] == ''
                                                ? Container()
                                                : Text(
                                                    feeds[index]['Headline'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                            height10,
                                            feeds[index]['Content'] == ''
                                                ? Container()
                                                : Text(
                                                    feeds[index]['Content'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Posted $formattedTimestamp',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
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
                                                  return Text(
                                                      "Error: ${snapshot.error}");
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewPost()));
        },
        label: const Text("NEW POST"),
        icon: const Icon(Icons.add),
      ),
    );
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

  Container userNameImage(
      bool isDarkMode, BuildContext context, feed, String uid) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: orange,
            child: Icon(
              Icons.abc,
              color: isDarkMode ? black : white,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String>(
                future: fetchUserName(uid), // Call the fetchUserName function.
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While waiting for the future to complete, you can show a loading indicator.
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Handle errors here.
                    return Text("Error: ${snapshot.error}");
                  } else {
                    // The future has completed successfully. Display the user's name.
                    return Text(
                      "${snapshot.data}",
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }
                },
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Product Manager",
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
          const SizedBox(
            width: 120,
          ),
          PopupMenuButton<String>(
            onSelected: (String choice) async {
              // Handle the choice selected from the popup menu
              // if (choice == 'edit') {
              //   // Perform the edit action
              // } else if (choice == 'delete') {
              //   // Perform the delete action
              // } else
              if (choice == 'share') {
                // Perform the share action
                final shareText =
                    'Check out this post: ${feed["Headline"]}\n\n${feed["Content"]}\n\nImage Link: ${feed["Image"]}';

                Share.share(
                  shareText,
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                // popupMenu('edit', Icons.edit, 'Edit'),
                // popupMenu('delete', Icons.delete, 'Delete'),
                // PopupMenuItem(
                //     onTap: () async {
                //       await Share.share("Bharati");
                //     },
                //     child: Row(
                //       children: const [Icon(Icons.share), Text("Share")],
                //     ))
                popupMenu('share', Icons.share, 'Share')
              ];
            },
            child: const Icon(
              Icons.more_vert_rounded,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  PopupMenuItem<String> popupMenu(value, icons, text) {
    return PopupMenuItem<String>(
      value: '$value',
      child: Row(
        children: [
          Icon(icons, color: orange),
          const SizedBox(width: 10),
          Text('$text'),
        ],
      ),
    );
  }
}
