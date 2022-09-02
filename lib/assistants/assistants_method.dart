import 'package:drive_user_flutter/assistants/request_assistant.dart';
import 'package:drive_user_flutter/global/global.dart';
import 'package:drive_user_flutter/global/map_key.dart';
import 'package:drive_user_flutter/infoHandler/app_info.dart';
import 'package:drive_user_flutter/models/direction_details_info.dart';
import 'package:drive_user_flutter/models/directions.dart';
import 'package:drive_user_flutter/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AssistantMethod {

  static Future<String> searchAddressForGeographicCoOrdenates(Position position, context) async {
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if(requestResponse != "Error occurred, Failed. No Response"){
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPikUpAddress = Directions();
      userPikUpAddress.locationLatitude = position.latitude;
      userPikUpAddress.locationLongitude = position.longitude;
      userPikUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context,listen: false).updatePickUpLocationAddress(userPikUpAddress);

    }

    return humanReadableAddress;
  }


  static void readCurrentOnlineUserInfo() async{
    currentFirebaseUser = fAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid);

    userRef.once().then((snap){
      if(snap.snapshot.value != null){
        userModelCurrentInfo =  UserModel.fromSnapshort(snap.snapshot);
        
        print("Name: "+userModelCurrentInfo!.name.toString());
        print("Email: "+userModelCurrentInfo!.email.toString());
      }
    });
  }

  static Future<DirectionDetailsInfo?> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosistion) async {
    String urlObtainOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosistion.latitude},${destinationPosistion.longitude}&key=$mapKey";

    var responseDirectionAPi = await RequestAssistant.receiveRequest(urlObtainOriginToDestinationDirectionDetails);

    if(responseDirectionAPi == "Error occurred, Failed. No Response"){
      return null;
    }
    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();

    directionDetailsInfo.e_point = responseDirectionAPi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text = responseDirectionAPi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value = responseDirectionAPi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text = responseDirectionAPi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value = responseDirectionAPi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;

  }
}