// ignore_for_file: use_key_in_widget_constructors, avoid_print, prefer_const_constructors, await_only_futures

import 'package:crm_demo/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'controllers/MenuAppController.dart';
import 'screens/main/main_screen.dart';
import 'package:firedart/firedart.dart';

void main() async {
  //     WidgetsFlutterBinding.ensureInitialized();
  //     if (kIsWeb) {
  //     await Firebase.initializeApp(
  //     options: FirebaseOptions(
  //     apiKey: Constants.apiKey,
  //     appId: Constants.appId,
  //     messagingSenderId: Constants.messagingSenderId,
  //     projectId: Constants.projectId,
  //     storageBucket: Constants.storageBucket,
  //   ));
  //  }
  // else if (!kIsWeb) {
  var projectId = Constants.projectId;
  await Firestore.initialize(projectId);
  // }
  // else {
  //   await
  //   Firebase.initializeApp();
  //   }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
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
              home: MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => MenuAppController(),
                  ),
                ],
                child: MainScreen(),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
