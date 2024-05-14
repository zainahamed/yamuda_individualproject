import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yamudacarpooling/Assistant/assistant_method.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Globle/Globle.dart';
import 'package:yamudacarpooling/Model/RouteDetails.dart';
import 'package:yamudacarpooling/Model/UserModel.dart';
import 'package:yamudacarpooling/Services/AuthService.dart';
import 'package:yamudacarpooling/Services/ConfirmRoute.dart';
import 'package:yamudacarpooling/Services/RouteService.dart';
import 'package:yamudacarpooling/Widgets/ConfirmationAlert.dart';
import 'package:yamudacarpooling/Widgets/PassengerView.dart';
import 'package:yamudacarpooling/Widgets/PassengerView2.dart';
import 'package:yamudacarpooling/Widgets/SnackbarMessage.dart';
import 'package:yamudacarpooling/infoHandler/App_info.dart';

class SelectRouteDriver extends StatefulWidget {
  const SelectRouteDriver({Key? key}) : super(key: key);

  @override
  State<SelectRouteDriver> createState() => _SelectRouteDriverState();
}

class _SelectRouteDriverState extends State<SelectRouteDriver> {
  late StreamSubscription<QuerySnapshot> _passengerRequestsSubscription;

  AuthServices authService = AuthServices();
  RouteService routeService = RouteService();
  ConfirmRoute confirmRoute = ConfirmRoute();
  LatLng? picklocation;

  loc.Location location = loc.Location();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();

  GoogleMapController? newGoogleMapController;

  double serachLocationContainerHight = 220;
  double waitingResponcefromDriverContainerHight = 0;
  double assignedDriverInfoContaineHight = 0;

  Position? userCurrentPosition;

  var geolocation = Geolocator();

  LocationPermission? locationPermission;
  double bottompaddingofmap = 0;

  List<LatLng> pLineCoordinateList = [];

  Set<Polyline> polylineSet = {};

  Set<Marker> markersSet = {};

  Set<Circle> circlesSet = {};

  String username = "";
  String email = '"';

  bool openNavigationDraver = true;

  bool activeNearbyPassengerKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  int _myPassengerList = 0;

  late StreamSubscription<QuerySnapshot> _userLocationSubscription;
  late StreamSubscription<Position> _positionSubscription;
  late UserModel userModel;

  locationUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;
    LatLng latlngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latlngPosition, zoom: 15);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    UserModel user =
        await authService.getAppUser(FirebaseAuth.instance.currentUser!.uid);

    username = user.username;
    email = user.email;

    //AssistantMethords.readTripKeyforOnlineUser(context);
  }

  createActiveNearByDriverIconMarker() {
    if (activeNearbyIcon == null) {
      BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(0.2, 0.2)),
              "assets/PMaker.png")
          .then((onValue) {
        activeNearbyIcon = onValue;
      });
    }
  }

  void displayActivePassengers(QuerySnapshot snapshot) {
    setState(() {
      circlesSet.clear();
      markersSet.clear();
      Set<Marker> passengerMarkerSet = Set<Marker>();

      _myPassengerList = snapshot.docs.length;

      // Loop through the documents in the snapshot
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        var userId = doc.id;
        var latitude = data['userLatitude'];
        var longitude = data['userLongitude'];

        double distance = routeService.calculateDistance(latitude, longitude,
            userCurrentPosition!.latitude, userCurrentPosition!.longitude);

        // Create a marker for each passenger
        if (doc['status'] == 1) {
          debugPrint(distance.toString());
          Marker marker = Marker(
            markerId: MarkerId(userId),
            position: LatLng(latitude, longitude),
            icon: activeNearbyIcon!,
            rotation: 360,
          );
          passengerMarkerSet.add(marker);
          drawPolylineForPassenger(latitude, longitude);
        }
      });

      markersSet = passengerMarkerSet;
    });
  }

  checkIfLocationPermissionAllowed() async {
    locationPermission = await Geolocator.requestPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }
  }

  Future<void> drawPolilineOriginToDestination() async {
    // locationUserPosition();
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickupLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropoffLocation;
    var originLatlng =
        LatLng(userCurrentPosition!.latitude!, userCurrentPosition!.longitude!);
    var destinationLatlng = LatLng(destinationPosition!.locationlatitude!,
        destinationPosition!.locationlongitude!);

    var directionDetailsInfo =
        await AssistantMethords.obtainOrigintoDestinationDirectionDetails(
            originLatlng, destinationLatlng);

    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolylineResultList =
        polylinePoints.decodePolyline(directionDetailsInfo.e_points!);
    pLineCoordinateList.clear();

    if (decodePolylineResultList.isNotEmpty) {
      decodePolylineResultList.forEach((PointLatLng pointLatLng) {
        pLineCoordinateList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    //polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
          color: polylineColor,
          polylineId: PolylineId('PolylineID'),
          jointType: JointType.round,
          points: pLineCoordinateList,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
          width: 5);

      polylineSet.add(polyline);
    });

    LatLngBounds boundsLatland;
    if (originLatlng.latitude > destinationLatlng.latitude &&
        originLatlng.longitude > destinationLatlng.longitude) {
      boundsLatland =
          LatLngBounds(southwest: destinationLatlng, northeast: originLatlng);
    } else if (originLatlng.longitude > destinationLatlng.longitude) {
      boundsLatland = LatLngBounds(
          southwest: LatLng(originLatlng.latitude, destinationLatlng.longitude),
          northeast:
              LatLng(destinationLatlng.latitude, destinationLatlng.longitude));
    } else if (originLatlng.latitude > destinationLatlng.latitude) {
      boundsLatland = LatLngBounds(
          southwest: LatLng(destinationLatlng.latitude, originLatlng.longitude),
          northeast:
              LatLng(originLatlng.latitude, destinationLatlng.longitude));
    } else {
      boundsLatland =
          LatLngBounds(southwest: originLatlng, northeast: destinationLatlng);
    }

    Marker originMaker = Marker(
      markerId: const MarkerId('originId'),
      infoWindow: InfoWindow(title: "you", snippet: 'Origin'),
      position: originLatlng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId('destinationId'),
      infoWindow: InfoWindow(
          title: destinationPosition.locationName, snippet: 'Destination'),
      position: destinationLatlng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markersSet.add(originMaker);
      markersSet.add(destinationMarker);
    });
  }

  // Method to draw polyline between current position and passenger's location
  void drawPolylineForPassenger(
      double passengerLatitude, double passengerLongitude) async {
    LatLng passengerLatLng = LatLng(
      passengerLatitude,
      passengerLongitude,
    );

    var directionDetails =
        await AssistantMethords.obtainOrigintoDestinationDirectionDetails(
      LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude),
      passengerLatLng,
    );

    // Decode polyline points
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolylineResultList =
        polylinePoints.decodePolyline(directionDetails.e_points!);

    // Clear previous polylines
    setState(() {
      // polylineSet.removeWhere((element) =>
      //     element.polylineId.value == '$passengerLatitude-$passengerLongitude');
    });

    List<LatLng> polylineCoordinates = [];

    if (decodePolylineResultList.isNotEmpty) {
      decodePolylineResultList.forEach((PointLatLng pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });

      // Add new polyline
      setState(() {
        Polyline passengerPolyline = Polyline(
          polylineId: PolylineId('$passengerLatitude-$passengerLongitude'),
          color: Colors.blue, // Choose your polyline color
          points: polylineCoordinates,
          width: 3,
        );
        polylineSet.add(passengerPolyline);
      });
    }
  }

  void rejectRoute(String id) {
    ConfirmRoute confirmRoute = ConfirmRoute();
    confirmRoute.rejectRequest(RouteDetails(driverId: currentuser.uid), id);
    Navigator.pop(context);
  }

  void accept(String id) {
    ConfirmRoute confirmRoute = ConfirmRoute();
    confirmRoute.acceptRequest(RouteDetails(driverId: currentuser.uid), id);
  }

  @override
  void initState() {
    super.initState();
    //initializeAsyncOperations();
    userModel =
        Provider.of<AuthServices>(context, listen: false).currentUserModel;

    routeService.listenDriverLocation();
    _positionSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        userCurrentPosition = position;
        drawPolilineOriginToDestination();
      });
    });

    _userLocationSubscription = confirmRoute
        .getPassengersCurrentPositions(currentuser.uid)
        .listen((snapshot) {
      displayActivePassengers(snapshot);
    });

    _passengerRequestsSubscription = confirmRoute
        .getPassengerConfirmRequests(
      currentuser.uid,
    )
        .listen((snapshot) {
      displayPassengerRequestDialog(snapshot);
    });
  }

  @override
  void dispose() {
    super.dispose();
    routeService.deleteDriverLocation();
    _userLocationSubscription.cancel();
    _passengerRequestsSubscription.cancel();
    _positionSubscription.cancel();
  }

  void displayPassengerRequestDialog(QuerySnapshot snapshot) {
    snapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data['status'] == 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfirmationAlert(
              pickup: data['startLocation'],
              dropoff: data['endLocation'],
              name: data['userName'],
              company: data['companyName'],
              seats: data['seatsNeeded'].toString(),
              btnName: 'Accept',
              onConfirmPressed: () {
                Provider.of<AppInfo>(context, listen: false)
                    .updatePassengesrs(data['seatsNeeded']);
                accept(doc.id);
                Navigator.of(context).pop();
              },
              onCancelPressed: () {
                rejectRoute(doc.id);
              },
            );

            // return ConfirmationAlert(
            //   title: Text('Passenger Request'),
            //   content: Text(
            //     'Passenger ${data['userName']} is requesting to join your ride. Do you accept?',
            //   ),
            //   actions: [
            //     TextButton(
            //       onPressed: () {
            //         ConfirmRoute confirmRoute = ConfirmRoute();
            //         confirmRoute.rejectRequest(
            //             RouteDetails(driverId: currentuser.uid), doc.id);
            //         Navigator.pop(context);
            //       },
            //       child: Text('Reject'),
            //     ),
            //     TextButton(
            //       onPressed: () {
            //         ConfirmRoute confirmRoute = ConfirmRoute();
            //         confirmRoute.acceptRequest(
            //           RouteDetails(driverId: currentuser.uid),
            //           doc.id,
            //         );
            //         Navigator.pop(context);
            //       },
            //       child: Text('Accept'),
            //     ),
            //   ],
            // );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    createActiveNearByDriverIconMarker();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SafeArea(
          child: Scaffold(
            key: const Key('selectRouteDriverScaffoldKey'),
            body: Column(
              children: [
                Container(
                  height: height * 0.5,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    initialCameraPosition: _kGooglePlex,
                    polylines: polylineSet,
                    markers: markersSet,
                    circles: circlesSet,
                    onMapCreated: (GoogleMapController controller) {
                      _controllerGoogleMap.complete(controller);
                      newGoogleMapController = controller;

                      setState(() {});

                      locationUserPosition();
                    },
                  ),
                ),
                Stack(children: [
                  _myPassengerList == 0
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 100),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("No Passengers!")),
                        )
                      : const SizedBox(),
                  Container(
                    height: 250,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.black), // Add border
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Text(
                            "Passengers in Vehicle ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(child: _builtMyPassengerList()),
                      ],
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Primary,
                    ),
                    onPressed: () async {
                      if (_myPassengerList == 0) {
                        await routeService.cancleRoute(
                            currentuser.uid,
                            userModel.totalRides,
                            Provider.of<AppInfo>(context, listen: false)
                                .currentRidePassengers);
                        await Provider.of<AuthServices>(context, listen: false)
                            .getAppUser(currentuser.uid);
                        Navigator.of(context).pop(); // Close the dialog
                      } else {
                        SnackBarMessage.showSnackBarError(context,
                            "You can't cancel the Route.You have ongoing passengers");
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      width: 300,
                      child: const Center(
                        child: Text(
                          'End Ride',
                          style: TextStyle(
                            color: Secondary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                    ),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Call Passenger'),
                            content: SizedBox(
                              height: 200, // Adjust height as needed
                              width: double.maxFinite,
                              child: Expanded(
                                  child: _builtMyPassengerListforPhoneNumber()),
                            ),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    width: 300,
                                    child: const Center(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      width: 300,
                      child: const Center(
                        child: Text(
                          "Emergency Call",
                          style: TextStyle(
                            color: Colors.red,
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
        ),
      ),
    );
  }

//get my passenger list
  Widget _builtMyPassengerList() {
    return StreamBuilder(
      stream: confirmRoute.getDriversPassengers(),
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
          children: snapshot.data!.docs
              .map((doc) => _buildPassengerView(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildPassengerView(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    int status = data['status'];
    late bool _isPickup;
    if (status == 1) {
      _isPickup = false;
      return PassengerView(
        passengerName: data['userName'],
        isPickup: _isPickup,
        passengerId: data['passengerId'],
        status: 'Pick Passenger',
        destination: data['endLocation'],
      );
    } else if (status == 2) {
      _isPickup = false;
      return PassengerView(
        passengerName: data['userName'],
        isPickup: _isPickup,
        passengerId: data['passengerId'],
        status: 'Pending to Pick Passenger',
        destination: data['endLocation'],
      );
    } else if (status == 3) {
      _isPickup = true;
      return PassengerView(
        passengerName: data['userName'],
        isPickup: _isPickup,
        passengerId: data['passengerId'],
        status: 'Drop Passenger',
        destination: data['endLocation'],
      );
    } else if (status == 4) {
      _isPickup = true;
      return PassengerView(
        passengerName: data['userName'],
        isPickup: _isPickup,
        passengerId: data['passengerId'],
        status: 'Pending to Drop Passenger',
        destination: data['endLocation'],
      );
    } else {
      return Container();
    }
  }

  Widget _builtMyPassengerListforPhoneNumber() {
    return StreamBuilder(
      stream: confirmRoute.getDriversPassengers(),
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
          children: snapshot.data!.docs
              .map((doc) => _buildPassengerViewPhoneNumber(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildPassengerViewPhoneNumber(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    int status = data['status'];
    late bool _isPickup;
    if (status == 1) {
      _isPickup = false;
      return PassengerView2(
        passengerName: data['userName'],
        isPickup: _isPickup,
        passengerId: data['passengerId'],
        status: 'Pick Passenger',
        destination: data['endLocation'],
      );
    } else if (status == 2) {
      _isPickup = false;
      return PassengerView2(
        passengerName: data['userName'],
        isPickup: _isPickup,
        passengerId: data['passengerId'],
        status: 'Pending to Pick Passenger',
        destination: data['endLocation'],
      );
    } else if (status == 3) {
      _isPickup = true;
      return PassengerView2(
        passengerName: data['userName'],
        isPickup: _isPickup,
        passengerId: data['passengerId'],
        status: 'Drop Passenger',
        destination: data['endLocation'],
      );
    } else if (status == 4) {
      _isPickup = true;
      return PassengerView2(
        passengerName: data['userName'],
        isPickup: _isPickup,
        passengerId: data['passengerId'],
        status: 'Pending to Drop Passenger',
        destination: data['endLocation'],
      );
    } else {
      return Container();
    }
  }
}

void makePhoneCall(String phoneNumber) async {
  String telScheme = 'tel:$phoneNumber';

  if (await canLaunch(telScheme)) {
    await launch(telScheme);
  } else {
    throw 'Could not launch $telScheme';
  }
}

//updated code for phone call
//not sure is it working
/////
////
