// ignore_for_file: unnecessary_string_interpolations, unused_shown_name, non_constant_identifier_names, unnecessary_new, camel_case_types, prefer_collection_literals, deprecated_colon_for_default_value, avoid_function_literals_in_foreach_calls, await_only_futures, unnecessary_null_comparison, unused_local_variable, avoid_print

import 'package:crm_demo/themes/firebase_functions.dart';
import 'dart:io';
import 'dart:convert';
import 'package:firedart/firestore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../themes/style.dart';
import '../../../themes/theme_widgets.dart';
import '../../order/invoice_service.dart';

class SellerController {
  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;

  Map<dynamic, dynamic> listCustomerAllDataArr = new Map();
  Map<dynamic, dynamic> listCustomer = new Map();
  List<String> listCustomerName = [];
  Map<dynamic, dynamic> listOrder = new Map();
  TextEditingController searchTextController = new TextEditingController();
  Map<dynamic, dynamic> user = new Map();
  bool ListShow = true;
  bool secondScreen = false;
  var selectedSellerId;
  var selectedSeller;

  Map<dynamic, dynamic> imgList = {"0": ''};

  List<String> headintList = [
    '#',
    'Seller Name',
    'Panding Meeting',
    'date',
    'Action'
  ];
  List<String> MeetingheadList = [
    '#',
    'Customer Name',
    'Meeting Reason',
    'Meeting Date',
    'Status',
    'Action'
  ];
  var selected_pro = {};

  final formKeyInvoice = GlobalKey<FormState>();
  List<LogicalKeyboardKey> Keys = [];
  final Customer_nameController = TextEditingController();
  final Customer_MobileController = TextEditingController();
  final Customer_emailController = TextEditingController();
  final Customer_addressController = TextEditingController();
  final Customer_meetingConversation_Controller = TextEditingController();
  final Customer_NextFollowUp_Controller = TextEditingController();
  final Customer_TypeController = TextEditingController();
////////  changes add My Nitin Sir++++++++++++++
  final Customer_pincodeController = TextEditingController();
  final Customer_shopNoController = TextEditingController();

  var customerId = "";
/////
  String Next_date = "";
  String sellerId = "";

  List<String> ListType = ['Customer', 'Supplier'];

  List<String> ListCustomer = [];
  Map<String, dynamic> CustomerArr = {};

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userData = (prefs.getString('user'));
    if (userData != null) {
      user = jsonDecode(userData) as Map<dynamic, dynamic>;
    }
  }

  // get all Customer name List =============================
  getCustomerNameList() async {
    ListCustomer = [];
    var dbData = await dbFindDynamic(db, {'table': 'customer'});
    dbData.forEach((k, data) {
      if (data['name'] != null) {
        ListCustomer.add(data['name']);
        CustomerArr[data['name']] = data;
      }
    });
  }

//////////  ++++++++++++++++++++++++++++++++
  var MeetingMap = {};
  OrderList_data(id, limit) async {
    Map<dynamic, dynamic> w = {
      'table': "follow_up",
      'sellerId': id,
      "limit": limit,
      'orderBy': '-next_follow_up_date',
    };
    MeetingMap = await dbFindDynamic(db, w);
    return MeetingMap;
  }

