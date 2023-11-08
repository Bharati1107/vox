import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailcontroller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignUp"),
      ),
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'email',
                hintText: 'enter email',
              ),
              controller: emailcontroller,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  String email = emailcontroller.text;

                  registration(email);
                }
              },
              child: const Text(
                'SignUp',
              ),
            )
          ],
        ),
      ),
    );
  }

  registration(String email) async {
    String password = "kalpesh@123";
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
}
