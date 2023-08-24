// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, deprecated_member_use, sized_box_for_whitespace, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';
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

///////=======================================================================
  @override
  void initState() {
    _getUser();
    super.initState();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Header(
          title: "My Profile",
        ),
        SizedBox(height: defaultPadding),
        build_top(context),
        listList(context, user),
      ],
    ));
  }

//// Widget for Start_up

  Widget listList(BuildContext context, user) {
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
          Text(
            "Account settings",
            style: Theme.of(context).textTheme.subtitle1,
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
                            color: Colors.green),
                        child: Text(
                          "Frist Name",
                          style: TextStyle(
                              color: Colors.yellowAccent, fontSize: 20),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '${user["fname"]}',
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
                            color: Colors.green),
                        child: Text(
                          "Last Name",
                          style: TextStyle(
                              color: Colors.yellowAccent, fontSize: 20),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '${user["lname"]}',
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
                            color: Colors.green),
                        child: Text(
                          "Email",
                          style: TextStyle(
                              color: Colors.yellowAccent, fontSize: 20),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '${user["email"]}',
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
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.green),
                        child: Text(
                          "Mobile Number",
                          style: TextStyle(
                              color: Colors.yellowAccent, fontSize: 20),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '${user["phone"]}',
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
                      themeButton3(context, () {},
                          buttonColor: themeBG3, label: "Update"),
                      SizedBox(
                        width: 10,
                      ),
                      themeButton3(context, () {},
                          label: "Cancel", buttonColor: Colors.black),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  final double coverHeight = 220;

  Widget build_top(BuildContext context) => Container(
        height: coverHeight + 80,
        //  width: MediaQuery.of(context).size.width,
        // margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(defaultPadding),
        child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(top: 0, child: buildCover()),
              Positioned(
                  top: coverHeight / 1.9,
                  right: coverHeight * 2,
                  child: profile_image()),
              Positioned(
                  top: coverHeight + 27,
                  child: GestureDetector(
                    onTap: () {
                      //  _fnGoEditPage();
                    },
                    child: Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(width: 1.0, color: Colors.white),
                            color: Color.fromARGB(255, 23, 160, 126)),
                        child: Icon(
                          Icons.mode_edit_outlined,
                          color: Colors.white,
                        )),
                  ))
            ]),
      );

///////////////

  Widget buildCover() => Container(
        width: MediaQuery.of(context).size.width - 200,
        // padding: EdgeInsets.all(defaultPadding),
        height: coverHeight - 20,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [themeBG2, themeBG3, themeBG],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // stops: [0.6,0.4,0.7],
              // tileMode: TileMode.repeated,
            ),
            image: DecorationImage(
                image: AssetImage("assets/images/baner1.jpg"),
                fit: BoxFit.fill)),
        //  child:
        //  Stack(
        //   children: [
        //        Positioned(
        //         top: coverHeight/1.15,
        //         right: coverHeight/3.2,
        //          child: Text("Saurabh Yadav",style: TextStyle(fontSize: 22.0,fontFamily: 'ms',fontWeight: FontWeight.bold,color: Colors.white,)
        //          ),
        //        ),
        //  ],),
      );

/////  Profile image +====

  Widget profile_image() => Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
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
