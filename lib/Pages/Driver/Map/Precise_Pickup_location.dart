import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:yamudacarpooling/Assistant/assistant_method.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Globle/Map_Key.dart';
import 'package:yamudacarpooling/Model/Directions.dart';
import 'package:yamudacarpooling/infoHandler/App_info.dart';

class PrecisePickupScreen extends StatefulWidget {
  const PrecisePickupScreen({super.key});

  @override
  State<PrecisePickupScreen> createState() => _PrecisePickupScreenState();
}

class _PrecisePickupScreenState extends State<PrecisePickupScreen> {
  LatLng? picklocation;

  loc.Location location = loc.Location();

  String? _address;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();

  GoogleMapController? newGoogleMapController;

  Position? userCurrentPosition;
  double bottompaddingofmap = 0;

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

    String humanReadableAddress =
        await AssistantMethords.searchAddressforGeographiccordinates(
            userCurrentPosition!, context);
  }

  GlobalKey<ScaffoldState> _scaffoldstate = GlobalKey<ScaffoldState>();

  getAddresssFromLatlng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: picklocation!.latitude,
          longitude: picklocation!.longitude,
          googleMapApiKey: map_key);
      setState(() {
        Directions userPickUpAddress = Directions();

        userPickUpAddress.locationlatitude = picklocation!.latitude;
        userPickUpAddress.locationlongitude = picklocation!.longitude;
        userPickUpAddress.locationName = data.address;

        Provider.of<AppInfo>(context, listen: false)
            .updatePickupLocationAddress(userPickUpAddress);

        _address = data.address;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                setState(() {});

                locationUserPosition();
              },
              onCameraMove: (CameraPosition? position) {
                if (picklocation != position!.target) {
                  picklocation = position.target;
                }
              },
              onCameraIdle: () {
                getAddresssFromLatlng();
              },
            ),
            const Align(
              alignment: Alignment.center,
              child: Icon(Icons.location_on),
            ),
            Positioned(
              top: 60,
              right: 20,
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                    color: Secondary, border: Border.all(color: Primary)),
                padding: const EdgeInsets.all(12),
                child: Text(
                  _address ?? "set your location",
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Primary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: const Center(
                      child: Text(
                        "Set location",
                        style: TextStyle(
                          color: Secondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
