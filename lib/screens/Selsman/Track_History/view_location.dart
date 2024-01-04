// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, unused_local_variable, unused_field, prefer_final_fields, unnecessary_new, prefer_collection_literals, camel_case_types, avoid_print, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../themes/theme_widgets.dart';
import '../../dashboard/components/header.dart';

class View_Location_Screen extends StatefulWidget {
  const View_Location_Screen({Key? key, required this.client_location})
      : super(key: key);
  final client_location;

  @override
  State<View_Location_Screen> createState() => _View_Location_ScreenState();
}

class _View_Location_ScreenState extends State<View_Location_Screen> {
  Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;

  //LocationData? _currentLocation;
  Map<dynamic, dynamic> user = new Map();
  Map<dynamic, dynamic> routdata = new Map();
  bool progressWidget = true;
  List tempArr = [];
  double Location_lat = 0.0;
  double Location_alt = 0.0;

  _getUser() async {
    tempArr =  (widget.client_location != null)?widget.client_location:[];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userData = (prefs.getString('user'));
    // SharedPreferences prefss = await SharedPreferences.getInstance();
    // dynamic userDataa = (prefs.getString('route'));
    if (userData != null) {
      user = await jsonDecode(userData) as Map<dynamic, dynamic>;
      // routdata = await jsonDecode(userDataa) as Map<dynamic, dynamic>;
      setState(() {
        imgstr = user["avatar"];

        Location_lat = tempArr[0][0];
        Location_alt = tempArr[0][1];
      });
      _init();
      progressWidget = false;
    }
  }

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  _init() async {
    List<LatLng> latLene = [
      //LatLng(28.597919, 77.329007),
      //  LatLng(Routedata[0][0], Routedata[0][1]),
      LatLng(Location_lat, Location_alt),
      for (var i = 1; i < tempArr.length; i++)
        LatLng(tempArr[i][0], tempArr[i][1])
      // LatLng(28.587021, 77.311183),
      //LatLng(Routedata[1][0], Routedata[1][1])
    ];
    _cameraPosition = CameraPosition(
        target: // LatLng(28.587021, 77.311183),
            latLene[0],
        zoom: 15);
    getPolylines(latLene);
  }

  getPolylines(List<LatLng> latLen) {
    for (int i = 0; i < latLen.length; i++) {
      if (i == 0) {
        _markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: latLen[i],
          infoWindow: InfoWindow(
            title: 'GCET Knowledge park',
            snippet: '${latLen[i].latitude} , ${latLen[i].longitude}',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      } else if (i == latLen.length - 1) {
        _markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: latLen[i],
          infoWindow: InfoWindow(
            title: '5 star Hotel',
            snippet: '${latLen[i].latitude} , ${latLen[i].longitude}',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      }

      setState(() {});
      _polyline.add(Polyline(
        polylineId: PolylineId('1'),
        points: latLen,
        color: Colors.green,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return (progressWidget == true)
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: pleaseWait(context)))
        : Scaffold(
            appBar: AppBar(
                title: GestureDetector(
                  onTap: () {
                    _getUser();
                  },
                  child: Text(
                    "View Route",
                    style: GoogleFonts.alike(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                backgroundColor: Colors.blue,
                actions: [
                  PopupMenuButton(
                      color: Colors.black,
                      itemBuilder: (context) => [
                            PopupMenuItem(
                                onTap: () {
                                  _googleMapController.future.then((value) {
                                    DefaultAssetBundle.of(context)
                                        .loadString(
                                            "assets/maptheme/silver_theme.json")
                                        .then((string) {
                                      setState(() {
                                        value.setMapStyle(string);
                                      });
                                    });
                                  });
                                },
                                child: Text("Silver")),
                            PopupMenuItem(
                                onTap: () {
                                  _googleMapController.future.then((value) {
                                    DefaultAssetBundle.of(context)
                                        .loadString(
                                            "assets/maptheme/retro_theme.json")
                                        .then((string) {
                                      setState(() {
                                        value.setMapStyle(string);
                                      });
                                    });
                                  });
                                },
                                child: Text("Retro")),
                            PopupMenuItem(
                                onTap: () {
                                  _googleMapController.future.then((value) {
                                    DefaultAssetBundle.of(context)
                                        .loadString(
                                            "assets/maptheme/night_theme.json")
                                        .then((string) {
                                      setState(() {
                                        value.setMapStyle(string);
                                      });
                                    });
                                  });
                                },
                                child: Text("Night")),
                            PopupMenuItem(
                                onTap: () {
                                  _googleMapController.future.then((value) {
                                    DefaultAssetBundle.of(context)
                                        .loadString(
                                            "assets/maptheme/dark_theme.json")
                                        .then((string) {
                                      setState(() {
                                        value.setMapStyle(string);
                                      });
                                    });
                                  });
                                },
                                child: Text("Dark")),
                            PopupMenuItem(
                                onTap: () {
                                  logout(context);
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      border: Border.all(color: Colors.black)),
                                  child: Center(
                                      child: Text(
                                    "Log Out",
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ))
                          ])
                ]),
            body: _buildBody(),
          );
  }

  Widget _buildBody() {
    return _getMap();
  }

  Widget _getMap() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _cameraPosition!,
          markers: _markers,
          polylines: _polyline,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            // now we need a variable to get the controller of google map
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
          },
        ),
        // Positioned.fill(
        //     child: Align(alignment: Alignment.center, child: _getMarker()))
      ],
    );
  }

/////////  Marker Widgets Show  ++++++++++++++++++++++++++++++++++++++++++++++++
  var imgstr;

  ///
  Widget _getMarker() {
    return Container(
      width: 35,
      height: 35,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 3),
                spreadRadius: 4,
                blurRadius: 6)
          ]),
      child: ClipOval(child: Image.network("$imgstr")),
    );
  }
///////////////////////   ====================================================
}
