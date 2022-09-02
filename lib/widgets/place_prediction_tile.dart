import 'package:drive_user_flutter/assistants/request_assistant.dart';
import 'package:drive_user_flutter/global/map_key.dart';
import 'package:drive_user_flutter/infoHandler/app_info.dart';
import 'package:drive_user_flutter/models/directions.dart';
import 'package:drive_user_flutter/models/predicted_placess.dart';
import 'package:drive_user_flutter/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PlacePredictionTileDesign extends StatelessWidget {
  final PredictedPlacess? predictedPlacess;

  PlacePredictionTileDesign({this.predictedPlacess});

  getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Setting Up drof-off, Please wait",
      ),
    );

    String placeDirectionDetails = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var responseApi = await RequestAssistant.receiveRequest(placeDirectionDetails);


    Navigator.pop(context);

    if(responseApi == "Error occurred, Failed. No Response"){
      return;
    }
    if(responseApi["status"] == "OK"){
      Directions directions = Directions();

      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude = responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude = responseApi["result"]["geometry"]["location"]["lng"];
      
      // print("\nLocation_name = "+directions.locationName!);
      // print("\nLocation log = "+directions.locationLongitude!.toString());
      // print("\nLocation lat = "+directions.locationLatitude!.toString());

      //updateing the drop Off location by provider
      Provider.of<AppInfo>(context,listen: false).updateDropOffLocationAddress(directions);
      
      Navigator.pop(context,"obtainedDropOff");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.white24),
      onPressed: () {
        getPlaceDirectionDetails(predictedPlacess!.place_id, context);
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            const Icon(
              Icons.add_location,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 14,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    predictedPlacess!.main_text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    predictedPlacess!.secondary_text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
