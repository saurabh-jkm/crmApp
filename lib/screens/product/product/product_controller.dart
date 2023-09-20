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
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../product/add_product_screen.dart';

class ProductController {
  //var db = FirebaseFirestore.instance;
  //var db = Firestore.instance;

  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;

  var formKey = GlobalKey<FormState>();
  List<LogicalKeyboardKey> Keys = [];

  var nameController = TextEditingController();
  var categoryController = TextEditingController();
  var quantityController = TextEditingController();
  var priceController = TextEditingController();
  var brandController = TextEditingController();
  // for new attribute
  var newAttributeController = TextEditingController();

  // temporary
  Map<String, dynamic> dynamicControllers = new Map();
  String alertRow = '';

  Map<String, TextEditingController> productPriceController = new Map();
  Map<String, TextEditingController> productQntController = new Map();
  Map<String, TextEditingController> productUnitController = new Map();
  Map<String, TextEditingController> productTotalUnitController = new Map();
  Map<String, TextEditingController> productLocationController = new Map();

  Map<String, TextEditingController> locationControllers = new Map();
  Map<String, TextEditingController> locationQuntControllers = new Map();

  // Suggation List =====================================
  List<String> ListName = [];
  List<String> RackList = [];
  List<String> ListCategory = [];
  Map<String, dynamic> ListAttribute = {};
  Map<String, dynamic> ListAttributeWithId = {};

  int totalLocation = 1;
  int totalProduct = 1;

  //init controller ==========================================
  init_functions({data: ''}) async {
    await getRackList();
    await getProductNameList();
    await getCategoryList();
    await getAttributeList();
    await default_var_set();

    // this is for edit ===========================================
    if (data != '') {
      //      documentId = widget.data['id'];
      nameController.text = data['name'];
      categoryController.text = data['category'];
      quantityController.text = data['quantity'];

      totalProduct = 0;
      await data['item_list'].forEach((i, v) {
        totalProduct++;
        // set product ==============================

        if (ListAttribute.isNotEmpty) {
          ListAttribute.forEach((key, value) {
            Map<String, TextEditingController> temp =
                (dynamicControllers['$totalProduct'] != null)
                    ? dynamicControllers["$totalProduct"]
                    : new Map();
            temp[key] = TextEditingController();
            if (v[key.toLowerCase()] != null) {
              temp[key]!.text = v[key.toLowerCase()];
            }
            dynamicControllers["$totalProduct"] = temp;
          });
        }

        productPriceController['$totalProduct'] = TextEditingController();
        productQntController['$totalProduct'] = TextEditingController();
        productUnitController['$totalProduct'] = TextEditingController();
        productTotalUnitController['$totalProduct'] = TextEditingController();
        productLocationController['$totalProduct'] = TextEditingController();

        productPriceController['$totalProduct']!.text = v['price'];
        productQntController['$totalProduct']!.text = v['quantity'];
        productUnitController['$totalProduct']!.text = v['unit'];
        productTotalUnitController['$totalProduct']!.text = v['totalUnit'];
        productLocationController['$totalProduct']!.text = v['location'];
        // End product ==============================
      });
    }
  }

