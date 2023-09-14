// ignore_for_file: unnecessary_string_interpolations, unused_shown_name

import 'package:crm_demo/themes/firebase_functions.dart';
import 'dart:io';
import 'package:firedart/firestore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

class customerController {
  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;

  Map<dynamic, dynamic> listCustomer = new Map();
  Map<dynamic, dynamic> listOrder = new Map();

  List<String> headintList = [
    '#',
    'name',
    'email',
    'phone',
    'T. Order',
    'T. Price',
    'addresss',
    'status',
    'date',
    'Action'
  ];

  // init Function for all =========================================
  //================================================================
  //================================================================
  //================================================================

  init_functions({dbData: ''}) async {
    await customerList();
  }

  // reset controller
  resetController() {}

  // get all Customer List =============================
  customerList() async {
    listCustomer = {};
    var dbData =
        await dbFindDynamic(db, {'table': 'customer', 'orderBy': '-date_at'});
    var i = 1;
    dbData.forEach((k, data) {
      if (data['customer_name'] != null) {
        listCustomer['$i'] = data;
        i++;
      }
    });
  }

  // customer Bill Details =============================
  getOrderData() async {
    listOrder = {};
    var dbData = await dbFindDynamic(db, {'table': 'order'});
    var i = 1;
    dbData.forEach((k, data) {
      if (data['customer_name'] != null) {
        var tempAllArr = (listOrder[data['customer_id']] != null)
            ? listOrder[data['customer_id']]
            : {};
        var tempItemList =
            (tempAllArr.isNotEmpty && tempAllArr['orderList'] != null)
                ? tempAllArr['orderList']
                : [];
        tempItemList.add(data);
        tempAllArr['orderList'] = tempItemList;
        // total order number
        tempAllArr['no_of_order'] = (tempAllArr['no_of_order'] == null)
            ? 1
            : int.parse(tempAllArr['no_of_order'].toString()) + 1;
        // total order price
        tempAllArr['total_pay_order'] = (tempAllArr['total_pay_order'] == null)
            ? int.parse(data['total'].toString())
            : int.parse(tempAllArr['total_pay_order'].toString()) +
                int.parse(data['total'].toString());

        listOrder[data['customer_id']] = tempAllArr;

        i++;
      }
    });
  }
}
