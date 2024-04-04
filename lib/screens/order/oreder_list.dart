// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_final_fields, prefer_collection_literals, unused_field, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, deprecated_member_use, unnecessary_null_comparison, unnecessary_new, sort_child_properties_last, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unnecessary_string_interpolations, unused_local_variable, prefer_is_empty, body_might_complete_normally_nullable, sized_box_for_whitespace, sized_box_for_whitespace, sized_box_for_whitespace, unnecessary_brace_in_string_interps, deprecated_colon_for_default_value, duplicate_ignore, depend_on_referenced_packages, unused_element

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jkm_crm_admin/screens/order/syncPdf.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/firebase_functions.dart';
import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';
import '../dashboard/components/header.dart';
import '../dashboard/components/my_fields.dart';
import '../dashboard/components/recent_files.dart';
import '../dashboard/components/storage_details.dart';
import 'package:file_picker/file_picker.dart';

import '../inventry/qr_code.dart';
import 'invoice_service.dart';
import 'dart:ui' as ui;

class OrderList extends StatefulWidget {
  const OrderList({super.key});
  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  GlobalKey globalKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final Buyer_name_Controller = TextEditingController();
  final Buyer_Mobile_Controller = TextEditingController();
  final Buyer_Email_Controller = TextEditingController();
  final Buyer_Address_Controller = TextEditingController();
  String _StatusValue = "";
  String _PerentCate = '';
  String Date_at = DateFormat('dd-MM-yyyy').format(DateTime.now());
  ///////////////////////////////////////////////////////////////////////////
  // final PdfInvoiceService service = PdfInvoiceService(title: "Saurabh Yadav");
  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    if (kIsWeb) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFview_Web_mobile(BytesCode: byteList),
        ),
      );
    } else {
      // final output = await getTemporaryDirectory();
      // var filePath = "${output.path}/$fileName.pdf";
      // final file = File(filePath);
      // await file.writeAsBytes(byteList);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFview_Web_mobile(BytesCode: byteList),
        ),
      );
    }
  }

  // // new order =====================================================
  // _newOrder() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => orderNewSreen(),
  //     ),
  //   );
  // }

  /// ===============================================================
  // get user data
///////////  Calling Category data +++++++++++++++++++++++++++
  ///
  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;
  Map<int, String> v_status = {1: 'Active', 2: 'Inactive'};
  Map<String, String> Cate_Name_list = {'Select': ''};
  _CateData() async {
    Map<dynamic, dynamic> w = {
      'table': 'category',
      //'status':'1',
    };

    // var dbData = await dbFindDynamic(db, w);
    var dbData = (!kIsWeb && Platform.isWindows)
        ? await All_dbFindDynamic(db, w)
        : await dbFindDynamic(db, w);
    dbData.forEach((k, v) {
      Cate_Name_list[v['category_name']] = v['category_name'];
    });
    // print("$Cate_Name_list  +++++++++++++++++++++");
  }
  ///////============================================================

////////////////////  add list   ++++++++++++++++++++++++++++++++++++++++++++++
  List<dynamic> Submit_subProductBox = [];
  addList() async {
    //var arrData = new Map();
    var alert = '';

    Map<dynamic, dynamic> itemField = {};
    //  int totalItem = 0;
    var featureImg = '';
    _controllers.forEach((k, val) {
      var tempVar = _controllers['$k']?.text;
      var temp = k.split("___");
      var key = temp[0];
      var field = temp[1];
      var tempData = (itemField[key] == null) ? {} : itemField[key];

      // totalItem = (tempVar != ''  //&& Submit_subProductBox.contains(key)
      //     )
      //     ? totalItem + int.parse(tempVar.toString())
      //     : totalItem;

      alert = (tempVar == null)
          ? 'Please Enter valid ${field.toUpperCase()}'
          : alert;

      tempData[field] = tempVar;

      if (tempVar != ''
          //Submit_subProductBox.contains(key)
          ) {
        itemField[key] = tempData;
      }
    });

    if (alert != '') {
      themeAlert(context, alert, type: 'error');
      return false;
    }
    Map<String, dynamic> w = {};
    w = {
      'table': "order",
      "buyer_name": "${Buyer_name_Controller.text}",
      "buyer_mobile": "${Buyer_Mobile_Controller.text}",
      "buyer_email": "${Buyer_Email_Controller.text}",
      "buyer_address": "${Buyer_Address_Controller.text}",
      "price_details": itemField,
      "status": (_StatusValue == "Active")
          ? "1"
          : (_StatusValue == "Inactive")
              ? "2"
              : "",
      'category': "$_PerentCate",
      "date_at": "$Date_at",
    };
    (!kIsWeb && Platform.isWindows)
        ? await win_dbSave(db, w)
        : await dbSave(db, w);
    themeAlert(context, "Successfully Uploaded");
    setState(() {
      clearText();
      Add_New_Order = false;
    });
  }

///////////////////////// Order List Data fetch fn ++++++++++++++++++++++++++++

  List OrderList = [];
  OrderList_data() async {
    OrderList = [];
    Map<dynamic, dynamic> w = {
      'table': "order",
    };
    var temp = (!kIsWeb && Platform.isWindows)
        ? await All_dbFindDynamic(db, w)
        : await dbFindDynamic(db, w);
    setState(() async {
      temp.forEach((k, v) {
        OrderList.add(v);
      });

      _CateData();
      Pro_Data_Drop();
      progressWidget = false;
    });
  }
////////////////////////////////////////========================================

