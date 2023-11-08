// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/constant.dart';
import '../../widgets/bottom_navigation_bar.dart';

final GlobalKey<FormState> _userformKey = GlobalKey<FormState>();
TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser!.email;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo_image.png',
                    width: 220,
                  ),
                  Text(
                    "VOICE OF YOUR OFFICE",
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: letterSapcing,
                      height: 1.5,
                      color: orange,
                    ),
                  ),
                  height20,
                  Container(
                    width: 155.0,
                    height: 155.0,
                    decoration: const BoxDecoration(
                      color: Colors.grey, // Background color
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/user_profile.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  height20,
                  height20,
                  Form(
                    key: _userformKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: firstNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter first name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'First Name',
                              labelStyle:
                                  Theme.of(context).textTheme.bodyMedium,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: orange,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: orange,
                                ),
                              )),
                          cursorColor: orange,
                        ),
                        height20,
                        TextFormField(
                          controller: lastNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter last name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Last Name',
                              labelStyle:
                                  Theme.of(context).textTheme.bodyMedium,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: orange,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: orange,
                                ),
                              )),
                          cursorColor: orange,
                        ),
                        height20,
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(200, 50),
                            ),
                            onPressed: () async {
                              final uid =
                                  FirebaseAuth.instance.currentUser!.uid;
                              print(uid);
                              await FirebaseFirestore.instance
                                  .collection("USERS")
                                  .doc(uid)
                                  .set({
                                'roles': 'Admin',
                                'email': email,
                                'first_name': firstNameController.text,
                                'last_name': lastNameController.text,
                              }).then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "User details added Successfully..!!",
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomNavigationExample()));
                              });
                            },
                            child: Text(
                              "SUBMIT",
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                letterSpacing: letterSapcing,
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
