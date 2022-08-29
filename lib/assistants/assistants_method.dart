import 'package:drive_user_flutter/global/global.dart';
import 'package:drive_user_flutter/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AssistantMethod {
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
}