////////////////////////  Data Get for Update++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Map<String, dynamic>? update_order_data;
  Future Update_initial(id) async {
    Map<dynamic, dynamic> w = {'table': "order", 'id': id};
    var dbData = await dbFind(w);
    if (dbData != null) {
      setState(() {
        _PerentCate = dbData!['category'];
        _StatusValue = (dbData!['status'] == "1")
            ? "Active"
            : (dbData!['status'] == "2")
                ? "Inactive"
                : "";
        Buyer_name_Controller.text = dbData!['buyer_name'];
        Buyer_Mobile_Controller.text = dbData!['buyer_mobile'];
        Buyer_Email_Controller.text = dbData!['buyer_email'];
        Buyer_Address_Controller.text = dbData!['buyer_address'];

        _controllers = new Map();
        dbData['price_details'].forEach((k, v) {
          v.forEach((ke, vl) {
            var key = "${k}___$ke";

            if (ke == 'img') {
              _itemCtr[key] = vl;
            } else {
              _controllers[key] = TextEditingController();
              _controllers[key]?.text = vl;
            }
          });
        });

        // print("$dbData   +++++++++");
      });
    }
  }

  ///////  Update Order Submit  ++++++++++++++++++++++

  Object updatelist(id) {
    CollectionReference _order = FirebaseFirestore.instance.collection('order');
    var alert = '';
    Map<dynamic, dynamic> itemField = {};
    //  int totalItem = 0;
    var featureImg = '';
    _controllers.forEach((k, val) {
      var tempVar = _controllers['$k']?.text;
      var temp = k.split("___");
      var key = temp[0];
      var field = temp[1];
      var tempData = (itemField[key] == null) ? {} : itemField[key];

      // totalItem = (tempVar != ''  //&& Submit_subProductBox.contains(key)
      //     )
      //     ? totalItem + int.parse(tempVar.toString())
      //     : totalItem;

      alert = (tempVar == null)
          ? 'Please Enter valid ${field.toUpperCase()}'
          : alert;

      tempData[field] = tempVar;

      if (tempVar != ''
          //Submit_subProductBox.contains(key)
          ) {
        itemField[key] = tempData;
      }
    });

    if (alert != '') {
      themeAlert(context, alert, type: 'error');
      return false;
    }

    return _order.doc(id).update({
      'buyer_name': Buyer_name_Controller.text,
      'category': _PerentCate,
      'buyer_mobile': Buyer_Mobile_Controller.text,
      'buyer_email': Buyer_Email_Controller.text,
      'buyer_address': Buyer_Address_Controller.text,
      "price_details": itemField,
      'status': (_StatusValue == "Active")
          ? "1"
          : (_StatusValue == "Inactive")
              ? "2"
              : "0",
      "date_at": "$Date_at"
    }).then((value) {
      themeAlert(context, "Successfully Update");
      setState(() {
        _Update_wd = false;
        Order_details = 1;
        OrderList_data();
      });
    }).catchError(
        (error) => themeAlert(context, 'Failed to update', type: "error"));
  }

  Object Win_updatelist(id) {
    var _order = Firestore.instance.collection('order');
    var alert = '';
    Map<dynamic, dynamic> itemField = {};
    //  int totalItem = 0;
    var featureImg = '';
    _controllers.forEach((k, val) {
      var tempVar = _controllers['$k']?.text;
      var temp = k.split("___");
      var key = temp[0];
      var field = temp[1];
      var tempData = (itemField[key] == null) ? {} : itemField[key];

      // totalItem = (tempVar != ''  //&& Submit_subProductBox.contains(key)
      //     )
      //     ? totalItem + int.parse(tempVar.toString())
      //     : totalItem;

      alert = (tempVar == null)
          ? 'Please Enter valid ${field.toUpperCase()}'
          : alert;

      tempData[field] = tempVar;

      if (tempVar != ''
          //Submit_subProductBox.contains(key)
          ) {
        itemField[key] = tempData;
      }
    });

    if (alert != '') {
      themeAlert(context, alert, type: 'error');
      return false;
    }

    return _order.document(id).update({
      'buyer_name': Buyer_name_Controller.text,
      'category': _PerentCate,
      'buyer_mobile': Buyer_Mobile_Controller.text,
      'buyer_email': Buyer_Email_Controller.text,
      'buyer_address': Buyer_Address_Controller.text,
      "price_details": itemField,
      'status': (_StatusValue == "Active")
          ? "1"
          : (_StatusValue == "Inactive")
              ? "2"
              : "0",
      "date_at": "$Date_at"
    }).then((value) {
      themeAlert(context, "Successfully Update");
      setState(() {
        _Update_wd = false;
        Order_details = 1;
        OrderList_data();
      });
    }).catchError(
        (error) => themeAlert(context, 'Failed to update', type: "error"));
  }
/////////////////////////////////////////===========================================\\
/////////  Product List data For Dropdown Value     ++++++++++

  List<String>? foodListSearch;
  final FocusNode _textFocusNode = FocusNode();
  TextEditingController? _textEditingController = TextEditingController();
  ////////////  Product data fetch  ++++++++++++++++++++++++++++++++++++++++++++
  List<String> foodList = [];
  List productList = [];
  Pro_Data_Drop() async {
    productList = [];
    Map<dynamic, dynamic> w = {
      'table': "product",
    };
    var temp = (!kIsWeb && Platform.isWindows)
        ? await All_dbFindDynamic(db, w)
        : await dbFindDynamic(db, w);
    setState(() {
      temp.forEach((k, v) {
        productList.add(v);
      });
      for (var i = 0; i < productList.length; i++) {
        foodList.add(productList[i]["name"]);
      }
      // print("${foodList}  ++++++++++++++");
    });
  }

/////////////======== ========= ========== ============

