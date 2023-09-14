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
import 'package:flutter/services.dart';

class invoiceController {
  //var db = FirebaseFirestore.instance;
  //var db = Firestore.instance;

  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;

  final formKeyInvoice = GlobalKey<FormState>();
  List<LogicalKeyboardKey> Keys = [];

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
  Map<String, dynamic> productArr = {};
  List<String> ListCustomer = [];
  Map<String, dynamic> CustomerArr = {};
  Map<String, dynamic> editProductQnt = {};
  // all product
  Map<String, dynamic> allProductList = {};

  // List<String> ListCategory = [];
  // Map<String, dynamic> ListAttribute = {};
  // Map<String, dynamic> ListAttributeWithId = {};

  Map<dynamic, dynamic> productDBdata = {};

  int totalLocation = 1;
  int totalProduct = 1;
  int totalPrice = 0;
  int totalGst = 0;

  // init Function for all =========================================
  //================================================================
  //================================================================
  //================================================================

  init_functions({dbData: ''}) async {
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
    ProductQuntControllers[1]!.text = '1';
    ProductDiscountControllers[1]!.text = '0';
    ProductGstControllers[1]!.text = '0';

    // set edit value for edit page =========================================
    if (dbData != '') {
      Customer_nameController.text =
          (dbData['customer_name'] != null) ? dbData['customer_name'] : '';
      Customer_MobileController.text =
          (dbData['mobile'] != null) ? dbData['mobile'] : '';
      Customer_emailController.text =
          (dbData['email'] != null) ? dbData['email'] : '';
      Customer_AddressController.text =
          (dbData['address'] != null) ? dbData['address'] : '';
      invoiceDateController.text = (dbData['invoice_date'] != null)
          ? dbData['invoice_date']
          : DateFormat('dd/MM/yyyy').format(dbData['date_at']);

      // for products
      var i = 1;
      if (dbData['products'] != null) {
        dbData['products'].forEach((k, v) async {
          totalProduct = i;
          // initiate
          ctrNewRow(ctrNewId: i);
          // set data
          ProductNameControllers[i]!.text =
              (v != null && v['name'] != null) ? v['name'] : '';
          ProductPriceControllers[i]!.text =
              (v != null && v['price'] != null) ? v['price'] : '';
          ;
          ProductQuntControllers[i]!.text =
              (v != null && v['quantity'] != null) ? v['quantity'] : '';
          ProductGstControllers[i]!.text =
              (v != null && v['gst_per'] != null) ? v['gst_per'] : '';
          ProductDiscountControllers[i]!.text =
              (v != null && v['discount'] != null) ? v['discount'] : '';
          ProductTotalControllers[i]!.text =
              (v != null && v['total'] != null) ? v['total'] : '';

          // get product details form product table

          productDBdata[i] = (allProductList[v['name']] != null)
              ? allProductList[v['name']]
              : {};
          if (allProductList[v['name']] != null) {
            editProductQnt['$i'] = v;
          }

          // productDBdata[i] =
          //     (productArr[v['id']] != null) ? productArr[v['id']] : {};
          // print("---------------------");
          // print(productArr[v['id']]);
          // if (productArr[v['id']] != null) {
          //   editProductQnt[v['id']] = v;
          // }

          ctrTotalCalculate(i);
          i++;
        });
      }
    }
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
    allProductList = {};
    var dbData = await dbFindDynamic(db, {'table': 'product'});
    dbData.forEach((k, data) {
      if (data['quantity'] != null &&
          int.parse(data['quantity'].toString()) < 1) {
        // then not add in list
      } else {
        if (data['item_list'] != null && data['item_list'].isNotEmpty) {
          data['item_list'].forEach((i, vl) {
            var tempName = '${data['name']} -';
            if (vl.isNotEmpty) {
              vl.forEach((k, v) {
                if (v == '' ||
                    v == null ||
                    k == 'price' ||
                    k == 'quantity' ||
                    k == 'location') {
                } else {
                  tempName = '$tempName ${v}';
                }
              });
              ListName.add(tempName);
              vl['id'] = data['id'];
              vl['list_item_id'] = i;
              allProductList[tempName] = vl;
            }
          });
        }
      }
      productArr[data['id']] = data;
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
    if (allProductList[productName] != null) {
      return allProductList[productName];
    } else {
      return Map();
    }
    // var dbData =
    //     await dbFindDynamic(db, {'table': 'product', 'name': productName});
    // if (dbData.isEmpty) {
    //   return Map();
    // } else {
    //   return dbData[0];
    // }
  }

  // quantity update
  upateQunatity(docId, k, v) async {
    int increaseDbQtt = 0;
    int decreaseDbQtt = 0;
    Map<String, dynamic> tempW = new Map();
    if (v['quantity'] != null && ProductQuntControllers[k] != null) {
      if (docId != '' &&
          editProductQnt['$k'] != null &&
          (int.parse(editProductQnt['$k']['quantity'].toString()) !=
              int.parse(ProductQuntControllers[k]!.text.toString()))) {
        // variable
        int editCurrentQnt =
            int.parse(editProductQnt['$k']['quantity'].toString());
        int ctrQnt = int.parse(ProductQuntControllers[k]!.text.toString());
        if (editCurrentQnt > ctrQnt) {
          increaseDbQtt = (editCurrentQnt - ctrQnt);
        } else {
          decreaseDbQtt = (ctrQnt - editCurrentQnt);
        }
      }

      // update

      var productData = await dbFind({'table': 'product', 'id': v['id']});
      if (productData['item_list'] != null) {
        //print(productData);
        var tempListData = productData['item_list'];
        int quantity = (productData['quantity'] == null)
            ? 0
            : int.parse(productData['quantity'].toString());
        var tempEditListData = tempListData[v['list_item_id']];

        if (tempEditListData != null && tempEditListData['quantity'] != null) {
          // variable area =====================
          int tempCurentQnt = 0;

          if (docId == '') {
            tempCurentQnt =
                int.parse(ProductQuntControllers[k]!.text.toString());
          }

          tempEditListData['quantity'] =
              (int.parse(tempEditListData['quantity'].toString()) -
                      tempCurentQnt +
                      increaseDbQtt -
                      decreaseDbQtt)
                  .toString();

          quantity = (quantity - tempCurentQnt + increaseDbQtt - decreaseDbQtt);

          // update data
          tempListData[v['list_item_id']] = tempEditListData;

          tempW = {
            'table': 'product',
            'id': v['id'],
            'quantity': '$quantity',
            'item_list': tempListData,
          };
        }
      }
    }
    if (tempW.isNotEmpty) {
      var r = await dbUpdate(db, tempW);
      return r;
    } else {
      return '';
    }
  }

// ***************************************************************
// insert product
// ***************************************************************

  insertInvoiceDetails(context, {docId: ''}) async {
    var alert = '';
    if (Customer_nameController.text.length < 4) {
      alert = "Valid Customer Name  Required !!";
    } else if (Customer_MobileController.text != '' &&
        Customer_MobileController.text.length < 10) {
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
    String tempTitle = '';
    while (i <= totalProduct) {
      var temp = new Map();
      tempTitle = (tempTitle == '')
          ? ProductNameControllers[i]!.text
          : '$tempTitle, ${ProductNameControllers[i]!.text}';

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
    dbArr['title'] = tempTitle;

    //product quntity calculate with product table

    Future<void> callUpdateFn() async {
      for (var k in productDBdata.keys) {
        await upateQunatity(docId, k, productDBdata[k]);
      }
    }

    await callUpdateFn();

    // check customer already exist ====================
    var w = {'table': 'customer'};
    if (Customer_MobileController.text != '') {
      w['mobile'] = Customer_MobileController.text;
    } else {
      w['name'] = Customer_nameController.text;
    }

    var testDbData = await dbFindDynamic(db, w);

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
      var customerId = await dbSave(db, customerData);
      dbArr["customer_id"] = customerId;
    } else {
      dbArr["customer_id"] = testDbData[0]['id'];
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

    var tempGst = '0';
    if (ProductGstControllers[controllerId]!.text != '') {
      tempGst = ProductGstControllers[controllerId]!.text;
    }
    double gst = double.parse(tempGst);

    var tempDiscount = '0';
    if (ProductDiscountControllers[controllerId]!.text != '') {
      tempDiscount = ProductDiscountControllers[controllerId]!.text;
    }

    double discount = double.parse(tempDiscount);
    // qunatity
    var tempQnt = '1';
    if (ProductQuntControllers[controllerId]!.text != '') {
      tempQnt = ProductQuntControllers[controllerId]!.text;
    }

    double qunt = double.parse(tempQnt);
    double price = double.parse(
        (ProductPriceControllers[controllerId]!.text == '')
            ? 0.toString()
            : ProductPriceControllers[controllerId]!.text.toString());
    if (pName != '' && price != '' && qunt != '') {
      productDBdata[controllerId] = (productDBdata[controllerId] != null)
          ? productDBdata[controllerId]
          : {};
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
  ctrNewRow({ctrNewId = 0}) async {
    var ctrId = ctrNewId;
    if (ctrNewId == 0) {
      totalProduct++;
      ctrId = totalProduct;
    } else {
      ctrId = ctrNewId;
    }

    ProductNameControllers[ctrId] = TextEditingController();
    ProductPriceControllers[ctrId] = TextEditingController();
    ProductQuntControllers[ctrId] = TextEditingController();
    ProductGstControllers[ctrId] = TextEditingController();
    ProductDiscountControllers[ctrId] = TextEditingController();
    ProductTotalControllers[ctrId] = TextEditingController();

    ProductQuntControllers[ctrId]!.text = '1';
    ProductDiscountControllers[ctrId]!.text = '0';
    ProductGstControllers[ctrId]!.text = '0';
    ProductTotalControllers[ctrId]!.text = '0';
  }

  // remove  row
  ctrRemoveRow(context) async {
    if (totalProduct > 1) {
      var ctrId = totalProduct;
      ProductNameControllers.remove(ctrId);
      ProductPriceControllers.remove(ctrId);
      ProductQuntControllers.remove(ctrId);
      ProductGstControllers.remove(ctrId);
      ProductDiscountControllers.remove(ctrId);
      ProductTotalControllers.remove(ctrId);
      await ctrGrandTotal();
      totalProduct--;
    }
  }

  // keyboard listner
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
        ctrNewRow();

        Keys = [];
        return true;
      }
      // ctr + R OR X => RemoveProduct
      if (Keys.contains(LogicalKeyboardKey.controlLeft) &&
          (Keys.contains(LogicalKeyboardKey.keyR) ||
              Keys.contains(LogicalKeyboardKey.keyX))) {
        ctrRemoveRow(context);
        Keys = [];
        return true;
      }
    } else {
      Keys.remove(key);
    }
  }
}
