import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant{
  static Future<dynamic> receiveRequest(String url) async {

    http.Response httpResponse = await http.get(Uri.parse(url));

    try{
      if(httpResponse.statusCode == 200){ // successfull
        String responseData = httpResponse.body; // this is in turm of json data

        var decodeResponseData = jsonDecode(responseData);

        return decodeResponseData;
      }else{
        return "Error occurred, Failed. No Response";
      }
    }catch(exp){
      return "Error occurred, Failed. No Response";
    }
  }
}