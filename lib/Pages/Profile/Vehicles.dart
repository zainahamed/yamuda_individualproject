import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Model/UserModel.dart';
import 'package:yamudacarpooling/Pages/CreateVehicle.dart';
import 'package:yamudacarpooling/Services/AuthService.dart';
import 'package:yamudacarpooling/Services/UploadImageService.dart';
import 'package:yamudacarpooling/Services/VehicleService.dart';
import 'package:yamudacarpooling/Widgets/VehicleView.dart';

class Vehicles extends StatefulWidget {
  const Vehicles({super.key});

  @override
  State<Vehicles> createState() => _VehiclesState();
}

class _VehiclesState extends State<Vehicles> {
  //instance
  final auth = AuthServices();
  final vehicleService = VehicleService();

  File? _image;
  final UploadImageService uploadimageService = UploadImageService();
  String? imageUrl;

  UserModel? user;

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
          'Vehicles',
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
          Column(
            children: [
              const Text("Long Press to Delete Vehicle"),
              Expanded(child: _buildVehicleList()),
              SizedBox(
                height: height * 0.02,
              ),
            ],
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CreateVehicle()));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: height * 0.02),
                        child: const Center(
                          child: Text(
                            "Create New Vehicle",
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

  Widget _buildVehicleList() {
    return StreamBuilder(
      stream: vehicleService.getVehicleList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Primary,
              size: 40,
            ),
          );
        }

        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildVehicleView(doc)).toList(),
        );
      },
    );
  }

  Widget _buildVehicleView(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return VehicleView(
      id: document.id,
      model: data['model'],
      seats: data['seatCapacity'].toString(),
      imageUrl: data['imageUrl'],
    );
  }
}