///////////++++++++++++++++++++++++++++++++++++++++++
  clearText() {
    Buyer_name_Controller.clear();
    Buyer_Mobile_Controller.clear();
    Buyer_Email_Controller.clear();
    Buyer_Address_Controller.clear();
    _controllers.clear();
    _StatusValue = '';
    _PerentCate = "";
  }
////////////////////////================================

  @override
  void initState() {
    super.initState();
    OrderList_data();
  }

  bool progressWidget = true;
//// end user fun
  @override
  Widget build(BuildContext context) {
    return (progressWidget == true)
        ? Center(child: pleaseWait(context))
        : Scaffold(
            body: Container(
            child: ListView(
              children: [
                Header(
                  title: "Order",
                ),
                SizedBox(height: defaultPadding),
                (_Details_wd == false)
                    ? (Add_New_Order != true)
                        ? (_Update_wd != true)
                            ? listList(context)
                            : Update_Order(context, "Edit", _Order_ID)
                        : Add_newOredr(context, "Add")
                    : Details_view(context, priceData)
              ],
            ),
          ));
    // });
  }

//////// ///////////////////////////////// @1  List  of Order       ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  bool Add_New_Order = false;
  var _number_select = 10;
  bool _Details_wd = false;
  Widget listList(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius:
        //     const BorderRadius.all(Radius.circular(10)),
      ),
      child: ListView(
        children: [
          HeadLine(
              context, Icons.inventory_outlined, "Order List", "Add / Edit",
              () {
            setState(() {
              Add_New_Order = true;
              clearText();
            });
          }, buttonColor: Colors.blue, iconColor: Colors.black),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: secondaryColor,
            ),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    color: Theme.of(context).secondaryHeaderColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Orders List",
                              style: themeTextStyle(
                                  fw: FontWeight.bold,
                                  color: Colors.white,
                                  size: 15),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Show",
                                  style: themeTextStyle(
                                      fw: FontWeight.normal,
                                      color: Colors.white,
                                      size: 15),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  padding: EdgeInsets.all(2),
                                  height: 20,
                                  color: Colors.white,
                                  child: DropdownButton<int>(
                                    dropdownColor: Colors.white,
                                    iconEnabledColor: Colors.black,
                                    hint: Text(
                                      "$_number_select",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                    value: _number_select,
                                    items:
                                        <int>[10, 25, 50, 100].map((int value) {
                                      return new DropdownMenuItem<int>(
                                        value: value,
                                        child: new Text(
                                          value.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newVal) {
                                      setState(() {
                                        _number_select = newVal!;
                                      });
                                    },
                                    underline: SizedBox(),
                                  ),
                                ),
                                Text(
                                  "entries",
                                  style: themeTextStyle(
                                      fw: FontWeight.normal,
                                      color: Colors.white,
                                      size: 15),
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: SearchField())
                      ],
                    )),
                SizedBox(
                  height: 5,
                ),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder(
                    horizontalInside: BorderSide(width: .5, color: Colors.grey),
                  ),
                  children: [
                    (Responsive.isMobile(context))
                        ? TableRow(
                            decoration: BoxDecoration(
                                color: Theme.of(context).secondaryHeaderColor),
                            children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Order List",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                ),
                              ])
                        :
                        //S.No.	OrderId	User	Product	Price	Payment Status	Delivery Status	Payment Date	Actions
                        TableRow(
                            decoration: BoxDecoration(
                                color: Theme.of(context).secondaryHeaderColor),
                            children: [
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text('S.No.',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    )),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text('OrderId',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    width: 40,
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Buyer Name",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text('Category',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Product Name",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Quantity",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Price",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Status",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                // TableCell(
                                //   verticalAlignment:
                                //       TableCellVerticalAlignment.middle,
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(5.0),
                                //     child: Text("Delivery Status",
                                //         style: TextStyle(
                                //             fontWeight: FontWeight.bold)),
                                //   ),
                                // ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Order Date",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Action",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ]),
                    for (var index = 0; index < OrderList.length; index++)
                      (Responsive.isMobile(context))
                          ? tableRowWidget_mobile(
                              OrderList[index]['id'],
                              OrderList[index]['buyer_name'],
                              OrderList[index]['category'],
                              (OrderList[index]['status'] == "1")
                                  ? "Active"
                                  : (OrderList[index]['status'] == "2")
                                      ? "Inactive"
                                      : "",
                              OrderList[index]['date_at'],
                              OrderList[index]['buyer_mobile'],
                              OrderList[index]['buyer_email'],
                              OrderList[index]['buyer_address'],
                              OrderList[index]['price_details'],
                            )
                          : tableRowWidget(
                              "${index + 1}",
                              OrderList[index]['id'],
                              OrderList[index]['buyer_name'],
                              OrderList[index]['category'],
                              OrderList[index]['buyer_name'],
                              (OrderList[index]['status'] == "1")
                                  ? "Success"
                                  : (OrderList[index]['status'] == "2")
                                      ? "Inactive"
                                      : "",
                              OrderList[index]['date_at'],
                              OrderList[index]['buyer_mobile'],
                              OrderList[index]['buyer_email'],
                              OrderList[index]['buyer_address'],
                              OrderList[index]['price_details'],
                            )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  price_de(price_details) {
    var prrr = {};
    var ffff = price_details as Map;
    var ff = new Map();
    if (ffff.isNotEmpty) {
      if (ffff.isNotEmpty) {
        ffff.forEach((k, v) {
          v.forEach((ke, vl) {
            var key = "${k}___$ke";
            ff[key];
            ff[key] = vl;
          });
        });
      }
    }
    setState(() {
      prrr["price"] = "${ff["Product No. 1___price"]}.00 rs";
      prrr["quantity"] = "${ffff.length}";
      prrr["Pro_name"] = "${ff["Product No. 1___product_name"]}";
      prrr["Pro_gst"] = "${ff["Product No. 1___gst"]}";
      prrr["Pro_total_price"] = "${ff["Product No. 1___total_price"]}.00 rs";
    });
    // int i = index as int;
    return prrr;
  }

  TableRow tableRowWidget(
      String index,
      odID,
      user,
      _product,
      _price,
      pro_status, //del_status,
      pay_date,
      buyer_mobile,
      buyer_email,
      buyer_address,
      price_details) {
//////// Product Detailll ++++++++++++++++++++++
    var pricett = price_de(price_details);
//////////////////// ++++++++++++++++++++++++++++++++++++++++++++++
    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(index,
              style: GoogleFonts.alike(
                  fontWeight: FontWeight.normal, fontSize: 11)),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text("$odID",
              style: GoogleFonts.alike(
                  fontWeight: FontWeight.normal, fontSize: 11)),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text('$user',
              style: GoogleFonts.alike(
                  fontWeight: FontWeight.normal, fontSize: 11)),
        ),
      ),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text("$_product",
              style: GoogleFonts.alike(
                  fontWeight: FontWeight.normal, fontSize: 11))),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text("${pricett["Pro_name"]}",
              style: GoogleFonts.alike(
                  fontWeight: FontWeight.normal, fontSize: 11))),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text("${pricett["quantity"]}",
              textAlign: TextAlign.center,
              style: GoogleFonts.alike(
                  fontWeight: FontWeight.normal, fontSize: 11))),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text("${pricett["price"]}",
              style: GoogleFonts.alike(
                  fontWeight: FontWeight.normal, fontSize: 11))),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              margin: EdgeInsets.only(right: 20),
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: (pro_status == "Success")
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Text("$pro_status",
                  style: GoogleFonts.alike(
                      color:
                          (pro_status == "Success") ? Colors.green : Colors.red,
                      fontSize: 12.5))),
        ),
      ),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text("$pay_date",
              style: GoogleFonts.alike(color: Colors.white, fontSize: 12.5))),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: RowFor_Mobile_web(
          context,
          () async {
            // print("Tedj    +++++++888++++");
            final data = await PdfInvoiceService(
              orderID: "$odID",
              category: "$_product",
              oderDate: "$pay_date",
              buyername: "$user",
              BuyerMobile: "$buyer_mobile",
              BuyerEmail: "$buyer_email",
              BuyerAddress: "$buyer_address",
              PriceDetail: price_details,
            ).createInvoice();
            // final data = await service.createInvoice();
            savePdfFile("invoice", data);
          },
          () {
            setState(() {
              _Details_wd = true;
              priceData["order_id"] = "$odID";
              priceData["oder_Date"] = "$pay_date";
              priceData["buyer_name"] = "$user";
              priceData["buyer_mobile"] = "$buyer_mobile";
              priceData["buyer_address"] = "$buyer_address";
              priceData["buyer_email"] = "$buyer_email";
              priceData["Pro_name"] = "${pricett["Pro_name"]}";
              priceData["Pro_quantity"] = "${pricett["quantity"]}";
              priceData["Pro_price"] = "${pricett["price"]}";
              priceData["Pro_gst"] = "${pricett["Pro_gst"]}";
              priceData["total_price"] = "${pricett["Pro_total_price"]}";

              priceData["product_details"] = price_details;
            });
          },
          () {
            setState(() {
              _Update_wd = true;
              _Order_ID = odID;
              Update_initial(odID);
            });
          },
        ),
      ),
    ]);
  }

