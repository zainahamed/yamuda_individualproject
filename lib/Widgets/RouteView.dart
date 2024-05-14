import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Globle/Globle.dart';
import 'package:yamudacarpooling/Model/Directions.dart';
import 'package:yamudacarpooling/Model/RouteDetails.dart';
import 'package:yamudacarpooling/Model/UserModel.dart';
import 'package:yamudacarpooling/Pages/Passenger/Map/OngoingRoutePassenger.dart';
import 'package:yamudacarpooling/Services/AuthService.dart';
import 'package:yamudacarpooling/Services/ConfirmRoute.dart';
import 'package:yamudacarpooling/Services/VehicleService.dart';
import 'package:yamudacarpooling/Widgets/ConfirmationAlert.dart';
import 'package:yamudacarpooling/Widgets/SnackbarMessage.dart';
import 'package:yamudacarpooling/infoHandler/App_info.dart';

class RouteView extends StatefulWidget {
  final String id;
  final String model;
  final String seats;
  final String pickup;
  final String dropoff;

  const RouteView({
    super.key,
    required this.model,
    required this.seats,
    required this.id,
    required this.pickup,
    required this.dropoff,
  });

  @override
  State<RouteView> createState() => _RouteViewState();
}

class _RouteViewState extends State<RouteView> {
  late Position cPosition;

  @override
  void initState() {
    super.initState();
    currentpassengers = int.parse(widget.seats);
  }

  @override
  @override
  void dispose() {
    super.dispose();
  }

  VehicleService vehicleService = VehicleService();
  ConfirmRoute confirmation = ConfirmRoute();
  AuthServices authServices = AuthServices();

  String userName = '';
  String companyName = '';

  Future<void> getPassengerDetails() async {
    Provider.of<AppInfo>(context, listen: false).setMyDriverId(widget.id);

    UserModel usermodel =
        Provider.of<AuthServices>(context, listen: false).currentUserModel!;
    userName = usermodel.username;
    companyName = usermodel.company;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        getPassengerDetails();

        Directions? userPickupLocation =
            Provider.of<AppInfo>(context, listen: false).userPickupLocation;
        Directions? userDropoffLocation =
            Provider.of<AppInfo>(context, listen: false).userDropoffLocation;
        if (userPickupLocation != null && userDropoffLocation != null) {
          showDialog(
              context: context,
              builder: (BuildContext context) => ConfirmationAlert(
                    pickup: userPickupLocation.locationName!,
                    dropoff: userDropoffLocation!.locationName!,
                    name: userName,
                    company: companyName,
                    seats: totalSeats.toString(),
                    btnName: 'Request',
                    onConfirmPressed: () {
                      if (int.parse(widget.seats) >= totalSeats) {
                        RouteDetails routeDetails = RouteDetails(
                          driverId: widget.id,
                          pickupLocation: userPickupLocation.locationName!,
                          dropOffLocation: userDropoffLocation.locationName!,
                          seats: totalSeats,
                          pickupLoactionlatitude:
                              userPickupLocation.locationlatitude,
                          pickupLoactionlongitude:
                              userPickupLocation.locationlongitude,
                          vehicleModel: widget.model,
                          passengerId: currentuser.uid,
                          name: userName,
                          company: companyName,
                        );

                        confirmation.passengerConfirmRequest(routeDetails);
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const OngoingRoutePassenger()));
                      } else {
                        SnackBarMessage.showSnackBarError(context,
                            "only ${widget.seats} seats are Available in this Route");
                      }
                    },
                    onCancelPressed: () {
                      Navigator.of(context).pop();
                    },
                  ));
        } else {
          SnackBarMessage.showSnackBarError(
              context, "please set your pickup  and drop off locations");
        }
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "From : ${widget.pickup.length >= 45 ? widget.pickup.substring(0, 43) + " .." : widget.pickup}",
                    style: const TextStyle(
                        color: Primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  Text(
                    "To : ${widget.dropoff.length >= 45 ? widget.dropoff.substring(0, 43) + " .." : widget.dropoff}",
                    style: const TextStyle(
                        color: Primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  Text(
                    "Model :${widget.model}",
                    style: TextStyle(
                        color: Primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  Text("Seat :${widget.seats} Capacity",
                      style: TextStyle(
                          color: Primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
