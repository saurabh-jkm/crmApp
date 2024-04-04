// ignore_for_file: non_constant_identifier_names, await_only_futures, unnecessary_string_interpolations

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../themes/firebase_functions.dart';

class SubadminController {
  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;
  String Date_at = DateFormat('dd-MM-yyyy' "  hh:mm").format(DateTime.now());
  String email = "";
  String password = "";
  String fname = "";
  String lname = "";
  String fullName = "";
  String Mobile = "";
  String StatusValue = "";
  String dropDownValue = "";
  String User_Cate = '';
  /////////////  Users data fetch From Firebase   +++++++++++++++++++++++++++++
  List StoreDocs = [];
  List UserIDcheck = [];
  bool progressWidget = true;
  SubAdminData(int limitData) async {
    StoreDocs = [];
    Map<dynamic, dynamic> w = {
      'table': "users",
      "orderBy": "-date_at",
      "limit": limitData
    };
    var temp = await dbFindDynamic(db, w);
    return temp;
  }
//////////////==================================================================
  ///=============================================================================

//////++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
////////////  User Category  data +++++++++++++++++++++++++++++++++++++++++++++++++

  Map<String, String> Cate_Name_list = {'Select': ''};
  CateData() async {
    Map<dynamic, dynamic> w = {
      'table': 'user_category',
      //'status':'1',
    };
    var dbData = await dbFindDynamic(db, w);
    return dbData;
  }

///////// ====================================================================
/////===========================================================================
  clearText() {
    fname = "";
    lname = "";
    email = "";
    fullName = "";
    password = "";
    User_Cate = '';
    Mobile = "";
    StatusValue = "";
  }
}///// class Close