/////////////   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  TableRow tableRowWidget_mobile(String odID, user, _product, pro_status,
      pay_date, buyer_mobile, buyer_email, buyer_address, price_details) {
    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // S.No.	OrderId	User	Product	Price	Payment Status	Delivery Status	Payment Date	Actions
                  themeListRow(context, "OrderId", odID),
                  themeListRow(context, "Buyer Name", "$user"),
                  themeListRow(context, "Product Category", "$_product"),
                  themeListRow(context, "Status", "$pro_status"),
                  themeListRow(context, "Order Date", "$pay_date"),
                  Row(
                    children: [
                      SizedBox(
                        width: 100.0,
                        child: Text(
                          "Action",
                          style: themeTextStyle(
                              size: 12.0,
                              color: Colors.white,
                              ftFamily: 'ms',
                              fw: FontWeight.bold),
                        ),
                      ),
                      Text(
                        ": ",
                        overflow: TextOverflow.ellipsis,
                        style: themeTextStyle(
                            size: 14,
                            color: Colors.white,
                            ftFamily: 'ms',
                            fw: FontWeight.normal),
                      ),
                      RowFor_Mobile_web(context, () {
                        setState(() async {
                          final data = await PdfInvoiceService(
                            orderID: "$odID",
                            category: "$_product",
                            oderDate: "$pay_date",
                            buyername: "$user",
                            BuyerMobile: "$buyer_mobile",
                            BuyerEmail: "$buyer_email",
                            BuyerAddress: "$buyer_address",
                            PriceDetail: price_details,
                          ).createInvoice();
                          savePdfFile("invoice", data);
                          // // final data = await service.createInvoice();
                          // savePdfFile("invoice", data);
                        });
                      }, () {
                        setState(() async {
                          _Details_wd = true;
                        });
                      }, () {
                        setState(() async {
                          _Update_wd = true;
                          _Order_ID = odID;
                          Update_initial(odID);
                        });
                      })
                    ],
                  ),
                  Divider(
                    thickness: 2,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }
  /////////================================================================

/////////////////////////////////////  Row GOt Action Button  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ///

  Widget RowFor_Mobile_web(
      BuildContext context, _invoice, _details_view, _Update) {
    return Padding(
        padding: EdgeInsets.only(
          bottom: 1.0,
        ),
        child: Row(
          children: [
            Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: IconButton(
                    onPressed: _invoice,
                    icon: Icon(
                      Icons.download,
                      color: Colors.green,
                      size: 15,
                    ))),
            SizedBox(width: 5),
            Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: IconButton(
                    onPressed: _details_view,
                    icon: Icon(
                      Icons.find_in_page_outlined,
                      color: Colors.blue,
                      size: 15,
                    ))),
            SizedBox(width: 5),
            Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: IconButton(
                    onPressed: _Update,
                    icon: Icon(
                      Icons.edit,
                      color: Colors.yellow,
                      size: 15,
                    ))),
          ],
        ));
  }

