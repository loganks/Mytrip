import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mytrip/AllScreens/homeScreen.dart';
import 'package:mytrip/AllScreens/searchScreen.dart';
import 'package:mytrip/AllWidgets/configMaps.dart';
import 'package:mytrip/AllWidgets/divider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mytrip/AllScreens/loginScreen.dart';
import 'package:mytrip/AllWidgets/progressDialog.dart';
import 'package:mytrip/Assistants/assistantMethods.dart';
import 'package:mytrip/DataHandler/appData.dart';
import 'package:mytrip/Models/directDetails.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';




class MainScreen extends StatefulWidget {

  const MainScreen({Key key}) : super(key: key);

  static const String idScreen = "mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin
{

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  DirectionDetails tripDirectionDetails;

  List<LatLng>  pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  Position currentPosition;
  var geolocator = Geolocator();
  double bottomPaddingofMap = 0;

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  double requestRideContainerHeight = 0;
  double riderDetailsContainerHeight = 0;
  double searchContainerHeight = 290;

  bool drawerOpen = true;

  DatabaseReference rideRequestRef = FirebaseDatabase.instance.reference().child("Ride Requests").push();


  String _date = "Not set";
  String _time = "Not set";

  TextEditingController nombredepersonnesTextEditingController = TextEditingController();

  String montantChauffeur = "";
  String montantService = "";
  String voyageurs = "0";

  //Ceci permet charger les informations de l'utilisateur actuel
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AssistantMethods.getCurrentOnlineUserInfo();
  }

  void saveRideRequest()
  {

    var pickUp = Provider.of<AppData>(context, listen: false).pickupLocation;
    var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;

    Map pickUpLocMap =
        {
          "latitude": pickUp.latitude.toString(),
          "longitude": pickUp.longitude.toString(),
        };

    Map dropOffLocMap =
    {
      "latitude": dropOff.latitude.toString(),
      "longitude": dropOff.longitude.toString(),
    };

    Map rideinfoMap =
        {
          "driver_id": "waiting",
          "payment_method": "cash",
          "pickup": pickUpLocMap,
          "dropoff": dropOffLocMap,
          "created_at": DateTime.now().toString(),
          "departure_day": _date,
          "departure_time": _time,
          "number_travellers": voyageurs,
          "Driver_pay": montantChauffeur ,
          "Service_cost": montantService ,
          "rider_name": userCurrentInfo.id,
          "rider_phone": userCurrentInfo.telephone,
          "pickup_address": pickUp.placeName,
          "dropOff_address": dropOff.placeName,
        };

    rideRequestRef.set(rideinfoMap);

  }

  void cancelRideRequest()
  {
    rideRequestRef.remove();
  }


  //Ceci gère le petit design de popup qui apparait lorsqu'on cherche une course
  void displayRequestRideContainer(){
    setState(() {
      requestRideContainerHeight = 200.0;
      riderDetailsContainerHeight = 0;
      bottomPaddingofMap = 265.0;
      drawerOpen = false;
    });

    saveRideRequest();
  }

  //Si l'utilisateur annule la course, on reinitialise la page avec cette fonction
  resetApp()
  {
    setState(() {
      drawerOpen = true;
      searchContainerHeight = 270;
      riderDetailsContainerHeight = 0;
      requestRideContainerHeight=0;
      bottomPaddingofMap = 265.0;

      polylineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      pLineCoordinates.clear();

    });

    locatePosition();
  }

  //Après la recherche de la destination, on switch la page de données par la page
  //contenant les informations sur la destination
  void displayRiderDetailsContainer() async
  {
    await getPlaceDirection();

    setState(() {
      searchContainerHeight = 0;
      riderDetailsContainerHeight = 475;
      bottomPaddingofMap = 0.0;
      drawerOpen = false;
    });
  }

