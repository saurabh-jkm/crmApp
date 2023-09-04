// ignore_for_file: unnecessary_string_interpolations, unused_shown_name

import 'package:crm_demo/screens/product/product/product_widgets.dart';
import 'package:crm_demo/themes/firebase_functions.dart';
import 'package:crm_demo/themes/style.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firedart/firestore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:intl/intl.dart';

class invoiceController {
  //var db = FirebaseFirestore.instance;
  //var db = Firestore.instance;

  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;

  final formKeyInvoice = GlobalKey<FormState>();

  final Customer_nameController = TextEditingController();
  final Customer_MobileController = TextEditingController();
  final Customer_emailController = TextEditingController();
  final Customer_AddressController = TextEditingController();
  final categoryController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final brandController = TextEditingController();

  // for new attribute
  final newAttributeController = TextEditingController();

  // temporary
  Map<String, TextEditingController> dynamicControllers = new Map();

  Map<String, TextEditingController> locationControllers = new Map();
  Map<String, TextEditingController> locationQuntControllers = new Map();
  Map<String, TextEditingController> ProductNameControllers = new Map();

  // Suggation List =====================================
  List<String> ListName = [];
  List<String> ListCategory = [];
  Map<String, dynamic> ListAttribute = {};
  Map<String, dynamic> ListAttributeWithId = {};

  int totalLocation = 1;

  init_functions() async {
    await getProductNameList();
    await getCategoryList();
    await getAttributeList();

    locationControllers['1'] = TextEditingController();
    ProductNameControllers['1'] = TextEditingController();
    locationQuntControllers['1'] = TextEditingController();
  }

  // reset controller
  resetController() {
    Customer_nameController.text = '';
    Customer_MobileController.text = "";
    Customer_emailController.text = "";
    Customer_AddressController.text = '';
    // categoryController.text = '';
    // quantityController.text = '';
    // priceController.text = '';
    // brandController.text = '';
  }

  // get all product name List =============================
  getProductNameList() async {
    ListName = [];
    //var dbData = await db.collection('product').get();
    var dbData = await dbFindDynamic(db, {'table': 'product'});
    dbData.forEach((k, data) {
      ListName.add(data['name']);
    });
  }

  // get all product Category List =============================
  getCategoryList() async {
    ListCategory = [];

    // var dbData = await db.collection('category').get();
    // dbData.forEach((doc) {
    //   ListCategory.add(doc.map['category_name']);
    // });

    var dbData = await dbFindDynamic(db, {'table': 'category'});
    dbData.forEach((k, data) {
      ListCategory.add(data['category_name']);
    });
  }

  // get all  Attribute List =============================
  getAttributeList() async {
    ListAttribute = {};

    var dbData = await dbFindDynamic(db, {'table': 'attribute'});
    dbData.forEach((k, data) {
      List<String> temp = [];
      if (data['value'] != null) {
        data['value'].forEach((k, v) {
          temp.add(k);
        });
      }
      ListAttribute[data['attribute_name'].toLowerCase()] = temp;

      ListAttributeWithId[data['attribute_name'].toLowerCase()] = {
        'id': data['id'],
        'data': data
      };
      dynamicControllers[data['attribute_name'].toLowerCase()] =
          TextEditingController();
    });

    // var dbData = await db.collection('attribute').get();
    // dbData.forEach((doc) {
    //   List<String> temp = [];
    //   if (doc.map['value'] != null) {
    //     doc.map['value'].forEach((k, v) {
    //       temp.add(k);
    //     });
    //   }
    //   ListAttribute[doc.map['attribute_name'].toLowerCase()] = temp;
    //   ListAttributeWithId[doc.map['attribute_name'].toLowerCase()] = {
    //     'id': doc.id,
    //     'data': doc.map
    //   };
    //   dynamicControllers[doc.map['attribute_name'].toLowerCase()] =
    //       TextEditingController();
    // });
  }

