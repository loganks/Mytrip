import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:mytrip/AllScreens/conditionScreen.dart';
import 'package:mytrip/AllScreens/driverregisterationScreen.dart';
import 'package:mytrip/AllScreens/loginScreen.dart';
import 'package:mytrip/AllScreens/registerationScreen.dart';
import 'package:mytrip/AllWidgets/configMaps.dart';



class NatureScreen extends StatelessWidget {
  const NatureScreen({Key key}) : super(key: key);

  static const String idScreen = "nature";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Container(
          padding: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(children: [

                    Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("images/logottt.png"),
                            fit: BoxFit.fill,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.lightBlue),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(24.0),
                              )),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                          textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Brand Bold",
                          )),
                        ),
                        onPressed: () {
                          nature = "Rider";
                          ouiounon = false;
                          Navigator.pushNamedAndRemoveUntil(context, RegisterationScreen.idScreen, (route) => false);
                        },
                        child: Text("Utilisateur"),

                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.lightBlue),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(24.0),
                              )),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
                          textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Brand Bold",
                          )),
                        ),
                        onPressed: () {
                          nature = "Driver";
                          ouiounon = true;
                          Navigator.pushNamedAndRemoveUntil(context, RegisterationScreen.idScreen, (route) => false);
                        },
                        child: Text(" Chauffeur"),

                      ),
                    ),
                  ],)
              ),
            ],
          ),
        ),

      ),
    );
  }

}
