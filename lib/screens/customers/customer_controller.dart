// ignore_for_file: unnecessary_string_interpolations, unused_shown_name, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, deprecated_colon_for_default_value, camel_case_types, unused_local_variable, unused_import

import 'package:jkm_crm_admin/themes/firebase_functions.dart';
import 'dart:io';
import 'package:firedart/firestore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import '../Invoice/pdf.dart';

class customerController {
  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;

  Map<dynamic, dynamic> listCustomerAllDataArr = new Map();
  Map<dynamic, dynamic> listCustomer = new Map();
  List<String> listCustomerName = [];
  Map<dynamic, dynamic> listOrder = new Map();
  TextEditingController searchTextController = new TextEditingController();

  List<String> headintList = [
    '#',
    'name',
    'type',
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

  init_functions(limit, {dbData: ''}) async {
    await customerList(limit);
  }

  // reset controller
  resetController() {}
  var selectedFilter = 'Customer';
  // get all Customer List =============================
  customerList(int limitData) async {
    listCustomerName = [];
    listCustomer = {};
    var dbData = await dbFindDynamic(
        db, {'table': 'customer', 'orderBy': '-date_at', "limit": limitData});

    var i = 1;
    dbData.forEach((k, data) {
      if (data['name'] != null) {
        listCustomer['$i'] = data;
        listCustomerAllDataArr['$i'] = data;
        listCustomerName.add(data['name']);
        i++;
      }
    });
    ctr_fn_search(filter: selectedFilter);
    // print("$listCustomer   ++++++++++++++++++++++");
  }

  // seach function -----------------------
  ctr_fn_search({filter: ""}) {
    var search = searchTextController.text;
    listCustomer = {};
    if (filter == "Customer") {
      for (String key in listCustomerAllDataArr.keys) {
        if (listCustomerAllDataArr[key]['type']
            .toLowerCase()
            .contains(filter.toLowerCase())) {
          listCustomer[key] = listCustomerAllDataArr[key];
        }
      }
    } else {
      //if (filter == "Supplier") {
      for (String key in listCustomerAllDataArr.keys) {
        if (listCustomerAllDataArr[key]['type']
            .toLowerCase()
            .contains(filter.toLowerCase())) {
          listCustomer[key] = listCustomerAllDataArr[key];
        }
      }
    }

    // else {
    //   for (String key in listCustomerAllDataArr.keys) {
    //     if (listCustomerAllDataArr[key]['name']
    //             .toLowerCase()
    //             .contains(search.toLowerCase()) ||
    //         listCustomerAllDataArr[key]['mobile']
    //             .toLowerCase()
    //             .contains(search.toLowerCase()) ||
    //         listCustomerAllDataArr[key]['email']
    //             .toLowerCase()
    //             .contains(search.toLowerCase())) {
    //       listCustomer[key] = listCustomerAllDataArr[key];
    //     }
    //   }
    // }
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
