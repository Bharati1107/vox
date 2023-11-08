// ignore_for_file: must_be_immutable, use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../utils/constant.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  TextEditingController headlineController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  PlatformFile? selectedFile;
  String? imageUrl;
  bool isFileAttached = false;
  bool isAllowSharing = false;

  // late Size size;
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                height20,
                Text("NEW POST",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        letterSpacing: 0.15,
                        height: 1.5,
                        color: orange)),
                height20,
                height10,
                TextFormField(
                  controller: headlineController,
                  decoration: InputDecoration(
                    labelText: 'Headline',
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Color.fromARGB(255, 107, 5, 251),
                      ),
                    ),
                  ),
                  cursorColor: orange,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Headline is required';
                    }
                    return null;
                  },
                ),
                height20,
                TextFormField(
                  maxLines: 6,
                  controller: contentController,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Color.fromARGB(255, 107, 5, 251),
                      ),
                    ),
                  ),
                  cursorColor: orange,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Content is required';
                    }
                    return null;
                  },
                ),
                height20,
                Row(
                  children: [
                    // iconsMethod(
                    //   Icons.face,
                    // ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    Column(
                      children: [
                        iconsMethod(
                          Icons.attach_file,
                        ),
                        isFileAttached
                            ? const Text("File attached",
                                style: TextStyle(color: Colors.green))
                            : const Text("Please attach file",
                                style: TextStyle(color: Colors.grey))
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    // iconsMethod(Icons.photo_camera),
                    Row(
                      children: [
                        Checkbox(
                            value: isAllowSharing,
                            onChanged: (bool? value) {
                              //value returned when checkbox is clicked
                              setState(() {
                                isAllowSharing = value!;
                              });
                            }),
                        const Text("Allow Sharing"),
                      ],
                    )
                  ],
                ),
                height20,
                height20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: orange,
                          elevation: 5,
                          minimumSize: const Size(160, 50),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              //uploadFile();

                              final uid =
                                  FirebaseAuth.instance.currentUser!.uid;

                              await FirebaseFirestore.instance
                                  .collection("NEWS")
                                  .add({
                                'Headline': headlineController.text,
                                'Content': contentController.text,
                                'Image': imageUrl ??
                                    "", // Store the URL in the 'Image' field
                                'Timestamp': FieldValue.serverTimestamp(),
                                "Uid": uid,
                                "Sharing_Allow": isAllowSharing
                              });

                              debugPrint("Headline ${headlineController.text}");
                              debugPrint("Content ${contentController.text}");
                              debugPrint(
                                  "IMAGE $imageUrl"); // Print the URL for debugging
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Post Add Successfully...!!!",
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pop(context);
                            } catch (e) {
                              debugPrint("Error uploading file: $e");
                            }
                          }
                        },
                        child: const Text("POST",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16))),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(160, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("DISCARD",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 16))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickFile(selectedFile) async {
    try {
      print("attach_file");
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        selectedFile = result.files.first;
        print("selectedFile-->> $selectedFile");
        uploadFile(selectedFile);
        isFileAttached = true;
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<String> uploadFile(selectedFile) async {
    try {
      final storage = FirebaseStorage.instance;
      final storageRef = storage.ref().child("NEW_POST");

      String? filePath = selectedFile!.path;

      if (filePath != null) {
        File file = File(filePath);

        String fileName = selectedFile!.name;
        await storageRef.child(fileName).putFile(file);

        final downloadURL = await storageRef.child(fileName).getDownloadURL();
        setState(() {
          imageUrl = downloadURL;
        });

        print("imageUrl $imageUrl");
        return downloadURL;
      } else {
        throw "File path is null.";
      }
    } catch (e) {
      rethrow;
    }
  }

  IconButton iconsMethod(
    icons,
  ) {
    return IconButton(
        onPressed: () async {
          if (icons == Icons.face) {}
          if (icons == Icons.attach_file) {
            pickFile(selectedFile);
          }
          if (icons == Icons.photo_camera) {}
        },
        icon: Icon(
          icons,
          color: orange,
          size: 30,
        ));
  }
}
