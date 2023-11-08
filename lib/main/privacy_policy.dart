import 'package:flutter/material.dart';

import '../utils/constant.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Privacy Policy",
                      style: Theme.of(context).textTheme.titleLarge),
                  height20,
                  Text(
                    "This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.We use Your Personal data to provide and improve the Service. By using the Service,You agree to the collection and use of information in accordance with this Privacy Policy. This Privacy Policy has been created with the help of the Privacy PolicyGenerator.",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  height20,
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            letterSpacing: letterSapcing,
                          ),
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
