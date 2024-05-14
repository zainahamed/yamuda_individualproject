import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:yamudacarpooling/Assistant/RequestAssistant.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Globle/Globle.dart';
import 'package:yamudacarpooling/Globle/Map_Key.dart';
import 'package:yamudacarpooling/Model/Directions.dart';
import 'package:yamudacarpooling/Model/PredictedPlaces.dart';
import 'package:yamudacarpooling/infoHandler/App_info.dart';

class PlacePredictedTile extends StatefulWidget {
  final PredictedPlaces? predictedPlace;

  const PlacePredictedTile({super.key, this.predictedPlace});

  @override
  State<PlacePredictedTile> createState() => _PlacePredictedTileState();
}

class _PlacePredictedTileState extends State<PlacePredictedTile> {
  getPlaceDirectionsDetails(String? placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              backgroundColor: Colors.transparent,
              child: LoadingAnimationWidget.threeArchedCircle(
                color: Primary,
                size: 40,
              ),
            ));

    String placeDirectionsDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$map_key";
    var responseApi =
        await RequestAssistance.receiveRequest(placeDirectionsDetailsUrl);

    Navigator.pop(context);
    if (responseApi == 'error occurred, no response') {
      return;
    }
    if (responseApi['status'] == 'OK') {
      Directions directions = Directions();
      directions.locationName = responseApi['result']['name'];
      directions.locationId = placeId;
      directions.locationlatitude =
          responseApi['result']['geometry']['location']['lat'];
      directions.locationlongitude =
          responseApi['result']['geometry']['location']['lng'];

      Provider.of<AppInfo>(context, listen: false)
          .updateDropoffLocationAddress(directions);
      setState(() {
        userDropoffAddress = directions.locationName!;
      });

      Navigator.pop(context, "obtainedDropoff");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Secondary,
        ),
        onPressed: () {
          getPlaceDirectionsDetails(widget.predictedPlace!.place_id, context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(Icons.add_location),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.predictedPlace!.main_text!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Primary)),
                    Text(
                        (widget.predictedPlace!.secondary_text == null)
                            ? ""
                            : widget.predictedPlace!.secondary_text!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Primary)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
