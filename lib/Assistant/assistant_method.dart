import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yamudacarpooling/Assistant/RequestAssistant.dart';
import 'package:yamudacarpooling/Globle/Map_Key.dart';
import 'package:yamudacarpooling/Model/Direction_details_info.dart';
import 'package:yamudacarpooling/Model/Directions.dart';
import 'package:yamudacarpooling/infoHandler/App_info.dart';

class AssistantMethords {
  static Future<String> searchAddressforGeographiccordinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$map_key";
    String humanReadableAddress = '';

    var requestresponse = await RequestAssistance.receiveRequest(apiUrl);
    if (requestresponse != 'error occurred, no response') {
      humanReadableAddress = requestresponse['results'][0]['formatted_address'];

      Directions userPickUpAddress = Directions();

      userPickUpAddress.locationlatitude = position.latitude;
      userPickUpAddress.locationlongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickupLocationAddress(userPickUpAddress);
    }
    return humanReadableAddress;
  }

  static Future<DirectionDetailsInfo> obtainOrigintoDestinationDirectionDetails(
      LatLng originPosition, LatLng destinationPosition) async {
    String urlOrigintoDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$map_key";

    var responseDirectionApi = await RequestAssistance.receiveRequest(
        urlOrigintoDestinationDirectionDetails);

    // if (responseDirectionApi == 'error occurred, no response') {
    //   return null;
    // }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();

    directionDetailsInfo.e_points =
        responseDirectionApi['routes'][0]['overview_polyline']['points'];
    directionDetailsInfo.distance_text =
        responseDirectionApi['routes'][0]['legs'][0]['distance']['text'];
    directionDetailsInfo.distanceValue =
        responseDirectionApi['routes'][0]['legs'][0]['distance']['value'];

    directionDetailsInfo.duration_text =
        responseDirectionApi['routes'][0]['legs'][0]['duration']['text'];
    directionDetailsInfo.durationValue =
        responseDirectionApi['routes'][0]['legs'][0]['duration']['value'];

    return directionDetailsInfo;
  }
}
