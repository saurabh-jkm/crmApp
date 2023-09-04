// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, deprecated_member_use, sized_box_for_whitespace, non_constant_identifier_names, unrelated_type_equality_checks, dead_code, unnecessary_string_interpolations, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/firebase_functions.dart';
import '../../themes/function.dart';
import '../../themes/style.dart';
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
  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userData = (prefs.getString('user'));
    if (userData != null) {
      setState(() {
        user = jsonDecode(userData) as Map<dynamic, dynamic>;
      });
    }
  }

/////////////  Update Data +++++++++++++++++++++++++++++++++++++++++++++++++++++
  Map<String, dynamic>? data;
  Future<void> _Update_initial(id) async {
    Map<dynamic, dynamic> w = {'table': "users", 'id': id};
    data = await dbFind(w);
    print("$data kk++++++");
  }

//////// =======================================================================
////////  Update Data of User Profile ++++++++++++++++++++++++++++++++++++++++++

  updatelist(
    id,
  ) async {
    Map<String, dynamic> w = {};
    w = {
      "table": "users",
      "first_name": fnameController.text.trim(),
      "last_name": lnameController.text.trim(),
      "mobile_no": phoneController.text.trim(),
      "password": passController.text.trim(),
      "email": emailnameController.text.trim(),
      'status': "1",
      "avatar": "",
      "date_at": "$Date_at"
    };
    w['id'] = id;
    var msg = await dbUpdate(db, w);
    themeAlert(context, "$msg !!");
    setState(() {});
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
    return Scaffold(
      body: ListView(
        children: [
          Header(
            title: "My Profile",
          ),
          (update == true) ? Edit_List(context, data) : Show_info(context)
        ],
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
            height: 40,
          ),
          profile_image(),
          SizedBox(
            height: 10,
          ),
          Text(
            "${user["name"]} ",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            ' ${user["user_type"]}'.toUpperCase(),
            style: TextStyle(
              fontSize: 15.0,
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
                      setState(() {
                        _Update_initial("${user["id"]}");
                        update = true;
                      });
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
            height: 20.0,
            width: MediaQuery.of(context).size.width,
            child: Divider(
              color: Colors.black12,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: const Color.fromARGB(73, 0, 0, 0),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    title: Text(
                      "${user["name"]}",
                      style:
                          GoogleFonts.alike(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
                Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    title: Text(
                      "${user["email"]}",
                      style:
                          GoogleFonts.alike(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
                Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.mobile_screen_share_rounded,
                      color: Colors.white,
                    ),
                    title: Text(
                      "${user["phone"]}",
                      style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ),
                Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.update,
                      color: Colors.white,
                    ),
                    title: Text(
                      (user["status"] == "1") ? "Active" : "Inactive",
                      style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: 15,
                          color: (user["status"] == "1")
                              ? Colors.green
                              : Colors.red),
                    ),
                  ),
                ),
                Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white,
                    ),
                    title: Text(
                      "${user["date_at"]}",
                      style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: 15,
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

//// Widget for Start_up

  Widget Edit_List(BuildContext context, userr) {
    bool passwordVisible = true;
    return Container(
      // height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_circle_outlined,
                color: Colors.blue,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Account settings",
                  style: GoogleFonts.alike(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ],
          ),
          SizedBox(
            height: 20,
            child: Divider(thickness: 1, color: Colors.white),
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white),
                        child: Text(
                          "Frist Name",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: fnameController,
                          decoration: InputDecoration(
                            hintText: '${userr["first_name"]}',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white),
                        child: Text(
                          "Last Name",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: lnameController,
                          decoration: InputDecoration(
                            hintText: '${userr["last_name"]}',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white),
                        child: Text(
                          "Email",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: emailnameController,
                          decoration: InputDecoration(
                            hintText: '${userr["email"]}',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white),
                        child: Text(
                          "Mobile Number",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            hintText: '${userr["mobile_no"]}',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white),
                        child: Text(
                          "Change Pin",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: passController,
                          obscureText: passwordVisible,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.blue,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(
                                  () {
                                    passwordVisible = !passwordVisible;
                                  },
                                );
                              },
                            ),
                            hintText: '******',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      themeButton3(context, () {
                        setState(() {
                          updatelist("${user["id"]}");
                        });
                      }, buttonColor: themeBG3, label: "Update"),
                      SizedBox(
                        width: 10,
                      ),
                      themeButton3(context, () {
                        setState(() {
                          update = false;
                        });
                      }, label: "Cancel", buttonColor: Colors.black),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  final double coverHeight = 220;

/////  Profile image +====

  Widget profile_image() => Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: Container(
          //margin: EdgeInsets.all(10),
          height: coverHeight / 1.5,
          width: coverHeight / 1.5,
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
