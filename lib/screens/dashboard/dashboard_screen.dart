// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_returning_null_for_void, no_leading_underscores_for_local_identifiers, avoid_print, non_constant_identifier_names, unnecessary_string_interpolations, sized_box_for_whitespace, unused_import, unnecessary_new, unnecessary_brace_in_string_interps, prefer_collection_literals, unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/themes/function.dart';
import 'package:crm_demo/themes/style.dart';
import 'package:firedart/firestore/firestore.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../../models/MyFiles.dart';
import '../../responsive.dart';
import '../../themes/firebase_functions.dart';
import '../../themes/theme_widgets.dart';
import 'components/header.dart';
import 'components/my_fields.dart';
import 'components/recent_files.dart';
import 'components/storage_details.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import '../../../models/RecentFile.dart';
import '../../../models/bar_charts.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //////Crosss file picker
  final GlobalKey exportKey = GlobalKey();
  /////// get user data  +++++++++++++++++++++++++++++++++++++++++++++++++++
  Map<dynamic, dynamic> user = new Map();
  int no_todaySale = 0;
  bool isNewUpdate = false;

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userData = (prefs.getString('user'));

    if (userData != null) {
      user = await jsonDecode(userData) as Map<dynamic, dynamic>;

      invo_Data();
      Stock_Data();
      User_Data();
      OutofStock_Data();

      // todaySale
      await todaySale();
      await yearSale();
      await appSetting();
    }

    setState(() {});
  }

  @override
  void initState() {
    _getUser();

    super.initState();
  }

  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;
  bool progressWidget = true;
  ////////// inoive ==========================================================
  int invoiceNo = 0;
  int StockNo = 0;
  int UserNo = 0;
  int Out_of_Stock_No = 0;
  int no_of_year_sale = 0;

  invo_Data() async {
    List StoreDocs = [];
    Map<dynamic, dynamic> w = {
      'table': "order",
      //'status': "$_StatusValue",
    };
    var temp = await dbFindDynamic(db, w);

    setState(() {
      invoiceNo = temp.length;
    });
  }

  /////////=====================================================================

  appSetting() async {
    List StoreDocs = [];
    Map<dynamic, dynamic> w = {
      'table': "app_setting",
      //'status': "$_StatusValue",
    };
    var temp = await dbFindDynamic(db, w);
    if (temp.isNotEmpty && temp[0]['version'] > 11) {
      setState(() {
        isNewUpdate = true;
      });
    }
  }

  // ============================
  Stock_Data() async {
    List StoreDocs = [];
    Map<dynamic, dynamic> w = {
      'table': "product",
      //'status': "$_StatusValue",
    };
    var temp = await dbFindDynamic(db, w);
    setState(() {
      StockNo = temp.length;
    });
  }

////////////////
  ///
  /////////=====================================================================

  User_Data() async {
    List StoreDocs = [];
    Map<dynamic, dynamic> w = {
      'table': "users",
      //'status': "$_StatusValue",
    };
    var temp = await dbFindDynamic(db, w);
    setState(() {
      UserNo = temp.length;
    });
  }

  /////////=====================================================================

  todaySale() async {
    List StoreDocs = [];
    var newDate = todayTimeStamp_for_query();
    var rData;

    if (!kIsWeb && Platform.isWindows) {
      var query = await Firestore.instance
          .collection('order')
          .where("date_at", isGreaterThan: newDate);
      rData = await dbRawQuery(query);
      //print("-----${rData}");
    } else {
      var query = await FirebaseFirestore.instance
          .collection('order')
          .where("date_at", isGreaterThan: newDate);
      rData = await dbRawQuery(query);
    }

    setState(() {
      no_todaySale = rData.length;
    });
  }

  yearSale() async {
    List StoreDocs = [];
    var newDate = todayTimeStamp_for_query();
    var yearStartDate = yearStamp_for_query();
    var rData;

    if (!kIsWeb && Platform.isWindows) {
      var query = await Firestore.instance
          .collection('order')
          .where("date_at", isGreaterThan: yearStartDate);
      rData = await dbRawQuery(query);
      //print("-----${rData}");
    } else {
      var query = await FirebaseFirestore.instance
          .collection('order')
          .where("date_at", isGreaterThan: yearStartDate);
      rData = await dbRawQuery(query);
    }

    setState(() {
      no_of_year_sale = rData.length;
    });
  }

