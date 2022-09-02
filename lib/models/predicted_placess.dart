class PredictedPlacess{
  String? place_id;
  String? main_text;
  String? secondary_text;

  PredictedPlacess({this.place_id, this.main_text, this.secondary_text});

  PredictedPlacess.fromJson(Map<String, dynamic> jsonSata){
    place_id = jsonSata["place_id"];
    main_text = jsonSata["structured_formatting"]["main_text"];
    secondary_text = jsonSata["structured_formatting"]["secondary_text"];
  }
}