// ignore_for_file: unnecessary_string_interpolations, unused_shown_name, non_constant_identifier_names, prefer_const_constructors, unused_local_variable, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';

class DashboardController {
  // var db = (!kIsWeb && Platform.isWindows)
  //     ? Firestore.instance
  //     : FirebaseFirestore.instance;

  // ============================
  Stock_Data_count() async {
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
  /////////  Out of Stoke =====================================================================

  OutofStock_Data_count() async {
    var tempCount = 0;
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
          .count()
          .get()
          .then((value) {
        return value.count;
      });
      tempCount = query;
    }
    return tempCount;

    // List StoreDocs = [];
    // var _category = await Firestore.instance
    //     .collection('product')
    //     .where("quantity", isEqualTo: "0")
    //     .get()
    //     .then(
    //   (querySnapshot) {
    //     for (var docSnapshot in querySnapshot) {
    //       setState(() {
    //         StoreDocs.add(docSnapshot.map);
    //         Out_of_Stock_No = StoreDocs.length;
    //       });
    //     }
    //   },
    // );
    // setState(() {});
  }

////////////////

  //////  Balance data call  ++++++++++++++++++++++++++++++++++++++++++++++++++++
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
          .where("balance", isNotEqualTo: "")
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
