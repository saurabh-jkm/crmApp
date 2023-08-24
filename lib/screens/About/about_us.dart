// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, prefer_final_fields, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_null_comparison, sort_child_properties_last, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, depend_on_referenced_packages, avoid_print, unnecessary_new, equal_keys_in_map

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/themes/theme_widgets.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

import '../../themes/firebase_functions.dart';
import '../../themes/style.dart';
import '../dashboard/components/header.dart';
import 'package:intl/intl.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});
  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String Date_at = DateFormat('dd-MM-yyyy').format(DateTime.now());
  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;
  final AboutController = TextEditingController();
  String AboutUs_text = "";
  var id_text;
  @override
  void initState() {
    About_Data();
    super.initState();
  }

  ////////////  Product data fetch  ++++++++++++++++++++++++++++++++++++++++++++
  List productList = [];
  bool progressWidget = true;
  About_Data() async {
    var temp2 = [];
    productList = [];
    Map<dynamic, dynamic> w = {
      'table': "about_us",
      //'status': "$_StatusValue",
    };
    var temp = (!kIsWeb && Platform.isWindows)
        ? await All_dbFindDynamic(db, w)
        : await dbFindDynamic(db, w);

    setState(() {
      temp.forEach((k, v) {
        productList.add(v);

        about_initial(productList[0]["id"]);
      });
      progressWidget = false;
    });
  }

  Future<void> All_addList() async {
    // print("$url_img  +++++++++++++");
    var _category = await Firestore.instance.collection('about_us');
    return _category.add(
        {'about': AboutController.text, "date_at": "$Date_at"}).then((value) {
      setState(() {
        themeAlert(context, "Submitted Successfully ");
      });
    }).catchError(
        (error) => themeAlert(context, 'Failed to Submit', type: "error"));
  }
/////////////=====================================================================

  // Edit  ================================================================
  Map<String, dynamic>? update_data;
  Future about_initial(id) async {
    Map<dynamic, dynamic> w = {'table': "about_us", 'id': id};
    var dbData = await dbFind(w);
    if (dbData != null) {
      setState(() {
        id_text = id;
        AboutUs_text = dbData!['about'];
        AboutController.text = dbData!['about'];
      });
    }
  }

  ///

  updatelist(id, about_text) async {
    Map<String, dynamic> w = {};
    w = {'table': "about_us", 'about': "$about_text", "date_at": "$Date_at"};
    w['id'] = id;
    if (!kIsWeb && Platform.isWindows) {
      await All_dbUpdate(
        db,
        w,
      );
    } else {
      await dbUpdate(db, w);
    }
    themeAlert(context, "Successfully Updated !!");
    setState(() {
      About_Data();
    });
  }

  //////

///////////////////       ======================================================

  bool updateWidget = false;
  var update_id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: ListView(
        children: [
          Header(
            title: "About Us",
          ),
          listCon(context, "Edit About Us")
        ],
      ),
    ));
  }

//// Widget for Start_up
  Widget listCon(BuildContext context, sub_text) {
    return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius:
          //     const BorderRadius.all(Radius.circular(10)),
        ),
        child: ListView(children: [
          Container(
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      // Add_Category = false;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.info_outlined, color: Colors.blue, size: 25),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'About Us',
                        style: themeTextStyle(
                            size: 18.0,
                            ftFamily: 'ms',
                            fw: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '$sub_text',
                        style: themeTextStyle(
                            size: 12.0,
                            ftFamily: 'ms',
                            fw: FontWeight.normal,
                            color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.all(defaultPadding),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text("About Us",
                          style: GoogleFonts.alike(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15))
                    ],
                  ),
                  Container(
                      alignment: Alignment.bottomLeft,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 1.5)),
                      child: TextField(
                        style: GoogleFonts.alike(
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                            fontSize: 13),
                        controller: AboutController,
                        onChanged: (val) {
                          setState(() {
                            AboutUs_text = AboutController.text;
                          });
                        },

                        decoration: InputDecoration(),
                        textAlign: TextAlign.start,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.multiline,
                        minLines: 1, // <-- SEE HERE
                        maxLines: 100, // <-- SEE HERE
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      themeButton3(context, () {
                        // All_addList();
                        updatelist(id_text, AboutUs_text);
                      }, label: 'Update')
                    ],
                  )
                ],
              )),
        ]));
  }
}
