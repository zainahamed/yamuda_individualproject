import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Services/UploadImageService.dart';
import 'package:yamudacarpooling/Services/VehicleService.dart';
import 'package:yamudacarpooling/Widgets/SnackbarMessage.dart'; // Import your Colors.dart file

class CreateVehicle extends StatefulWidget {
  const CreateVehicle({Key? key}) : super(key: key);

  @override
  State<CreateVehicle> createState() => _CreateVehicleState();
}

class _CreateVehicleState extends State<CreateVehicle> {
  // Controller for the text fields
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _seatsCapacityController =
      TextEditingController();

  // VehicleService instance
  VehicleService vehicleService = VehicleService();

  final _formKey = GlobalKey<FormState>();

  File? _image;
  final UploadImageService uploadimageService = UploadImageService();
  String? imageUrl;

  // Function to add vehicle
  void addVehicle() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              backgroundColor: Colors.transparent,
              child: LoadingAnimationWidget.threeArchedCircle(
                color: Primary,
                size: 40,
              ),
            ));

    if (_image == null) {
      SnackBarMessage.showSnackBarError(context, 'Please insert the image');
    }
    // Validate input fields
    if (_makeController.text.isEmpty ||
        _modelController.text.isEmpty ||
        _registrationNumberController.text.isEmpty ||
        _seatsCapacityController.text.isEmpty ||
        _image == null) {
      SnackBarMessage.showSnackBarError(context, 'Please fill the all felids');
    } else {
      if (_image != null) {
        imageUrl = await uploadimageService.uploadVehicleImage(
            _image!, _registrationNumberController.text);
        vehicleService.insertVehicle(
          'id',
          _makeController.text,
          _modelController.text,
          int.parse(_seatsCapacityController.text),
          imageUrl,
          _registrationNumberController.text,
        );

        // Show success message
        SnackBarMessage.showSnackBarSuccess(
            context, 'Vehicle added successfully');
      }

      _makeController.clear();
      _modelController.clear();
      _registrationNumberController.clear();
      _seatsCapacityController.clear();
    }

    Navigator.pop(context);
  }

  bool isValidNumber(String value) {
    if (value == null) {
      return false;
    }
    int number = int.tryParse(value) ?? -1;
    return number >= 0 && number <= 9;
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
            Navigator.pop(context);
          },
        ),
        // Title
        title: const Text(
          'Create Vehicle',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Set the background color of the app bar
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.02,
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Container(
                  height: 65,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1), // Add border if needed
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Update Vehicle Picture",
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

            // Input fields for vehicle details
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _makeController,
                      decoration: InputDecoration(
                        labelText: 'Vehicle Make',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Enter Vehicle Make',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter vehicle make';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _modelController,
                      decoration: InputDecoration(
                        labelText: 'Vehicle Model',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Enter Vehicle Model',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter vehicle model';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _registrationNumberController,
                      decoration: InputDecoration(
                        labelText: 'Registration Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Enter Registration Number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter registration number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _seatsCapacityController,
                      decoration: InputDecoration(
                        labelText: 'Seats Capacity',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Enter Seats Capacity',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter seats capacity';
                        }
                        if (!isValidNumber(value)) {
                          return 'Invlid Input Type';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.23,
            ),
            // Display button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Primary,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addVehicle();
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  child: const Center(
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Secondary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
