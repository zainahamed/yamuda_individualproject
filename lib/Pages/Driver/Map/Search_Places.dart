import 'package:flutter/material.dart';
import 'package:yamudacarpooling/Assistant/RequestAssistant.dart';
import 'package:yamudacarpooling/Globle/Map_Key.dart';
import 'package:yamudacarpooling/Model/PredictedPlaces.dart';
import 'package:yamudacarpooling/Widgets/Place_predicted_tile.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({super.key});

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  List<PredictedPlaces> placesPredictedList = [];
  findPlaceAuthoCompleteSearch(String inputText) async {
    if (inputText.length > 1) {
      String urlAutocompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$map_key&components:BD";
      var response =
          await RequestAssistance.receiveRequest(urlAutocompleteSearch);

      if (response == 'error occurred, no response') {
        return;
      }
      if (response['status'] == 'OK') {
        var placePredications = response['predictions'];
        var placePredictationList = (placePredications as List)
            .map((jsonData) => PredictedPlaces.fromJson(jsonData))
            .toList();
        setState(() {
          placesPredictedList = placePredictationList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back to previous screen
            },
          ),
          title: const Text(
            "Search Place",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(children: [
          Container(
            decoration: BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextField(
                              onChanged: (value) {
                                findPlaceAuthoCompleteSearch(value);
                              },
                              decoration: InputDecoration(
                                hintText: "Search Here ...",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                        )
                      ])
                ],
              ),
            ),
          ),
          (placesPredictedList.length > 0)
              ? Expanded(
                  child: ListView.separated(
                    physics: ClampingScrollPhysics(),
                    itemCount: placesPredictedList.length,
                    itemBuilder: (context, index) {
                      return PlacePredictedTile(
                        predictedPlace: placesPredictedList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 0,
                        thickness: 0,
                      );
                    },
                  ),
                )
              : Container()
        ]),
      ),
    );
  }
}
