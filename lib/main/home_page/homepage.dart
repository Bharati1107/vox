// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/constant.dart';
import 'discover.dart';
import 'my_feed.dart';
import 'my_posts.dart';

String userRole = '';

class AppbarTop extends StatefulWidget {
  const AppbarTop({super.key});

  @override
  _AppbarTopState createState() => _AppbarTopState();
}

class _AppbarTopState extends State<AppbarTop> {
  // Initialize userRole

  @override
  void initState() {
    super.initState();
    fetchUserRole(); // Fetch the user's role when the widget is initialized.
  }

  Future<void> fetchUserRole() async {
    // Replace 'yourUserID' with the actual user ID or use FirebaseAuth to get the user's UID.
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Fetch the user's role from Firestore
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('USERS').doc(userId).get();

    if (userDoc.exists) {
      // Retrieve the 'role' field from the document
      final data = userDoc.data() as Map<String, dynamic>;
      final role = data['roles'];

      setState(() {
        userRole = role;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: userRole == 'Admin' || userRole == 'Contributor' ? 3 : 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            tabs: <Widget>[
              const Tab(text: 'Highlights'),
              const Tab(text: 'News Flash'),
              if (userRole == 'Admin' || userRole == 'Contributor')
                const Tab(
                    text: 'My Posts'), // Conditionally show the tab for admin
            ],
            indicator: BoxDecoration(color: orange),
          ),
        ),
        body: TabBarView(
          children: [
            const Highlights(),
            const NewsFlash(),
            if (userRole == 'Admin' || userRole == 'Contributor')
              const MyPostsTabContent(), // Conditionally show the content for admin
          ],
        ),
      ),
    );
  }
}

class MyPostsTabContent extends StatelessWidget {
  const MyPostsTabContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: UniqueKey(),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return const MyPosts();
          },
        );
      },
    );
  }
}
