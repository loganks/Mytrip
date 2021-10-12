

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mytrip/AllWidgets/configMaps.dart';
import 'package:mytrip/Assistants/requestAssistant.dart';
import 'package:mytrip/Models/address.dart';
import 'package:mytrip/DataHandler/appData.dart';
import 'package:mytrip/Models/allUsers.dart';
import 'package:mytrip/Models/directDetails.dart';
import 'package:provider/provider.dart';

class AssistantMethods
{
  static  Future<String> searchCoordinateAddress(Position position, context) async
  {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistant.getRequest(url);

    if (response != "Echec, pas de reponse.")
      {
        //placeAddress = response["results"][0]["formatted_address"];
        st1 = response["results"][0]["address_components"][1]["long_name"];
        st2 = response["results"][0]["address_components"][2]["long_name"];
        st3 = response["results"][0]["address_components"][4]["long_name"];
        //st4 = response["results"][0]["address_components"][2]["long_name"];
        placeAddress = st1 + ", " + st2 + ", " + st3;


        Address userPickupAddress = new Address("","",0,0);
        userPickupAddress.longitude = position.longitude;
        userPickupAddress.latitude = position.latitude;
        userPickupAddress.placeName = placeAddress;

        Provider.of<AppData>(context, listen: false).updatePickupLocationAddress(userPickupAddress);
      }

    return placeAddress;
  }

  static Future<DirectionDetails> obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async
  {
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(directionUrl);

    if(res == "Echec, pas de reponse.")
      {
        return null;
      }
    else{
    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;}
  }

  static int calculateFares(DirectionDetails directionDetails, String nombreVoyageur)
  {
    //En Fcfa
    int n= int.tryParse(nombreVoyageur);
    double timeTraveledFare = (directionDetails.durationValue/60)*50;
    double distanceTraveledFare = (directionDetails.distanceValue /1000)*50;
    double totalFareAmount = (timeTraveledFare + distanceTraveledFare)*n;

    if(n==0) {return 0;}
    else{
    return totalFareAmount.truncate();}

  }

  static int calculateCommission(String nombreVoyageur)
  {
    int n= int.tryParse(nombreVoyageur);
    double totalCommission = 500 + 500*(n-1)*3/5;

    if(n==0) {return 0;}
    else{
    return totalCommission.truncate();}
  }

  static void getCurrentOnlineUserInfo() async
  {
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference().child("users").child(userId);

    reference.once().then((DataSnapshot dataSnapShot)
    {
      if(dataSnapShot.value != null)
      {
        userCurrentInfo = Users.fromSnapshot(dataSnapShot);
      }
    }
    );

  }

}