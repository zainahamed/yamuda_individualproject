import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:yamudacarpooling/Globle/Globle.dart';
import 'package:yamudacarpooling/Model/RouteDetails.dart';

class RouteService {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  Future<void> startRoute(RouteDetails routeDetails) async {
    try {
      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      CollectionReference routesCollection =
          FirebaseFirestore.instance.collection('onlineRoutes');

      await routesCollection.doc(routeDetails.driverId).set({
        'driverId': routeDetails.driverId,
        'pickupLocation': routeDetails.pickupLocation,
        'dropOffLocation': routeDetails.dropOffLocation,
        'vehicleModel': routeDetails.vehicleModel,
        'seats': routeDetails.seats,
        'pickupLoactionlatitude': pos!.latitude,
        'pickupLoactionlongitude': pos!.longitude,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> cancleRoute(String id, int rides, int passengers) async {
    try {
      CollectionReference routesCollection =
          FirebaseFirestore.instance.collection('onlineRoutes');

      await routesCollection.doc(id).delete();
      await updateDriverRouteInfo(rides, passengers);

      Future.delayed(Duration(microseconds: 2000), () {});
    } catch (e) {
      throw e;
    }
  }

  Stream<QuerySnapshot> getRoutes() {
    try {
      return FirebaseFirestore.instance.collection('onlineRoutes').snapshots();
    } catch (e) {
      print('Error fetching routes: $e');
      throw e;
    }
  }

//store user locations in database

  Future<void> listenUserLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();

      _locationSubscription = null;
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance
          .collection('onlineUserLocations')
          .doc(currentuser.uid)
          .set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
      }, SetOptions(merge: true));
    });
  }

//delete user location from database
  Future<void> deleteUserLocation() async {
    _locationSubscription?.cancel();

    _locationSubscription = null;

    await FirebaseFirestore.instance
        .collection('onlineUserLocations')
        .doc(currentuser.uid)
        .delete();
  }

  //Retrive user locations from database
  Stream<QuerySnapshot> getUserLocation() {
    try {
      return FirebaseFirestore.instance
          .collection('onlineUserLocations')
          .snapshots();
    } catch (e) {
      print('Error fetching routes: $e');
      throw e;
    }
  }

  //store driver locations in database

  Future<void> listenDriverLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();

      _locationSubscription = null;
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance
          .collection('onlineDriverLocations')
          .doc(currentuser.uid)
          .set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
      }, SetOptions(merge: true));
    });
  }

//delete driver location from database
  Future<void> deleteDriverLocation() async {
    _locationSubscription?.cancel();

    _locationSubscription = null;

    await FirebaseFirestore.instance
        .collection('onlineDriverLocations')
        .doc(currentuser.uid)
        .delete();
  }

  //Retrive driver locations from database
  Stream<QuerySnapshot> getDriverLocation() {
    try {
      return FirebaseFirestore.instance
          .collection('onlineDriverLocations')
          .snapshots();
    } catch (e) {
      print('Error fetching routes: $e');
      throw e;
    }
  }

  //caculate the distance
  double calculateDistance(lat1, lon1, lat2, lon2) {
    const p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  //update dirverRoute info
  Future<void> updateDriverRouteInfo(int rides, int passengers) async {
    rides++;
    await FirebaseFirestore.instance
        .collection('AppUser')
        .doc(currentuser.uid)
        .update({
      'passengers': passengers,
      'rides': rides,
    });
  }

  //update passinfo
  Future<void> updatePassengerRouteInfo(int rides, int passengers) async {
    rides++;
    await FirebaseFirestore.instance
        .collection('AppUser')
        .doc(currentuser.uid)
        .update({
      'passengers': passengers,
      'rides': rides,
    });
  }
}
