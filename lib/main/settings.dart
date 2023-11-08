// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../login/loginpage.dart';

import '../provider/app_theme_provider.dart';
import '../utils/constant.dart';
import 'privacy_policy.dart';

class Settings extends ConsumerWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // bool isSwitched = false;
    // bool isPrivate = false;
    var isDarkMode = ref.watch(appThemeProvider);
    final user = FirebaseAuth.instance.currentUser!.uid;
    final email = FirebaseAuth.instance.currentUser!.email;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height20,
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_sharp,
                  size: 14,
                  color: isDarkMode ? white : black,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          height10,
          userInfoContainer(context, user, email),
          height20,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: isDarkMode
                    ? white
                    : const Color.fromARGB(255, 203, 202,
                        202), // Change this color to your desired border color
                width: 1.0, // Change the border width as needed
              ),
            ),
            child: ListTile(
                leading: Icon(isDarkMode ? Icons.brightness_3 : Icons.sunny),
                title: Text(
                  isDarkMode ? "Dark Mode" : "Light Mode",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: Consumer(builder: (context, ref, child) {
                  return Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      activeColor: orange,
                      onChanged: (value) {
                        ref.read(appThemeProvider.notifier).state = value;
                      },
                      value: isDarkMode,
                    ),
                  );
                })),
          ),
          height10,
          // Container(
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(5),
          //     border: Border.all(
          //       color: isDarkMode
          //           ? white
          //           : const Color.fromARGB(255, 203, 202,
          //               202), // Change this color to your desired border color
          //       width: 1.0, // Change the border width as needed
          //     ),
          //   ),
          //   child: ListTile(
          //     leading: const Icon(Icons.notifications),
          //     title: Text(
          //       "Notifications",
          //       style: Theme.of(context).textTheme.titleMedium,
          //     ),
          //     trailing: StatefulBuilder(
          //       builder: (BuildContext context, StateSetter setState) {
          //         return Transform.scale(
          //           scale: 0.7,
          //           child: Switch(
          //             activeColor: orange,
          //             value: isSwitched,
          //             onChanged: (value) {
          //               setState(() {
          //                 isSwitched = value;
          //               });
          //             },
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
          height10,
          Text(
            "Account",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 5,
          ),
          accountInformation(isDarkMode, context),
          height10,
          Text(
            "Privacy And Security",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: isDarkMode
                    ? white
                    : const Color.fromARGB(255, 203, 202,
                        202), // Change this color to your desired border color
                width: 1.0, // Change the border width as needed
              ),
            ),
            child: Column(children: [
              // textIconListData(
              //     context,
              //     'Private Account',
              //     const Icon(Icons.private_connectivity),
              //     toggleButton(isDarkMode, isPrivate)),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrivacyPolicy()));
                },
                child: textIconListData(
                  context,
                  'Privacy And Security',
                  const Icon(Icons.security),
                  icon,
                ),
              ),
            ]),
          )
        ],
      ),
    );
    //   bottomNavigationBar: const BottomNavigationAppBar(),
    // );
  }

  toggleButton(bool isDarkMode, isPrivate) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Transform.scale(
          scale: 0.7,
          child: Switch(
            activeColor: orange,
            value: isPrivate,
            onChanged: (value) {
              setState(() {
                isPrivate = value;
              });
            },
          ),
        );
      },
    );
  }

  Container accountInformation(bool isDarkMode, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: isDarkMode
              ? white
              : const Color.fromARGB(255, 203, 202,
                  202), // Change this color to your desired border color
          width: 1.0, // Change the border width as needed
        ),
      ),
      child: Column(
        children: [
          textIconListData(
            context,
            'Edit',
            const Icon(Icons.edit),
            icon,
          ),
          // textIconListData(
          //     context, 'Change Password', const Icon(Icons.lock), icon),
          // textIconListData(
          //   context,
          //   'Languague',
          //   const Icon(Icons.language),
          //   icon,
          // ),
        ],
      ),
    );
  }

  ListTile textIconListData(BuildContext context, text, Icon? leadingIcon,
      [toggleButton]) {
    return ListTile(
        leading: leadingIcon,
        title: Text(
          "$text",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: toggleButton);
  }

  userInfoContainer(BuildContext context, userId, email) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(1), // Border radius
            child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  "assets/images/user_profile.png",
                  fit: BoxFit.fill,
                  width: 120,
                  height: 120,
                )),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String>(
              future: fetchUserName(userId), // Call the fetchUserName function.
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
                    style: Theme.of(context).textTheme.titleMedium,
                  );
                }
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              email,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text(
                "Sign Out",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ],
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
}