  //Cette fonction détecte notre adresse initiale
  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    
    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 15);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethods.searchCoordinateAddress(position, context);
    print("Voici votre adresse:" + address);
  }

  void printDetails()
  {

  }


  //Ceci permet d'initialiser GoogleMap
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  //Les vraies choses commencent ici...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: scaffoldKey,
      backgroundColor: Colors.white,

      //Ceci c'est pour la barre de titre avec l'icone de l'application.
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          centerTitle: true,
          flexibleSpace: ClipRRect(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/logo.png"),
                  fit: BoxFit.fill,

                  alignment: Alignment.center,
                ),

                ),

              ),
          ),
          ),
        ),

      //Ceci c'est pour la barre de menu
      drawer: Container(
        color: Colors.white,
        width: 230.0,
        child: Drawer(
          child: ListView(
            children: [
              //Drawer Header
              Container(
                height: 140.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset("images/user_icon.png", height: 65.0, width: 65.0,),
                      SizedBox(width:16.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ((userCurrentInfo !=null) ? userCurrentInfo.nom : "Nom de profil"), style: TextStyle(fontSize: 15.0,fontFamily: "Brand-Bold"),),
                          SizedBox(height: 6.0,),
                          Text(
                            ((userCurrentInfo !=null) ? userCurrentInfo.telephone : "Tel"), style: TextStyle(fontSize: 15.0,fontFamily: "Brand-Bold"),),
                        ],
                      ),
                    ],
                  ),
                )
              ),

              DividerWidget(),

              SizedBox(height: 15.0,),

              ListTile(
                leading: Icon(Icons.person),
                title: Text("Profil", style: TextStyle(fontSize: 15.0,fontFamily: "Brand-Bold"),),
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text("Historique", style: TextStyle(fontSize: 15.0,fontFamily: "Brand-Bold"),),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Paramètres", style: TextStyle(fontSize: 15.0,fontFamily: "Brand-Bold"),),
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text("Partager l'Appli", style: TextStyle(fontSize: 15.0,fontFamily: "Brand-Bold"),),
              ),
              DividerWidget(),
              ListTile(
                leading: Icon(Icons.help),
                title: Text("Aide", style: TextStyle(fontSize: 15.0,fontFamily: "Brand-Bold"),),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text("Contacts", style: TextStyle(fontSize: 15.0,fontFamily: "Brand-Bold"),),
              ),
              DividerWidget(),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("A propos", style: TextStyle(fontSize: 15.0,fontFamily: "Brand-Bold"),),
              ),
              DividerWidget(),
              SizedBox(height: 100.0,),
              GestureDetector(
                onTap: ()
                  {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                  },
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text("Deconnexion", style: TextStyle(fontSize: 15.0,fontFamily: "Brand-Bold"),),
                ),
              ),


            ],
          ),
        ),
      ),
      body: Stack(

        children: [

          SizedBox(height: 150.0,),

          //Ceci gère toute la carte
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingofMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: polylineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller)
            {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingofMap = 265.0;
              });

              locatePosition();
            },
          ),

          //HamburgerButton for Drawer
          //Avant que l'on ne tape une destination, ca affiche le menu
          //Après, ca affiche la croix qui permet de reinitialiser l'application
          Positioned(
            top: 35.0,
            left: 22.0,
            child: GestureDetector(
              onTap: ()
              {
                if(drawerOpen)
                  {
                    scaffoldKey.currentState.openDrawer();
                  }
                else
                  {
                    resetApp();
                  }

              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset (0.7,0.7),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor:  Colors.white,
                  child: Icon((drawerOpen)? Icons.menu: Icons.close, color: Colors.black,),
                  radius: 20.0,
                ),
              ),
            ),
          ),

          //Ceci gère la barre de recherche et les diverses adresses de départ/arrivée.
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 150),
              child: Container(
                height: searchContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:24.0, vertical: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 0.0,),

                        GestureDetector(
                          onTap: () async
                          {
                            var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen()));

                            if(res == "obtainDirection")
                              {
                                await getPlaceDirection();
                              }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 10.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7, 0.7),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Icon(Icons.search, color: Colors.blueAccent,),
                                  SizedBox(width: 15.0, height: 20.0,),
                                  Text("Rechercher la destination", style: TextStyle(fontSize: 20.0,),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: [
                            Icon(FontAwesomeIcons.home, color: Colors.blueAccent,),
                            SizedBox(width: 10.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Provider.of<AppData>(context).pickupLocation != null
                                  ? Provider.of<AppData>(context).pickupLocation.placeName
                                  : "Domicile",
                                  style: TextStyle(fontSize: 20.0,),),
                                SizedBox(height: 0.0,),
                                Text("Point de départ", style: TextStyle(color:Colors.black54, fontSize: 12.0),),
                              ],
                            )
                            
                          ],
                        ),

                        SizedBox(height: 0.0),
                        DividerWidget(),

                        SizedBox(height: 1.0),

                        Row(
                          children: [
                            Icon(FontAwesomeIcons.carAlt, color: Colors.blueAccent,),
                            SizedBox(width: 0.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  //"Travail", style: TextStyle(fontSize: 20.0,),),
                                Provider.of<AppData>(context).dropOffLocation != null
                                    ? Provider.of<AppData>(context).dropOffLocation.placeName
                                    : "Destination",
                                  style: TextStyle(fontSize: 20.0,),),
                                SizedBox(height: 0.0,),
                                Text("Point d'Arrivée", style: TextStyle(color:Colors.black54, fontSize: 12.0),),
                              ],
                            ),

                          ],
                        ),
                        SizedBox(height:0.0),

                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                              shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(24.0),
                              )),
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 80, vertical: 10)),
                              textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Brand Bold",
                              )),
                            ),
                            onPressed: () {
                              displayRiderDetailsContainer();
                            },
                            child: Text("Valider le trajet"),

                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          //Ceci affiche les informations (distance & duree) concernant la destination.
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 150),
              child: Container(
                height: riderDetailsContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7,0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.tealAccent[100],
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Image.asset("images/taxi.png", height: 70.0, width: 80.0,),
                              SizedBox(width: 16.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Distance", style: TextStyle(fontSize: 15.0, fontFamily: "Brand Bold",),
                                  ),
                                  Text(
                                    ((tripDirectionDetails !=null) ? tripDirectionDetails.distanceText : ""), style: TextStyle(fontSize: 15.0, color: Colors.blueAccent,),
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),

                              Text(
                                "Duree", style: TextStyle(fontSize: 15.0, fontFamily: "Brand Bold",),
                              ),
                              Text(
                                ((tripDirectionDetails !=null) ? tripDirectionDetails.durationText : ""), style: TextStyle(fontSize: 15.0, color: Colors.blueAccent,),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 5.0,),

                      //Ca c'est pour choisir le depart, date et heure
                      Padding(
                      padding: const EdgeInsets.all(16.0),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(5.0),
                                  )),
                                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 80, vertical: 10)),
                                  textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: "Brand Bold",
                                  )),
                                ),
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                      theme: DatePickerTheme(
                                        containerHeight: 210.0, ),
                                      showTitleActions: true,
                                      minTime: DateTime(2000, 1, 1),
                                      maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                                    print('confirm $date');
                                    _date = '${date.year} - ${date.month} - ${date.day}';
                                    setState(() {});
                                    }, currentTime: DateTime.now(), locale: LocaleType.fr);
                                  },
                                child: Container(
                                alignment: Alignment.center,
                                height: 40.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.date_range,
                                                size: 18.0,
                                                color: Colors.teal,
                                              ),
                                              Text(
                                                " $_date",
                                                style: TextStyle(
                                                    color: Colors.teal,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      " Change",
                                      style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
                                    ),
                                  ],
                                ),
                                ),
                              ),

                              SizedBox( height: 5.0, ),

                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(5.0),
                                  )),
                                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 80, vertical: 10)),
                                  textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: "Brand Bold",
                                  )),
                                ),
                                onPressed: () {
                                  DatePicker.showTimePicker(context,
                                      theme: DatePickerTheme(
                                        containerHeight: 210.0, ),
                                      showTitleActions: true, onConfirm: (time) {
                                    print('confirm $time');
                                    _time = '${time.hour} : ${time.minute} : ${time.second}';
                                    setState(() {});
                                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                                  setState(() {});
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.access_time,
                                                  size: 18.0,
                                                  color: Colors.teal,
                                                ),
                                                Text(
                                                  " $_time",
                                                  style: TextStyle( color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                              Text(
                                                " Change",
                                                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 18.0),
                                              ),
                                    ],
                                ),
                               ),

                              ),
                            ],
                          ),

                        ),
                      ),

                      //Ca c'est pour entrer le nombre de personnes
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child:
                                /*TextFormField(
                                  controller: nombredepersonnesTextEditingController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "nombre de voyageurs",
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  //The validator receives the text that the user has entered.
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      displayToastMessage(
                                          "Veuillez entrer le nombre de voyageurs", context);
                                      return "nombre de voyageurs";
                                    }
                                    return null;

                                  },
                                ),*/
                                TextField(
                                  controller: nombredepersonnesTextEditingController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: "nombre de voyageurs",
                                      /*labelStyle: TextStyle(
                                        fontSize: 14.0,
                                      ),*/
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),),
                                      /*hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15.0,
                                      )*/
                                  ),
                                  //style: TextStyle(fontSize: 20.0),
                                ),
                            ),

                      //Ca c'est pour valider le nombre de personnes
                      Padding(
                              padding: EdgeInsets.all(20.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                                  shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(24.0),
                                  )),
                                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 80, vertical: 10)),
                                  textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: "Brand Bold",
                                  )),
                                ),
                                onPressed: () {
                                    if(!nombredepersonnesTextEditingController.text.contains("1") &&
                                        !nombredepersonnesTextEditingController.text.contains("2") &&
                                        !nombredepersonnesTextEditingController.text.contains("3") &&
                                        !nombredepersonnesTextEditingController.text.contains("4")
                                      )
                                    {
                                        displayToastMessage(
                                          "Veuillez entrer le nombre de voyageurs", context);
                                        nombredepersonnesTextEditingController.clear();
                                    }
                                    else{
                                        voyageurs = nombredepersonnesTextEditingController.text;
                                        montantChauffeur = AssistantMethods.calculateFares(tripDirectionDetails, voyageurs).toString();
                                        montantService = AssistantMethods.calculateCommission(voyageurs).toString();
                                        print(montantChauffeur);
                                        print(montantService);
                                        displayRequestRideContainer();
                                    }

                                },
                                child: Text("Valider"),

                              ),
                            ),

                      //Ca c'est pour le calcul du montant total
                      /*Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.moneyCheckAlt, size: 15.0, color: Colors.grey,),
                            SizedBox(width: 20.0,),
                            Text("Cout du transport: "),
                            Text(
                                ((tripDirectionDetails != null)? '$montantChauffeur F cfa' : ""), style: TextStyle(fontSize: 15.0, color: Colors.blueAccent,),
                              ),
                            SizedBox(width: 15.0,),
                            Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 15.0,),
                            Text("Cout du service: "),
                            Text(
                              ((tripDirectionDetails != null)? '$montantService F cfa' : ""), style: TextStyle(fontSize: 15.0, color: Colors.blueAccent,),
                            ),
                            SizedBox(width: 15.0,),
                            Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 15.0,),
                          ],
                        ),
                      ),*/

                      //SizedBox(height: 10.0,),

                      //Ca c'est la validation générale puis on lance l'appel aux chauffeurs...
                      /*Padding(
                        padding: EdgeInsets.all(20.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                              shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(24.0),
                              )),
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 80, vertical: 10)),
                              textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Brand Bold",
                              )),
                            ),
                            onPressed: () {
                             displayRequestRideContainer();
                            },
                            child: Text("Confirmer le trajet"),

                          ),
                        ),*/
                    ],
                  ),
                ),
              ),
            )
          ),

          //Ceci recherche le chauffeur
          Positioned(

            bottom:0.0,
            left: 0.0,
            right: 0.0,

            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0),),
                color: Colors.white,
                boxShadow:[
                  BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 15.0,
                    color: Colors.black54,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: requestRideContainerHeight,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                    //Ca c'est pour le calcul du montant total
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.0),
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.moneyCheckAlt, size: 15.0, color: Colors.grey,),
                            SizedBox(width: 20.0,),
                            Text("Cout du transport: "),
                            Text(
                                ((tripDirectionDetails != null)? '$montantChauffeur F cfa' : ""), style: TextStyle(fontSize: 15.0, color: Colors.blueAccent,),
                              ),
                            SizedBox(width: 15.0,),
                            Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 15.0,),
                            Text("Cout du service: "),
                            Text(
                              ((tripDirectionDetails != null)? '$montantService F cfa' : ""), style: TextStyle(fontSize: 15.0, color: Colors.blueAccent,),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 10.0,),

                    //Ca c'est la validation générale puis on lance l'appel aux chauffeurs...
                    Padding(
                        padding: EdgeInsets.all(20.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                              shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(24.0),
                              )),
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 80, vertical: 10)),
                              textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Brand Bold",
                              )),
                            ),
                            onPressed: () {
                              showDialog(context: context, builder: (BuildContext context)=>ProgressDialog(message: "Veuillez Patienter..."),);
                            },
                            child: Text("Confirmer"),
                          ),
                        ),
                    /*Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(width: 20.0, height: 50.0),
                        const Text(
                          '',
                          style: TextStyle(fontSize: 25.0),
                        ),
                        const SizedBox(width: 20.0, height: 50.0),
                        DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 25.0,
                            fontFamily: 'Signatra',
                            color: Colors.blue,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              RotateAnimatedText("Demande d'une course,"),
                              RotateAnimatedText('Veuillez Patienter,'),
                              RotateAnimatedText("Recherche d'un chauffeur"),
                            ],
                            onTap: () {
                              print("Tap Event");
                            },
                          ),
                        ),
                      ],
                    ),*/
                    //SizedBox(height: 20.0,),
                    /*GestureDetector(
                      onTap:()
                      {
                        cancelRideRequest();
                        resetApp();
                      },
                      child: Container(
                        height: 60.0,
                        width: 60.6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(width: 3.0, color: Colors.blue),
                        ),
                        child: Icon(Icons.close, size: 25.0,),
                      ),


                      //SizedBox(height: 5.0,),
                      /*Container(
                        width: double.infinity,
                        child: Text("Annuler la course", textAlign: TextAlign.center,style: TextStyle(fontSize: 10.0),),
                      ),*/
                    ),*/
                  ],
                ),
              ),
            ),
          ),
          

          
        ],
      ),
    );
  }


  //Cette fonction cherche la destination finale, et affiche la trajectoire sur la carte
  //Elle s'occupe aussi de définir les marqueurs sur la carte
  Future<void> getPlaceDirection() async
  {
    var initialPos = Provider.of<AppData>(context, listen: false).pickupLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(
        context: context,
      builder: (BuildContext context) => ProgressDialog(message: "Veuillez patienter...",)
    );

    var details = await AssistantMethods.obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);
    setState(() {
      tripDirectionDetails = details;
    });
    Navigator.pop(context);

    print("Encoded Points::");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult = polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();
    if(decodedPolyLinePointsResult.isNotEmpty)
      {
        decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
          pLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
        });
      }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);

    });

    LatLngBounds latLngBounds;
    if(pickUpLatLng.latitude > dropOffLatLng.latitude && pickUpLatLng.longitude > dropOffLatLng.longitude)
      {
        latLngBounds = LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
      }
    else if(pickUpLatLng.longitude  > dropOffLatLng.longitude)
      {
        latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude), northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
      }
    else if(pickUpLatLng.latitude > dropOffLatLng.latitude)
    {
      latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude), northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    }
    else
      {
        latLngBounds = LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
      }
    
    newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker (
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: InfoWindow(title: initialPos.placeName, snippet: "my Location"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker (
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: finalPos.placeName, snippet: "DropOff Location"),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: Colors.blue,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.green,
      circleId: CircleId("pickUpId"),
    );

    Circle dropOffLocCircle = Circle(
      fillColor: Colors.red,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.redAccent,
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }

  displayToastMessage(String message, BuildContext context)
  {
    Fluttertoast.showToast(msg: message);
  }
}
