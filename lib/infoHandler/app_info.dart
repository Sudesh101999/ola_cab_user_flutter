import 'package:drive_user_flutter/models/directions.dart';
import 'package:flutter/cupertino.dart';

class AppInfo extends ChangeNotifier{

  Directions? userPickUpLocation,userDropOffLocation;

  void updatePickUpLocationAddress(Directions userPickUpAddress){
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }
  void updateDropOffLocationAddress(Directions userDropOffAddress){
    userDropOffLocation = userDropOffAddress;
    notifyListeners();
  }
}