import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:yamudacarpooling/Assistant/assistant_method.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Globle/Globle.dart';
import 'package:yamudacarpooling/Model/UserModel.dart';
import 'package:yamudacarpooling/Pages/HomePage.dart';
import 'package:yamudacarpooling/Services/AuthService.dart';
import 'package:yamudacarpooling/Services/ConfirmRoute.dart';
import 'package:yamudacarpooling/Services/RouteService.dart';
import 'package:yamudacarpooling/infoHandler/App_info.dart';

class OngoingRoutePassenger extends StatefulWidget {
  const OngoingRoutePassenger({Key? key}) : super(key: key);

  @override
  State<OngoingRoutePassenger> createState() => _OngoingRoutePassengerState();
}

class _OngoingRoutePassengerState extends State<OngoingRoutePassenger> {
  late StreamSubscription<QuerySnapshot> _passengerRequestsSubscription;
  late StreamSubscription<QuerySnapshot> _driverRequestsSubscription;

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

  late StreamSubscription<QuerySnapshot> _driverLocationSubscription;
  late StreamSubscription<Position> _positionSubscription;

  bool isblock = true;
  void block() {
    if (isblock) {}
  }

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
  }

  void displayMyDriverInMap(QuerySnapshot snapshot) {
    setState(() {
      circlesSet.clear();
      markersSet.clear();
      Set<Marker> driversMarkerSet = Set<Marker>();
      String? myDriverId =
          Provider.of<AppInfo>(context, listen: false).myDriverId;

      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        var latitude = data['latitude'];
        var longitude = data['longitude'];

        // Create a marker for each passenger
        if (myDriverId != null && doc.id == myDriverId) {
          Marker marker = Marker(
            markerId: MarkerId(myDriverId!),
            position: LatLng(latitude, longitude),
            icon: activeNearbyIcon!,
            rotation: 360,
          );
          driversMarkerSet.add(marker);
        }
      });

      markersSet = driversMarkerSet;
    });
  }

  createActiveNearByDriverIconMarker() {
    if (activeNearbyIcon == null) {
      BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(0.02, 0.02)), "assets/DMaker.png")
          .then((onValue) {
        activeNearbyIcon = onValue;
      });
    }
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

  void displayDriverReponse(QuerySnapshot snapshot) {
    // Loop through the documents in the snapshot
    snapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data['status'] == 1 && data['passengerId'] == currentuser.uid) {
        showDialog(
            context: context,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: AlertDialog(
                  title: const Text('Driver Response'),
                  content: const Text('Driver has accepted your request'),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Primary,
                        ),
                        onPressed: () {
                          isblock = false;
                          block();
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          width: 250,
                          child: const Center(
                            child: Text(
                              'Ok',
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
              );
            });
      } else if (data['status'] == -1 &&
          data['passengerId'] == currentuser.uid) {
        showDialog(
            context: context,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: AlertDialog(
                  title: const Text('Driver Response'),
                  content: const Text('Driver has rejected your request'),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Primary,
                        ),
                        onPressed: () async {
                          ConfirmRoute confirmRoute = ConfirmRoute();
                          await confirmRoute.cancelRequest(data['driverId']);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          width: 250,
                          child: const Center(
                            child: Text(
                              'Ok',
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
              );
            });
      } else if (data['status'] == 2 &&
          data['passengerId'] == currentuser.uid) {
        showDialog(
            context: context,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: AlertDialog(
                  title: const Text('Driver Response'),
                  content: const Text('Enter the Vehicle'),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Primary,
                        ),
                        onPressed: () async {
                          await confirmRoute.setPassengerPicpuped(
                              currentuser.uid, context);

                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          width: 250,
                          child: const Center(
                            child: Text(
                              'Ok',
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
              );
            });
      } else if (data['status'] == 4 &&
          data['passengerId'] == currentuser.uid) {
        showDialog(
            context: context,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: AlertDialog(
                  title: const Text('Driver Response'),
                  content: const Text('End Route'),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Primary,
                        ),
                        onPressed: () async {
                          ConfirmRoute confirmRoute = ConfirmRoute();

                          await FirebaseFirestore.instance
                              .collection('AppUser')
                              .doc(currentuser.uid)
                              .update({
                            'passengers':
                                (authService.currentUserModel.totalPassengers +
                                    currentpassengers),
                            'rides':
                                authService.currentUserModel.totalRides + 1,
                          });
                          await confirmRoute.setPassngerToDropped(
                              currentuser.uid, context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const HomePage()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          width: 250,
                          child: const Center(
                            child: Text(
                              'Ok',
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
              );
            });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //initializeAsyncOperations();

    _positionSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        userCurrentPosition = position;
        drawPolilineOriginToDestination();
      });

      _driverLocationSubscription =
          routeService.getDriverLocation().listen((snapshot) {
        displayMyDriverInMap(snapshot);
      });
    });
    _driverRequestsSubscription = confirmRoute
        .getDriverResponse(currentuser.uid, context)
        .listen((event) {
      displayDriverReponse(event);
    });
    // block();

    // _userLocationSubscription = confirmRoute
    //     .getPassengersCurrentPositions(currentuser.uid)
    //     .listen((snapshot) {
    //   displayActivePassengers(snapshot);
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _driverLocationSubscription.cancel();
    _driverRequestsSubscription.cancel();

    _positionSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    createActiveNearByDriverIconMarker();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          key: const Key('OngoingRoutePassengerScaffoldKey'),
          body: Column(
            children: [
              Container(
                height: height * 0.75,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Primary,
                  ),
                  onPressed: () async {
                    await confirmRoute.endRidePassenger(
                        currentuser.uid, context);

                    Navigator.of(context).pop();
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
            ],
          ),
        ),
      ),
    );
  }
}
