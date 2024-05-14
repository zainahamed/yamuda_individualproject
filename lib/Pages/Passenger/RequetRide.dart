import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Globle/Globle.dart';
import 'package:yamudacarpooling/Pages/Driver/Map/Precise_Pickup_location.dart';
import 'package:yamudacarpooling/Pages/Driver/Map/Search_Places.dart';
import 'package:yamudacarpooling/Services/ConfirmRoute.dart';
import 'package:yamudacarpooling/Services/RouteService.dart';
import 'package:yamudacarpooling/Widgets/RouteView.dart';
import 'package:yamudacarpooling/infoHandler/App_info.dart';

class RequestRide extends StatefulWidget {
  const RequestRide({Key? key}) : super(key: key);

  @override
  State<RequestRide> createState() => _RequestRideState();
}

class _RequestRideState extends State<RequestRide> {
  bool obscureText1 = true;
  bool obscureText2 = true;
  bool showIcon = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool location1Selected = false;
  bool location2Selected = false;
  bool vehicle1Selected = false;
  bool vehicle2Selected = false;

  RouteService routeService = RouteService();

  late Timer _timer;
  Position cPosition = Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.fromMillisecondsSinceEpoch(
        0), // Assuming timestamp is in milliseconds since epoch
    accuracy: 0,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );

  ConfirmRoute confirmRoute = ConfirmRoute();
  void resfresh() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        getCurrentPosition();
      });
    });
  }

  Future<void> getCurrentPosition() async {
    cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
    resfresh();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  //display a popup

  // //display a popup
  // void displayDriverReponse(QuerySnapshot snapshot) {
  //   if (snapshot.docs.isNotEmpty) {
  //     String driverId =
  //         (snapshot.docs[0].data() as Map<String, dynamic>)['driverId'];

  //     if ((snapshot.docs[0].data() as Map<String, dynamic>)['status'] == 1) {
  //       showDialog(
  //           context: context,
  //           builder: (context) {
  //             return AlertDialog(
  //               title: const Text('Driver Response'),
  //               content: const Text('Driver has accepted your request'),
  //               actions: [
  //                 TextButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: const Text('OK'))
  //               ],
  //             );
  //           });
  //     } else if ((snapshot.docs[0].data() as Map<String, dynamic>)['status'] ==
  //         -1) {
  //       showDialog(
  //           context: context,
  //           builder: (context) {
  //             return AlertDialog(
  //               title: const Text('Driver Response'),
  //               content: const Text('Driver has rejected your request'),
  //               actions: [
  //                 TextButton(
  //                     onPressed: () {
  //                       ConfirmRoute confirmRoute = ConfirmRoute();
  //                       confirmRoute.cancelRequest(driverId);
  //                       Navigator.pop(context);
  //                     },
  //                     child: const Text('OK'))
  //               ],
  //             );
  //           });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await routeService.deleteUserLocation();
            Navigator.pop(context); // Navigate back to previous screen
          },
        ),
        title: const Text(
          "Request New Ride",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          await routeService.deleteUserLocation();
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Start and End Location
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Start and End Location",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PrecisePickupScreen()));
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(Provider.of<AppInfo>(context)
                                      .userPickupLocation !=
                                  null
                              ? Provider.of<AppInfo>(context)
                                  .userPickupLocation!
                                  .locationName!
                              : "Select Start Location"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.search, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              // Second Search Bar
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: () async {
                    var responseFromSearchScreen = await Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => const SearchPlacesScreen()));

                    if (responseFromSearchScreen == "obtainedDropoff") {
                      setState(() {});
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            Provider.of<AppInfo>(context).userDropoffLocation !=
                                    null
                                ? Provider.of<AppInfo>(context)
                                    .userDropoffLocation!
                                    .locationName!
                                : "Select End Location"),
                      )),
                      const SizedBox(width: 10),
                      const Icon(Icons.search, color: Colors.grey),
                    ],
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Nearby locations of a radius of 500m will be detected",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "No of Passengers",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              // Quantity Increase and Decrease Buttons
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (totalSeats != 1) {
                            totalSeats--;
                          }
                        });
                      },
                      icon: Icon(Icons.remove),
                    ),
                    Text('Request seats : $totalSeats'),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          totalSeats++;
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
              ),

              Container(
                height: height * 0.4,
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.black), // Add border
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(
                        "Available Riders ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(child: _buildRouteList())
                  ],
                ),
              ),
              // Select Vehicle

              // Start Ride Button
              SizedBox(
                height: height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteList() {
    return StreamBuilder(
      stream: routeService.getRoutes(),
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
              snapshot.data!.docs.map((doc) => _buildRouteView(doc)).toList(),
        );
      },
    );
  }

  Widget _buildRouteView(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    double distance = routeService.calculateDistance(
        cPosition.latitude,
        cPosition.longitude,
        data['pickupLoactionlatitude'],
        data['pickupLoactionlongitude']);

    if (distance < 25 && data['driverId'] != currentuser.uid) {
      return RouteView(
        model: data['vehicleModel'],
        seats: data['seats'].toString(),
        id: data['driverId'],
        pickup: data['pickupLocation'],
        dropoff: data['dropOffLocation'],
      );
    }

    return Container();
  }
}
