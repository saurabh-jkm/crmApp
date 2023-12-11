// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_brace_in_string_interps, non_constant_identifier_names, unused_local_variable, deprecated_colon_for_default_value, unnecessary_string_interpolations

import 'package:crm_demo/screens/product/product/add_product_screen.dart';

import 'dart:convert';
import 'package:crm_demo/themes/function.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crm_demo/screens/product/product/product_widgets.dart';
import 'package:crm_demo/themes/firebase_functions.dart';
import 'package:crm_demo/themes/style.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firedart/firestore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ProductController {
  //var db = FirebaseFirestore.instance;
  //var db = Firestore.instance;

  Map<dynamic, dynamic> user = new Map();

  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;

  var productId = '';

  var formKey = GlobalKey<FormState>();
  List<LogicalKeyboardKey> Keys = [];

  var nameController = TextEditingController();
  var categoryController = TextEditingController();
  var quantityController = TextEditingController();
  var priceController = TextEditingController();
  var brandController = TextEditingController();
  var stockDateController = TextEditingController();

  // supplire detials ===========================
  var c_name_controller = TextEditingController();
  var c_phone_controller = TextEditingController();
  var c_email_controller = TextEditingController();
  var c_address_controller = TextEditingController();
  var c_gst_controller = TextEditingController();
  var invoiceDateController = TextEditingController();
  List<String> ListCustomer = [];
  Map<String, dynamic> CustomerArr = {};

  // for new attribute
  var newAttributeController = TextEditingController();

  // temporary
  Map<String, dynamic> dynamicControllers = new Map();
  String alertRow = '';

  Map<String, TextEditingController> productPriceController = new Map();
  Map<String, TextEditingController> productQntController = new Map();
  Map<String, TextEditingController> productQntNewController = new Map();
  Map<String, TextEditingController> productUnitController = new Map();
  Map<String, TextEditingController> productTotalUnitController = new Map();
  Map<String, TextEditingController> productLocationController = new Map();

  Map<String, TextEditingController> s_price_controller = new Map();
  Map<String, TextEditingController> s_subTotal_controller = new Map();

  Map<String, TextEditingController> locationControllers = new Map();
  Map<String, TextEditingController> locationQuntControllers = new Map();

  // Suggation List =====================================
  List<String> ListName = [];
  Map<dynamic, dynamic> productDbData = {};
  List<String> RackList = [];
  List<String> ListCategory = [];
  Map<String, dynamic> ListAttribute = {};
  Map<String, dynamic> ListAttributeWithId = {};
  Map<String, dynamic> editData = {};

  int totalLocation = 1;
  int totalProduct = 1;

