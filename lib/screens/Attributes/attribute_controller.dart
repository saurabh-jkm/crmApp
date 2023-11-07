// ignore_for_file: non_constant_identifier_names, await_only_futures, unnecessary_string_interpolations, camel_case_types

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../themes/firebase_functions.dart';
import '../../themes/style.dart';

class attributeController {
  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;
  String Date_at = DateFormat('dd-MM-yyyy' "  hh:mm").format(DateTime.now());

//////
  final AttributeController = TextEditingController();
  final Sub_AttributeController = TextEditingController();
  String? StatusValue = "Active";

/////
  /////////////  Category data fetch From Firebase   +++++++++++++++++++++++++++++++++++++++++++++
  List StoreDocs = [];
  bool progressWidget = true;
  AttributeData(int limitData) async {
    StoreDocs = [];
    Map<dynamic, dynamic> w = {
      'table': "attribute",
      "orderBy": "-date_at",
      "limit": limitData
    };
    var temp = await dbFindDynamic(db, w);
    return temp;
  }

/////// add Category Data  =+++++++++++++++++++

  Future<void> addList(context) async {
    if (!kIsWeb && Platform.isWindows) {
      var attribute = await Firestore.instance.collection('attribute');
      await _saveAttr(attribute, context);
    } else {
      var attribute = FirebaseFirestore.instance.collection('attribute');
      await _saveAttr(attribute, context);
    }
    clearText();
  }

  // save attribute
  _saveAttr(attribute, context) {
    return attribute.add({
      'attribute_name': "${AttributeController.text}",
      "value": {},
      'status': (StatusValue == 'Active') ? '1' : "2",
      "date_at": Date_at
    }).then((value) {
      themeAlert(context, "Added Successfully !!");
    }).catchError(
        (error) => themeAlert(context, 'Failed to Submit', type: "error"));
  }

//////////
  ///

  ///
  ///

  clearText() {
    AttributeController.clear();

    StatusValue = "Active";
  }
}///// class Close
