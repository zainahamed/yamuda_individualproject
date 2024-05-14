import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Globle/Globle.dart';
import 'package:yamudacarpooling/Model/Directions.dart';
import 'package:yamudacarpooling/Model/RouteDetails.dart';
import 'package:yamudacarpooling/Model/Vehicle.dart';
import 'package:yamudacarpooling/Pages/Driver/Map/Precise_Pickup_location.dart';
import 'package:yamudacarpooling/Pages/Driver/Map/Search_Places.dart';
import 'package:yamudacarpooling/Pages/Driver/Map/SelectRouteDriver.dart';
import 'package:yamudacarpooling/Pages/HomePage.dart';
import 'package:yamudacarpooling/Pages/Profile/Vehicles.dart';
import 'package:yamudacarpooling/Services/AuthService.dart';
import 'package:yamudacarpooling/Services/RouteService.dart';
import 'package:yamudacarpooling/Widgets/SnackbarMessage.dart';
import 'package:yamudacarpooling/Widgets/VehicleView.dart';
import 'package:yamudacarpooling/infoHandler/App_info.dart';

class StartNewRide extends StatefulWidget {
  const StartNewRide({Key? key}) : super(key: key);

  @override
  State<StartNewRide> createState() => _StartNewRideState();
}

class _StartNewRideState extends State<StartNewRide> {
  bool obscureText1 = true;
  bool obscureText2 = true;
  bool showIcon = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool location1Selected = false;
  bool location2Selected = false;
  bool vehicle1Selected = false;
  bool vehicle2Selected = false;
  int totalSeats = 1;

  void startRide() {
    Vehicle? selectedVehicle =
        Provider.of<AppInfo>(context, listen: false).selectedVehicle;
    Directions? userPickupLocation =
        Provider.of<AppInfo>(context, listen: false).userPickupLocation;
    Directions? userDropoffLocation =
        Provider.of<AppInfo>(context, listen: false).userDropoffLocation;

    if (selectedVehicle != null &&
        userDropoffLocation != null &&
        userPickupLocation != null) {
      RouteService routeService = RouteService();
      RouteDetails routeDetails = RouteDetails();

      routeDetails.pickupLocation = userPickupLocation.locationName;
      routeDetails.dropOffLocation = userDropoffLocation.locationName;
      routeDetails.vehicleModel = selectedVehicle.model;
      routeDetails.driverId = currentuser.uid;
      routeDetails.seats = totalSeats;

      routeService.startRoute(routeDetails);
      debugPrint(userPickupLocation.locationName);
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SelectRouteDriver()));
    } else {
      SnackBarMessage.showSnackBarError(context,
          "Please select the start and end locations and Your Vehicle");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Vehicle? selectedVehicle =
        Provider.of<AppInfo>(context, listen: false).selectedVehicle;
    return WillPopScope(
      onWillPop: () async {
        Provider.of<AuthServices>(context, listen: false)
            .getAppUser(currentuser.uid);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePage()));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Provider.of<AuthServices>(context, listen: false)
                  .getAppUser(currentuser.uid);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      HomePage())); // Navigate back to previous screen
            },
          ),
          title: const Text(
            "Start New Ride",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
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
                // First Search Bar
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
                              builder: (context) =>
                                  const SearchPlacesScreen()));

                      if (responseFromSearchScreen == "obtainedDropoff") {
                        setState(() {});
                      }
                    },
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(Provider.of<AppInfo>(context)
                                      .userDropoffLocation !=
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
                // Your Route
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Your Route",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                // Select Route
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.black), // Add border
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        child: Text(
                          "Select Vehicle",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: width,
                        child: selectedVehicle != null
                            ? VehicleView(
                                id: selectedVehicle.id,
                                model: selectedVehicle.model,
                                seats: selectedVehicle.seatCapacity.toString(),
                                imageUrl: selectedVehicle.imageUrl!)
                            : const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 8),
                                child:
                                    Text("Click here to select your vehicle"),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
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
                              icon: const Icon(Icons.remove),
                            ),
                            Text('Available seats : $totalSeats'),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  totalSeats++;
                                });
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Primary),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Vehicles()));
                          },
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(vertical: height * 0.02),
                            width: width * 0.7,
                            child: const Center(
                              child: Text(
                                "Select the Vehecle",
                                style: TextStyle(
                                  color: Primary,
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
                // Start Ride Button
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Primary,
                    ),
                    onPressed: () {
                      startRide();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: height * 0.02),
                      child: const Center(
                        child: Text(
                          "Start Ride",
                          style: TextStyle(
                            color: Secondary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Login button

                // Text and Sign Up option

                SizedBox(
                  height: height * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
