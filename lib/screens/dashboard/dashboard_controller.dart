// ignore_for_file: unnecessary_string_interpolations, unused_shown_name, non_constant_identifier_names, prefer_const_constructors, unused_local_variable, avoid_print, avoid_function_literals_in_foreach_calls, unnecessary_new, prefer_collection_literals, await_only_futures

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../themes/firebase_functions.dart';
import '../../themes/function.dart';

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
      tempCount = query!;
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
      tempCount = query!;
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
      tempCount = query!;
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
        // print("${Out_of_stock_Data2.length}     ++++");
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
        // value.docs.forEach((doc) {
        //   // Access data in each document
        //   print(
        //       'Document ID: ${doc.id}, Data: ${doc["balance"]}   +++++++sss++++++++++');
        // });
        return value.count;
      });
      tempCount = query!;
    }
    return tempCount;
  }

  ///
  ///
  yearBuy() async {
    var tempList = [];
    var tempCount = 0;
    var newDate = todayTimeStamp_for_query();
    var yearStartDate = yearStamp_for_query();
    var rData;

    if (!kIsWeb && Platform.isWindows) {
      var query = await Firestore.instance
          .collection('order')
          .where("date_at", isGreaterThan: yearStartDate)
          .get()
          .then((value) {
        return value.length;
      });
      tempCount = query;
    } else {
      var query = await FirebaseFirestore.instance
          .collection('order')
          .where("date_at", isGreaterThan: yearStartDate)
          .count()
          .get()
          .then((value) {
        return value.count;
      });
      tempCount = query!;
    }
    return tempCount;
  }

  ///

  totallBuy() async {
    var tempCount = 0;
    if (!kIsWeb && Platform.isWindows) {
      var query = await Firestore.instance
          .collection('order')
          .where("type", isEqualTo: "Buy")
          .get()
          .then((value) {
        return value.length;
      });
      tempCount = query;
    } else {
      var query = await FirebaseFirestore.instance
          .collection('order')
          .where("type", isEqualTo: "Buy")
          .count()
          .get()
          .then((value) {
        return value.count;
      });
      tempCount = query!;
    }
    return tempCount;
  }

///////
  ///

  todayBuy() async {
    List tempList = [];
    var newDate = await todayTimeStamp_for_query();
    var tempCount = 0;

    var query;
    if (!kIsWeb && Platform.isWindows) {
      query = await Firestore.instance
          .collection('order')
          .where("date_at", isGreaterThan: newDate);
    } else {
      query = await FirebaseFirestore.instance
          .collection('order')
          .where("date_at", isGreaterThan: newDate);
      //.where("date_at", isLessThan: dateTo);
    }

    var temp = await dbRawQuery(query);
    tempCount = temp.length;

    return tempCount;

    /*if (!kIsWeb && Platform.isWindows) {
      var query = await Firestore.instance
          .collection('order')
          //.where("type", isEqualTo: "Buy")
          .where("date_at", isGreaterThan: newDate)
          .get()
          .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              if (doc["type"] == "Buy") {
                tempList.add(doc["date_at"]);
              }
            });
            return tempList.length;
          } as FutureOr Function(List<Document> value));
      tempCount = query;
    } else {
      var query = await FirebaseFirestore.instance
          .collection('order')
          // .where("type", isEqualTo: "Buy")
          .where("date_at", isGreaterThan: newDate)
          //  .count()
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc["type"] == "Buy") {
            tempList.add(doc.data());
          }
        });

        return tempList.length;
      });

      //     .then((value) {
      //   return value.count;
      // });
      tempCount = query;
    }

    return tempCount;*/
  }

  ///

  yearSale() async {
    var tempList = [];
    var tempCount = 0;
    var newDate = todayTimeStamp_for_query();
    var yearStartDate = yearStamp_for_query();
    var rData;

    var query;
    if (!kIsWeb && Platform.isWindows) {
      query = await Firestore.instance
          .collection('order')
          .where("date_at", isGreaterThan: yearStartDate)
          .where("type", isEqualTo: "Sale");
    } else {
      query = await FirebaseFirestore.instance
          .collection('order')
          .where("date_at", isGreaterThan: yearStartDate)
          .where("type", isEqualTo: "Sale");
      //.where("date_at", isLessThan: dateTo);
    }

    var temp = await dbRawQuery(query);
    tempCount = temp.length;

    // if (!kIsWeb && Platform.isWindows) {
    //   var query = await Firestore.instance
    //       .collection('order')
    //       .where("date_at", isGreaterThan: yearStartDate)
    //       .get()
    //       .then((value) {
    //     return value.length;
    //   });
    //   tempCount = query;
    // } else {
    //   var query = await FirebaseFirestore.instance
    //       .collection('order')
    //       .where("date_at", isGreaterThan: yearStartDate),
    //       .where("type", isGreaterThan: "Sale"),
    //       .count()
    //       .get()
    //       .then((value) {
    //     return value.count;
    //   });
    //   tempCount = query;
    // }

    // if (doc["type"] == "Sale") {
    //             tempList.add(doc.data());
    //           }

    return tempCount;
  }

// ////////////////
  ///

  totalSale() async {
    var tempCount = 0;

    var query;
    if (!kIsWeb && Platform.isWindows) {
      query = await Firestore.instance
          .collection('order')
          .where("type", isEqualTo: "Sale");
    } else {
      query = await FirebaseFirestore.instance
          .collection('order')
          .where("type", isEqualTo: "Sale");
      //.where("date_at", isLessThan: dateTo);
    }

    var temp = await dbRawQuery(query);
    tempCount = temp.length;

    return tempCount;
  }

///////

  todaySale() async {
    List tempList = [];
    var newDate = await todayTimeStamp_for_query();
    var tempCount = 0;

    var query;
    if (!kIsWeb && Platform.isWindows) {
      query = await Firestore.instance
          .collection('order')
          .where("date_at", isGreaterThan: newDate);
    } else {
      query = await FirebaseFirestore.instance
          .collection('order')
          .where("date_at", isGreaterThan: newDate);
      //.where("date_at", isLessThan: dateTo);
    }

    var temp = await dbRawQuery(query);
    tempCount = temp.length;

    return tempCount;
  }
}
/// close class
