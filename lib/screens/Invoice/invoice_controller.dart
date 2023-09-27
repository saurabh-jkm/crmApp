// ignore_for_file: unnecessary_string_interpolations, unused_shown_name

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
  final Customer_TypeController = TextEditingController();
  final Customer_GstNoController = TextEditingController();

  final c_payment_controller = TextEditingController();
  final c_balance_controller = TextEditingController();

  List<String> ListType = ['Customer', 'Supplier'];
  String InvoiceType = 'Customer';

  List<String> ListSaleType = ['Sale', 'Estimate'];
  List<String> itemList = ['All', 'Sale', 'Estimate'];
  String SaleType = 'Sale';

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
  Map<int, TextEditingController> ProductUnitControllers = new Map();
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

  Map<dynamic, dynamic> readOnlyField = new Map();

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
    ProductUnitControllers[1] = TextEditingController();
    ProductPriceControllers[1] = TextEditingController();
    ProductTotalControllers[1] = TextEditingController();
    ProductGstControllers[1] = TextEditingController();
    ProductDiscountControllers[1] = TextEditingController();
    ProductQuntControllers[1]!.text = '1';
    ProductUnitControllers[1]!.text = '0';
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
      Customer_GstNoController.text =
          (dbData['gst_no'] != null) ? dbData['gst_no'] : '';
      invoiceDateController.text = (dbData['invoice_date'] != null)
          ? dbData['invoice_date']
          : DateFormat('dd/MM/yyyy').format(dbData['date_at']);

      c_payment_controller.text =
          (dbData['payment'] != null) ? dbData['payment'] : '';
      c_balance_controller.text =
          (dbData['balance'] != null) ? dbData['balance'] : '';

      InvoiceType =
          (dbData['invoice_for'] != null) ? dbData['invoice_for'] : 'Customer';
      SaleType = (dbData['is_sale'] != null) ? dbData['is_sale'] : 'Sale';

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
          ProductUnitControllers[i]!.text =
              (v != null && v['unit'] != null) ? v['unit'] : '0';
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
                    k == 'unit' ||
                    k == 'totalUnit' ||
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

  // quantity update ===========================
  upateQunatity(docId, k, v) async {
    int increaseDbQtt = 0;
    int decreaseDbQtt = 0;
    Map<String, dynamic> tempW = new Map();
    var NewLog = {};
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
          NewLog = {
            'type': 'return',
            'quantity': increaseDbQtt,
            'date_at': DateTime.now()
          };
        } else {
          decreaseDbQtt = (ctrQnt - editCurrentQnt);
          NewLog = {
            'type': 'add_more',
            'quantity': decreaseDbQtt,
            'date_at': DateTime.now()
          };
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
          // return & addition log --------------------------------
          // var temReturnLog = (tempEditListData['returnLog'] != null)
          //     ? tempEditListData['returnLog']
          //     : [];
          // temReturnLog.add(NewLog);
          // tempEditListData['returnLog'] = temReturnLog;

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
      return NewLog;
    } else {
      return '';
    }
  }

  // update product quantity
  fn_update_product_qnt(docId, i, liveData, instData) async {
    var k = i - 1;
    i = (liveData['list_item_id'] != null) ? liveData['list_item_id'] : i;
    var NewLog = {};

    var productData = (liveData['id'] == null)
        ? {}
        : await dbFind({'table': 'product', 'id': liveData['id']});
    var subProducts =
        (productData['item_list'] != null) ? productData['item_list'] : {};

    // if isset current product

    if (subProducts['$i'] != null && instData['$k'] != null) {
      // set all variables
      var t_ins_qnt = (instData['$k']['quantity'] == '')
          ? 0
          : int.parse(instData['$k']['quantity'].toString());
      var t_ins_unit = (instData['$k']['unit'] == '')
          ? 0
          : int.parse(instData['$k']['unit'].toString());
      var t_productdb_totalUnit = (subProducts['$i']['totalUnit'] == '')
          ? 0
          : int.parse(subProducts['$i']['totalUnit'].toString());

      var t_productdb_unit = (subProducts['$i']['unit'] == '')
          ? 0
          : int.parse(subProducts['$i']['unit'].toString());
      var t_productdb_qnt = (subProducts['$i']['quantity'] == '')
          ? 0
          : int.parse(subProducts['$i']['quantity'].toString());

      var t_product_qnt = (subProducts['quantity'] == '')
          ? 0
          : int.parse(productData['quantity'].toString());

      // update all quantity & unit
      if (t_productdb_unit == 0) {
        t_productdb_qnt = t_productdb_qnt - t_ins_qnt;
        t_product_qnt = t_product_qnt - t_ins_qnt;
      } else {
        t_ins_unit =
            (t_ins_unit == 0) ? t_ins_qnt * t_productdb_unit : t_ins_unit;
        t_productdb_totalUnit = t_productdb_totalUnit - t_ins_unit;
        int tQnt2 = (t_productdb_totalUnit / t_productdb_unit).toInt();
        t_product_qnt = t_product_qnt - (t_productdb_qnt - tQnt2);
      }
      // check add or remove when update
      int diffRance = 0;
      if (docId != '' && editProductQnt['$i'] != null) {
        var logUnit = 0;
        var logQnt = 0;
        var logType = 'add_more';
        var oldData = editProductQnt['$i'];

        int old_totalUnit = (oldData['unit'] != null && oldData['unit'] == '')
            ? 0
            : int.parse(oldData['unit']);
        int old_qnt = (oldData['quantity'] != null && oldData['quantity'] == '')
            ? 0
            : int.parse(oldData['quantity']);

        subProducts['$i']['totalUnit'] =
            '${t_productdb_totalUnit + t_ins_unit + (old_totalUnit - t_ins_unit)}';

        logUnit = t_ins_unit - old_totalUnit;
        logType = (logUnit < 0) ? 'return' : 'add_more';

        if (t_productdb_unit == 0) {
          subProducts['$i']['totalUnit'] =
              '${t_productdb_qnt + t_ins_qnt + (old_qnt - t_ins_qnt)}';
          logQnt = old_qnt - t_ins_qnt;
          logType = (logQnt > 1) ? 'return' : 'add_more';
        } else {
          subProducts['$i']['quantity'] =
              '${((int.parse(subProducts['$i']['totalUnit'].toString()) / t_productdb_unit).toInt())}';
        }

        NewLog = {
          'type': '${logType}',
          'quantity': '$logQnt',
          'unit': '$logUnit',
          'date_at': DateTime.now()
        };
      } else {
        // update product table
        subProducts['$i']['totalUnit'] = '$t_productdb_totalUnit';
        subProducts['$i']['quantity'] = '$t_productdb_qnt';
      }

      // total quantity count
      int totalQ = 0;
      subProducts.forEach((k, v) {
        totalQ += int.parse(v['quantity'].toString());
      });

      var tempW = {
        'table': 'product',
        'id': liveData['id'],
        'quantity': '$totalQ',
        'item_list': subProducts,
      };
      var r = await dbUpdate(db, tempW);
    }

    return NewLog;
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
    } else if (Customer_GstNoController.text.length != 0 &&
        Customer_GstNoController.text.length != 15) {
      alert = "Please Enter Valid GST Number ";
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
      "gst_no": Customer_GstNoController.text,
      "invoice_for": InvoiceType,
      "is_sale": SaleType,
      "type": (InvoiceType == 'Customer') ? "Sale" : "Buy",
      // "category": categoryController.text,
      // "quantity": quantityController.text,
      "total": totalPrice,
      "invoice_date": invoiceDateController.text,
      "payment": c_payment_controller.text,
      "balance": c_balance_controller.text,
      "status": true
    };
    if (docId == '') {
      dbArr["date_at"] = DateTime.now();
    } else {
      dbArr["update_at"] = DateTime.now();
    }

    // all product
    int intTotalQuntity = 0;
    int intTotalUnit = 0;
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
      temp['unit'] = ProductUnitControllers[i]!.text;
      temp['gst_per'] = ProductGstControllers[i]!.text;
      temp['discount'] = ProductDiscountControllers[i]!.text;
      temp['subtotal'] =
          (productDBdata[i] != null) ? productDBdata[i]['subTotal'] : '0';
      temp['gst'] = (productDBdata[i] != null) ? productDBdata[i]['gst'] : '0';
      temp['total'] = ProductTotalControllers[i]!.text;

      totalGst += (productDBdata[i] != null)
          ? int.parse(productDBdata[i]['gst'].toString())
          : 0;

      intTotalQuntity += int.parse(temp['quantity'].toString());
      intTotalUnit += int.parse(temp['unit'].toString());

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

    //product quntity calculate with product table ==============

    Future<void> callUpdateFn() async {
      for (var k in productDBdata.keys) {
        var Newlog =
            await fn_update_product_qnt(docId, k, productDBdata[k], products);

        if (Newlog.isNotEmpty) {
          var tempTotalInnerItem =
              (products['${k - 1}'] != null) ? products['${k - 1}'] : {};
          var tempLog = (tempTotalInnerItem['returnLog'] != null)
              ? tempTotalInnerItem['returnLog']
              : [];
          tempLog.add(Newlog);
          tempTotalInnerItem['returnLog'] = tempLog;
          products['${k - 1}'] = tempTotalInnerItem;
        }
      }
    }

    if (dbArr['type'] == 'Sale') {
      await callUpdateFn();
    } else {
      // this is for Supplier Log manage ====================
      if (docId != '') {
        var tempProduct = products;

        tempProduct.forEach((k, v) {
          int z = int.parse(k.toString()) + 1;

          if (editProductQnt['$z'] != null) {
            var tempTotalInnerItem =
                (products['${k}'] != null) ? products['${k}'] : {};
            var tempLog = (tempTotalInnerItem['returnLog'] != null)
                ? tempTotalInnerItem['returnLog']
                : [];
            var qnt = int.parse(editProductQnt['$z']['quantity'].toString()) -
                int.parse(v['quantity'].toString());

            var NewLog = {
              'type': '${(qnt >= 1) ? 'return' : 'add_more'}',
              'quantity': '${int.parse(qnt.toString())}',
              'date_at': DateTime.now()
            };
            tempLog.add(NewLog);
            tempTotalInnerItem['returnLog'] = tempLog;
            if (qnt != 0) {
              products['${k}'] = tempTotalInnerItem;
            }
          }
        });
      }
      // End this is for Supplier Log manage ====================
    }

    dbArr['gst'] = totalGst;
    dbArr['subtotal'] = totalPrice - totalGst;
    dbArr['products'] = products;
    dbArr['title'] = tempTitle;
    dbArr['quantity'] = '$intTotalQuntity';
    dbArr['unit'] = '$intTotalUnit';

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
        "type": InvoiceType,
        "name": Customer_nameController.text,
        "mobile": Customer_MobileController.text,
        "email": Customer_emailController.text,
        "address": Customer_AddressController.text,
        "gst_no": Customer_GstNoController.text,
        "date_at": DateTime.now(),
        "status": true
      };
      var customerId = await dbSave(db, customerData);
      dbArr["customer_id"] = customerId;
    } else {
      // update
      var customerData = {
        "table": "customer",
        "id": testDbData[0]['id'],
        "type":
            (testDbData[0]['type'] == '') ? InvoiceType : testDbData[0]['type'],
        "name": Customer_nameController.text,
        "mobile": (Customer_MobileController.text == '')
            ? testDbData[0]['mobile']
            : Customer_MobileController.text,
        "email": (Customer_emailController.text == '')
            ? testDbData[0]['email']
            : Customer_emailController.text,
        "address": Customer_AddressController.text,
        "gst_no": (Customer_GstNoController.text == '')
            ? testDbData[0]['gst_no']
            : Customer_GstNoController.text,
        "update_at": DateTime.now(),
        "status": true
      };
      await dbUpdate(db, customerData);
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
    if (ProductQuntControllers[controllerId]!.text != '' &&
        ProductQuntControllers[controllerId]!.text != '0') {
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

    if (c_payment_controller.text != '') {
      var tempAmount = int.parse(c_payment_controller.text.toString());
      c_balance_controller.text = '${totalPrice - tempAmount}';
    } else {
      c_balance_controller.text = '$totalPrice';
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
    ProductUnitControllers[ctrId] = TextEditingController();
    ProductGstControllers[ctrId] = TextEditingController();
    ProductDiscountControllers[ctrId] = TextEditingController();
    ProductTotalControllers[ctrId] = TextEditingController();

    ProductQuntControllers[ctrId]!.text = '1';
    ProductUnitControllers[ctrId]!.text = '0';
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
      ProductUnitControllers.remove(ctrId);
      ProductGstControllers.remove(ctrId);
      ProductDiscountControllers.remove(ctrId);
      ProductTotalControllers.remove(ctrId);
      productDBdata.remove(ctrId);
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
      // ctr + D OR X => addnewproduct
      if (Keys.contains(LogicalKeyboardKey.controlLeft) &&
          (Keys.contains(LogicalKeyboardKey.keyD) ||
              Keys.contains(LogicalKeyboardKey.keyX))) {
        ctrNewRow();

        Keys = [];
        return true;
      }
      // ctr + R OR Z => RemoveProduct
      if (Keys.contains(LogicalKeyboardKey.controlLeft) &&
          (Keys.contains(LogicalKeyboardKey.keyR) ||
              Keys.contains(LogicalKeyboardKey.keyZ))) {
        ctrRemoveRow(context);
        Keys = [];
        return true;
      }
    } else {
      Keys.remove(key);
    }
  }
}
