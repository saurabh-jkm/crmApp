// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, unused_local_variable, avoid_unnecessary_containers, unused_field, unnecessary_new, prefer_collection_literals, non_constant_identifier_names, prefer_final_fields, await_only_futures, avoid_types_as_parameter_names, avoid_function_literals_in_foreach_calls, use_build_context_synchronously, camel_case_types

import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:crmclientapp/screen/Home/home_page.dart';
// import 'package:crmclientapp/screen/Home/notification_controller.dart';
// import 'package:crmclientapp/screen/Login_Pages/login_screen.dart';

// import 'package:crmclientapp/themes/style.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../themes/style.dart';
import '../../../themes/theme_widgets.dart';

class privacyDiscloser extends StatefulWidget {
  const privacyDiscloser({Key? key}) : super(key: key);

  @override
  State<privacyDiscloser> createState() => _privacyDiscloserState();
}

class _privacyDiscloserState extends State<privacyDiscloser> {
  bool loginIs = false;
  bool isWait = false;
  Map<dynamic, dynamic> user = new Map();
  // NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    // declared for loop for various locations
  }

  _getUser() async {
    await _init();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userData = (prefs.getString('user'));
    if (userData != null) {
      user = jsonDecode(userData) as Map<dynamic, dynamic>;
    }

    if (userData != null) {
      // Navigator.of(context).pushReplacement(
      //     new MaterialPageRoute(builder: (context) => new HomePage()));
    } else {
      // Navigator.of(context).pushReplacement(
      //     new MaterialPageRoute(builder: (context) => new LoginScreen()));
    }
  }

  // var controllerr = new Google_Map_Controller();

  Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  Location? _location;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  // list of locations to display polylines
  _init() async {
    _location = Location();
    _cameraPosition = CameraPosition(
        target: LatLng(
            0, 0), // this is just the example lat and lng for initializing
        zoom: 15);
    _initLocation();
  }

  LocationData? _tempLocation;
  LocationData? _currentLocation;
  //function to listen when we move position
  _initLocation() async {
    //use this to go to current location instead
    _location?.getLocation().then((location) {
      _tempLocation = location;
      _currentLocation = location;
    });
    _location?.onLocationChanged.listen((newLocation) {
      _currentLocation = newLocation;
      // moveToPosition(LatLng(
      //     _currentLocation?.latitude ?? 0, _currentLocation?.longitude ?? 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding:
            EdgeInsets.only(top: 80.0, left: 20.0, right: 20.0, bottom: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on_outlined, size: 50.0, color: themeBG),
                ],
              ),
              themeSpaceVertical(20.0),
              Text(
                "Allow Your Location",
                style: themeTextStyle(
                    color: Color.fromARGB(255, 28, 106, 151),
                    fw: FontWeight.bold,
                    size: 22.0),
              ),
              themeSpaceVertical(15.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'This app collects location data to Track "Salesman Location", "Salesman Realtime Movement" AND "Salesman Track Route" even when the app is running in background.',
                        textAlign: TextAlign.center,
                        style: themeTextStyle(
                          //color: Color.fromARGB(255, 28, 106, 151),
                          //fw: FontWeight.w300,
                          size: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              themeSpaceVertical(20.0),
              themeSpaceVertical(40.0),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Image.asset('assets/images/location.jpg')),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      if (Platform.isAndroid) {
                        SystemNavigator.pop();
                      } else if (Platform.isIOS) {
                        exit(0);
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text("Don't Allow",
                        style: themeTextStyle(
                            color: themeBG, fw: FontWeight.bold, size: 14.0))),
                (isWait)
                    ? progress()
                    : themeButton3(context, () {
                        setState(() {
                          isWait = true;
                        });
                        _getUser();
                      },
                        label: 'Allow',
                        radius: 3.0,
                        fontSize: 12.0,
                        btnWidthSize: 50.0,
                        btnHeightSize: 30.0)
              ],
            ),
          ],
        ),
      ),
    );
  }

//////===============================================================================
} //Class Close