////////////////
  ///
  /////////=====================================================================

  OutofStock_Data() async {
    List StoreDocs = [];

    var _category = await Firestore.instance
        .collection('product')
        .where("quantity", isEqualTo: "0")
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot) {
          setState(() {
            StoreDocs.add(docSnapshot.map);
            Out_of_Stock_No = StoreDocs.length;
          });
        }
      },
    );

    // var temp = await dbFindDynamic(db, w);
    setState(() {
      // temp.forEach((k, v) {
      //   StoreDocs.add(v);
      //   UserNo = StoreDocs.length;
      //});
    });
  }
////////////////

  final List<BarChartModel> data = [
    BarChartModel(
      year: "Jan",
      Sale: 200,
      Expenses: 100,
      Profit: 50,
      color: charts.ColorUtil.fromDartColor(Colors.green),
      color1: charts.ColorUtil.fromDartColor(Colors.red),
      color2: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
    BarChartModel(
      year: "Feb",
      Sale: 350,
      Expenses: 200,
      Profit: 100,
      color: charts.ColorUtil.fromDartColor(Colors.green),
      color1: charts.ColorUtil.fromDartColor(Colors.red),
      color2: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
    BarChartModel(
      year: "March",
      Sale: 450,
      Expenses: 200,
      Profit: 250,
      color: charts.ColorUtil.fromDartColor(Colors.green),
      color1: charts.ColorUtil.fromDartColor(Colors.red),
      color2: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
    BarChartModel(
      year: "April",
      Sale: 300,
      Expenses: 200,
      Profit: 100,
      color: charts.ColorUtil.fromDartColor(Colors.green),
      color1: charts.ColorUtil.fromDartColor(Colors.red),
      color2: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
  ];

///////=======================================================================
  @override
  Widget build(BuildContext context) {
    // List<charts.Series<BarChartModel, String>> series = [
    //   charts.Series(
    //     id: "Sale",
    //     data: data,
    //     domainFn: (BarChartModel series, _) => series.year,
    //     measureFn: (BarChartModel series, _) => series.Sale,
    //     colorFn: (BarChartModel series, _) => series.color,
    //   ),
    //   charts.Series(
    //     id: "Expenses",
    //     data: data,
    //     domainFn: (BarChartModel series, _) => series.year,
    //     measureFn: (BarChartModel series, _) => series.Expenses,
    //     colorFn: (BarChartModel series, _) => series.color1,
    //   ),
    //   charts.Series(
    //     id: "Profit",
    //     data: data,
    //     domainFn: (BarChartModel series, _) => series.year,
    //     measureFn: (BarChartModel series, _) => series.Profit,
    //     colorFn: (BarChartModel series, _) => series.color2,
    //   ),
    // ];
    // dashborad list init
    List demoMyFiles = [
      CloudStorageInfo(
        title: "Total Invoice",
        numOfFiles: invoiceNo,
        svgSrc: Icons.shopping_cart,
        // svgSrc: "assets/icons/shoping.svg",
        color: primaryColor,
        PageNo: 5,
      ),
      CloudStorageInfo(
        title: "Total Stocks",
        numOfFiles: StockNo,
        svgSrc: Icons.wallet_giftcard,
        // svgSrc: "assets/icons/google_drive.svg",
        color: Color(0xFFFFA113),
        PageNo: 4,
      ),
      CloudStorageInfo(
        title: "Total User",
        numOfFiles: UserNo,
        svgSrc: Icons.person,
        // svgSrc: "assets/icons/one_drive.svg",
        color: Color(0xFFA4CDFF),

        PageNo: 10,
      ),
      CloudStorageInfo(
        title: "Out of stock",
        numOfFiles: Out_of_Stock_No,
        svgSrc: Icons.production_quantity_limits_outlined,
        // svgSrc: "assets/icons/drop_box.svg",
        color: Color.fromARGB(255, 119, 143, 31),

        PageNo: 4,
      ),
      CloudStorageInfo(
        title: "Today Sales",
        numOfFiles: no_todaySale,
        svgSrc: Icons.auto_graph_rounded,
        // svgSrc: "assets/icons/drop_box.svg",
        color: Color.fromARGB(255, 235, 202, 16),

        PageNo: 5,
      ),
      CloudStorageInfo(
        title: "Yearly Sales",
        numOfFiles: no_of_year_sale,
        svgSrc: Icons.sync_alt_rounded,
        // svgSrc: "assets/icons/drop_box.svg",
        color: Color.fromARGB(255, 235, 202, 16),

        PageNo: 5,
      ),
    ];
    return (user.isEmpty)
        ? Center(child: pleaseWait(context))
        : Scaffold(
            body: Container(
              padding: EdgeInsets.all(defaultPadding),
              child: (isNewUpdate)
                  ? Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "New Update Available !!",
                              style: themeTextStyle(
                                  size: 40.0, color: Colors.green),
                            ),
                            Text(
                              "Please do Hard Refresh Browser",
                              style: themeTextStyle(
                                  size: 24.0,
                                  color: Color.fromARGB(255, 114, 173, 250)),
                            ),
                            SizedBox(height: 40.0),
                            Text(
                              "Press Ctr + Shift + R",
                              style:
                                  themeTextStyle(size: 40.0, color: Colors.red),
                            )
                          ],
                        ),
                      ),
                    )
                  : ListView(
                      children: [
                        Header(
                          title: "Dashboard",
                        ),
                        SizedBox(height: defaultPadding),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  MyFiles(
                                      demoMyFiles: demoMyFiles,
                                      quantity_no: 10),

                                  SizedBox(height: defaultPadding),

                                  /*Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(defaultPadding),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Column(children: [
                                  SizedBox(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.business,
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                          SizedBox(width: 10),
                                          Text("Company Performance",
                                              style: GoogleFonts.alike(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.currency_rupee_outlined,
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                              "Sales , Expenses and Profit : 2017 - 2023",
                                              style: GoogleFonts.alike(
                                                  fontSize: 13,
                                                  color: Colors.black45,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              demo_color(context, Colors.green,
                                                  "Sale"),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              demo_color(context, Colors.red,
                                                  "Expenses"),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              demo_color(context, Colors.yellow,
                                                  "Profit")
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    width: double.infinity,
                                    height: 500,
                                    child: charts.BarChart(
                                      series,
                                      animate: true,
                                    ),
                                  )
                                ]))*/

                                  // ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Back")),
                                  // RecentFiles(),

                                  // if (Responsive.isMobile(context))
                                  //   SizedBox(height: defaultPadding),
                                  // if (Responsive.isMobile(context))
                                  // StarageDetails(),
                                ],
                              ),
                            ),
                            // if (!Responsive.isMobile(context))
                            //   SizedBox(width: defaultPadding),
                            // // On Mobile means if the screen is less than 850 we dont want to show it
                            // if (!Responsive.isMobile(context))
                            //   Expanded(
                            //     flex: 2,
                            //     child:
                            //     StarageDetails(),
                            //   ),
                          ],
                        ),
                      ],
                    ),
            ),
          );
  }

  Widget demo_color(BuildContext context, clr, name) {
    return Container(
      margin: EdgeInsets.only(right: 30),
      child: Row(children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: clr, borderRadius: BorderRadius.circular(2.5)),
          height: 15,
          width: 15,
        ),
        Text("$name",
            style: GoogleFonts.alike(
                fontSize: 13,
                color: Colors.black54,
                fontWeight: FontWeight.normal)),
      ]),
    );
  }
}
