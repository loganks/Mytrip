import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mytrip/AllScreens/drivermainScreen.dart';
import 'package:mytrip/AllScreens/homeScreen.dart';
import 'package:mytrip/AllScreens/natureScreen.dart';
import 'package:mytrip/AllScreens/registerationScreen.dart';
import 'package:mytrip/AllScreens/mainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytrip/AllWidgets/configMaps.dart';
import 'package:mytrip/Assistants/assistantMethods.dart';
import 'package:mytrip/main.dart';
import 'package:mytrip/AllWidgets/progressDialog.dart';



class LoginScreen extends StatelessWidget {
  //const LoginScreen({Key key}) : super(key: key);
  final _loginformKey = GlobalKey<FormState>();

  static const String idScreen = "login";
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController motdepasseEditingController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

          leading:IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.blueAccent),
            onPressed:()
              {
              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
              },
          ),
          actions: <Widget>[
            GestureDetector(
              onTap:(){
                Navigator.pushNamedAndRemoveUntil(context, NatureScreen.idScreen, (route) => false);
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  "S'inscrire",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 18.0, fontWeight: FontWeight.w700,)
                ),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildForm(context),
              SizedBox(height: 30.0),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 150.0),
                    Text("Se connecter autrement", style: TextStyle(fontWeight: FontWeight.w700,),),
                    SizedBox(height: 10.0),
                    Padding(
                        padding: EdgeInsets.all(0.0),
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
                        padding: EdgeInsets.all(0.0),
                        child: SignInButton(
                          Buttons.Facebook,
                          text: "S'inscrire avec Facebook",
                          onPressed: () {},
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(24.0),
                          ),
                        )
                    ),
                  ]
                )
              )
            ],

          )


        )


      ),

      /*body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 35.0,),
              Text(
                "Connexion à mon compte",
                style: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold", color: Colors.black),
                textAlign: TextAlign.center,
              ),


              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 25.0),
                    TextField(
                      controller: emailEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                        )
                    ),
                    style: TextStyle(fontSize: 20.0),
                    ),

                    SizedBox(height: 10.0),
                    TextField(
                      controller: motdepasseEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Mot de passe",
                          labelStyle: TextStyle(
                            fontSize: 15.0,
                          ),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 20.0),
                    ),

                    SizedBox(height:50.0),
                    ElevatedButton(
                      child: Text('Me connecter'),
                      onPressed: () {
                        print("Connexion terminée");
                        if(!emailEditingController.text.contains("@"))
                        {
                          displayToastMessage("Adresse mail non valide.", context);
                        }
                        else if(motdepasseEditingController.text.isEmpty)
                        {
                          displayToastMessage("Le mot de passe est obligatoire.", context);
                        }
                        else{loginAndAuthenticateUser(context);}

                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
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
              ),
              SizedBox(height: 150.0,),
              TextButton(
                onPressed: ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Nouvel utilisateur? Créez votre compte",
                  style: TextStyle(fontSize: 17.0, fontFamily: "Brand Bold"),
                ),
              ),
            ],
          ),
        ),
      ),
    */

    );
  }


  Widget _buildForm(BuildContext context) {
    return Form(
      key: _loginformKey,
      //child: SingleChildScrollView(
        child: Column(children: <Widget>[
          SizedBox(height: 50.0,),

          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextFormField(
              controller: emailEditingController,
              decoration: InputDecoration(
                labelText: "Adresse Email",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              //The validator receives the text that the user has entered.
              validator: (value) {
                if (!value.contains("@")) {
                  displayToastMessage("Adresse email non valide.", context);
                  return "Adresse Email";
                }
                return null;
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextFormField(
              controller: motdepasseEditingController,
              decoration: InputDecoration(
                labelText: "Mot de passe",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              //The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  displayToastMessage("Le mot de passe est obligatoire.", context);
                  return "Mot de passe";
                }
                return null;
              },
            ),
          ),

          SizedBox(height: 20.0),

          Padding(
              padding: EdgeInsets.all(0.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.lightBlue),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      )),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 115, vertical: 10)),
                  textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                    fontSize: 20.0,
                    fontFamily: "Brand Bold",
                  )),
                ),
                onPressed: () {
                  if (_loginformKey.currentState.validate()) {
                    loginAndAuthenticateUser(context);
                  }
                },
                child: Text("Me connecter"),

              ),
          ),

        ]),
      //),

    );
  }

  void loginAndAuthenticateUser(BuildContext context) async
  {
    firebaseAuth
        .signInWithEmailAndPassword(
            email: emailEditingController.text,
            password: motdepasseEditingController.text
    ).then((result){
      AssistantMethods.getCurrentOnlineUserInfo();
      if(userCurrentInfo.nature == "Rider") {
        Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.idScreen, (route) => false);
      }
      else {
        Navigator.pushNamedAndRemoveUntil(
            context, DriverMainScreen.idScreen, (route) => false);
      }
    }).catchError((err){
      print(err.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erreur"),
            content:  Text(err.message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    });

    /*showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return ProgressDialog(message: "Veuillez patienter...",);
        }
    );

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.authStateChanges()
        .listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    try {

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailEditingController.text,
          password: motdepasseEditingController.text
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        displayToastMessage("Aucun utilisateur trouvé.", context);
      }
      else if (e.code == 'wrong-password') {
        print('Mot de passe incorrect.');
        displayToastMessage("Mot de passe incorrect.", context);
      }
      else
      {
        UserCredential user = await auth.signInWithEmailAndPassword(
            email: emailEditingController.text,
            password: motdepasseEditingController.text
        );
        if(user != null)  //user created
        {
      usersRef.child(user.uid).once().then((DataSnapshot snap){
        if(snap.value != null)
        {
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayToastMessage("Vous êtes connecté", context);
        }
        else
        {
          auth.signOut();
          displayToastMessage("Aucun utilisateur identifié. Veuillez créer un compte.", context);
        }
      });
    }
    else
    {
      displayToastMessage("Echec de connexion au compte.", context); //error occured = display error message
    }
      }


    }*/
  }

  displayToastMessage(String message, BuildContext context)
  {
    Fluttertoast.showToast(msg: message);
  }

}


