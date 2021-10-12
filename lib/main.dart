import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytrip/AllScreens/conditionScreen.dart';
import 'package:mytrip/AllScreens/drivermainScreen.dart';
import 'package:mytrip/AllScreens/driverregisterationScreen.dart';
import 'package:mytrip/AllScreens/homeScreen.dart';
import 'package:mytrip/AllScreens/introScreen.dart';
import 'package:mytrip/AllScreens/loginScreen.dart';
import 'package:mytrip/AllScreens/mainscreen.dart';
import 'package:mytrip/AllScreens/natureScreen.dart';
import 'package:mytrip/AllScreens/registerationScreen.dart';
import 'package:mytrip/AllScreens/searchScreen.dart';
import 'package:mytrip/DataHandler/appData.dart';
import 'package:provider/provider.dart';






Future<void> main() async
{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

//DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");


class MyApp extends StatelessWidget {
  //final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'MyRoadTrip',
        theme: ThemeData(
          fontFamily: 'Signatra',
          primarySwatch: Colors.grey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null? HomeScreen.idScreen : MainScreen.idScreen,

        routes:{
          HomeScreen.idScreen: (context) => HomeScreen(),
          RegisterationScreen.idScreen: (context) => RegisterationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
          ConditionScreen.idScreen: (context) => ConditionScreen(),
          SearchScreen.idScreen: (context) => SearchScreen(),
          DriverRegisterationScreen.idScreen: (context) => DriverRegisterationScreen(),
          DriverMainScreen.idScreen: (context) => DriverMainScreen(),
          NatureScreen.idScreen: (context) => NatureScreen(),

        },

        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

