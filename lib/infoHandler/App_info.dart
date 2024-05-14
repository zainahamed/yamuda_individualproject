import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yamudacarpooling/Globle/Globle.dart';
import 'package:yamudacarpooling/Model/Directions.dart';
import 'package:yamudacarpooling/Model/RouteDetails.dart';
import 'package:yamudacarpooling/Model/Vehicle.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickupLocation, userDropoffLocation;

  Vehicle? selectedVehicle;

  RouteDetails? myRouteDetails;

  String? myDriverId = "sdfs";

  int countTotalTrips = 0;

  List<String> historyTripKeyLis = [];

  int currentRidePassengers = 0;

  //List<TripHistoryModel> allTripsHistoryInfolist =[];

  void updatePickupLocationAddress(Directions userPickupAddress) {
    userPickupLocation = userPickupAddress;
    notifyListeners();
  }

  void updateDropoffLocationAddress(Directions userDropoffAddress) {
    userDropoffLocation = userDropoffAddress;
    notifyListeners();
  }

  void setDirverSelectedVehicle(Vehicle? selected) {
    selectedVehicle = selected;
    notifyListeners();
  }

  void setMyDriverId(String driverId) async {
    await FirebaseFirestore.instance
        .collection('AppUser')
        .doc(currentuser!.uid)
        .update({
      'myDriverId': driverId,
    });
    myDriverId = driverId;
    notifyListeners();
  }

  void updatePassengesrs(int passengers) {
    currentRidePassengers = currentRidePassengers + passengers;
    debugPrint("Passenger sdfdsfs" + currentRidePassengers.toString());
    notifyListeners();
  }

  void resetPassengesrs() {
    currentRidePassengers = 0;
    debugPrint(currentRidePassengers.toString());

    notifyListeners();
  }
}
