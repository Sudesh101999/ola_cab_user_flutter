import 'package:drive_user_flutter/assistants/request_assistant.dart';
import 'package:drive_user_flutter/global/map_key.dart';
import 'package:drive_user_flutter/models/predicted_placess.dart';
import 'package:drive_user_flutter/widgets/place_prediction_tile.dart';
import 'package:flutter/material.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({Key? key}) : super(key: key);

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  List<PredictedPlacess> placesPredictedList = [];

  void findPlaceAutoComplateSearch(String inputText) async {
    if (inputText.length > 1) {
      String urlAutoCompleteSearh =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:IN";
      var responseAutoCompleteSearch =
          await RequestAssistant.receiveRequest(urlAutoCompleteSearh);

      if (responseAutoCompleteSearch == "Error occurred, Failed. No Response") {
        return;
      }

      if (responseAutoCompleteSearch["status"] == "OK") {
        var placesPredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionList = (placesPredictions as List)
            .map((jsonData) => PredictedPlacess.fromJson(jsonData))
            .toList();

        setState((){
          placesPredictedList = placePredictionList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //search placed UI
          Container(
            height: 160,
            decoration: const BoxDecoration(
              color: Colors.black54,
              boxShadow: [
                BoxShadow(
                  color: Colors.white54,
                  blurRadius: 8,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Search & set DropOff Location",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.adjust_sharp,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (valueTyped) {
                              findPlaceAutoComplateSearch(valueTyped);
                            },
                            decoration: const InputDecoration(
                                hintText: "search here",
                                fillColor: Colors.white54,
                                filled: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 11, top: 8, bottom: 8)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

          //display place predictions
          (placesPredictedList.length > 0)
              ? Expanded(
                child: ListView.separated(
                  itemCount: placesPredictedList.length,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index){
                    return PlacePredictionTileDesign(
                      predictedPlacess: placesPredictedList[index],
                    );
                  },
                  separatorBuilder: (BuildContext contxt,int index){
                    return const Divider(
                      height: 1,
                      color: Colors.white,
                      thickness: 1,
                    );
                  },
                ),
              )
              : Container(),
        ],
      ),
    );
  }
}
