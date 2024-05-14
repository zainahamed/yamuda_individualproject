import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yamudacarpooling/Globle/Globle.dart';
import 'package:yamudacarpooling/Model/RouteDetails.dart';
import 'package:yamudacarpooling/Services/AuthService.dart';
import 'package:yamudacarpooling/Services/RouteService.dart';
import 'package:yamudacarpooling/infoHandler/App_info.dart';

class ConfirmRoute {
  //add default constructor

  AuthServices authService = AuthServices();
  RouteService routeService = RouteService();

  CollectionReference routesCollection =
      FirebaseFirestore.instance.collection('onlineRoutes');

  //make a collection in the routescollection and add the requested route to firebase
  Future<void> passengerConfirmRequest(RouteDetails routeDetails) async {
    try {
      await routesCollection
          .doc(routeDetails.driverId)
          .collection("passengers")
          .doc(currentuser.uid)
          .set({
        'startLocation': routeDetails.pickupLocation,
        'endLocation': routeDetails.dropOffLocation,
        'seatsNeeded': routeDetails.seats,
        'userName': routeDetails.name,
        'companyName': routeDetails.company,
        'userLatitude': routeDetails.pickupLoactionlatitude,
        'userLongitude': routeDetails.pickupLoactionlongitude,
        'status': 0,
        'passengerId': routeDetails.passengerId,
        'driverId': routeDetails.driverId,
      });
    } catch (e) {
      throw e;
    }
  }

  //now driver should be able to get the stream of confirmRoutes to driver
  Stream<QuerySnapshot> getPassengerConfirmRequests(String driverId) {
    try {
      return routesCollection
          .doc(driverId)
          .collection("passengers")
          .snapshots()
          .where((event) => event.docs[0].data()['status'] == 0);
    } catch (e) {
      print('Error fetching routes: $e');
      throw e;
    }
  }

  //change the status to true when driver accepts the request
  Future<void> acceptRequest(
    RouteDetails routeDetails,
    String passengerID,
  ) async {
    try {
      await routesCollection
          .doc(routeDetails.driverId)
          .collection("passengers")
          .doc(passengerID)
          .update({
        'status': 1,
      });
    } catch (e) {
      throw e;
    }
  }

  //change the status to true when driver accepts the request
  Future<void> rejectRequest(
      RouteDetails routeDetails, String passengerID) async {
    try {
      await routesCollection
          .doc(routeDetails.driverId)
          .collection("passengers")
          .doc(passengerID)
          .update({
        'status': -1,
      });
    } catch (e) {
      throw e;
    }
  }

  //get the stream to passenger when the driver accept it
  Stream<QuerySnapshot> getPassengerStatus(RouteDetails routeDetails) {
    try {
      return routesCollection.doc().collection("passengers").snapshots().where(
          (event) =>
              event.docs[0].data()['status'] == 1 &&
              event.docs[1].data()['passengerId'] == currentuser.uid);
    } catch (e) {
      print('Error fetching routes: $e');
      throw e;
    }
  }

  //get the stream of the request
  Stream<QuerySnapshot> getDriverResponse(
      String passengerID, BuildContext context) {
    try {
      String id = Provider.of<AppInfo>(context, listen: false).myDriverId!;
      return routesCollection.doc(id).collection("passengers").snapshots();
    } catch (e) {
      print('Error fetching routes: $e');
      throw e;
    }
  }

  //write a function to set the status to -2
  Future<void> cancelRequest(String driverId) async {
    try {
      await routesCollection
          .doc(driverId)
          .collection("passengers")
          .doc(currentuser.uid)
          .delete();
    } catch (e) {
      throw e;
    }
  }

//get the stream of the request
  Stream<QuerySnapshot> getPassengersCurrentPositions(String id) {
    try {
      return routesCollection.doc(id).collection("passengers").snapshots();
    } catch (e) {
      print('Error fetching routes: $e');
      throw e;
    }
  }

  //get the stream of the request of dirver's passengers
  Stream<QuerySnapshot> getDriversPassengers() {
    try {
      return routesCollection
          .doc(currentuser.uid)
          .collection("passengers")
          .snapshots();
    } catch (e) {
      print('Error fetching routes: $e');
      throw e;
    }
  }

  //pickup passenger
  Future<void> setPassengerPicpuped(
      String passengerId, BuildContext context) async {
    try {
      String id = Provider.of<AppInfo>(context, listen: false).myDriverId!;
      await routesCollection
          .doc(id)
          .collection("passengers")
          .doc(passengerId)
          .update({
        'status': 3,
      });
    } catch (e) {
      throw e;
    }
  }

//pickup passenger
  Future<void> setPassengerPendingToPicpuped(String passengerId) async {
    try {
      await routesCollection
          .doc(currentuser.uid)
          .collection("passengers")
          .doc(passengerId)
          .update({
        'status': 2,
      });
    } catch (e) {
      throw e;
    }
  }

  //drop passenger
  Future<void> setPassengerPendingToDrop(String passengerId) async {
    try {
      await routesCollection
          .doc(currentuser.uid)
          .collection("passengers")
          .doc(passengerId)
          .update({
        'status': 4,
      });
    } catch (e) {
      throw e;
    }
  }

  //drop passneger
  Future<void> setPassngerToDropped(
      String passengerId, BuildContext context) async {
    try {
      String id = Provider.of<AppInfo>(context, listen: false).myDriverId!;

      await routesCollection
          .doc(id)
          .collection("passengers")
          .doc(passengerId)
          .delete();
    } catch (e) {
      throw e;
    }
  }

  //end ride passenger
  Future<void> endRidePassenger(
      String passengerID, BuildContext context) async {
    try {
      String id = Provider.of<AppInfo>(context, listen: false).myDriverId!;
      await routesCollection
          .doc(id)
          .collection("passengers")
          .doc(passengerID)
          .delete();
    } catch (e) {
      throw e;
    }
  } //Update driver details
}
