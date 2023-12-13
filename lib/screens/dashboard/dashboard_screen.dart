// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_returning_null_for_void, no_leading_underscores_for_local_identifiers, avoid_print, non_constant_identifier_names, unnecessary_string_interpolations, sized_box_for_whitespace, unused_import, unnecessary_new, unnecessary_brace_in_string_interps, prefer_collection_literals, unused_local_variable, await_only_futures, prefer_typing_uninitialized_variables, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/themes/function.dart';
import 'package:crm_demo/themes/style.dart';
import 'package:crm_demo/themes/theme_footer.dart';
import 'package:crm_demo/themes/theme_header.dart';
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
import 'dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var controller = new DashboardController();
  //////Crosss file picker
  final GlobalKey exportKey = GlobalKey();
  /////// get user data  +++++++++++++++++++++++++++++++++++++++++++++++++++
  Map<dynamic, dynamic> user = new Map();
  int no_todaySale = 0;
  bool isNewUpdate = false;
  int invoiceNo = 0;
  int StockNo = 0;
  int UserNo = 0;
  int Out_of_Stock_No = 0;
  int no_of_year_sale = 0;
  int BalanceCount = 0;
  int totallbuy = 0;
  int todaybuy = 0;
  int no_of_year_buy = 0;
  int todaysell = 0;
  int totalsell = 0;
  var tempMap = {};
  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userData = (prefs.getString('user'));

    if (userData != null) {
      user = await jsonDecode(userData) as Map<dynamic, dynamic>;

      invoiceNo = await controller.invo_Data_count();
      StockNo = await controller.stock_Data_count();
      UserNo = await controller.User_Data_count();
      Out_of_Stock_No = await controller.OutofStock_Data_count();
      totallbuy = await controller.totallBuy();
      todaybuy = await controller.todayBuy();
      no_of_year_buy = await controller.yearBuy();

      // todaySale
      totalsell = await controller.totalSale();
      todaysell = await controller.todaySale();
      no_of_year_sale = await controller.yearSale();

      if (kIsWeb) {
        await appSetting();
      }
      BalanceCount = await controller.Balance_count();
      setState(() {});
    }
  }

  var smallD = true;
  @override
  void initState() {
     if(Platform.isAndroid || Platform.isIOS){
      smallD = true;
    }else{
      smallD = false;
    }

    _getUser();
    super.initState();
  }

  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;
  bool progressWidget = true;

  appSetting() async {
    List StoreDocs = [];
    Map<dynamic, dynamic> w = {
      'table': "app_setting",
      //'status': "$_StatusValue",
    };
    var temp = await dbFindDynamic(db, w);
    if (temp.isNotEmpty && temp[0]['version'] > 22) {
      setState(() {
        isNewUpdate = true;
      });
    }
  }


