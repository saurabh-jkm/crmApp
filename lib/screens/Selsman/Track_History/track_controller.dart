// ignore_for_file: unnecessary_string_interpolations, unused_shown_name, non_constant_identifier_names, unnecessary_new, camel_case_types, prefer_collection_literals, deprecated_colon_for_default_value, avoid_function_literals_in_foreach_calls, await_only_futures, unused_local_variable

import 'package:crm_demo/themes/firebase_functions.dart';
import 'dart:io';
import 'package:firedart/firestore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class trackController {
  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;

  Map<dynamic, dynamic> listCustomerAllDataArr = new Map();
  Map<dynamic, dynamic> listCustomer = new Map();
  List<String> listCustomerName = [];
  Map<dynamic, dynamic> listOrder = new Map();
  TextEditingController searchTextController = new TextEditingController();

  List headintList = ['#', 'Seller', 'Distance', 'date', 'Action'];
  var selected_pro = {};
  /////// distance Calculate controller ++++++++++++++++++++++++++++++++++++++++
  var distance;
  var tempLocation = [];
  List loc = [];
  ///////////////////==========================================================
  // init Function for all =========================================
  //================================================================

  init_functions(LimitData, {dbData: ''}) async {
    await customerList(LimitData);
  }

  // reset controller
  resetController() {}

  // get all Customer List =============================
  var name = "";
  Future customerList(int Limit) async {
    listCustomerName = [];
    listCustomer = {};
    var dbData =
        await dbFindDynamic(db, {'table': 'client_location', 'orderBy':'-date', "limit": Limit});

    
   

    var i = 1;
    //dbData.forEach((k, data) async {
      for(var k in  dbData.keys){
      var data = dbData[k];
      if (data['client_id'] != null) {
        var datar = await dbFind({'table': 'users', 'id': data['client_id']});
        name = "${datar["first_name"]} ${datar["last_name"]}";
        var Loc_point = data["location_points"];
        data["location_points"] = Loc_point;
        data["name"] = name;
        listCustomer['$i'] = data;
        listCustomerAllDataArr['$i'] = data;
        listCustomerName.add(name);
        //print('++++++++++++++++++++++++++++++++++++++++++++++++++++');
        i++;
      }
    };

     //print(listCustomer);
  }

  /////// distance Calculate fun ++++++++++++++++++++++++++++++++++++++++

  Future<double> calculateDistance(
      double lat1, double lon1, double lat2, double lon2) async {
    double distanceInMeters =
        await Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
    double distanceInKm =
        distanceInMeters / 1000; // Convert meters to kilometers

    return distanceInKm;
  }
/////// =====================================================================

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
