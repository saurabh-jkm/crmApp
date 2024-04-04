// ignore_for_file: prefer_const_constructors, unnecessary_new, await_only_futures, prefer_collection_literals, avoid_unnecessary_containers, unused_local_variable, non_constant_identifier_names, unnecessary_this

import 'package:jkm_crm_admin/screens/Invoice/add_supplier_invoice_screen.dart';

import 'package:jkm_crm_admin/screens/privacy_policy/privacy_policy.dart';
import 'package:jkm_crm_admin/themes/global.dart';
import 'package:jkm_crm_admin/themes/style.dart';
import 'package:jkm_crm_admin/themes/theme_widgets.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';

import 'package:jkm_crm_admin/screens/Invoice/add_invoice_screen.dart';
import 'package:jkm_crm_admin/screens/product/product-backup.dart';
import 'package:jkm_crm_admin/screens/product/product/add_product_screen.dart';
import 'package:jkm_crm_admin/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';
import 'controllers/MenuAppController.dart';
//import 'screens/Login_Reg/Login_user.dart';

import 'screens/Login_Reg/login_screen.dart';
import 'screens/Selsman/WorkAlot/salesman_list.dart';
import 'screens/main/main_screen.dart';
import 'themes/firebase_functions.dart';
import '../themes/global.dart' as globals;

//////////////
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

  // ========================
  // Has Remove # from URL =======================
  //setPathUrlStrategy();
  runApp(new MyApp());
}

// 2nd My app Start =========================================
// ==========================================================

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final Future<FirebaseApp> _initialization =  Firebase.initializeApp();
//// ///
  var settingDate = {};
  bool isNewUpdate = false;
  bool loginIs = false;
  bool isWait = true;
  Map<dynamic, dynamic> user = new Map();

  // get user data
  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userData = (prefs.getString('user'));
    if (userData != null) {
      user = jsonDecode(userData) as Map<dynamic, dynamic>;
      loginIs = true;
    }
    isWait = false;
    await check_Device_plateform();
    if (is_mobile == true) {
      await check_new_version();
    }

    if (this.mounted) {
      setState(() {});
    }
  }

///////

  check_Device_plateform() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        is_mobile = true;
      }
    } catch (e) {
      is_mobile = false;
    }
  }

  ///
  ///// Check

  check_new_version() async {
    Map<dynamic, dynamic> w = {
      'table': "app_setting",
      //'status': "$_StatusValue",
    };
    var temp = await dbFindDynamic(db, w);
    if (temp[0]['crm_admin_android_v'] > globals.androidRealeaseNo) {
      setState(() {
        settingDate = temp[0];
        isNewUpdate = true;
      });
    }
  }

/////////////////////
  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "JKM CRM",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => MenuAppController(),
            ),
          ],
          child: (isWait)
              ? Scaffold(
                  body: Container(child: Center(child: pleaseWait(context))))
              : (loginIs == true)
                  ? (isNewUpdate)
                      ? newVersionCon(context)
                      : MainScreen(pageNo: 1, stockvalue: 0)
                  : Login_Copy()),
      // child: Scaffold(
      //     body: (loginIs)
      //         ? MainScreen(pageNo: 1)
      //         : Container(child: Center(child: pleaseWait(context))))),

      // All Routs ====================//=====================
      routes: {
        '/add_stock': (context) => addStockScreen(
              header_name: "Add New Stock",
            ),
        '/stock_list': (context) => ProductAdd(),
        '/privacy-policy': (context) => privacyPolicy(),
        //  '/invoice': (context) => Invoice_List(),
        '/salesman': (context) => SalemanList(),
        '/dashboard': (context) => MainScreen(pageNo: 1, stockvalue: 0),
        '/new_invoice': (context) => addInvoiceScreen(
              header_name: "Customer",
            ),
        '/new_supplier_invoice': (context) => addInvoiceSupplierScreen(
              header_name: "Suplier",
            ),
      },
    );
  }

  // New Update Widgets ==================================================
  //if(isNewUpdate)
  Widget newVersionCon(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 143, 144, 255),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/images/update-avialble.png')),
              GoogleText(
                  text:
                      "New Update Available (1.0.${settingDate['crm_android_version']})",
                  fsize: 15.0,
                  fstyle: FontStyle.italic,
                  color: Colors.white),
              themeSpaceVertical(30.0),
              themeButton3(context, () {
                _launchInBrowser("https://play.google.com/store/apps/");
              },
                  buttonColor: buttonBG,
                  label: "Update Now >>",
                  radius: 8.0,
                  btnWidthSize: 200.0,
                  btnHeightSize: 45.0),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(uri) async {
    final url = Uri.parse(uri);

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
/////close///