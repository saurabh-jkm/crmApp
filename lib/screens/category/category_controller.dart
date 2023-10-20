// // ignore_for_file: unnecessary_string_interpolations, unused_shown_name, non_constant_identifier_names, prefer_const_constructors, unused_local_variable, avoid_print

// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firedart/firedart.dart';
// import 'package:flutter/foundation.dart';

// import '../../themes/firebase_functions.dart';

// class CategoryController {
//   var db = (!kIsWeb && Platform.isWindows)
//       ? Firestore.instance
//       : FirebaseFirestore.instance;

//   /////////////  Category data fetch From Firebase   +++++++++++++++++++++++++++++++++++++++++++++

//   List StoreDocs = [];
//   bool progressWidget = true;
//   Comman_Cate_Data() async {
//     StoreDocs = [];
//     Map<dynamic, dynamic> w = {
//       'table': "category",
//     };
//     var temp = await dbFindDynamic(db, w);
//     return temp;
//   }
// ///////// =====================================================================
// } ///////  Close Class

// ignore_for_file: non_constant_identifier_names, camel_case_types, unused_field, unnecessary_string_interpolations, avoid_print, unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slug_it/slug_it.dart';

import '../../themes/firebase_functions.dart';

class categoryController {
  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;
  final CategoryController = TextEditingController();
  final SlugUrlController = TextEditingController();
  var cate_name = "";
  var slug__url = "";
  var image_logo = "";

  String? dropDownValue;
  String? StatusValue;
  String Date_at = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String PerentCate = '';
  String? downloadURL;

  /////////////  Category data fetch From Firebase   +++++++++++++++++++++++++++++++++++++++++++++

  List StoreDocs = [];
  bool progressWidget = true;
  Comman_Cate_Data(int limitData) async {
    StoreDocs = [];
    Map<dynamic, dynamic> w = {
      'table': "category",
      "orderBy": "-date_at",
      "limit": limitData
    };
    var temp = await dbFindDynamic(db, w);
    return temp;
  }

/////////////  Media Image Call   +++++++++++++++++++++++++++++++++++++++++++++
  var Storage_image_List = [];
  Future Image_data() async {
    Storage_image_List = [];
    Map<dynamic, dynamic> w = {
      'table': "window_image",
    };
    var temp = await dbFindDynamic(db, w);
    return temp;
  }

///////////    Creating SLug Url Function +++++++++++++++++++++++++++++++++++++++

///////////  Calling Category data +++++++++++++++++++++++++++
  Map<int, String> v_status = {0: "Select", 1: 'Active', 2: 'Inactive'};
  Map<String, String> Cate_Name_list = {'Select': ''};
  CateData() async {
    Map<dynamic, dynamic> w = {
      'table': 'category',
    };
    var dbData = await dbFindDynamic(db, w);
    return dbData;
  }

  ///////============================================================

/////// add Category Data  =+++++++++++++++++++
  ///

  clearText() {
    SlugUrlController.clear();
    CategoryController.clear();
    StatusValue = null;
    fileName = "";
    url_img = "";
  }

  var url_img = "";
  String fileName = "";

  ///
}///// class Close
