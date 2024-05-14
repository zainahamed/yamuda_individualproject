import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Model/UserModel.dart';
import 'package:yamudacarpooling/Services/AuthService.dart';
import 'package:yamudacarpooling/Services/UploadImageService.dart';
import 'package:yamudacarpooling/Widgets/SnackbarMessage.dart';

class EditPersonal extends StatefulWidget {
  const EditPersonal({super.key});

  @override
  State<EditPersonal> createState() => _EditPersonalState();
}

class _EditPersonalState extends State<EditPersonal> {
  final _formKey = GlobalKey<FormState>();
  bool obcureText1 = true;
  bool obcureText2 = true;
  bool showIcon = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();

  //instance
  final auth = AuthServices();

  File? _image;
  final UploadImageService uploadimageService = UploadImageService();
  String? imageUrl;

  UserModel? user;

  void update() async {
    if (_image != null) {
      imageUrl = await uploadimageService.uploadImage(_image!);
    }
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              backgroundColor: Colors.transparent,
              child: LoadingAnimationWidget.threeArchedCircle(
                color: Primary,
                size: 40,
              ),
            ));
    bool result = await auth.updateUser(
        nameController.text,
        emailController.text,
        contactController.text,
        companyController.text,
        occupationController.text,
        imageUrl!,
        linkedinController.text);
    if (result == true) {
      // Show success message
      // ignore: use_build_context_synchronously
      SnackBarMessage.showSnackBarSuccess(context, 'Update Successfully');

      Navigator.pop(context);
    }
  }

  void initializeUser() async {
    user = await auth.getAppUser(FirebaseAuth.instance.currentUser!.uid);

    if (user != null) {
      contactController.text = user!.contact.toString();
      nameController.text = user!.username;
      emailController.text = user!.email;
      occupationController.text = user!.occupation;
      companyController.text = user!.company;
      imageUrl = user!.imageUrl;
      linkedinController.text = user!.linkedin ?? "";
    }
  }

  //initialize
  @override
  void initState() {
    super.initState();
    initializeUser();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous screen
          },
        ),
        // Title
        title: const Text(
          'Edit Personal Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Set the background color of the app bar
        backgroundColor: Colors.white,
      ),
      body: Stack(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Container(
                        height: 55,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 1), // Add border if needed
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Change Profile Picture",
                              style: TextStyle(
                                color: Primary,
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  final image = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  if (image != null) {
                                    setState(() {
                                      _image = File(image.path);
                                    });
                                  }
                                },
                                icon: const Icon(Icons.upload_file)),
                          ],
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter the Name";
                        } else if (value.length > 15) {
                          return 'Name should not be greater than 15 characters';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: 'Enter Name',
                        hintText: 'e.g., john',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextFormField(
                      enabled: false,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter the Email";
                        } else {
                          // Basic email format validation using a regular expression
                          String emailRegex =
                              r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                          RegExp regex = RegExp(emailRegex);

                          if (!regex.hasMatch(value)) {
                            return 'Enter a valid email address';
                          }

                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: 'Enter Email',
                        hintText: 'e.g., john_doe@gmail.com',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextFormField(
                      controller: contactController,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter the Contact Number";
                        } else {
                          // Remove any non-digit characters from the input
                          String cleanedValue =
                              value.replaceAll(RegExp(r'\D'), '');

                          // Validate the cleaned value
                          if (cleanedValue.length != 10 ||
                              !cleanedValue.startsWith('0')) {
                            return 'Enter a valid Contact Number';
                          }

                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: 'Enter Contact',
                        hintText: '07xxxxxxxx',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextFormField(
                      controller: companyController,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter the company";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: 'Enter company',
                        hintText: 'e.g., company',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextFormField(
                      controller: linkedinController,
                      keyboardType: TextInputType
                          .url, // Use TextInputType.url for URL input
                      obscureText: false,
                      validator: (value) {
                        // You can add custom validation for the LinkedIn URL here
                        return null; // Return null if validation passes
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Enter LinkedIn URL',
                        hintText: 'https://www.linkedin.com/in/username',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextFormField(
                      controller: occupationController,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter the occupation";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: 'Enter occupation',
                        hintText: 'e.g., UX Designer',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //second
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              color: Secondary,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.01),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Primary,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          update();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: height * 0.02),
                        child: const Center(
                          child: Text(
                            "Update",
                            style: TextStyle(
                              color: Secondary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
