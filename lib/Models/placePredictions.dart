class PlacePredictions
{
  String secondary_text;
  String main_text;
  String place_id;

  PlacePredictions({this.secondary_text, this.main_text, this.place_id});

  PlacePredictions.fromJson(Map<String, dynamic> json)
  {
    secondary_text = json["structured_formatting"]["secondary_text"].toString();
    main_text = json["structured_formatting"]["main_text"].toString();
    place_id = json["place_id"].toString();
  }
}