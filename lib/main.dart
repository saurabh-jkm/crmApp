// ignore_for_file: use_key_in_widget_constructors, avoid_print, prefer_const_constructors, await_only_futures, unused_import, unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:crm_demo/screens/product/product/add_product_screen.dart';
import 'package:crm_demo/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'controllers/MenuAppController.dart';
import 'screens/Login_Reg/Login_user.dart';
import 'screens/Login_Reg/login_screen.dart';
import 'screens/main/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: Constants.apiKey,
      appId: Constants.appId,
      messagingSenderId: Constants.messagingSenderId,
      projectId: Constants.projectId,
      storageBucket: Constants.storageBucket,
    ));
  } else if (Platform.isWindows) {
    var projectId = "crmapp-aed0e";
    var apiKey = "AIzaSyCbtC7CC-VQPanXbmdFp_HJg5VYB10AXHQ";

    await Firestore.initialize(
      projectId,
    );
    FirebaseAuth.initialize(apiKey, VolatileStore());
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  bool loginIs = false;
  Map<dynamic, dynamic> user = new Map();

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userData = (prefs.getString('user'));
    if (userData != null) {
      setState(() {
        user = jsonDecode(userData) as Map<dynamic, dynamic>;
        loginIs = true;
      });
    }
  }

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Something went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Admin Panel',
              theme: ThemeData.dark().copyWith(
                scaffoldBackgroundColor: bgColor,
                textTheme:
                    GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
                        .apply(bodyColor: Colors.white),
                canvasColor: secondaryColor,
              ),
              home: MultiProvider(providers: [
                ChangeNotifierProvider(
                  create: (context) => MenuAppController(),
                ),
              ], child: (loginIs == true) ? MainScreen(pageNo: 1) : Login_Copy()
                  //MainScreen(pageNo: 1)
                  // child: LoginPage()

                  ////MainScreen(pageNo: 1) // MainScreen(),
                  ),
              routes: {
                '/add_stock': (context) => addStockScreen(),
              },
            );
          }
          return CircularProgressIndicator();
        });
  }
}