/////////////////////////////////////////////=====================================================

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////// @2 Detaials View ++++++++++++++++++++++++++++++++++++++++++++
  var priceData = {};
  Widget Details_view(BuildContext context, priceData) {
    var ffff = priceData["product_details"] as Map;
    var ff = new Map();
    if (ffff.isNotEmpty) {
      if (ffff.isNotEmpty) {
        ffff.forEach((k, v) {
          v.forEach((ke, vl) {
            var key = "${k}___$ke";
            ff[key];
            ff[key] = vl;
          });
        });
      }
    }

    // for (var i = 1; i <= ffff.length; i++) {
    //   print("${i} ${ff["Product No. ${i}___product_name"]}  ++++hhhhh++++");
    // }

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius:
        //     const BorderRadius.all(Radius.circular(10)),
      ),
      child: ListView(
        children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _Details_wd = false;
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.arrow_back, color: Colors.blue, size: 25),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Order Details',
                      style: themeTextStyle(
                          size: 18.0,
                          ftFamily: 'ms',
                          fw: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ],
                ),
              )),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(thickness: 4, color: Colors.blue)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black12,
                // borderRadius:
                //     const BorderRadius.all(Radius.circular(10)),
              ),
              child: (priceData == null)
                  ? Center(child: CircularProgressIndicator())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.shopping_bag_rounded,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Order Details",
                                    style: GoogleFonts.alike(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              themeListRow(context, "Product Name",
                                  "${priceData["Pro_name"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              themeListRow(context, "Order ID",
                                  "${priceData["order_id"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              themeListRow(
                                  context, "Price", "${priceData["Pro_price"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              themeListRow(context, "Quantity",
                                  "${priceData["Pro_quantity"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              themeListRow(
                                  context, "GST", "${priceData["Pro_gst"]} %",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              themeListRow(context, "Total",
                                  "${priceData["total_price"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_history,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Shipping Details",
                                    style: GoogleFonts.alike(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              themeListRow(context, "Customer",
                                  "${priceData["buyer_name"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              themeListRow(context, "Mobile No.",
                                  "${priceData["buyer_mobile"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              themeListRow(context, "Email Id",
                                  "${priceData["buyer_email"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              themeListRow(context, "Address",
                                  "${priceData["buyer_address"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                            ]),
                      ],
                    ))
        ],
      ),
    );
  }

///////////////////////////////// @3 New Order Add  ++++++++++++++++++++++++++++++++++++++++++++++++++++

  Widget Add_newOredr(BuildContext context, sub_text) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius:
        //     const BorderRadius.all(Radius.circular(10)),
      ),
      child: ListView(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      Add_New_Order = false;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.blue, size: 25),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Order',
                        style: themeTextStyle(
                            size: 18.0,
                            ftFamily: 'ms',
                            fw: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '$sub_text',
                        style: themeTextStyle(
                            size: 12.0,
                            ftFamily: 'ms',
                            fw: FontWeight.normal,
                            color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  wd_buyer_details(context),
                  SizedBox(height: 20.0),
                  Divider(
                    thickness: 1.5,
                    color: Colors.black12,
                  ),
                  wd_add_product(context),
                  SizedBox(height: 20.0),
                  Divider(
                    thickness: 1.5,
                    color: Colors.black12,
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      themeButton3(context, () {
                        setState(() {
                          clearText();
                        });
                      }, label: "Reset", buttonColor: Colors.black),
                      SizedBox(
                        width: 10,
                      ),
                      themeButton3(context, () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            addList();
                          });
                        } else {
                          themeAlert(context, 'Image value required!',
                              type: "error");
                        }
                      }, buttonColor: Colors.green, label: "Submit"),
                    ],
                  ),
                  SizedBox(height: 20.0),
                ],
              ))
        ],
      ),
    );
  }
