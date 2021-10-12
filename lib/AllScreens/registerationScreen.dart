import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mytrip/AllScreens/conditionScreen.dart';
import 'package:mytrip/AllScreens/drivermainScreen.dart';
import 'package:mytrip/AllScreens/homeScreen.dart';
import 'package:mytrip/AllScreens/loginScreen.dart';
import 'package:mytrip/AllScreens/mainScreen.dart';
import 'package:mytrip/AllScreens/natureScreen.dart';
import 'package:mytrip/AllWidgets/configMaps.dart';
import 'package:mytrip/main.dart';
import 'package:mytrip/AllWidgets/progressDialog.dart';






class RegisterationScreen extends StatelessWidget {

  static const String idScreen = "register";

  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController nomTextEditingController = TextEditingController();
  TextEditingController prenomTextEditingController = TextEditingController();
  TextEditingController telephoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController motdepasseTextEditingController = TextEditingController();
  TextEditingController cniTextEditingController = TextEditingController();
  TextEditingController matriculeTextEditingController = TextEditingController();
  TextEditingController cartegriseTextEditingController = TextEditingController();
  TextEditingController marqueTextEditingController = TextEditingController();
  TextEditingController etatTextEditingController = TextEditingController();
  TextEditingController couleurTextEditingController = TextEditingController();