///////===============================================

  /////////  if Notication seller Done Meeting =====================================================================

  Meeting_done_Notifications(salesmanIdd) async {
    var tempCount = 0;
    if (!kIsWeb && Platform.isWindows) {
      var query = await Firestore.instance
          .collection('follow_up')
          .where("sellerId", isEqualTo: "$salesmanIdd")
          .where("status", isEqualTo: true)
          .get()
          .then((value) {
        return value.length;
      });
      tempCount = query;
    } else {
      var query = await FirebaseFirestore.instance
          .collection('follow_up')
          .where("sellerId", isEqualTo: "$salesmanIdd")
          .where("status", isEqualTo: true)
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
// auto complete =================================
  autoCompleteFormInput(suggationList, label, myController,
      {padding = 10.0,
      myFocusNode = '',
      method = '',
      methodArg = '',
      strinFilter = ''}) {
    return Autocomplete(
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        controller.text = myController.text;
        return formInput(context, "$label", controller,
            editComplete: onEditingComplete,
            focusNode: (myFocusNode == '') ? focusNode : myFocusNode,
            currentController: myController,
            padding: padding);
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        } else {
          List<String> matches = <String>[];
          matches.addAll(suggationList);
          matches.retainWhere((s) {
            return s
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
          return matches;
        }
      },
      onSelected: (String selection) {
        myController.text = selection;
        // if method call
        if (method != '') {
          if (methodArg != '') {
            method(methodArg);
          } else {
            method();
          }
        }
      },
    );
  }

// insert product
// ***************************************************************

  insertInvoiceDetails(context, {docId = ''}) async {
    sellerId = selectedSellerId;
    var alert = '';
    if (Customer_nameController.text.length < 4) {
      alert = "Valid Customer Name  Required !!";
    } else if (Customer_MobileController.text == '' &&
        Customer_MobileController.text.length < 10) {
      alert = "Valid Mobile Number Required !!";
    } else if (Customer_pincodeController.text == '') {
      alert = "Valid  Pincode Required !!";
    } else if (Next_date == '') {
      alert = "Meeting Date Required !!";
    }

    if (alert != '') {
      themeAlert(context, "$alert", type: 'error');
      return false;
    }

    var customerData = {
      "table": "customer",
      "type": Customer_TypeController.text,
      "name": Customer_nameController.text,
      "mobile": Customer_MobileController.text,
      "email": Customer_emailController.text,
      "address": Customer_addressController.text,
      "Add_by": "${user['user_type']}",
      "gst_no": "",
      "date_at": DateTime.now(),
      "status": true
    };

    // default value
    var dbArr = {
      "table": "follow_up",
      "sellerId": "$selectedSellerId",
      "customer_name": Customer_nameController.text,
      "mobile": Customer_MobileController.text,
      "email": Customer_emailController.text,
      "address": Customer_addressController.text,
      "pin_code": Customer_pincodeController.text,
      "shop_no": Customer_shopNoController.text,
      "image": imgList,
      "meeting_conversation": Customer_meetingConversation_Controller.text,
      "next_follow_up_date": Next_date,
      "next_follow_up": Customer_NextFollowUp_Controller.text,
      // "customer_type": Customer_TypeController.text,
      "update_at": "",
      "date_at": DateTime.now(),
      "status": true,
      "date": Date_at
    };
    if (docId == '') {
      dbArr["date_at"] = DateTime.now();
    } else {
      dbArr["update_at"] = DateTime.now();
    }

    if (docId == '') {
      if (customerId == "" ||
          ListCustomer.contains(Customer_nameController.text) == false) {
        await dbSave(db, customerData);
      } else {
        print("");
      }
      await dbSave(db, dbArr);

      await resetController();
      await OrderList_data(selectedSellerId, 50);
      themeAlert(context, "Submitted Successfully ");
      return 'success';
      //Navigator.pop(context);
    } else {
      dbArr['id'] = docId;
      var rData = await dbUpdate(db, dbArr);

      if (rData != null) {
        await OrderList_data(selectedSellerId, 50);
        themeAlert(context, "Updated Successfully !!");
        ListShow = true;
        return 'success';
        //Navigator.pop(context);
      }
    }
  }

  // init Function for all =========================================
  //================================================================
  //================================================================
  //================================================================

  init_functions({dbData = ''}) async {
    await _getUser();
    await getCustomerNameList();

    DateTime DateNow = DateTime.now();

    // set edit value for edit page =========================================
    if (dbData != '') {
      Customer_nameController.text =
          (dbData['customer_name'] != null) ? dbData['customer_name'] : '';
      Customer_MobileController.text =
          (dbData['mobile'] != null) ? dbData['mobile'] : '';
      Customer_emailController.text =
          (dbData['email'] != null) ? dbData['email'] : '';
      Customer_addressController.text =
          (dbData['address'] != null) ? dbData['address'] : '';
      Customer_TypeController.text =
          (dbData['customer_type'] != null) ? dbData['customer_type'] : '';

      Customer_meetingConversation_Controller.text =
          (dbData['meeting_conversation'] != null)
              ? dbData['meeting_conversation']
              : "";

      Customer_NextFollowUp_Controller.text =
          (dbData['next_follow_up'] != null) ? dbData['next_follow_up'] : "";
    }
  }

  // reset controller
  resetController() {
    Customer_nameController.clear();
    Customer_MobileController.clear();
    Customer_emailController.clear();
    Customer_addressController.clear();
    Customer_meetingConversation_Controller.clear();
    Customer_NextFollowUp_Controller.clear();
    Customer_TypeController.clear();
////////  changes add My Nitin Sir++++++++++++++
    Customer_pincodeController.clear();
    Next_date = "";
    sellerId = "";
  }

  // get all Customer List =============================
  sellerList(int limitData) async {
    listCustomerName = [];
    listCustomer = {};
    Map dbData = await dbFindDynamic(
        db, {'table': 'users', 'user_type': 'Sales Man', "limit": limitData});

    var i = 1;

    if (dbData != null) {
      for (var key in dbData.keys) {
        Map<dynamic, dynamic> data = dbData[key];
        // var datar = await dbFind({'table': 'users', 'id': data['client_id']});
        var notify = await Meeting_done_Notifications(data["id"]);
        String name = "${data["first_name"]} ${data["last_name"]}";
        data["name"] = name;
        data["date_at"] = data["date_at"];
        data["id"] = data["id"];
        data["notification"] = notify;
        data[""] = listCustomer['$i'] = data;
        listCustomerAllDataArr['$i'] = data;
        listCustomerName.add("$data");
        i++;
      }
    }
  }

  // seach function -----------------------
  ctr_fn_search() {
    var search = searchTextController.text;
    listCustomer = {};
    for (String key in listCustomerAllDataArr.keys) {
      if (listCustomerAllDataArr[key]['first_name']
              .toLowerCase()
              .contains(search.toLowerCase()) ||
          listCustomerAllDataArr[key]['last_name']
              .toLowerCase()
              .contains(search.toLowerCase())) {
        listCustomer[key] = listCustomerAllDataArr[key];
      }
    }
    return 1;
  }
}/////   closs class