///////////////////
//  @3a buyer details ======================================================

  Widget wd_buyer_details(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.blue,
                size: 30,
              ),
              SizedBox(width: 10),
              Text("Buyer Details",
                  style: GoogleFonts.alike(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Buyer's Name*",
                              style: GoogleFonts.alike(
                                fontSize: 15,
                                color: Colors.black,
                              )),
                          Text_field(context, Buyer_name_Controller,
                              "Buyer Name", "Enter Buyer Name"),
                        ],
                      )),
                      // SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context))
                        SizedBox(width: defaultPadding),
                      if (Responsive.isMobile(context))
                        Container(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Status",
                                style: GoogleFonts.alike(
                                  fontSize: 15,
                                  color: Colors.black,
                                )),
                            Container(
                              height: 40,
                              margin: EdgeInsets.only(
                                  top: 10, bottom: 10, right: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: DropdownButton(
                                dropdownColor: Colors.white,
                                hint: _StatusValue == null
                                    ? Text(
                                        'Select',
                                        style: TextStyle(color: Colors.black),
                                      )
                                    : Text(
                                        _StatusValue,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 1, 0, 0)),
                                      ),
                                isExpanded: true,
                                underline: Container(),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                                iconSize: 35,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 1, 7, 7)),
                                items: ['Select', 'Inactive', 'Active'].map(
                                  (val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text(val),
                                    );
                                  },
                                ).toList(),
                                onChanged: (val) {
                                  setState(
                                    () {
                                      _StatusValue = val!;
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        )),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Status",
                            style: GoogleFonts.alike(
                              fontSize: 15,
                              color: Colors.black,
                            )),
                        Container(
                          height: 40,
                          margin:
                              EdgeInsets.only(top: 10, bottom: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: DropdownButton(
                            dropdownColor: Colors.white,
                            hint: _StatusValue == null
                                ? Text(
                                    'Select',
                                    style: TextStyle(color: Colors.black),
                                  )
                                : Text(
                                    _StatusValue,
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 1, 0, 0)),
                                  ),
                            isExpanded: true,
                            underline: Container(),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            iconSize: 35,
                            style:
                                TextStyle(color: Color.fromARGB(255, 1, 7, 7)),
                            items: ['Select', 'Inactive', 'Active'].map(
                              (val) {
                                return DropdownMenuItem<String>(
                                  value: val,
                                  child: Text(val),
                                );
                              },
                            ).toList(),
                            onChanged: (val) {
                              setState(
                                () {
                                  _StatusValue = val!;
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    )),
                  ),
              ],
            ),
          ),

          //////  Email and Mobile  ++++++++++++++
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Mobile No.",
                            style: GoogleFonts.alike(
                              fontSize: 15,
                              color: Colors.black,
                            )),
                        Text_field(context, Buyer_Mobile_Controller,
                            "Mobile Number", "Enter Mobile Number"),
                      ],
                    )),
                    if (Responsive.isMobile(context))
                      SizedBox(width: defaultPadding),
                    if (Responsive.isMobile(context))
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email Id",
                              style: GoogleFonts.alike(
                                fontSize: 15,
                                color: Colors.black,
                              )),
                          Text_field(context, Buyer_Email_Controller, "Email",
                              "Enter Email Id"),
                        ],
                      ))
                  ],
                ),
              ),
              if (!Responsive.isMobile(context))
                SizedBox(width: defaultPadding),
              if (!Responsive.isMobile(context))
                Expanded(
                    flex: 2,
                    child: Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email Id",
                            style: GoogleFonts.alike(
                              fontSize: 15,
                              color: Colors.black,
                            )),
                        Text_field(context, Buyer_Email_Controller, "Email",
                            "Enter Email Id"),
                      ],
                    ))),
            ],
          ),

          ///
          // dropdown
          SizedBox(height: 10.0),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Address",
                            style: GoogleFonts.alike(
                              fontSize: 15,
                              color: Colors.black,
                            )),
                        Text_field(context, Buyer_Address_Controller, "Address",
                            "Enter Address"),
                      ],
                    )),
                    if (Responsive.isMobile(context))
                      SizedBox(width: defaultPadding),
                    if (Responsive.isMobile(context))
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Product's Category",
                              style: GoogleFonts.alike(
                                fontSize: 15,
                                color: Colors.black,
                              )),
                          Container(
                            height: 40,
                            margin:
                                EdgeInsets.only(top: 10, bottom: 10, right: 10),
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton(
                              dropdownColor: Colors.white,
                              value: _PerentCate,
                              underline: SizedBox(),
                              isExpanded: true,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                              iconSize: 35,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 5, 8, 10)),
                              items: [
                                for (MapEntry<String, String> e
                                    in Cate_Name_list.entries)
                                  DropdownMenuItem(
                                    value: e.value,
                                    child: Text(e.key),
                                  ),
                              ],
                              onChanged: (val) {
                                setState(
                                  () {
                                    _PerentCate = val!;
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      )),
                  ],
                ),
              ),
              if (!Responsive.isMobile(context))
                SizedBox(width: defaultPadding),
              if (!Responsive.isMobile(context))
                Expanded(
                  flex: 2,
                  child: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Product's Category",
                          style: GoogleFonts.alike(
                            fontSize: 15,
                            color: Colors.black,
                          )),
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton(
                          dropdownColor: Colors.white,
                          value: _PerentCate,
                          underline: SizedBox(),
                          isExpanded: true,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                          iconSize: 35,
                          style:
                              TextStyle(color: Color.fromARGB(255, 5, 8, 10)),
                          items: [
                            for (MapEntry<String, String> e
                                in Cate_Name_list.entries)
                              DropdownMenuItem(
                                value: e.value,
                                child: Text(e.key),
                              ),
                          ],
                          onChanged: (val) {
                            setState(
                              () {
                                _PerentCate = val!;
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )),
                ),
            ],
          ),
        ],
      ),
    );
  }

//  @3b Add Product Cib ======================================================
  int Order_details = 1;
  Widget wd_add_product(BuildContext context) {
    return Container(
      //decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_bag,
                size: 30,
                color: Colors.blue,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Add Product Details",
                  style: GoogleFonts.alike(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          ),
          // dropdown
          SizedBox(height: 10.0),
          // wd_added_product_list(context),
          // SizedBox(height: 10.0),
          for (var i = 0; i < Order_details; i++)
            wd_sub_product_details(context, "Product No. ${i + 1}"),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          // primary: Colors.amber // Background color
                          ),
                      onPressed: () {
                        setState(() {
                          Order_details++;
                        });
                      },
                      child: Text(
                        "+",
                        style: GoogleFonts.alike(fontSize: 30),
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                (Order_details != 1)
                    ? Container(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                // primary: Colors.red, // Background color
                                ),
                            onPressed: () {
                              setState(() {
                                Order_details--;
                              });
                            },
                            child: Text("-",
                                style: GoogleFonts.alike(fontSize: 30))),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }

  // }

