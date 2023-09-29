// ignore_for_file: unnecessary_string_interpolations, unused_shown_name, non_constant_identifier_names, unnecessary_new, camel_case_types, prefer_collection_literals, deprecated_colon_for_default_value, avoid_function_literals_in_foreach_calls

import 'package:crm_demo/themes/firebase_functions.dart';
import 'dart:io';
import 'package:firedart/firestore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';

class trackController {
  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;

  Map<dynamic, dynamic> listCustomerAllDataArr = new Map();
  Map<dynamic, dynamic> listCustomer = new Map();
  List<String> listCustomerName = [];
  Map<dynamic, dynamic> listOrder = new Map();
  TextEditingController searchTextController = new TextEditingController();

  List<String> headintList = ['#', 'Seller Name', 'date', 'Action'];
  var selected_pro = {};
  // init Function for all =========================================
  //================================================================

  init_functions({dbData: ''}) async {
    await customerList();
  }

  // reset controller
  resetController() {}

  // get all Customer List =============================
  customerList() async {
    listCustomerName = [];
    listCustomer = {};
    var dbData = await dbFindDynamic(db, {'table': 'client_location'});

    var i = 1;
    dbData.forEach((k, data) async {
      if (data['client_id'] != null) {
        var datar = await dbFind({'table': 'users', 'id': data['client_id']});
        String name = "${datar["first_name"]} ${datar["last_name"]}";
        data["name"] = name;

        listCustomer['$i'] = data;
        listCustomerAllDataArr['$i'] = data;
        listCustomerName.add(name);
        i++;
      }
    });
  }

  // seach function -----------------------
  ctr_fn_search() {
    var search = searchTextController.text;
    listCustomer = {};
    for (String key in listCustomerAllDataArr.keys) {
      if (listCustomerAllDataArr[key]['name']
              .toLowerCase()
              .contains(search.toLowerCase()) ||
          listCustomerAllDataArr[key]['mobile']
              .toLowerCase()
              .contains(search.toLowerCase()) ||
          listCustomerAllDataArr[key]['email']
              .toLowerCase()
              .contains(search.toLowerCase())) {
        listCustomer[key] = listCustomerAllDataArr[key];
      }
    }
    return 1;
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

// controller for order==================================================
class orderController {
  TextEditingController searchTextController = new TextEditingController();
  List<dynamic> allOrder = [];
  List<dynamic> listOrder = [];

  List<String> orderHeadintList = [
    '#',
    'order Id',
    'Product',
    'discount',
    'subtotal',
    'gst',
    'total',
    'date',
    'Action'
  ];

  // set all order data in list variable
  fn_set_order(data) {
    allOrder = listOrder = data;
  }

  // seach function -----------------------
  ctr_fn_order_search() {
    var search = searchTextController.text;
    listOrder = [];
    allOrder.forEach((data) {
      if (data['title'].toLowerCase().contains(search.toLowerCase()) ||
          data['id'].toLowerCase().contains(search.toLowerCase())) {
        listOrder.add(data);
      }
    });
    return 1;
  }
}
