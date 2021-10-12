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




class DriverMainScreen extends StatefulWidget {

  const DriverMainScreen({Key key}) : super(key: key);

  static const String idScreen = "drivermainScreen";

  @override
  _DriverMainScreenState createState() => _DriverMainScreenState();
}


class _DriverMainScreenState extends State<DriverMainScreen> with TickerProviderStateMixin
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

  double confirmRideContainerHeight = 0;
  double driverDetailsContainerHeight = 0;
  double searchContainerHeight = 290;

  bool drawerOpen = true;

  DatabaseReference driveRequestRef = FirebaseDatabase.instance.reference().child("Drive Requests").push();
  final dbRef = FirebaseDatabase.instance.reference().child("Ride Requests");

  String _date = "Not set";
  String _time = "Not set";

  TextEditingController nombredepersonnesTextEditingController = TextEditingController();

  String montantChauffeur = "";
  String montantService = "";
  String voyageurs = "0";

  List lists = [];

  //Ceci permet charger les informations de l'utilisateur actuel
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AssistantMethods.getCurrentOnlineUserInfo();
  }

  void saveDriveRequest()
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
      "pickup": pickUpLocMap,
      "dropoff": dropOffLocMap,
      "departure_day": _date,
      "departure_time": _time,
      "number_travellers": voyageurs,
      "Driver_pay": montantChauffeur ,
      "Service_cost": montantService ,
      "driver_name": userCurrentInfo.id,
      "driver_phone": userCurrentInfo.telephone,
      "pickup_address": pickUp.placeName,
      "dropOff_address": dropOff.placeName,
    };

    driveRequestRef.set(rideinfoMap);

  }

  void cancelRideRequest()
  {
    driveRequestRef.remove();
  }


  //Ceci gère le petit design de popup qui apparait lorsqu'on cherche une course
  void displayRequestRideContainer(){
    setState(() {
      confirmRideContainerHeight = 200.0;
      driverDetailsContainerHeight = 0;
      bottomPaddingofMap = 265.0;
      drawerOpen = false;
    });

    saveDriveRequest();
  }

  //Si l'utilisateur annule la course, on reinitialise la page avec cette fonction
  resetApp()
  {
    setState(() {
      drawerOpen = true;
      searchContainerHeight = 270;
      driverDetailsContainerHeight = 0;
      confirmRideContainerHeight=0;
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
  void displayDriverDetailsContainer() async
  {
    await getPlaceDirection();

    setState(() {
      searchContainerHeight = 0;
      driverDetailsContainerHeight = 475;
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
                title: Text("Mes Trajets", style: TextStyle(fontSize: 15.0,fontFamily: "Brand-Bold"),),
              ),
              ListTile(
                leading: Icon(Icons.recommend),
                title: Text("Mes avis", style: TextStyle(fontSize: 15.0,fontFamily: "Brand-Bold"),),
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
                              displayDriverDetailsContainer();
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

          //Ceci affiche les informations (distance&prix) concernant la destination.
          /*Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: AnimatedSize(
                vsync: this,
                curve: Curves.bounceIn,
                duration: new Duration(milliseconds: 150),
                child: Container(
                  height: driverDetailsContainerHeight,
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
                  child: FutureBuilder(
                    future: dbRef.once(),
                    builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                      if(snapshot.hasData) {
                        lists.clear();
                        Map<dynamic, dynamic> values = snapshot.data.value;
                        values.forEach((key, value) {
                          lists.add(values);
                        });
                        return new ListView.builder(
                          shrinkWrap: true,
                          itemCount: lists.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Date de départ: "+ lists[index]["departure_day"]),
                                  Text("Heure de départ: "+ lists[index]["departure_time"]),
                                  Text("Adresse de départ: " + lists[index]["pickup_address"]),
                                  Text("Nombre de personnes: " + lists[index]["number_travellers"]),
                                  Text(""+lists[index]["Driver_pay"]),


                                ],
                              ),
                              onTap: () {},
                            );
                          }
                        );
                      }
                      return CircularProgressIndicator();
                    }
                  ),
                ),
              )
          ),
*/
          /*Positioned(

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
              height: confirmRideContainerHeight,
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


                  ],
                ),
              ),
            ),
          ),*/

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
