import 'package:flutter/material.dart';
import 'package:mytrip/AllWidgets/configMaps.dart';
import 'package:mytrip/AllWidgets/divider.dart';
import 'package:mytrip/AllWidgets/progressDialog.dart';
import 'package:mytrip/Assistants/requestAssistant.dart';
import 'package:mytrip/DataHandler/appData.dart';
import 'package:mytrip/Models/address.dart';
import 'package:mytrip/Models/placePredictions.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  static const String idScreen = "searchScreen";

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
{

  TextEditingController departTextEditingController = TextEditingController();
  TextEditingController arriveeTextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionsList = [];

  @override
  Widget build(BuildContext context)
  {
    String placeAddress = Provider.of<AppData>(context).pickupLocation.placeName ?? "";
    departTextEditingController.text = placeAddress;


    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7,0.7),
                  ),
                ],
              ),

              child: Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 35.0, right:25.0, bottom: 20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 5.0),
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: ()
                            {
                              Navigator.pop(context);
                            },

                            child: Icon(
                                Icons.arrow_back
                            ),
                          ),
                          Center(
                            child: Text(" Définir la destination", style: TextStyle(fontSize: 20.0, fontFamily: "Brand-Bold"),),
                          ),
                        ],
                      ),

                      SizedBox(height: 15.0,),
                      Row(
                        children: [
                          Image.asset("images/pickicon.png", height: 15.0, width: 15.0,),

                          SizedBox(width: 15.0,),

                          Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: TextField(
                                      controller: departTextEditingController,
                                      decoration: InputDecoration(
                                        hintText: "Point de depart",
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.only(left: 11.0, top:8.0, bottom: 8.0),
                                      )
                                    ),
                                ),
                              )
                          ),
                        ],
                      ),

                      SizedBox(height: 10.0,),
                      Row(
                        children: [
                          Image.asset("images/desticon.png", height: 15.0, width: 15.0,),

                          SizedBox(width: 15.0,),

                          Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: TextField(
                                    onChanged: (val)
                                      {
                                        findPlace(val);
                                      },
                                      controller: arriveeTextEditingController,
                                      decoration: InputDecoration(
                                        hintText: "Destination",
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.only(left: 11.0, top:8.0, bottom: 8.0),
                                      )
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                    ],
                  )
              ),
            ),

            //tile for prediction
            SizedBox(height: 10.0),
            (placePredictionsList.length>0)
            ? Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
              child: ListView.separated(
                padding: EdgeInsets.all(0.0),
                itemBuilder: (context, index)
                {
                  return PredictionTile(placePredictions: placePredictionsList[index],);
                },
                separatorBuilder: (BuildContext context, int index)=> DividerWidget(),
                itemCount: placePredictionsList.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
              )
            )
            : Container(),
          ],
        ),
      ),
    );
  }

  void findPlace(String placeName) async
  {
    if(placeName.length >1)
      {
        String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:fr";

        var res = await RequestAssistant.getRequest(autoCompleteUrl);



        if (res == "Echec, pas de reponse.")
          {
            return;
          }

        if (res["status"] == "OK")
        {

          var predictions = res["predictions"];
          var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();
          setState(() {
            placePredictionsList =  placesList;

           });
        }
      }
  }
  
}

class PredictionTile extends StatelessWidget
{

  final PlacePredictions placePredictions;

  const PredictionTile({Key key, this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return TextButton(

      onPressed: ()
      {
        getPlaceAddressDetails(placePredictions.place_id, context);
      },

      child: Container(
        child: Column(
          children: [
            SizedBox(width: 20.0),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 15.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
                      Text(placePredictions.main_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize:15.0),),
                      SizedBox(height:2.0),
                      Text(placePredictions.secondary_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0, color: Colors.grey),),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width:10.0),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async
  {
    
    showDialog(context: context, builder: (BuildContext context)=>ProgressDialog(message: "Veuillez Patienter..."),);
    
    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    
    var res = await RequestAssistant.getRequest(placeDetailsUrl);

    Navigator.pop(context);

    if (res == "Echec, pas de reponse.")
    {
      return;
    }
    if(res["status"] == "OK")
      {
        Address address = Address("","",0,0);
        address.placeName = res["result"]["name"];
        address.latitude = res["result"]["geometry"]["location"]["lat"];
        address.longitude = res["result"]["geometry"]["location"]["lng"];
        address.placeId= placeId;
        Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(address);
        print("Destination: ");
        print(address.placeName);

        Navigator.pop(context, "obtainDirection");
      }
  }
}


