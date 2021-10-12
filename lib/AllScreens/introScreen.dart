import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mytrip/AllScreens/homeScreen.dart';
import 'package:mytrip/AllScreens/loginScreen.dart';
import 'package:mytrip/AllScreens/mainscreen.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:mytrip/main.dart';
import 'package:flutter/material.dart';


class IntroScreen extends StatelessWidget{
  static const String idScreen = "intro";

  @override
  Widget build(BuildContext context) {
    User res = FirebaseAuth.instance.currentUser;
    return new SplashScreen(
      navigateAfterSeconds: res != null? //MainScreen(uid: result.uid) : LoginScreen(),
      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false) :
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false),
      seconds: 5,
      title: new Text(
        'Welcome to MyRoadTrip',
        style: new TextStyle(fontFamily: "Signatra", fontSize: 20.0),
      ),
        image: Image.asset("assets/images/logo.png", fit: BoxFit.scaleDown),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("flutter"),
        loaderColor: Colors.red
      );


  }
}