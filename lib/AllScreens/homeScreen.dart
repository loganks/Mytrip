import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:mytrip/AllScreens/conditionScreen.dart';
import 'package:mytrip/AllScreens/loginScreen.dart';
import 'package:mytrip/AllScreens/natureScreen.dart';
import 'package:mytrip/AllScreens/registerationScreen.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  static const String idScreen = "home";



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
                            Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                          },
                          child: Text("Se connecter"),

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
                            Navigator.pushNamedAndRemoveUntil(context, NatureScreen.idScreen, (route) => false);
                          },
                          child: Text("S'inscrire"),

                        ),
                      ),
                    ],)
                  ),
              SizedBox(height: 10.0),
              Text("------- Se connecter autrement -------", style: TextStyle(fontFamily: "Brand Bold",), textAlign: TextAlign.center,),
              SizedBox(height: 10.0),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: SignInButton(

                    Buttons.Google,
                    text: "S'inscrire avec Google",
                    onPressed: () {},
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(24.0),
                    ),
                  )
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: SignInButton(
                    Buttons.Facebook,
                    text: "S'inscrire avec Facebook",
                    onPressed: () {},
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(24.0),
                    ),
                  )
              ),
              /*Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height:100.0),
                    ElevatedButton(
                      child: Text('Connexion'),
                      onPressed: () {
                        print("Connexion terminée");
                        Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        padding: EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                        textStyle: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "Brand Bold",
                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0,),
                    ElevatedButton(
                      child: Text('Inscription'),
                      onPressed: () {
                        print("Inscription terminée");
                        Navigator.pushNamedAndRemoveUntil(context, RegisterationScreen.idScreen, (route) => false);

                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                        textStyle: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "Brand Bold",
                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0),
                        ),
                      ),
                    ),



                  ],
                ),
              ),*/
              /*TextButton(
                onPressed: ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                  "S'identifier",
                  style: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold", color: Colors.blue),
                ),
              ),*/
            ],
          ),
        ),

      ),
    );
  }

}
