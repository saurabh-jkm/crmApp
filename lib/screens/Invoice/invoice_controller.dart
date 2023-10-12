// ignore_for_file: unnecessary_string_interpolations, unused_shown_name, division_optimization
import 'dart:convert';
import 'package:crm_demo/themes/firebase_functions.dart';
import 'package:crm_demo/themes/style.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firedart/firestore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class invoiceController {
  //var db = FirebaseFirestore.instance;
  //var db = Firestore.instance;
  bool isSupplier = false;
  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;

  final formKeyInvoice = GlobalKey<FormState>();
  List<LogicalKeyboardKey> Keys = [];
  Map<dynamic, dynamic> user = new Map();

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

  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final brandController = TextEditingController();
  final invoiceDateController = TextEditingController();

  // for new attribute
  final newAttributeController = TextEditingController();

  // temporary

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
  Map<int, bool> totalIdentifire = {};

  int totalLocation = 1;
  int totalProduct = 1;
  int totalPrice = 0;
  int totalGst = 0;

  // this is for dynamice controller
  Map<String, dynamic> dynamicControllers = new Map();
  Map<String, dynamic> ListAttribute = {};
  Map<String, dynamic> ListAttributeWithId = {};
  List<String> RackList = [];
  Map<int, TextEditingController> productLocationController = new Map();
  Map<int, TextEditingController> categoryController = new Map();
  List<String> ListCategory = [];

  // init Function for all =========================================
  //================================================================
  //================================================================
  //================================================================

  init_functions({dbData: '', type: ''}) async {
    if (type == 'buy') {
      isSupplier = true;
      InvoiceType = 'Supplier';
      SaleType = 'Sale';
      await getAttributeList();
      await getRackList();
      await getCategoryList();
    }

    await _getUser();
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
    totalIdentifire[1] = false;
    ProductNameControllers[1] = TextEditingController();
    ProductQuntControllers[1] = TextEditingController();
    ProductUnitControllers[1] = TextEditingController();
    ProductPriceControllers[1] = TextEditingController();
    ProductTotalControllers[1] = TextEditingController();
    ProductGstControllers[1] = TextEditingController();
    ProductDiscountControllers[1] = TextEditingController();
    productLocationController[1] = TextEditingController();
    categoryController[1] = TextEditingController();
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

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userData = (prefs.getString('user'));
    if (userData != null) {
      user = jsonDecode(userData) as Map<dynamic, dynamic>;
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
              vl['category'] = data['category'];
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
    var dbData = await dbFindDynamic(db,
        {'table': 'customer', 'type': (isSupplier) ? 'Supplier' : 'Customer'});

    dbData.forEach((k, data) {
      if (data['name'] != null) {
        ListCustomer.add(data['name']);
        CustomerArr[data['name']] = data;
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

  // category list ============================================
  getCategoryList() async {
    ListCategory = [];
    var dbData = await dbFindDynamic(db, {'table': 'category'});
    dbData.forEach((k, data) {
      if (data['category_name'] != '') {
        ListCategory.add(data['category_name']);
      }
    });
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

  // get product details ======================================
  getProductDetails(productName) async {
    if (allProductList[productName] != null) {
      return allProductList[productName];
    } else {
      return Map();
    }
  }

  //function get supplier products details ================================
  fnGetProductDetails(productId, data) async {
    categoryController[productId]!.text = data['category'];
    productLocationController[productId]!.text = data['location'];
    ProductUnitControllers[productId]!.text = data['unit'];
    dynamicControllers['$productId'].forEach((key, value) {
      if (data[key] != null) {
        dynamicControllers['$productId'][key].text = data[key];
      }
    });
  }

  // update product quantity
  var oldSubProduct = {};
  fn_update_product_qnt(docId, i, liveData, instData) async {
    var k = i - 1;
    i = (liveData['list_item_id'] != null) ? liveData['list_item_id'] : i;
    var NewLog = {};

    var productData = (liveData['id'] == null)
        ? {}
        : await dbFind({'table': 'product', 'id': liveData['id']});

    var subProducts =
        (productData['item_list'] != null) ? productData['item_list'] : {};
    subProducts.forEach((k, v) {
      oldSubProduct[k] = v;
    });
    print(oldSubProduct);

    // if isset current product

    if (subProducts['$i'] != null && instData['$k'] != null) {
      // set all variables
      var t_ins_qnt = (instData['$k']['quantity'] == '')
          ? 0
          : int.parse(instData['$k']['quantity'].toString());
      var t_ins_unit = (instData['$k']['unit'] == '')
          ? 0
          : int.parse(instData['$k']['unit'].toString());

      // db data ================================

      var t_productdb_unit = (subProducts['$i']['unit'] != '')
          ? int.parse(subProducts['$i']['unit'].toString())
          : 0;

      var t_productdb_qnt = (productData['quantity'] == '')
          ? 0
          : int.parse(productData['quantity'].toString());

      var t_subproduct_qnt = (subProducts['$i']['quantity'] == '')
          ? 0
          : int.parse(subProducts['$i']['quantity'].toString());

      var t_productdb_totalUnit = (subProducts['$i']['totalUnit'] == '')
          ? 0
          : int.parse(subProducts['$i']['totalUnit'].toString());

      // old data ================================
      // var t_product_totalUnit = (subProducts['$i']['totalUnit'] == '')
      //     ? 0
      //     : int.parse(subProducts['$i']['totalUnit'].toString());

      // var t_product_qnt = (subProducts['$i']['quantity'] == '')
      //     ? 0
      //     : int.parse(subProducts['$i']['quantity'].toString());

      // var t_product_unit = (subProducts['$i']['unit'] == '')
      //     ? 0
      //     : int.parse(subProducts['$i']['unit'].toString());

      // update all quantity & unit
      if (t_productdb_unit == 0) {
        t_productdb_qnt = t_productdb_qnt - t_ins_qnt;
        t_subproduct_qnt = t_subproduct_qnt - t_ins_qnt;
      } else {
        if (t_ins_unit == 0 || t_ins_unit == '') {
          t_productdb_qnt = t_productdb_qnt - t_ins_qnt;
          t_subproduct_qnt = t_subproduct_qnt - t_ins_qnt;
        } else {
          t_productdb_totalUnit =
              (t_productdb_totalUnit == 0 || t_productdb_totalUnit == '')
                  ? t_productdb_qnt * t_productdb_unit
                  : t_productdb_totalUnit;

          t_productdb_totalUnit = int.parse(t_productdb_totalUnit.toString()) -
              int.parse(t_ins_unit.toString());

          int tQnt2 = (t_ins_unit / t_productdb_unit).toInt();

          t_productdb_qnt = t_productdb_qnt - tQnt2;
          t_subproduct_qnt = t_subproduct_qnt - tQnt2;
        }

        // t_ins_unit =
        //     (t_ins_unit == 0) ? t_ins_qnt * t_productdb_unit : t_ins_unit;
        // t_productdb_totalUnit = t_productdb_totalUnit - t_ins_unit;
        // int tQnt2 = (t_productdb_totalUnit / t_productdb_unit).toInt();
        // t_productdb_qnt = t_productdb_qnt - t_ins_qnt;
        // t_subproduct_qnt = t_subproduct_qnt - t_ins_qnt;
      }
      // check add or remove when update =================================
      var logType = 'Sale';
      int diffRance = 0;
      if (docId != '' && editProductQnt['$i'] != null) {
        var logUnit = 0;
        var logQnt = 0;
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
          subProducts['$i']['totalUnit'] = '0';
          logQnt = old_qnt - t_ins_qnt;
          logType = (logQnt > 1) ? 'return' : 'add_more';
          subProducts['$i']['quantity'] =
              '${int.parse(subProducts['$i']['quantity'].toString()) + logQnt}';
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
        // this is for new ==========================================
        // update product table

        if (t_productdb_unit != 0) {
          subProducts['$i']['totalUnit'] = '$t_productdb_totalUnit';
        }
        subProducts['$i']['quantity'] = '$t_subproduct_qnt';
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

      // product log =============================================
      await updateProductLog(liveData['id'], tempW, oldSubProduct,
          logType: logType);
    }

    return NewLog;
  }

// ***************************************************************
// insert product
// ***************************************************************
// ***************************************************************
// ***************************************************************
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
      "type": (isSupplier) ? "Buy" : "Sale",
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

    // all product ================================================
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
        themeAlert(context,
            "Row No. $i :  Product Name, Price, Quantity  are required!!",
            type: 'error');
        return false;
      }

      if (isSupplier && categoryController[i] == '') {
        themeAlert(context, "Row No. $i : Category Required", type: 'error');
        return false;
      } else if (isSupplier && productLocationController[i] == '') {
        themeAlert(context, "Row No. $i : Location Required", type: 'error');
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

    // update stok functions
    Future<void> updateStock(products) async {
      products.forEach((k, value) async {
        int i = int.parse(k.toString()) + 1;
        if (allProductList[ProductNameControllers[i]!.text] != null) {
          // update
          await stock_update(allProductList[ProductNameControllers[i]!.text],
              products['$k'], dynamicControllers['$i']);
        } else {
          // insert new product
          await stock_insert(
              products['$k'],
              dynamicControllers['$i'],
              categoryController[i]!.text,
              productLocationController[i]!.text,
              invoiceDateController.text);
        }
      });
    }

    if (dbArr['type'] == 'Sale') {
      await callUpdateFn();
    } else {
      // this is for Supplier Log manage ====================
      if (docId != '') {
        // when edit
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
      } else {
        // update Stock =======================================
        updateStock(products);
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
      if (isSupplier) {
        Navigator.popAndPushNamed(context, '/new_supplier_invoice');
      } else {
        Navigator.popAndPushNamed(context, '/new_invoice');
      }
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

    ListAttribute.forEach((key, value) {
      Map<String, TextEditingController> temp =
          (dynamicControllers['$totalProduct'] != null)
              ? dynamicControllers["$totalProduct"]
              : new Map();
      temp[key] = TextEditingController();
      dynamicControllers["$totalProduct"] = temp;
    });

    totalIdentifire[ctrId] = false;

    ProductNameControllers[ctrId] = TextEditingController();
    ProductPriceControllers[ctrId] = TextEditingController();
    ProductQuntControllers[ctrId] = TextEditingController();
    ProductUnitControllers[ctrId] = TextEditingController();
    ProductGstControllers[ctrId] = TextEditingController();
    ProductDiscountControllers[ctrId] = TextEditingController();
    ProductTotalControllers[ctrId] = TextEditingController();
    productLocationController[ctrId] = TextEditingController();
    categoryController[ctrId] = TextEditingController();

    ProductQuntControllers[ctrId]!.text = '1';
    ProductUnitControllers[ctrId]!.text = '0';
    ProductDiscountControllers[ctrId]!.text = '0';
    ProductGstControllers[ctrId]!.text = '0';
    ProductTotalControllers[ctrId]!.text = '0';
  }

  // remove  row
  ctrRemoveRow(context) async {
    if (totalProduct > 1) {
      totalIdentifire.remove(totalProduct);
      dynamicControllers.remove(totalProduct);
      var ctrId = totalProduct;
      ProductNameControllers.remove(ctrId);
      ProductPriceControllers.remove(ctrId);
      ProductQuntControllers.remove(ctrId);
      ProductUnitControllers.remove(ctrId);
      ProductGstControllers.remove(ctrId);
      ProductDiscountControllers.remove(ctrId);
      ProductTotalControllers.remove(ctrId);
      productLocationController.remove(ctrId);
      categoryController.remove(ctrId);
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

  // update Stock ====================================================
  // update Stock ====================================================
  // update Stock ====================================================
  stock_update(old, currentData, dynamicData) async {
    var dbArr = {
      "table": "product",
      "update_at": DateTime.now(),
    };

    // get saved data

    var rData = await dbFind({'table': 'product', 'id': '${old['id']}'});

    var listData = rData['item_list'];
    var oldSubData = {};
    var subData = (listData[old['list_item_id']] != null)
        ? listData[old['list_item_id']]
        : {};
    oldSubData['${old['list_item_id']}'] = listData[old['list_item_id']];

    var qnt = currentData['quantity'];
    var unit = (currentData['unit'] == '') ? '0' : currentData['unit'];
    var price = (currentData['price'] == '') ? '0' : currentData['price'];
    var Tunit =
        int.parse(currentData['unit'].toString()) * int.parse(qnt.toString());
    dynamicData.forEach((k, v) {
      subData['$k'] = v.text;
    });

    subData['quantity'] =
        '${int.parse(subData['quantity'].toString()) + int.parse(qnt.toString())}';
    subData['totalUnit'] =
        '${int.parse(subData['totalUnit'].toString()) + int.parse(Tunit.toString())}';
    subData['unit'] = '${unit}';
    subData['price'] = '${price}';

    rData['item_list'][old['list_item_id']] = subData;
    rData['quantity'] =
        '${(int.parse(rData['quantity'].toString()) + int.parse(qnt.toString()))}';

    rData['table'] = 'product';
    rData['id'] = '${old['id']}';
    await dbUpdate(db, rData);
    // for log variable added
    subData['qnt_added'] = qnt;
    rData['item_list'][old['list_item_id']] = subData;

    // log update ====================================================
    var logDb = await dbFindDynamic(
        db, {'table': 'product_log', 'product_id': '${old['id']}'});

    var newLog = (logDb.isNotEmpty && logDb[0]['log'] != null)
        ? logDb[0]['log'].toList()
        : [];

    rData['log_date'] = DateTime.now();
    rData['updatedBy'] = (user['id'] != null) ? user['id'] : '';
    rData['updatedByName'] = (user['name'] != null) ? user['name'] : '';
    rData['oldSubData'] = oldSubData;
    rData['changedSubData'] = subData;

    rData.remove('id');
    rData.remove('table');

    newLog.add(rData);
    var updateArr = {
      'table': 'product_log',
      'product_id': '${old['id']}',
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
  }

  // new stock add ====================================================
  // new stock add ====================================================
  // new stock add ====================================================
  stock_insert(currentData, dynamicData, cat, location, stockDate) async {
    var dbArr = {
      "table": "product",
      "name": currentData['name'],
      "category": '$cat',
      "price": currentData['price'],
      "date_at": DateTime.now(),
      "stock_date": stockDate,
      "status": true
    };

    var qnt = currentData['quantity'];
    var unit = (currentData['unit'] == '') ? '0' : currentData['unit'];
    var Tunit =
        int.parse(currentData['unit'].toString()) * int.parse(qnt.toString());

    // get saved data
    var subData = {};
    dynamicData.forEach((k, v) {
      subData['$k'] = v.text;
    });

    subData['quantity'] = '$qnt';
    subData['unit'] = '$unit';
    subData['totalUnit'] = '$Tunit';
    subData['location'] = '$location';
    subData['price'] = '${dbArr['price']}';

    var itemList = {};
    itemList['1'] = subData;
    dbArr['item_list'] = itemList;

    dbArr['quantity'] = '$qnt';
    dbArr['brand'] = (subData['brand'] == null) ? '' : subData['brand'];
    dbArr['item_location'] = {'${location}': '${dbArr['quantity']}'};

    // return false;

    var productID = await dbSave(db, dbArr);

    //log update ====================================================
    var logDb = await dbFindDynamic(
        db, {'table': 'product_log', 'product_id': '$productID}'});

    var newLog = (logDb.isNotEmpty && logDb[0]['log'] != null)
        ? logDb[0]['log'].toList()
        : [];

    dbArr['log_date'] = DateTime.now();
    dbArr['updatedBy'] = (user['id'] != null) ? user['id'] : '';
    dbArr['updatedByName'] =
        (user['name'] != null) ? "${user['name']} - Buy Invoice " : '';
    dbArr['singleLog'] = 'new Product_from_suplier_invoice';
    newLog.add(dbArr);
    var updateArr = {
      'table': 'product_log',
      'product_id': '${productID}',
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
  }

  // update product log ==========================================
  updateProductLog(docId, dbArr, oldSubProductList, {logType: 'Sale'}) async {
    var logDb = await dbFindDynamic(
        db, {'table': 'product_log', 'product_id': '$docId'});

    var newLog = (logDb.isNotEmpty && logDb[0]['log'] != null)
        ? logDb[0]['log'].toList()
        : [];

    dbArr.remove('id');
    dbArr.remove('table');
    dbArr['log_date'] = DateTime.now();
    dbArr['updatedBy'] = (user['id'] != null) ? user['id'] : '';
    dbArr['updatedByName'] =
        (user['name'] != null) ? '${user['name']} - Sale Invoice $logType' : '';
    dbArr['oldSubatDa'] = oldSubProductList;
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
  }
}