  default_var_set() async {
    productPriceController['1'] = TextEditingController();
    productQntController['1'] = TextEditingController();
    productUnitController['1'] = TextEditingController();
    productTotalUnitController['1'] = TextEditingController();
    productLocationController['1'] = TextEditingController();

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

    // reset product price
    Map<String, TextEditingController> productPriceController = new Map();
    Map<String, TextEditingController> productQntController = new Map();
    Map<String, TextEditingController> productUnitController = new Map();
    Map<String, TextEditingController> productTotalUnitController = new Map();
    Map<String, TextEditingController> productLocationController = new Map();
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
    totalProduct = 1;

    default_var_set();
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

  // get all product name List =============================
  getRackList() async {
    RackList = [];
    //var dbData = await db.collection('product').get();
    var dbData = await dbFindDynamic(db, {'table': 'rack'});
    dbData.forEach((k, data) {
      RackList.add(data['name']);
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
      for (var i = 1; i <= totalProduct; i++) {
        Map<String, TextEditingController> temp =
            (dynamicControllers['$i'] != null)
                ? dynamicControllers["$i"]
                : new Map();
        temp[data['attribute_name'].toLowerCase()] = TextEditingController();
        dynamicControllers["$i"] = temp;
      }
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

  //Add New Location =============================
  fnAddNewRack(str) async {
    await getRackList();
    if (!RackList.contains(str)) {
      Map<String, dynamic> dbArr = {};
      dbArr['table'] = 'rack';
      dbArr['name'] = '$str';
      var rData = await dbSave(db, dbArr);
    }
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

  // add new product
  fnAddNewProduct(context) {
    totalProduct++;
    ListAttribute.forEach((key, value) {
      Map<String, TextEditingController> temp =
          (dynamicControllers['$totalProduct'] != null)
              ? dynamicControllers["$totalProduct"]
              : new Map();
      temp[key] = TextEditingController();
      dynamicControllers["$totalProduct"] = temp;
    });

    productPriceController['$totalProduct'] = TextEditingController();
    productQntController['$totalProduct'] = TextEditingController();
    productUnitController['$totalProduct'] = TextEditingController();
    productTotalUnitController['$totalProduct'] = TextEditingController();
    productLocationController['$totalProduct'] = TextEditingController();
  }

  // Remove Product
  fnRemoveProduct(context) {
    if (totalProduct > 1) {
      dynamicControllers.remove(totalProduct);
      productPriceController.remove('$totalProduct');
      productQntController.remove('$totalProduct');
      productUnitController.remove('$totalProduct');
      productTotalUnitController.remove('$totalProduct');
      productLocationController.remove('$totalProduct');

      totalProduct--;
    }
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
// ==========================================================
// ==========================================================
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
      //"price": priceController.text,
      "date_at": DateTime.now(),
      "status": true
    };
    var location = {};
    // for attribute
    var itemList = {};
    alertRow = '';

    for (var i = 1; i <= totalProduct; i++) {
      dynamicControllers['$i'].forEach((key, value) async {
        if (value.text != '') {
          // sub product add ==============================
          var tempList = (itemList['$i'] != null) ? itemList['$i'] : {};
          tempList[key.toLowerCase()] = value.text;
          tempList['price'] = productPriceController['$i']!.text;
          tempList['location'] = productLocationController['$i']!.text;
          tempList['quantity'] = productQntController['$i']!.text;
          tempList['unit'] = productUnitController['$i']!.text;
          tempList['totalUnit'] = productTotalUnitController['$i']!.text;
          dbArr['price'] =
              (dbArr['price'] == null) ? tempList['price'] : dbArr['price'];

          itemList['$i'] = tempList;

          dbArr[key.toLowerCase()] = (dbArr[key.toLowerCase()] == null)
              ? value.text
              : '${dbArr[key.toLowerCase()]}, ${value.text} ';
          if (!ListAttribute[key.toLowerCase()].contains(value.text)) {
            await fnUpdateAttrVal(key, value.text);
          }
        }
      });

      // check attribute is empty or not

      if (itemList['$i'] == null) {
        alertRow = '$i';
        themeAlert(context, 'Item No. $i Minimum One Atribute required',
            type: 'error');
        return false;
      } else if (productPriceController['$i']!.text == '') {
        alertRow = '$i';
        themeAlert(context, 'Item No. $i =>  Price Required ', type: 'error');
        return false;
      } else if (productQntController['$i']!.text == '') {
        alertRow = '$i';
        themeAlert(context, 'Item No. $i =>  Quantity Required ',
            type: 'error');
        return false;
      } else if (productLocationController['$i']!.text == '') {
        alertRow = '$i';
        themeAlert(context, 'Item No. $i =>  Location Required ',
            type: 'error');
        return false;
      }

      // End sub product =====================================

      // check rack
      if (productLocationController['$i'] != null &&
          productLocationController['$i'] != '' &&
          !RackList.contains(
              productLocationController['$i']!.text.toString())) {
        await fnAddNewRack(productLocationController['$i']!.text.toString());
      }
      if (productLocationController['$i'] != null &&
          productQntController['$i'] != null) {
        location[productLocationController['$i']!.text] =
            productQntController['$i']!.text;
      }
    }

    // // for address =================================

    dbArr['item_location'] = location;
    dbArr['item_list'] = itemList;

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

  // key press function
  cntrKeyPressFun(e, context) {
    final key = e.logicalKey;
    if (e is RawKeyDownEvent) {
      if (e.isKeyPressed(LogicalKeyboardKey.escape)) {
        Navigator.pop(context, 'updated');
      }

      if (e.isKeyPressed(LogicalKeyboardKey.keyD) ||
          e.isKeyPressed(LogicalKeyboardKey.controlLeft)) {
        Keys.add(key);
      }
      // ctr + D OR C => addnewproduct
      if (Keys.contains(LogicalKeyboardKey.controlLeft) &&
          (Keys.contains(LogicalKeyboardKey.keyD) ||
              Keys.contains(LogicalKeyboardKey.keyC))) {
        fnAddNewProduct(context);

        Keys = [];
        return true;
      }
      // ctr + R OR X => RemoveProduct
      if (Keys.contains(LogicalKeyboardKey.controlLeft) &&
          (Keys.contains(LogicalKeyboardKey.keyR) ||
              Keys.contains(LogicalKeyboardKey.keyX))) {
        fnRemoveProduct(context);
        Keys = [];
        return true;
      }
    } else {
      Keys.remove(key);
    }
  }
}
