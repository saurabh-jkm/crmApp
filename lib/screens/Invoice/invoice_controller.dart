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
  final invoiceDateController = TextEditingController();

  // for new attribute
  final newAttributeController = TextEditingController();

  // temporary
  Map<String, TextEditingController> dynamicControllers = new Map();

  Map<String, TextEditingController> locationControllers = new Map();
  Map<String, TextEditingController> locationQuntControllers = new Map();

  // product controllers
  Map<int, TextEditingController> ProductNameControllers = new Map();
  Map<int, TextEditingController> ProductQuntControllers = new Map();
  Map<int, TextEditingController> ProductPriceControllers = new Map();
  Map<int, TextEditingController> ProductTotalControllers = new Map();
  Map<int, TextEditingController> ProductGstControllers = new Map();
  Map<int, TextEditingController> ProductDiscountControllers = new Map();

  // Suggation List =====================================
  List<String> ListName = [];
  List<String> ListCustomer = [];
  Map<String, dynamic> CustomerArr = {};
  // List<String> ListCategory = [];
  // Map<String, dynamic> ListAttribute = {};
  // Map<String, dynamic> ListAttributeWithId = {};

  Map<dynamic, dynamic> productDBdata = {};

  int totalLocation = 1;
  int totalProduct = 1;
  int totalPrice = 0;
  int totalGst = 0;

  init_functions() async {
    await getProductNameList();
    await getCustomerNameList();
    // await getCategoryList();
    // await getAttributeList();

    DateTime DateNow = DateTime.now();
    String dateIs = DateFormat('dd/MM/yyyy').format(DateNow);

    invoiceDateController.text = dateIs;

    // locationControllers['1'] = TextEditingController();
    // locationQuntControllers['1'] = TextEditingController();

    // init default controllers
    ProductNameControllers[1] = TextEditingController();
    ProductQuntControllers[1] = TextEditingController();
    ProductPriceControllers[1] = TextEditingController();
    ProductTotalControllers[1] = TextEditingController();
    ProductGstControllers[1] = TextEditingController();
    ProductDiscountControllers[1] = TextEditingController();
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
    var dbData = await dbFindDynamic(db, {'table': 'product'});
    dbData.forEach((k, data) {
      ListName.add(data['name']);
    });
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

  // get product details ======================================
  getProductDetails(productName) async {
    var dbData =
        await dbFindDynamic(db, {'table': 'product', 'name': productName});
    if (dbData.isEmpty) {
      return Map();
    } else {
      return dbData[0];
    }
  }

  // get all product Category List =============================
  /*getCategoryList() async {
    ListCategory = [];

    // var dbData = await db.collection('category').get();
    // dbData.forEach((doc) {
    //   ListCategory.add(doc.map['category_name']);
    // });

    var dbData = await dbFindDynamic(db, {'table': 'category'});
    dbData.forEach((k, data) {
      ListCategory.add(data['category_name']);
    });
  }*/

  // get all  Attribute List =============================
  /*getAttributeList() async {
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
  */

  // Attribute Value List =============================
  /*fnUpdateAttrVal(key, value) async {
    var doc = ListAttributeWithId[key];
    var tempArr = doc['data']['value'];

    tempArr[value] = {"name": value, "status": "1"};
    var dbArr = doc['data'];
    dbArr['value'] = tempArr;

    dbArr['table'] = 'attribute';
    dbArr['id'] = doc['id'];

    await dbUpdate(db, dbArr);
  }*/

  // add attribute Funciton
  /*fnAddAttribute(context) async {
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
  }*/

// insert product ============================================
  insertInvoiceDetails(context, {docId: ''}) async {
    var alert = '';
    if (Customer_nameController.text.length < 4) {
      alert = "Valid Customer Name  Required !!";
    } else if (Customer_MobileController.text.length < 10) {
      alert = "Valid Mobile Number Required !!";
    } else if (totalProduct == 0) {
      alert = "Minimum 1 product required";
    }

    if (alert != '') {
      themeAlert(context, "$alert", type: 'error');
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
      "total": totalPrice,
      "date_at": DateTime.now(),
      "invoice_date": invoiceDateController.text,
      "status": true
    };

    // all product
    var i = 1;
    Map<String, dynamic> products = new Map();
    int totalGst = 0;
    while (i <= totalProduct) {
      var temp = new Map();
      temp['id'] = (productDBdata[i] != null) ? productDBdata[i]['id'] : '';
      temp['name'] = ProductNameControllers[i]!.text;
      temp['price'] = ProductPriceControllers[i]!.text;
      temp['quantity'] = ProductQuntControllers[i]!.text;
      temp['gst_per'] = ProductGstControllers[i]!.text;
      temp['discount'] = ProductDiscountControllers[i]!.text;
      temp['subtotal'] =
          (productDBdata[i] != null) ? productDBdata[i]['subTotal'] : '0';
      temp['gst'] = (productDBdata[i] != null) ? productDBdata[i]['gst'] : '0';
      temp['total'] = ProductTotalControllers[i]!.text;

      totalGst += (productDBdata[i] != null)
          ? int.parse(productDBdata[i]['gst'].toString())
          : 0;

      if (temp['name'] == '' ||
          temp['price'] == '' ||
          temp['quantity'] == '' ||
          temp['total'] == '') {
        themeAlert(context, "Row No. $i Some Fields are Empty!!",
            type: 'error');
        return false;
      }
      products['${i - 1}'] = temp;
      i++;
    }

    dbArr['gst'] = totalGst;
    dbArr['subtotal'] = totalPrice - totalGst;
    dbArr['products'] = products;

    // check customer already exist ====================
    var testDbData = await dbFindDynamic(
        db, {'table': 'customer', 'mobile': Customer_MobileController.text});

    if (testDbData.isEmpty) {
      // add customer also =======================
      var customerData = {
        "table": "customer",
        "name": Customer_nameController.text,
        "mobile": Customer_MobileController.text,
        "email": Customer_emailController.text,
        "address": Customer_AddressController.text,
        "date_at": DateTime.now(),
        "status": true
      };
      await dbSave(db, customerData);
    }

    if (docId == '') {
      await dbSave(db, dbArr);
      themeAlert(context, "Submitted Successfully ");
      Navigator.popAndPushNamed(context, '/new_invoice');
    } else {
      dbArr['id'] = docId;
      var rData = await dbUpdate(db, dbArr);

      if (rData != null) {
        themeAlert(context, "Updated Successfully !!");
        Navigator.pop(context, 'updated');
      }
    }
  }

  // calculate all =========================================
  ctrTotalCalculate(controllerId) async {
    String pName = ProductNameControllers[controllerId]!.text;
    ProductGstControllers[controllerId]!.text =
        (ProductGstControllers[controllerId]!.text == '')
            ? '18'
            : ProductGstControllers[controllerId]!.text;
    int gst = int.parse(ProductGstControllers[controllerId]!.text.toString());

    ProductDiscountControllers[controllerId]!.text =
        (ProductDiscountControllers[controllerId]!.text == '')
            ? '0'
            : ProductDiscountControllers[controllerId]!.text;
    int discount =
        int.parse(ProductDiscountControllers[controllerId]!.text.toString());
    // qunatity
    if (ProductQuntControllers[controllerId]!.text == '') {
      ProductQuntControllers[controllerId]!.text = '1';
    }

    int qunt = int.parse(ProductQuntControllers[controllerId]!.text);
    int price = int.parse((ProductPriceControllers[controllerId]!.text == '')
        ? 0.toString()
        : ProductPriceControllers[controllerId]!.text.toString());
    if (pName != '' && price != '' && qunt != '') {
      // calculate
      int subTotal = int.parse(((price * qunt) - discount).round().toString());
      int totalGst = int.parse((((subTotal * gst) / 100).round()).toString());
      productDBdata[controllerId]['gst'] = "$totalGst";
      productDBdata[controllerId]['subTotal'] = "$subTotal";
      int total = int.parse((subTotal + totalGst).toString());
      ProductTotalControllers[controllerId]!.text = total.toString();
    }

    ctrGrandTotal();
  }

  ctrGrandTotal() {
    // total calculate
    var i = 1;
    totalGst = 0;
    totalPrice = 0;
    while (i <= totalProduct) {
      if (ProductTotalControllers[i] != null &&
          ProductTotalControllers[i]!.text != '') {
        totalPrice += int.parse(ProductTotalControllers[i]!.text);

        totalGst += (productDBdata[i] != null)
            ? int.parse(productDBdata[i]['gst'].toString())
            : 0;
      }
      i++;
    }
  }

  // new row
  ctrNewRow(ctrId) async {
    ProductNameControllers[ctrId] = TextEditingController();
    ProductPriceControllers[ctrId] = TextEditingController();
    ProductQuntControllers[ctrId] = TextEditingController();
    ProductGstControllers[ctrId] = TextEditingController();
    ProductDiscountControllers[ctrId] = TextEditingController();
    ProductTotalControllers[ctrId] = TextEditingController();
  }

  // remove  row
  ctrRemoveRow(ctrId) async {
    ProductNameControllers.remove(ctrId);
    ProductPriceControllers.remove(ctrId);
    ProductQuntControllers.remove(ctrId);
    ProductGstControllers.remove(ctrId);
    ProductDiscountControllers.remove(ctrId);
    ProductTotalControllers.remove(ctrId);
    ctrGrandTotal();
  }
}
