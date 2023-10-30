// ignore_for_file: unnecessary_string_interpolations, unused_shown_name, non_constant_identifier_names, prefer_const_constructors, unused_local_variable, avoid_print, avoid_function_literals_in_foreach_calls, unnecessary_new, prefer_collection_literals

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';

class DashboardController {
  // var db = (!kIsWeb && Platform.isWindows)
  //     ? Firestore.instance
  //     : FirebaseFirestore.instance;

  // ============================
  stock_Data_count() async {
    var tempCount = 0;
    if (!kIsWeb && Platform.isWindows) {
      var query =
          await Firestore.instance.collection('product').get().then((value) {
        return value.length;
      });
      tempCount = query;
    } else {
      var query = await FirebaseFirestore.instance
          .collection('product')
          .count()
          .get()
          .then((value) {
        return value.count;
      });
      tempCount = query;
    }
    return tempCount;
  }

////////////////

  ////////// inoive ==========================================================

  invo_Data_count() async {
    var tempCount = 0;
    if (!kIsWeb && Platform.isWindows) {
      var query =
          await Firestore.instance.collection('order').get().then((value) {
        return value.length;
      });
      tempCount = query;
    } else {
      var query = await FirebaseFirestore.instance
          .collection('order')
          .count()
          .get()
          .then((value) {
        return value.count;
      });
      tempCount = query;
    }
    return tempCount;
  }

  /////////=====================================================================

  /////////=====================================================================

  User_Data_count() async {
    var tempCount = 0;
    if (!kIsWeb && Platform.isWindows) {
      var query =
          await Firestore.instance.collection('users').get().then((value) {
        return value.length;
      });
      tempCount = query;
    } else {
      var query = await FirebaseFirestore.instance
          .collection('users')
          .count()
          .get()
          .then((value) {
        return value.count;
      });
      tempCount = query;
    }
    return tempCount;
  }

  /////////=====================================================================
  /////////  Out of Stoke ======================================================

  var tempCount = 0;
  Map<int, dynamic> Out_of_stock_Data2 = new Map();
  OutofStock_Data_count() async {
    Out_of_stock_Data2 = {};
    int k = 0;
    if (!kIsWeb && Platform.isWindows) {
      var query = await Firestore.instance
          .collection('product')
          .where("quantity", isEqualTo: "0")
          .get()
          .then((value) {
        return value.length;
      });
      tempCount = query;
    } else {
      var query = await FirebaseFirestore.instance
          .collection('product')
          .where("quantity", isEqualTo: "0")
          .get()
          .then((res) {
        for (var doc in res.docs) {
          //returnData2[doc.id] = doc.data();
          Map<String, dynamic> temp = doc.data();
          temp['id'] = doc.id;
          Out_of_stock_Data2[k] = temp;
          k++;
        }
        return Out_of_stock_Data2.length;
      });
      tempCount = query;
    }
    return tempCount;
  }

////////////////

  //////  Balance data call  +++++++++++++++++++++++++++++++++++++++++
  Balance_count() async {
    var tempCount = 0;
    if (!kIsWeb && Platform.isWindows) {
      var query = await Firestore.instance
          .collection('order')
          .where("balance")
          .get()
          .then((value) {
        return value.length;
      });
      tempCount = query;
    } else {
      var query = await FirebaseFirestore.instance
          .collection('order')
          .where("balance", isNotEqualTo: "0")
          .count()
          .get()
          .then((value) {
        return value.count;
      });
      tempCount = query;
    }
    return tempCount;
  }
}
///////
///


///