  // Attribute Value List =============================
  fnUpdateAttrVal(key, value) async {
    var doc = ListAttributeWithId[key];
    var tempArr = doc['data']['value'];

    tempArr[value] = {"name": value, "status": "1"};
    var dbArr = doc['data'];
    dbArr['value'] = tempArr;

    dbArr['table'] = 'attribute';
    dbArr['id'] = doc['id'];

    await dbUpdate(db, dbArr);
  }

  // add new category
  fnAddNewCat(parentCat, context) async {
    // add new category

    // default value
    var dbArr = {
      "table": 'category',
      "category_name": categoryController.text,
      "img": '',
      "parent_cate": (parentCat == 'Primary') ? '' : parentCat,
      "date_at": DateFormat('dd-MM-yyyy').format(DateTime.now()),
      "status": "1",
      "slug_url": categoryController.text.replaceAll(" ", "-"),
    };

    await dbSave(db, dbArr);
    await getCategoryList();
    // await insertProduct(context);
  }

  // add attribute Funciton
  fnAddAttribute(context) async {
    if (newAttributeController.text == '') {
      return false;
    }
    Navigator.of(context).pop();

    if (ListAttribute.containsKey(newAttributeController.text.toLowerCase())) {
      themeAlert(context, "${newAttributeController.text} already added",
          type: 'error');
    }

    // default value
    var dbArr = {
      "table": "attribute",
      "attribute_name": newAttributeController.text,
      "img": '',
      "date_at": DateTime.now(),
      "status": "1",
      "value": {},
    };

    await dbSave(db, dbArr);
    await getAttributeList();
  }

// insert product ============================================
  insertInvoiceDetails(context, {docId: ''}) async {
    var alert = '';
    if (Customer_nameController.text == '') {
      alert = "Customer Name  Required !!";
    }
    if (Customer_MobileController.text == '') {
      alert = "Mobile Required !!";
    } else if (categoryController.text == '') {
      alert = "Category Required";
    }

    if (alert != '') {
      themeAlert(context, "$alert", type: 'error');
      return false;
    }

    if (!ListCategory.contains(categoryController.text)) {
      addNewCategory(
          context, categoryController.text, ListCategory, fnAddNewCat,
          label: "Add New Category");
      return false;
    }

    //var dbCollection = await db.collection('product');

    // default value
    var dbArr = {
      "table": "order",
      "customer_name": Customer_nameController.text,
      "mobile": Customer_MobileController.text,
      "email": Customer_emailController.text,
      "address": Customer_AddressController.text,
      // "category": categoryController.text,
      // "quantity": quantityController.text,
      "price": priceController.text,
      "date_at": DateTime.now(),
      "status": true
    };

    // for attribute
    dynamicControllers.forEach((key, value) async {
      if (value.text != '') {
        dbArr[key.toLowerCase()] = value.text;
        if (!ListAttribute[key.toLowerCase()].contains(value.text)) {
          await fnUpdateAttrVal(key, value.text);
        }
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
      if (tempLocation[key] != '') {
        location[tempLocation[key]] = value.text;
      }
    });
    // Product Name
    var ProName = {};
    ProductNameControllers.forEach((key, value) {
      if (tempLocation[key] != '') {
        ProName[tempLocation[key]] = value.text;
      }
    });

    dbArr['item_location'] = location;

    // return false;

    // return dbCollection.add(dbArr).then((value) {
    //   themeAlert(context, "Submitted Successfully ");
    //   resetController();

    //   Navigator.popAndPushNamed(context, '/add_stock');

    //   //Navigator.pop(context, 'updated');
    // }).catchError(
    //     (error) => themeAlert(context, 'Failed to Submit', type: "error"));

    //print(dbArr);

    if (docId == '') {
      await dbSave(db, dbArr);
      themeAlert(context, "Submitted Successfully ");
      Navigator.popAndPushNamed(context, '/add_stock');
    } else {
      dbArr['id'] = docId;
      var rData = await dbUpdate(db, dbArr);

      if (rData != null) {
        themeAlert(context, "Updated Successfully !!");
        Navigator.pop(context, 'updated');
      }
    }
  }
}
