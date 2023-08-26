import 'package:crm_demo/themes/firebase_functions.dart';
import 'package:crm_demo/themes/style.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firedart/firestore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

class ProductController {
  //var db = FirebaseFirestore.instance;
  var db = Firestore.instance;

  // var db = (!kIsWeb && Platform.isWindows)
  //     ? Firestore.instance
  //     : FirebaseFirestore.instance;

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final brandController = TextEditingController();

  // temporary
  Map<String, TextEditingController> dynamicControllers = new Map();

  Map<String, TextEditingController> locationControllers = new Map();
  Map<String, TextEditingController> locationQuntControllers = new Map();

  // Suggation List =====================================
  List<String> ListName = [];
  List<String> ListCategory = [];
  Map<String, dynamic> ListAttribute = {};

  init_functions() async {
    await getProductNameList();
    await getCategoryList();
    await getAttributeList();

    locationControllers['1'] = TextEditingController();
    locationQuntControllers['1'] = TextEditingController();
  }

  // reset controller
  resetController() {
    nameController.text = '';
    categoryController.text = '';
    quantityController.text = '';
    priceController.text = '';
    brandController.text = '';
  }

  // get all product name List =============================
  getProductNameList() async {
    ListName = [];
    var dbData = await db.collection('product').get();
    dbData.forEach((doc) {
      ListName.add(doc.map['name']);
    });
  }

  // get all product Category List =============================
  getCategoryList() async {
    ListCategory = [];
    var dbData = await db.collection('category').get();
    dbData.forEach((doc) {
      ListCategory.add(doc.map['category_name']);
    });
  }

  // get all  Attribute List =============================
  getAttributeList() async {
    ListAttribute = {};
    var dbData = await db.collection('attribute').get();
    dbData.forEach((doc) {
      List<String> temp = [];
      if (doc.map['value'] != null) {
        doc.map['value'].forEach((k, v) {
          temp.add(k);
        });
      }
      ListAttribute[doc.map['attribute_name'].toLowerCase()] = temp;
      dynamicControllers[doc.map['attribute_name'].toLowerCase()] =
          TextEditingController();
    });
  }

// insert product ============================================
  insertProduct(context) async {
    var alert = '';
    if (nameController.text.length < 5) {
      alert = "Please Enter Valid Product Name";
    } else if (quantityController.text == '') {
      alert = "Quntity Required";
    }

    if (alert != '') {
      themeAlert(context, "$alert", type: 'error');
      return false;
    }

    var dbCollection = await db.collection('product');

    // default value
    var dbArr = {
      "name": nameController.text,
      "category": categoryController.text,
      "quantity": quantityController.text,
      "price": priceController.text,
      "date_at": DateTime.now(),
      "status": true
    };

    // for attribute
    dynamicControllers.forEach((key, value) {
      if (value.text != '') {
        dbArr[key.toLowerCase()] = value.text;
      }
    });

    // for address =================================
    var tempLocation = {};
    locationControllers.forEach((key, value) {
      tempLocation[key] = value.text;
    });

    // location quantity
    var location = {};
    locationQuntControllers.forEach((key, value) {
      if (tempLocation[key] != null) {
        location[tempLocation[key]] = value.text;
      }
    });

    dbArr['item_location'] = location;

    return dbCollection.add(dbArr).then((value) {
      themeAlert(context, "Submitted Successfully ");
      resetController();
    }).catchError(
        (error) => themeAlert(context, 'Failed to Submit', type: "error"));
  }
}