///////// Product List   ++++++++++++++++++++++++++++++++++++++++++++++++++++++=
////////////  Product data fetch  ++++++++++++++++++++++++++++++++++++++++++++
  bool progressWidget = true;
  List finalProductList = [];
  List productList = [];
  Pro_Data(int limitData) async {
    productList = [];
    Map<dynamic, dynamic> w = {
      'table': "product",
      "orderBy": "-date_at",
      "limit": limitData
    };
    var temp = await dbFindDynamic(db, w);
    return temp;
  }

  ///  =======================================================

  //init controller ==========================================
  init_functions({data: ''}) async {
    productId = '';
    await _getUser();
    await getRackList();
    await getProductNameList();
    await getCategoryList();
    await getAttributeList();
    await default_var_set();
    await getCustomerNameList();

    DateTime DateNow = DateTime.now();
    String dateIs = DateFormat('dd/MM/yyyy').format(DateNow);
    stockDateController.text = dateIs;

    // this is for edit ===========================================
    if (data != '') {
      stockDateController.text =
          (data['stock_date'] != null && data['stock_date'] != '')
              ? data['stock_date']
              : formatDate(data['date_at'], formate: 'dd/MM/yyyy');

      editData = data;
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
        productQntNewController['$totalProduct'] = TextEditingController();
        s_price_controller['$totalProduct'] = TextEditingController();
        s_subTotal_controller['$totalProduct'] = TextEditingController();
        productUnitController['$totalProduct'] = TextEditingController();
        productTotalUnitController['$totalProduct'] = TextEditingController();
        productLocationController['$totalProduct'] = TextEditingController();

        productPriceController['$totalProduct']!.text = v['price'];
        productQntController['$totalProduct']!.text = v['quantity'];
        productUnitController['$totalProduct']!.text = v['unit'];
        productTotalUnitController['$totalProduct']!.text =
            v['totalUnit'].toString();
        productLocationController['$totalProduct']!.text = v['location'];

        productQntNewController['$totalProduct']!.text = '0';
        s_subTotal_controller['$totalProduct']!.text = '0';
        s_price_controller['$totalProduct']!.text = v['price'];
        // End product ==============================
      });
    }
  }

  default_var_set() async {
    productPriceController['1'] = TextEditingController();
    productQntController['1'] = TextEditingController();
    productQntNewController['1'] = TextEditingController();
    productUnitController['1'] = TextEditingController();
    productTotalUnitController['1'] = TextEditingController();
    productLocationController['1'] = TextEditingController();

    s_price_controller['1'] = TextEditingController();
    s_subTotal_controller['1'] = TextEditingController();

    locationControllers['1'] = TextEditingController();
    locationQuntControllers['1'] = TextEditingController();
  }

  // reset controller =====================================
  resetController() {
    productId = '';
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    categoryController = TextEditingController();
    quantityController = TextEditingController();
    priceController = TextEditingController();
    brandController = TextEditingController();

    // reset product price
    Map<String, TextEditingController> productPriceController = new Map();
    Map<String, TextEditingController> productQntController = new Map();
    Map<String, TextEditingController> productQntNewController = new Map();
    Map<String, TextEditingController> productUnitController = new Map();
    Map<String, TextEditingController> productTotalUnitController = new Map();
    Map<String, TextEditingController> productLocationController = new Map();

    Map<String, TextEditingController> s_price_controller = new Map();
    Map<String, TextEditingController> s_subTotal_controller = new Map();
    // for new attribute
    newAttributeController = TextEditingController();
    // temporary
    dynamicControllers = new Map();

    locationControllers = new Map();
    locationQuntControllers = new Map();

    // Suggation List =====================================

    productDbData = {};
    ListName = [];
    ListCategory = [];
    ListAttribute = {};
    ListAttributeWithId = {};
    totalLocation = 1;
    totalProduct = 1;

    default_var_set();
  }

  // session data================================================
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

  // get all product name List =============================
  getProductNameList() async {
    ListName = [];
    productDbData = {};
    //var dbData = await db.collection('product').get();
    var dbData = await dbFindDynamic(db, {'table': 'product'});
    dbData.forEach((k, data) {
      ListName.add(data['name']);
      productDbData[data['name']] = data;
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
      if (data['category_name'] != '') {
        ListCategory.add(data['category_name']);
      }
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
    productQntNewController['$totalProduct'] = TextEditingController();
    productUnitController['$totalProduct'] = TextEditingController();
    productTotalUnitController['$totalProduct'] = TextEditingController();
    productLocationController['$totalProduct'] = TextEditingController();

    s_price_controller['$totalProduct'] = TextEditingController();
    s_subTotal_controller['$totalProduct'] = TextEditingController();
  }

  // Remove Product
  fnRemoveProduct(context) {
    if (totalProduct > 1) {
      dynamicControllers.remove(totalProduct);
      productPriceController.remove('$totalProduct');
      productQntController.remove('$totalProduct');
      productQntNewController.remove('$totalProduct');
      productUnitController.remove('$totalProduct');
      productTotalUnitController.remove('$totalProduct');
      productLocationController.remove('$totalProduct');

      s_price_controller.remove('$totalProduct');
      s_subTotal_controller.remove('$totalProduct');

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
      "quantity": "${quantityController.text}",
      //"price": priceController.text,
      "date_at": DateTime.now(),
      "stock_date": stockDateController.text,
      "status": true
    };
    var location = {};
    // for attribute
    var itemList = {};
    alertRow = '';

    String tempTitle = '';
    int totalGst = 0;
    int intTotalQuntity = 0;
    int intTotalUnit = 0;
    int totalPrice = 0;
    Map<String, dynamic> products = new Map();

    for (var i = 1; i <= totalProduct; i++) {
      tempTitle = (tempTitle == '')
          ? nameController!.text
          : '${tempTitle}, ${nameController!.text}';
      var inv_name = nameController!.text;

      dynamicControllers['$i'].forEach((key, value) async {
        if (value.text != '') {
          // sub product add ==============================
          var tempList = (itemList['$i'] != null) ? itemList['$i'] : {};
          tempList[key.toLowerCase()] = value.text;
          tempList['price'] = productPriceController['$i']!.text;
          tempList['location'] = productLocationController['$i']!.text;
          tempList['quantity'] = productQntController['$i']!.text;
          //tempList['quantity'] = productQntNewController['$i']!.text;
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

          tempTitle = '$tempTitle - ${value!.text}';
          inv_name = '$inv_name - ${value!.text}';
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

      // invoice product list =======================
      if (productId != '') {
        var temp = new Map();
        temp['id'] = docId;
        temp['name'] = inv_name;
        temp['price'] = productPriceController['$i']!.text;
        temp['quantity'] = productQntNewController['$i']!.text;
        temp['unit'] = '0';
        temp['gst_per'] = '0';
        temp['discount'] = '0';
        temp['subtotal'] = s_subTotal_controller['$i']!.text;
        temp['gst'] = '0';
        temp['total'] = temp['subtotal'];

        totalGst += int.parse(temp['gst'].toString());
        intTotalQuntity += int.parse(temp['quantity'].toString());
        intTotalUnit += int.parse(temp['unit'].toString());
        totalPrice += int.parse(temp['total'].toString());

        products['${i - 1}'] = temp;
      }
    } // end foreach

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
      var oldData = await dbFind({'table': 'product', 'id': docId});
      dbArr['id'] = docId;
      var rData = await dbUpdate(db, dbArr);
      // save log

      if (rData != null) {
        if (productId != '') {
          var logDb = await dbFindDynamic(
              db, {'table': 'product_log', 'product_id': '$docId'});

          var newLog = (logDb.isNotEmpty && logDb[0]['log'] != null)
              ? logDb[0]['log'].toList()
              : [];

          dbArr.remove('id');
          dbArr.remove('table');
          dbArr['log_date'] = DateTime.now();
          dbArr['updatedBy'] = (user['id'] != null) ? user['id'] : '';
          dbArr['updatedByName'] = (user['name'] != null) ? user['name'] : '';
          dbArr['oldSubData'] = oldData['item_list'];
          newLog.add(dbArr);
          var updateArr = {
            'table': 'product_log',
            'product_id': '$docId',
            'log': newLog,
            'last_update': DateTime.now()
          };

          if (logDb.isNotEmpty && logDb[0]['id'] != null) {
            // update
            updateArr['id'] = logDb[0]['id'];
            await dbUpdate(db, updateArr);
          } else {
            // insert
            await dbSave(db, updateArr);
          }

          // also save in order table ============================
          var invArr = {
            "table": "order",
            "customer_name": (c_name_controller.text == '')
                ? 'Self'
                : c_name_controller.text,
            "mobile": c_phone_controller.text,
            "email": c_email_controller.text,
            "address": c_address_controller.text,
            "gst_no": c_gst_controller.text,
            "invoice_for": 'Supplier',
            "is_sale": 'Sale',
            "type": "Buy",
            "payment": '',
            "balance": '',
            "total": totalPrice,
            "invoice_date": (invoiceDateController.text == '')
                ? formatDate(DateTime.now(), formate: 'dd/MM/yyyy')
                : invoiceDateController.text,
            "date_at": DateTime.now(),
            "status": true
          };
          invArr['gst'] = totalGst;
          invArr['subtotal'] = totalPrice - totalGst;
          invArr['products'] = products;
          invArr['title'] = tempTitle;
          invArr['quantity'] = '$intTotalQuntity';
          invArr['unit'] = '$intTotalUnit';

          var rDbData = await dbSave(db, invArr);
        }

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

      // if (e.isKeyPressed(LogicalKeyboardKey.keyD) ||
      //     e.isKeyPressed(LogicalKeyboardKey.controlLeft)) {
      //   Keys.add(key);
      // }
      // // ctr + D OR C => addnewproduct
      // if (Keys.contains(LogicalKeyboardKey.controlLeft) &&
      //     (Keys.contains(LogicalKeyboardKey.keyD) ||
      //         Keys.contains(LogicalKeyboardKey.keyC))) {
      //   fnAddNewProduct(context);

      //   Keys = [];
      //   return true;
      // }
      // // ctr + R OR X => RemoveProduct
      // if (Keys.contains(LogicalKeyboardKey.controlLeft) &&
      //     (Keys.contains(LogicalKeyboardKey.keyR) ||
      //         Keys.contains(LogicalKeyboardKey.keyX))) {
      //   fnRemoveProduct(context);
      //   Keys = [];
      //   return true;
      // }
    } else {
      Keys.remove(key);
    }
  }
}