  DatabaseReference userdataRef = FirebaseDatabase.instance.reference().child("users");
  //DatabaseReference driverdataRef = FirebaseDatabase.instance.reference().child("drivers");

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
          leading:IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.blueAccent),
            onPressed:()
            {
              Navigator.pushNamedAndRemoveUntil(context, NatureScreen.idScreen, (route) => false);
            },
          ),
          actions: <Widget>[
            GestureDetector(
              onTap:(){
                Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                    "Se connecter",
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
                  _buildNewForm(context),
                  SizedBox(height: 30.0),
                  Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(height:100.0),
                            RichText(
                              text: new TextSpan(
                                children: [
                                  new TextSpan(
                                    text: "En poursuivant votre connexion/inscription, vous acceptez nos ",
                                    style: TextStyle(fontSize: 15.0, fontFamily: "Brand Bold", color: Colors.grey,),
                                  ),
                                  new TextSpan(
                                    text: "Conditions générales ",
                                    style: TextStyle(fontSize: 15.0,
                                        fontFamily: "Brand Bold",
                                        color: Colors.blueAccent,
                                        decoration: TextDecoration.underline),
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamedAndRemoveUntil(context, ConditionScreen.idScreen, (route) => false);
                                      },
                                  ),
                                  new TextSpan(
                                    text:"et notre ",
                                    style: TextStyle(fontSize: 15.0, fontFamily: "Brand Bold", color: Colors.grey),
                                  ),
                                  new TextSpan(
                                    text: "Politique de Confidentialité.",
                                    style: TextStyle(fontSize: 15.0,
                                        fontFamily: "Brand Bold",
                                        color: Colors.blueAccent,
                                        decoration: TextDecoration.underline),
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamedAndRemoveUntil(context, ConditionScreen.idScreen, (route) => false);
                                      },
                                  ),
                                ],
                              ),
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


  Widget _buildNewForm(BuildContext context) {
    return Form(
      key: _formKey,

      child: SingleChildScrollView(
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: nomTextEditingController,
              decoration: InputDecoration(
                labelText: "Entrez votre nom",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              //The validator receives the text that the user has entered.
              validator: (value) {
                if (value.length < 3) {
                  displayToastMessage(
                      "Le nom doit contenir au moins 3 caractères.", context);
                  return "Entrez votre nom";
                }
                return null;
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: prenomTextEditingController,
              decoration: InputDecoration(
                labelText: "Entrez votre prenom",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              //The validator receives the text that the user has entered.
              validator: (value) {
                if (value.length < 2) {
                  displayToastMessage(
                      "Le prénom doit contenir au moins 2 caractères.",
                      context);
                  return "Entrez votre prenom";
                }
                return null;
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: telephoneTextEditingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Numero de telephone",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              //The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  displayToastMessage(
                      "Numéro de téléphone obligatoire.", context);
                  return "Numéro de téléphone";
                }
                return null;
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: emailTextEditingController,
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
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: motdepasseTextEditingController,
              decoration: InputDecoration(
                labelText: "Mot de passe",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              //The validator receives the text that the user has entered.
              validator: (value) {
                Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
                RegExp regExp = new RegExp(pattern);
                print(value);
                if (value.isEmpty) {
                  displayToastMessage(
                      "Veuillez entrer un mot de passe", context);
                  return "Mot de passe";
                }
                else {
                  if (!regExp.hasMatch(value)) {
                    return "Le mot de passe doit contenir au moins un chiffre, une lettre majuscule et au moins 8 caractères";
                  }
                  else
                    return null;
                }
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: cniTextEditingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Numéro de CNI",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              //The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  displayToastMessage(
                      "Numéro de téléphone obligatoire.", context);
                  return "Numéro de CNI";
                }
                if (value.length < 8) {
                  displayToastMessage("Numéro de CNI non Valide.", context);
                  return "Numéro de CNI";
                }
                return null;
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              enabled: ouiounon,
              controller: matriculeTextEditingController,
              decoration: InputDecoration(
                labelText: "Matricule du véhicule",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              //The validator receives the text that the user has entered.
              validator: (value) {
                if ((value.length < 7) && ouiounon) {
                  displayToastMessage(
                      "Le matricule doit contenir au moins 7 caractères.", context);
                  return "Saisissez le matricule du véhicule";
                }
                return null;
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              enabled: ouiounon,
              controller: cartegriseTextEditingController,
              decoration: InputDecoration(
                labelText: "Numéro de carte grise",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              //The validator receives the text that the user has entered.
              validator: (value) {
                if ((value.length < 6) && ouiounon) {
                  displayToastMessage(
                      "Le numéro de carte grise doit contenir au moins 6 caractères.", context);
                  return "Numéro de carte grise du véhicule";
                }
                return null;
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              enabled: ouiounon,
              controller: marqueTextEditingController,
              decoration: InputDecoration(
                labelText: "Marque du véhicule",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              //The validator receives the text that the user has entered.
              validator: (value) {
                if ((value.length < 3) && ouiounon) {
                  displayToastMessage(
                      "La marque doit contenir au moins 3 caractères.",
                      context);
                  return "Marque du véhicule";
                }
                return null;
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              enabled: ouiounon,
              controller: etatTextEditingController,
              decoration: InputDecoration(
                hintText: "Neuf, Bon etat, Vieux, Autre",
                labelText: "Etat du véhicule",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              //The validator receives the text that the user has entered.
              validator: (value) {
                if ((value.length < 3) && ouiounon) {
                  displayToastMessage(
                      "L'état doit contenir au moins 3 caractères.",
                      context);
                  return "Etat du véhicule";
                }
                return null;
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(

              enabled: ouiounon,
              controller: couleurTextEditingController,
              decoration: InputDecoration(
                labelText: "Couleur du véhicule",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              //The validator receives the text that the user has entered.
              validator: (value) {
                if ((value.length < 3) && ouiounon) {
                  displayToastMessage(
                      "la couleur doit contenir au moins 3 caractères.",
                      context);
                  return "Couleur du véhicule";
                }
                return null;
              },
            ),
          ),




          Padding(
              padding: EdgeInsets.all(20.0),
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
                  if (_formKey.currentState.validate()) {

                    if(nature == "Driver")
                      {
                        registerNewUser(context);
                      }
                    else if(nature == "Rider"){
                      matriculeTextEditingController.text= "No";
                      cartegriseTextEditingController.text ="No";
                      marqueTextEditingController.text="No";
                      etatTextEditingController.text="No";
                      couleurTextEditingController.text="No";
                      registerNewUser(context);
                    }
                    else{
                      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
                    }
                  }
                },
                child: Text("Créer mon compte"),

              ),
          ),

        ]),
      ),

    );
  }


  void registerNewUser(BuildContext context) async
  {
    firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: motdepasseTextEditingController.text)
        .then((result) {
      userdataRef.child(result.user.uid).set({
        "nom": nomTextEditingController.text,
        "prenom": prenomTextEditingController.text,
        "telephone": telephoneTextEditingController.text,
        "email": emailTextEditingController.text,
        "motdepasse": motdepasseTextEditingController.text,
        "cni": cniTextEditingController.text,
        "matricule": matriculeTextEditingController.text,
        "cartegrise": cartegriseTextEditingController.text,
        "marque": marqueTextEditingController.text,
        "etat": etatTextEditingController.text,
        "couleur": couleurTextEditingController,
        "nature": nature,
      }).then((res) {
        Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
      });
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Erreur"),
              content: Text(err.message),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
      );
    });

  }

  /*void registerNewDriver(BuildContext context) async
  {
    firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: motdepasseTextEditingController.text)
        .then((result) {
        userdataRef.child(result.user.uid).set({
        "nom": nomTextEditingController.text,
        "prenom": prenomTextEditingController.text,
        "telephone": telephoneTextEditingController.text,
        "email": emailTextEditingController.text,
        "motdepasse": motdepasseTextEditingController.text,
        "cni": cniTextEditingController.text,
        "matricule": matriculeTextEditingController.text,
        "cartegrise": cartegriseTextEditingController.text,
        "marque": marqueTextEditingController.text,
        "etat": etatTextEditingController.text,
        "couleur": couleurTextEditingController,
        "nature": nature,
      }).then((res) {
        Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
      });
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Erreur"),
              content: Text(err.message),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
      );
    });

  }*/


  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }

}