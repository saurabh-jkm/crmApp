import 'package:crm_demo/screens/product/product/add_product_screen.dart';
import 'package:crm_demo/screens/product/product/product_widgets.dart';
import 'package:crm_demo/themes/firebase_functions.dart';
import 'package:crm_demo/themes/style.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firedart/firestore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:intl/intl.dart';
import '../product/add_product_screen.dart';

class ProductController {
  //var db = FirebaseFirestore.instance;
  //var db = Firestore.instance;

  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;

  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var categoryController = TextEditingController();
  var quantityController = TextEditingController();
  var priceController = TextEditingController();
  var brandController = TextEditingController();
  // for new attribute
  var newAttributeController = TextEditingController();

  // temporary
  Map<String, TextEditingController> dynamicControllers = new Map();

  Map<String, TextEditingController> locationControllers = new Map();
  Map<String, TextEditingController> locationQuntControllers = new Map();

  // Suggation List =====================================
  List<String> ListName = [];
  List<String> ListCategory = [];
  Map<String, dynamic> ListAttribute = {};
  Map<String, dynamic> ListAttributeWithId = {};

  int totalLocation = 1;

  //init controller ==========================================
  init_functions() async {
    await getProductNameList();
    await getCategoryList();
    await getAttributeList();

    locationControllers['1'] = TextEditingController();
    locationQuntControllers['1'] = TextEditingController();
  }

  // reset controller =====================================
  resetController() {
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    categoryController = TextEditingController();
    quantityController = TextEditingController();
    priceController = TextEditingController();
    brandController = TextEditingController();
    // for new attribute
    newAttributeController = TextEditingController();
    // temporary
    dynamicControllers = new Map();

    locationControllers = new Map();
    locationQuntControllers = new Map();

    // Suggation List =====================================
    ListName = [];
    ListCategory = [];
    ListAttribute = {};
    ListAttributeWithId = {};
    totalLocation = 1;
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
    await insertProduct(context);
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
  insertProduct(context, {docId: ''}) async {
    var alert = '';
    if (nameController.text.length < 5) {
      alert = "Please Enter Valid Product Name";
    } else if (quantityController.text == '') {
      alert = "Quntity Required";
    } else if (categoryController.text == '') {
      alert = "Category Required";
    }

    if (alert != '') {
      themeAlert(context, "$alert", type: 'error');
      return false;
    }

    // check product already added
    var checkDB = await dbFindDynamic(
        db, {'table': 'product', 'name': nameController.text});
    if (docId == '' && (checkDB.isNotEmpty)) {
      themeAlert(context, ' "${nameController.text}" Already Added',
          type: 'error');
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
      "table": "product",
      "name": nameController.text,
      "category": categoryController.text,
      "quantity": quantityController.text,
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
      await resetController();
      await init_functions();
      themeAlert(context, "Submitted Successfully ");
      //Navigator.popAndPushNamed(context, '/add_stock');
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
