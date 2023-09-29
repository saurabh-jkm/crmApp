// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, deprecated_member_use, sized_box_for_whitespace, non_constant_identifier_names, unrelated_type_equality_checks, dead_code, unnecessary_string_interpolations, use_build_context_synchronously, unnecessary_new, prefer_collection_literals, unused_element, avoid_print, sort_child_properties_last, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/firebase_Storage.dart';
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

import '../product/product/product_widgets.dart';

class EditProfileDetails extends StatefulWidget {
  const EditProfileDetails(
      {super.key, required this.header_name, required this.iid});
  final String header_name;
  final String iid;
  @override
  State<EditProfileDetails> createState() => _EditProfileDetailsState();
}

class _EditProfileDetailsState extends State<EditProfileDetails> {
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

  bool progressWidget = true;
  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userData = (prefs.getString('user'));
    if (userData != null) {
      setState(() {
        user = jsonDecode(userData) as Map<dynamic, dynamic>;
      });
    }
  }

  ///// File Picker ==========================================================
  var url_img;
  String? fileName;

  void clear_imageData() {
    fileName = "";
    url_img = "";
  }

  String? downloadURL;
  pickFile() async {
    if (!kIsWeb) {
      final results = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg'],
        allowMultiple: false,
      );

      if (results != null) {
        final path = results.files.single.path;
        final fileName = results.files.single.name;

        // UploadFile(path!, fileName).then((value) {});

        setState(() async {
          url_img = await uploadFile(path!, fileName, db);
          _getUser();
        });
      } else {
        themeAlert(context, 'Not find selected', type: "error");
      }
    } else if (kIsWeb) {
      final results = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg'],
      );
      if (results != null) {
        Uint8List? UploadImage = results.files.single.bytes;
        fileName = results.files.single.name;
        Reference reference = FirebaseStorage.instance.ref('media/$fileName');
        final UploadTask uploadTask = reference.putData(UploadImage!);
        uploadTask.whenComplete(() => print("selected image"));
        setState(() async {
          downloadURL = await FirebaseStorage.instance
              .ref()
              .child('media/$fileName')
              .getDownloadURL();
          setState(() {
            url_img = downloadURL.toString();
            // image_addList(url_img);
          });
        });
      } else {
        themeAlert(context, 'Not find selected', type: "error");
        return null;
      }
    }
  }

/////////////  Update Data +++++++++++++++++++++++++++++++++++++++++++++++++++++
  Map<String, dynamic>? data;
  Future<void> _Update_initial(id) async {
    Map<dynamic, dynamic> w = {'table': "users", 'id': id};
    data = await dbFind(w);
    setState(() {
      fnameController.text = data!["first_name"];
      lnameController.text = data!["last_name"];
      phoneController.text = data!["mobile_no"];
      emailnameController.text = data!["email"];
      passController.text = data!["password"];
      url_img = data!["avatar"];
      progressWidget = false;
    });
  }

//////// =======================================================================

  updatelist(
    id,
  ) async {
    var alert = '';
    if (emailnameController.text.isEmpty ||
        emailnameController.text.length < 6) {
      alert = "Please enter valid Email";
    } else if (phoneController.text.isEmpty ||
        phoneController.text.length < 10) {
      alert = "Please enter valid Phone Number";
    } else if (fnameController.text.isEmpty ||
        fnameController.text.length < 2) {
      alert = "Please enter valid first Name";
    } else if (lnameController.text.isEmpty) {
      alert = "Please enter valid Last Name";
    } else if (passController.text.isEmpty || passController.text.length < 6) {
      alert = "Please enter valid password";
    }

    if (alert != '') {
      themeAlert(context, alert, type: "error");
    } else {
      Map<String, dynamic> w = {};
      w = {
        "table": "users",
        "first_name": fnameController.text.trim(),
        "last_name": lnameController.text.trim(),
        "mobile_no": phoneController.text.trim(),
        "password": passController.text.trim(),
        "email": emailnameController.text.trim(),
        "avatar": "$url_img",
        "date_at": "$Date_at"
      };
      w['id'] = id;
      var msg = await dbUpdate(db, w);
      await _Update_initial(widget.iid);

      await shared_pref_update();
      if (msg != null) {
        themeAlert(context, "Updated Successfully !!");
        Navigator.pop(context, true);
      }
    }
  }

  shared_pref_update() async {
    var userDataArr = {
      'user_type': data!["user_type"],
      'id': widget.iid,
      'name': "${data!["first_name"]} ${data!["last_name"]}",
      'fname': data!["first_name"],
      'lname': data!["last_name"],
      'phone': data!["mobile_no"],
      'email': data!["email"],
      "status": data!["status"],
      "date_at": data!["date_at"],
      'avatar': data!["avatar"],
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(userDataArr));
  }

////// =========================================================================
  @override
  void initState() {
    _getUser();
    _Update_initial(widget.iid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("$user ++++++");
    return (progressWidget == true)
        ? Center(child: progress())
        : Scaffold(
            body: Container(
              color: Colors.white,
              child: ListView(children: [
                //header ======================
                themeHeader2(context, "${widget.header_name}"),
                // formField =======================
                SizedBox(
                  height: 40,
                ),
                profile_image(),
                themeButton3(context, () {
                  pickFile();
                },
                    label: "Change Profile Image",
                    fontSize: 12,
                    btnHeightSize: 30.0,
                    buttonColor: themeBG4),
                SizedBox(
                  height: 40,
                ),
                Edit_List(context, data)
              ]),
            ),
          );
  }

  bool passwordVisible = true;
  Widget Edit_List(BuildContext context, userr) {
    return Container(
      // height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Color.fromARGB(99, 0, 0, 0),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_circle_outlined,
                color: Colors.black,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Account settings",
                  style: GoogleFonts.alike(
                      color: Colors.black,
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
                          style: GoogleFonts.alike(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        width: 150,
                      ),
                      SizedBox(
                        width: 10,
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
                          style: GoogleFonts.alike(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        width: 150,
                      ),
                      SizedBox(
                        width: 10,
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
                          "Email Id",
                          style: GoogleFonts.alike(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        width: 150,
                      ),
                      SizedBox(
                        width: 10,
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
                        width: 150,
                        child: Text(
                          "Mobile Number",
                          style: GoogleFonts.alike(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 10,
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
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        width: 150,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: passController,
                          obscureText: passwordVisible,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                (passwordVisible == true)
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.blue,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(
                                  () {
                                    if (passwordVisible == true) {
                                      passwordVisible = false;
                                    } else {
                                      passwordVisible = true;
                                    }
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
                      // themeButton3(context, () {
                      //   setState(() {});
                      // }, label: "Cancel", buttonColor: Colors.black),
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
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: Container(
          //margin: EdgeInsets.all(10),
          height: coverHeight / 1.8,
          width: coverHeight / 1.8,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: (url_img != null)
                      ? NetworkImage("$url_img")
                      : NetworkImage(
                          "https://img.freepik.com/premium-vector/account-icon-user-icon-vector-graphics_292645-552.jpg?w=2000"),
                  fit: BoxFit.contain)),
        ),
      );
}

/// Class CLose