// ///////=======================================================================
  @override
  Widget build(BuildContext context) {
    
    // dashborad list init
    List demoMyFiles = [
      CloudStorageInfo(
        title: "Total User",
        numOfFiles: UserNo,
        svgSrc: Icons.person,
        // svgSrc: "assets/icons/one_drive.svg",
        color: Color(0xFFA4CDFF),
        PageNo: 10,
      ),
      CloudStorageInfo(
        title: "Total Stocks",
        numOfFiles: StockNo,
        svgSrc: Icons.shopping_cart,
        // svgSrc: "assets/icons/google_drive.svg",
        color: Color(0xFFFFA113),
        PageNo: 4,
      ),
      CloudStorageInfo(
        title: "Out of stock",
        numOfFiles: Out_of_Stock_No,
        svgSrc: Icons.production_quantity_limits_outlined,

        // svgSrc: "assets/icons/drop_box.svg",
        color: Colors.red,

        PageNo: 4,
      ),
      CloudStorageInfo(
        title: "Total Invoice",
        numOfFiles: invoiceNo,
        svgSrc: Icons.inventory_outlined,
        // svgSrc: "assets/icons/shoping.svg",
        color: primaryColor,
        PageNo: 5,
      ),
      CloudStorageInfo(
        title: "Today Sales",
        numOfFiles: todaysell,
        svgSrc: Icons.auto_graph_rounded,
        // svgSrc: "assets/icons/drop_box.svg",
        color: Color.fromARGB(255, 235, 202, 16),

        PageNo: 14,
      ),
      CloudStorageInfo(
        title: "Total Sales",
        numOfFiles: totalsell,
        svgSrc: Icons.sync_alt_rounded,
        // svgSrc: "assets/icons/drop_box.svg",
        color: Color.fromARGB(255, 235, 202, 16),

        PageNo: 14,
      ),
      CloudStorageInfo(
        title: "Yearly Sales",
        numOfFiles: no_of_year_sale,
        svgSrc: Icons.sync_alt_rounded,
        // svgSrc: "assets/icons/drop_box.svg",
        color: Color.fromARGB(255, 235, 202, 16),
        PageNo: 14,
      ),
      CloudStorageInfo(
        title: "Today Buys",
        numOfFiles: todaybuy,
        svgSrc: Icons.sell,
        // svgSrc: "assets/icons/drop_box.svg",
        color: Color.fromARGB(255, 78, 235, 16),

        PageNo: 5,
      ),
      CloudStorageInfo(
        title: "Total Buys",
        numOfFiles: totallbuy,
        svgSrc: Icons.sell_outlined,
        // svgSrc: "assets/icons/drop_box.svg",
        color: Color.fromARGB(255, 78, 235, 16),

        PageNo: 5,
      ),
      CloudStorageInfo(
        title: "Yearly Buys",
        numOfFiles: no_of_year_buy,
        svgSrc: Icons.sell_outlined,
        // svgSrc: "assets/icons/drop_box.svg",
        color: Color.fromARGB(255, 78, 235, 16),

        PageNo: 5,
      ),
      CloudStorageInfo(
        title: "Total Outstanding",
        numOfFiles: BalanceCount,
        svgSrc: Icons.balance,
        // svgSrc: "assets/icons/drop_box.svg",
        color: Color.fromARGB(255, 241, 123, 123),
        PageNo: 12,
      ),
    ];
    //totallbuy
    return (user.isEmpty)
        ? Center(child: pleaseWait(context))
        : Scaffold(
            bottomNavigationBar: (smallD)? theme_footer_android(context, 0):SizedBox(),
            body: Container(
              padding: EdgeInsets.all((smallD)?0.0:defaultPadding),
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
                                  size: (smallD)?20.0:40.0, color: Colors.green),
                            ),
                            Text(
                              "Please do Hard Refresh Browser",
                              style: themeTextStyle(
                                  size: (smallD)?14.0:24.0,
                                  color: Color.fromARGB(255, 114, 173, 250)),
                            ),
                            SizedBox(height: 40.0),
                            Text(
                              "Press Ctr + Shift + R",
                              style:
                                  themeTextStyle(size:(smallD)?13.0: 40.0, color: Colors.red),
                            )
                          ],
                        ),
                      ),
                    )
                  : ListView(
                      children: [
                        (smallD)?themeHeader_android(context,title: "Dashboard"):Header(
                          title: "Dashboard",
                        ),
                        SizedBox(height: defaultPadding),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  MyFiles(
                                    demoMyFiles: demoMyFiles,
                                    quantity_no: 10,
                                    value: controller.tempCount,
                                  ),

                                  SizedBox(height: defaultPadding),

                              
                                ],
                              ),
                            ),
                            
                          ],
                        ),
                      ],
                    ),
            ),
          );
  }

  // Widget demo_color(BuildContext context, clr, name) {
  //   return Container(
  //     margin: EdgeInsets.only(right: 30),
  //     child: Row(children: [
  //       Container(
  //         margin: EdgeInsets.only(right: 10),
  //         decoration: BoxDecoration(
  //             color: clr, borderRadius: BorderRadius.circular(2.5)),
  //         height: 15,
  //         width: 15,
  //       ),
  //       Text("$name",
  //           style: GoogleFonts.alike(
  //               fontSize: 13,
  //               color: Colors.black54,
  //               fontWeight: FontWeight.normal)),
  //     ]),
  //   );
  // }
}
