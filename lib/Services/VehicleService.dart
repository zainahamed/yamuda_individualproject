import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yamudacarpooling/Model/Vehicle.dart';

class VehicleService extends ChangeNotifier {
//firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //firestore instance
  final firestore = FirebaseFirestore.instance;

  //Insert a vehicle
  Future<dynamic> insertVehicle(String id, String vehicleMake, String model,
      int seatCapacity, String? imageUrl, String registrationNumber) async {
    firestore
        .collection("AppUser")
        .doc(_auth.currentUser!.uid)
        .collection("Vehicles")
        .add({
      'registrationNumber': registrationNumber,
      'imageUrl': imageUrl,
      'seatCapacity': seatCapacity,
      'model': model,
      'vehicleMake': vehicleMake
    });
  }

  //Get Vehicle list
  Stream<QuerySnapshot> getVehicleList() {
    return firestore
        .collection("AppUser")
        .doc(_auth.currentUser!.uid)
        .collection("Vehicles")
        .snapshots();
  }

  //Delete vehicle

  Future<void> deleteVehicle(String vehicleId) async {
    await firestore
        .collection("AppUser")
        .doc(_auth.currentUser!.uid)
        .collection("Vehicles")
        .doc(vehicleId)
        .delete();
  }

  Future<Vehicle?> getVehicle(String vehicleId) async {
    try {
      DocumentSnapshot vehicleSnapshot = await firestore
          .collection("AppUser")
          .doc(_auth.currentUser!.uid)
          .collection("Vehicles")
          .doc(vehicleId)
          .get();

      if (vehicleSnapshot.exists) {
        return Vehicle(
          vehicleSnapshot.id,
          vehicleSnapshot['vehicleMake'],
          vehicleSnapshot['model'],
          vehicleSnapshot['seatCapacity'],
          vehicleSnapshot['imageUrl'],
          vehicleSnapshot['registrationNumber'],
        );
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting vehicle: $e");
      return null;
    }
  }
}