//////////////    @3c Product details_++++++++++++++++++++++++++++++++++++++++++

///////////// this is for  Featured Product   +++++++++++++++++++++++++++++++++++++++
  bool show_drop_list = false;
  Map<dynamic, dynamic> _itemCtr = {};
  Widget wd_sub_product_details(BuildContext context, title) {
    var itemNo = title;
    // print("$itemNo   +++++++++++++++++++++++++++");
    var tempType = itemNo;
    var tempData = (_itemCtr[tempType] != null) ? _itemCtr[tempType] : {};
    return Container(
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
        padding: EdgeInsets.symmetric(horizontal: 3.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(228, 182, 222, 248),
          border:
              Border.all(width: 1.0, color: Color.fromARGB(255, 187, 187, 187)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
            margin: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: themeBG2),
            child: Text(
              "$title",
              style: GoogleFonts.alike(fontWeight: FontWeight.normal),
            ),
          ),
          Divider(
            thickness: 1.5,
            color: Colors.black26,
          ),
          SizedBox(height: 10),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Product*",
                    style: GoogleFonts.alike(
                      fontSize: 15,
                      color: Colors.black,
                    )),
                Drowpdow_wd(context, "product_name", itemNo),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Quantity*",
                              style: GoogleFonts.alike(
                                fontSize: 15,
                                color: Colors.black,
                              )),
                          wd_input_field(
                              context, 'Enter Quantity', 'quantity', itemNo),
                        ],
                      )),
                    ),
                    SizedBox(width: defaultPadding),
                    Expanded(
                      flex: 2,
                      child: Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Price*",
                              style: GoogleFonts.alike(
                                fontSize: 15,
                                color: Colors.black,
                              )),
                          wd_input_field(
                              context, 'Enter Price', 'price', itemNo),
                        ],
                      )),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(width: defaultPadding),
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 2,
                        child: Container(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("GST*",
                                style: GoogleFonts.alike(
                                  fontSize: 15,
                                  color: Colors.black,
                                )),
                            wd_input_field(context, 'GST', 'gst', itemNo),
                          ],
                        )),
                      ),
                    if (!Responsive.isMobile(context))
                      SizedBox(width: defaultPadding),
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 2,
                        child: Container(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Discount (%)",
                                style: GoogleFonts.alike(
                                  fontSize: 15,
                                  color: Colors.black,
                                )),
                            wd_input_field(
                                context, 'Enter Discount', 'discount', itemNo),
                          ],
                        )),
                      ),
                    if (!Responsive.isMobile(context))
                      SizedBox(width: defaultPadding),
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 2,
                        child: Container(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total",
                                style: GoogleFonts.alike(
                                  fontSize: 15,
                                  color: Colors.black,
                                )),
                            wd_input_field(
                                context, 'Total', 'total_price', itemNo),
                          ],
                        )),
                      ),
                  ],
                ),
                if (Responsive.isMobile(context))
                  SizedBox(height: defaultPadding),
                if (Responsive.isMobile(context))
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("GST",
                                style: GoogleFonts.alike(
                                  fontSize: 15,
                                  color: Colors.black,
                                )),
                            wd_input_field(context, 'GST', 'gst', itemNo),
                          ],
                        )),
                      ),
                      SizedBox(width: defaultPadding),
                      Expanded(
                        flex: 2,
                        child: Container(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Discount",
                                style: GoogleFonts.alike(
                                  fontSize: 15,
                                  color: Colors.black,
                                )),
                            wd_input_field(
                                context, 'Discount', 'discount', itemNo),
                          ],
                        )),
                      ),
                      if (Responsive.isMobile(context))
                        SizedBox(width: defaultPadding),
                      if (Responsive.isMobile(context))
                        Expanded(
                          flex: 2,
                          child: Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total",
                                  style: GoogleFonts.alike(
                                    fontSize: 15,
                                    color: Colors.black,
                                  )),
                              wd_input_field(
                                  context, 'Total', 'total_price', itemNo),
                            ],
                          )),
                        ),
                    ],
                  ),
              ],
            ),
          )
        ]));
  }

  ////////////// Search drop down

  Widget Drowpdow_wd(BuildContext context, ctrName, conName) {
    conName = conName;
    var key = "${conName}___${ctrName}";

    var tempStr =
        (_controllers[key]?.text != null) ? _controllers[key]?.text : '';

    _controllers[key] = TextEditingController();
    _controllers[key]?.text = tempStr.toString();

    // for cursor show in input field at last
    int stringLength = (tempStr == null) ? 0 : tempStr.length;
    _controllers[key]?.selection =
        TextSelection.collapsed(offset: stringLength);

    ///

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            style: TextStyle(color: Colors.black),
            controller: _controllers[key],

            /// _textEditingController,
            focusNode: _textFocusNode,
            cursorColor: Colors.black,
            decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: 'Product search here',
                hintStyle: TextStyle(color: Colors.black38)
                // contentPadding: EdgeInsets.all(8)
                ),

            onChanged: (value) {
              /////++
              setState(() {
                if (show_drop_list == false &&
                    _controllers[key]!.text.isNotEmpty) {
                  show_drop_list = true;
                }

                foodListSearch = foodList
                    .where((element) => element.contains(value.toLowerCase()))
                    .toList();
                if (_controllers[key]!.text.isNotEmpty &&
                    foodListSearch!.length == 0) {
                  // print('foodListSearch length ${foodListSearch!.length}');
                }
              });

              ///====
            },
          ),
        ),
        (show_drop_list == true && _controllers[key]!.text.isNotEmpty)
            ? Container(
                padding: EdgeInsets.all(5.0),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                width: MediaQuery.of(context).size.width,
                child: Column(children: [
                  (_controllers[key]!.text.isNotEmpty &&
                          foodListSearch!.length == 0)
                      ? Container(
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 30,
                                color: Colors.red,
                              ),
                              Text(
                                'No results found,\n Please try other keyword',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          show_drop_list = false;
                                        });
                                      },
                                      child: Text(
                                        "Done",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              )
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(5.0),
                              height: 130,
                              child: ListView.builder(
                                  itemCount: _controllers[key]!.text.isNotEmpty
                                      ? foodListSearch!.length
                                      : foodList.length,
                                  itemBuilder: (ctx, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _controllers[key]!.text.isNotEmpty
                                                ? _controllers[key]!.text =
                                                    foodListSearch![index]
                                                : _controllers[key]!.text =
                                                    foodList[index];

                                            show_drop_list = false;
                                          });
                                        },
                                        child: Container(
                                          color: Colors.black12,
                                          child: Row(
                                            children: [
                                              Text(
                                                  _controllers[key]!
                                                          .text
                                                          .isNotEmpty
                                                      ? foodListSearch![index]
                                                      : foodList[index],
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        show_drop_list = false;
                                      });
                                    },
                                    child: Text(
                                      "Done",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            )
                          ],
                        )
                ]),
              )
            : SizedBox(),
      ],
    );
  }

  ///

