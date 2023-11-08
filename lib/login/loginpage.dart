import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main/home_page/user_profile.dart';
import '../utils/constant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isAgreeTerms = false;
  bool userExits = false;

  Future<void> _signInWithEmailAndPassword(String email) async {
    String password = "VoxOffice";
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final auth = FirebaseAuth.instance;
      User user = auth.currentUser!;
      if (user.emailVerified) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const UserProfile()));
      } else {
        user = auth.currentUser!;
        user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Your Email is not Verified..Plz verify! link send to $email",
            ),
          ),
        );
        // auth.signOut();
        await user.reload();
      }

      // Successful login
      // You can navigate to another screen or perform other actions here
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "No user found for that email",
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Wrong password provided by user",
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  height20,
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
                  Image.asset('assets/images/login_image.jpg'),
                  height20,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Add your email, we'll send you a verification code so we know you're real",
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  height20,
                  // TextField(
                  //   controller: _emailController,
                  //   decoration: const InputDecoration(labelText: 'Email'),
                  // ),
                  SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          shadowColor: const Color.fromARGB(255, 104, 104, 104),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(children: [
                                height10,
                                TextFormField(
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an email address';
                                    } else if (!value.endsWith('@gmail.com')) {
                                      return 'Please enter a valid Gmail email address';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'e.g user@gmail.com',
                                    labelText: 'Email',
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
                                    ),
                                  ),
                                  cursorColor: orange,
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isAgreeTerms,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isAgreeTerms = value!;
                                        });
                                      },
                                    ),
                                    const Text("I agree to"),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        "terms & conditions",
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(200, 50),
                                    ),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        if (!isAgreeTerms) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Please agree to the terms & conditions.'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        } else {
                                          userExits == false
                                              ? registration(
                                                  _emailController.text)
                                              : loginMethod();
                                        }
                                      }
                                    },
                                    child: Text(
                                      userExits == false ? "SIGNUP" : "LOGIN",
                                      style: TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                        letterSpacing: letterSapcing,
                                      ),
                                    ))
                              ])))),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(userExits == false
                          ? "Already have an account?"
                          : "Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            userExits == false
                                ? loginMethod()
                                : registration(_emailController.text);
                          },
                          child: Text(userExits == false ? "LOGIN" : 'SIGNUP')),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  registration(String email) async {
    String password = "VoxOffice";
    //  String password = "kalpesh@123";
    final auth = FirebaseAuth.instance;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User user = auth.currentUser!;
      user.sendEmailVerification();
      await FirebaseFirestore.instance
          .collection("Userr")
          .add({"email": email});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // backgroundColor: snackBarBackgroundG,
          content: Text(
            "verification link send to $email.. Plz Kindly verify your Email",
            // style: TextStyle(fontSize: F20),
          ),
        ),
      );

      await user.reload();
      if (user.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Email is Verified",
            ),
          ),
        );
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
      auth.signOut();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            // backgroundColor: snackBarBackgroundO,
            content: Text(
              "Account Already exists",
              // style: TextStyle(fontSize: F18, color: black),
            ),
          ),
        );
      }
    }
  }

  loginMethod() async {
    try {
      FirebaseFirestore.instance
          .collection('Userr')
          .get()
          .then((QuerySnapshot querySnapshot) {
        // ignore: avoid_function_literals_in_foreach_calls
        querySnapshot.docs.forEach((doc) async {
          // print(doc["PRIVACY_POLICY"]);
          if (doc["email"] == _emailController.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Email Exist",
                ),
                backgroundColor: Colors.green,
              ),
            );
            _signInWithEmailAndPassword(_emailController.text);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Email not exist Plz SignUP first",
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
