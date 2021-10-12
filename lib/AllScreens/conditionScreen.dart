import 'Dart:io';
import 'package:flutter/material.dart';
import 'package:mytrip/AllScreens/homeScreen.dart';
import 'Dart:async';
import 'package:flutter/foundation.dart';





class ConditionScreen extends StatelessWidget {

  static const String idScreen = "condition";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 15.0,),

              Text(
                "Conditions Générales",
                style: TextStyle(fontSize: 25.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15.0,),
              Text(
                "Tic tac tic tac tic tac",
                style: TextStyle(fontSize: 25.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),


              TextButton(
                onPressed: ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Confirmer et retourner à l'Accueil",
                  style: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}