///////////////////////////////// @4 Upadate Order  ++++++++++++++++++++++++++++++++++++++++++++++++++++
  var _Update_wd = false;
  var _Order_ID;

  Widget Update_Order(BuildContext context, sub_text, O_ID) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius:
        //     const BorderRadius.all(Radius.circular(10)),
      ),
      child: ListView(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _Update_wd = false;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.blue, size: 25),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Order',
                        style: themeTextStyle(
                            size: 18.0,
                            ftFamily: 'ms',
                            fw: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '$sub_text',
                        style: themeTextStyle(
                            size: 12.0,
                            ftFamily: 'ms',
                            fw: FontWeight.normal,
                            color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  wd_buyer_details(context),
                  SizedBox(height: 20.0),
                  Divider(
                    thickness: 1.5,
                    color: Colors.black12,
                  ),
                  wd_add_product(context),
                  SizedBox(height: 20.0),
                  Divider(
                    thickness: 1.5,
                    color: Colors.black12,
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      themeButton3(context, () {
                        setState(() {
                          clearText();
                        });
                      }, label: "Reset", buttonColor: Colors.black),
                      SizedBox(
                        width: 10,
                      ),
                      themeButton3(context, () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            if (!kIsWeb && Platform.isWindows) {
                              Win_updatelist(O_ID);
                            } else {
                              updatelist(O_ID);
                            }
                          });
                        } else {
                          themeAlert(context, 'Image value required!',
                              type: "error");
                        }
                      }, buttonColor: Colors.green, label: "Update"),
                    ],
                  ),
                  SizedBox(height: 20.0),
                ],
              ))
        ],
      ),
    );
  }
///////////////////===============================================================

  ///
  Map<String, TextEditingController> _controllers = new Map();
  // input fields
  Widget wd_input_field(BuildContext context, label, ctrName, conName) {
    // conName = conName;
    var key = "${conName}___${ctrName}";

    var tempStr =
        (_controllers[key]?.text != null) ? _controllers[key]?.text : '';

    _controllers[key] = TextEditingController();
    _controllers[key]?.text = tempStr.toString();

    // for cursor show in input field at last
    int stringLength = (tempStr == null) ? 0 : tempStr.length;
    _controllers[key]?.selection =
        TextSelection.collapsed(offset: stringLength);

    return Container(
      height: 35,
      margin: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        obscureText: false,
        controller: _controllers[key],
        readOnly: (ctrName == "" //'discount'
            )
            ? true
            : false,
        onChanged: (value) async {
          if (ctrName == 'sell_price' || ctrName == 'mrp') {
            var tempMrp = _controllers['${conName}___mrp']?.text;
            var tempSellPrice = _controllers['${conName}___sell_price']?.text;

            if (tempSellPrice != '' && tempMrp != '') {
              var discount = (((int.parse(tempMrp.toString()) -
                              int.parse(tempSellPrice.toString())) *
                          100) /
                      int.parse(tempMrp.toString()))
                  .round();

              setState(() {
                _controllers['${conName}___discount'] = TextEditingController();
                _controllers['${conName}___discount']?.text =
                    (discount == null) ? '' : discount.toString();
              });
            } else {
              setState(() {
                _controllers['${conName}___discount'] = TextEditingController();
                _controllers['${conName}___discount']?.text = '';
              });
            }
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please Enter value';
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          hintText: '$label',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          // suffixIcon: Container(
          //   height: 8.0,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       GestureDetector(
          //         onTap: () {
          //           // var mrpIncre = int.parse(conName!.text);
          //           // setState(() {
          //           //   mrpIncre++;
          //           //   conName = mrpIncre.toString();
          //           // });
          //         },
          //         child: Icon(Icons.expand_less_rounded,
          //             size: 15, color: Colors.black),
          //       ),
          //       GestureDetector(
          //         onTap: () {},
          //         child: Icon(Icons.expand_more_outlined,
          //             size: 15, color: Colors.black),
          //       )
          //     ],
          //   ),
          // ),
        ),
        style: TextStyle(color: Colors.black),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ], // Onl
      ),
    );
  }

///////  Text_field 22 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ///
  Widget Text_field(BuildContext context, ctr_name, lebel, hint) {
    return Container(
        height: 40,
        margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: ctr_name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Enter value';
            }
            return null;
          },
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            hintText: '$hint',
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ));
  }
///////////
}

/// Class CLose
