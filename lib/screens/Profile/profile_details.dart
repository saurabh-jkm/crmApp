// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, deprecated_member_use, sized_box_for_whitespace, non_constant_identifier_names, unrelated_type_equality_checks, dead_code, unnecessary_string_interpolations, use_build_context_synchronously, unnecessary_new, prefer_collection_literals

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/screens/Profile/edit_profile.dart';
import 'package:crm_demo/themes/base_controller.dart';
import 'package:crm_demo/themes/global.dart';
import 'package:crm_demo/themes/theme_footer.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/firebase_functions.dart';
import '../../themes/function.dart';
import '../../themes/style.dart';
import '../../themes/theme_header.dart';
import '../../themes/theme_widgets.dart';
import '../Invoice/invoice_serv.dart';
import '../dashboard/components/header.dart';
import '../dashboard/components/my_fields.dart';
import '../dashboard/components/recent_files.dart';
import '../dashboard/components/storage_details.dart';
import 'package:file_picker/file_picker.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});
  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final emailnameController = TextEditingController();
  final phoneController = TextEditingController();
  final passController = TextEditingController();
  /////// get user data  +++++++++++++++++++++++++++++++++++++++++++++++++++
  Map<dynamic, dynamic> user = new Map();
  var baseController = new base_controller();
  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userData = (prefs.getString('user'));
    if (userData != null) {
      setState(() {
        user = jsonDecode(userData) as Map<dynamic, dynamic>;
      });
    }
  }

  addNewStock() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => EditProfileDetails(
                header_name: "Edit Profile Details",
                iid: "my0Zs0h3wAY6bF0d4xHF")));
  }

////// =========================================================================
  @override
  void initState() {
    _getUser();
    super.initState();
  }

  bool update = false;

  ///
  @override
  Widget build(BuildContext context) {
    // print("$user ++++++");
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (e) {
        var rData =
            baseController.KeyPressFun(e, context, backtype: 'dashboard');
        if (rData != null && rData) {
          setState(() {});
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: clientAppBar(),
        ),
        bottomNavigationBar:
            (is_mobile) ? theme_footer_android(context, 1) : SizedBox(),
        body: ListView(
          children: [
            (is_mobile)
                ? themeHeader_android(context, title: "My Profile")
                : Header(
                    title: "My Profile",
                  ),
            Show_info(context)
          ],
        ),
      ),
    );
  }

  Widget Show_info(BuildContext context) {
    return Container(
      color: Colors.white,
      // height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          SizedBox(
            height: (!is_mobile) ? 40 : 10,
          ),
          profile_image(),
          SizedBox(
            height: (!is_mobile) ? 10 : 5.0,
          ),
          Text(
            "${user["name"]} ",
            style: TextStyle(
              fontSize: (!is_mobile) ? 20 : 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            ' ${user["user_type"]}'.toUpperCase(),
            style: TextStyle(
              fontSize: (!is_mobile) ? 15 : 12.0,
              color: Colors.blue,
              fontWeight: FontWeight.normal,
              letterSpacing: 2.5,
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      addNewStock();
                      // setState(() {
                      //   _Update_initial("${user["id"]}");
                      //   update = true;
                      // });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // Background color
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Edit Profile")
                      ],
                    ))
              ],
            ),
          ),
          SizedBox(
            height: (!is_mobile) ? 20 : 10,
            width: MediaQuery.of(context).size.width,
            child: Divider(
              color: Colors.black12,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                vertical: (!is_mobile) ? 20 : 10, horizontal: 10),
            padding: EdgeInsets.all(
                (!is_mobile) ? defaultPadding : defaultPadding / 2.5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(73, 0, 0, 0),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.symmetric(
                      vertical: (!is_mobile) ? 10.0 : 5.0,
                      horizontal: (!is_mobile) ? 20.0 : 10.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    title: Text(
                      "${user["name"]}",
                      style: GoogleFonts.alike(
                          fontSize: (!is_mobile) ? 15.0 : 12.0,
                          color: Colors.white),
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(
                      vertical: (!is_mobile) ? 10.0 : 5.0,
                      horizontal: (!is_mobile) ? 20.0 : 10.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    title: Text(
                      "${user["email"]}",
                      style: GoogleFonts.alike(
                          fontSize: (!is_mobile) ? 15.0 : 12.0,
                          color: Colors.white),
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(
                      vertical: (!is_mobile) ? 10.0 : 5.0,
                      horizontal: (!is_mobile) ? 20.0 : 10.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.mobile_screen_share_rounded,
                      color: Colors.white,
                    ),
                    title: Text(
                      "${user["phone"]}",
                      style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: (!is_mobile) ? 15.0 : 12.0,
                          color: Colors.white),
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(
                      vertical: (!is_mobile) ? 10.0 : 5.0,
                      horizontal: (!is_mobile) ? 20.0 : 10.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.update,
                      color: Colors.white,
                    ),
                    title: Text(
                      (user["status"] == "1") ? "Active" : "Inactive",
                      style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: (!is_mobile) ? 15.0 : 12.0,
                          color: (user["status"] == "1")
                              ? Colors.green
                              : Colors.red),
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(
                      vertical: (!is_mobile) ? 10.0 : 5.0,
                      horizontal: (!is_mobile) ? 20.0 : 10.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white,
                    ),
                    title: Text(
                      "${user["date_at"]}",
                      style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: (!is_mobile) ? 15.0 : 12.0,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

/////  Profile image +====
  final double coverHeight = 220;
  Widget profile_image() => Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: Container(
          height: (!is_mobile) ? coverHeight / 1.5 : coverHeight / 2,
          width: (!is_mobile) ? coverHeight / 1.5 : coverHeight / 2,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: (user.isNotEmpty && user != "")
                      ? NetworkImage("${user["avatar"]}")
                      : NetworkImage(
                          "https://img.freepik.com/premium-vector/account-icon-user-icon-vector-graphics_292645-552.jpg?w=2000"),
                  // AssetImage("assets/images/sl1.jpg"),
                  fit: BoxFit.fill)),
        ),
      );
}

/// Class CLose
