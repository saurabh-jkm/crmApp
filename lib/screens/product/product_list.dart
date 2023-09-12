// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_this, non_constant_identifier_names, unnecessary_cast, avoid_print, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, prefer_final_fields, override_on_non_overriding_member, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_null_comparison, unnecessary_brace_in_string_interps, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable, sort_child_properties_last, depend_on_referenced_packages, avoid_types_as_parameter_names, unused_field, curly_braces_in_flow_control_structures, prefer_is_empty, unnecessary_new, prefer_collection_literals, unused_local_variable, deprecated_member_use, unused_element, unused_shown_name, unnecessary_import

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/screens/product/product/add_product_screen.dart';
import 'package:crm_demo/screens/product/product/edit_product_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:firedart/generated/google/firestore/v1/document.pb.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../themes/function.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/firebase_Storage.dart';
import '../../themes/firebase_functions.dart';
import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';
import '../dashboard/components/header.dart';
import '../dashboard/components/my_fields.dart';
import '../dashboard/components/recent_files.dart';
import '../dashboard/components/storage_details.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:slug_it/slug_it.dart';
import 'package:intl/intl.dart';

import 'product/detail_product_screen.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({super.key});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  final _controllers = TextEditingController();
  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;
  @override
  void initState() {
    Pro_Data();
    super.initState();
  }

////////////  Product data fetch  ++++++++++++++++++++++++++++++++++++++++++++
  bool progressWidget = true;
  List finalProductList = [];
  List productList = [];
  Pro_Data() async {
    var temp2 = [];
    productList = finalProductList = [];

    Map<dynamic, dynamic> w = {
      'table': "product",
      "orderBy": "date_at"
      //'status': "$_StatusValue",
    };
    var temp = await dbFindDynamic(db, w);

    setState(() {
      temp.forEach((k, v) {
        var tempLocation = '';

        if (v['item_location'] != null && v['item_location'].isNotEmpty) {
          v['item_location'].forEach((ke, vl) {
            tempLocation = (tempLocation == '') ? "$ke" : '$tempLocation , $ke';
          });
        }
        v['location'] = tempLocation;

        productList.add(v);
      });
      filteredItems = productList;
      finalProductList = productList;
      progressWidget = false;
    });
  }

///////  delete  Product ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Future<void> delete_Pro(id) {
    // var db = FirebaseFirestore.instance;
    if (!kIsWeb && Platform.isWindows) {
      final _product = Firestore.instance.collection('product');
      return _product.document(id).delete().then((value) {
        setState(() {
          themeAlert(context, "Deleted Successfully ");
          _controllers.clear();
          productList2 = [];
          Pro_Data();
        });
      }).catchError(
          (error) => themeAlert(context, 'Not find Data', type: "error"));
    } else {
      CollectionReference _product =
          FirebaseFirestore.instance.collection('product');
      return _product.doc(id).delete().then((value) {
        setState(() {
          themeAlert(context, "Deleted Successfully ");
          _controllers.clear();
          productList2 = [];
          Pro_Data();
        });
      }).catchError(
          (error) => themeAlert(context, 'Not find Data', type: "error"));
    }
  }

/////////////=====================================================================

  addNewStock() async {
    final temp = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => addStockScreen(header_name: "Add New Stock")));
    if (temp == 'updated') {
      Pro_Data();
    }
  }

  var selected_pro = {};
///////// ======================================================================

  Future<void> _fetchDataAsc(bool boolvalue, String where) async {
    final _product = await Firestore.instance
        .collection('product')
        .orderBy('$where', descending: boolvalue)
        .get()
        .then(
      (res) {
        Map<int, dynamic> returnData2 = new Map();
        int k = 0;
        for (var doc in res) {
          Map<String, dynamic> temp = doc.map;
          temp['id'] = doc.id;
          returnData2[k] = temp;
          k++;
        }
        return returnData2;
      },
      onError: (e) => print("Error completing: $e"),
    );
    // return _product;
    progressWidget = true;
    productList = [];
    for (var i = 0; i < _product.length; i++) {
      setState(() {
        productList.add(_product[i]);
        ascen = !boolvalue;
      });
    }
    progressWidget = false;
  }

  ///
  bool ascen = true;

  ///
  @override
  Widget build(BuildContext context) {
    return (progressWidget == true)
        ? Center(child: pleaseWait(context))
        : Scaffold(
            body: Container(
              color: Colors.white,
              child: ListView(
                children: [
                  //header ======================
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                    decoration: BoxDecoration(color: themeBG2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {},
                                child: Icon(
                                  Icons.view_list_sharp,
                                  size: 35,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(width: 20.0),
                              Text("Stocks", style: GoogleFonts.alike())
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Pro_Data();
                                },
                                icon: Icon(Icons.refresh),
                                tooltip: 'Refresh',
                              ),
                              SizedBox(width: 20.0),
                              themeButton3(context, addNewStock,
                                  label: 'Add New', radius: 5.0),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                    ),
                    child: Column(
                      children: [
                        searchBar(context),
                        Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          border: TableBorder(
                            horizontalInside:
                                BorderSide(width: .5, color: Colors.grey),
                          ),
                          columnWidths: {
                            0: FlexColumnWidth(0.01),
                            1: FlexColumnWidth(0.3),
                            2: FlexColumnWidth(0.6),
                            3: FlexColumnWidth(0.3),
                            4: FlexColumnWidth(0.4),
                            5: FlexColumnWidth(0.2),
                            6: FlexColumnWidth(0.3),
                            7: FlexColumnWidth(0.3),
                            8: FlexColumnWidth(0.2),
                            9: FlexColumnWidth(0.3),
                            10: IntrinsicColumnWidth(),
                          },
                          children: [
                            TableRow(
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                                children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('#',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.0)),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (ascen == true) {
                                            await _fetchDataAsc(ascen, "name");
                                          } else if (ascen == false) {
                                            await _fetchDataAsc(ascen, "name");
                                          }
                                        },
                                        child: Text("Name",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10.0)),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (ascen == true) {
                                            await _fetchDataAsc(ascen, "brand");
                                          } else if (ascen == false) {
                                            await _fetchDataAsc(ascen, "brand");
                                          }
                                        },
                                        child: Text('Brand',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10.0)),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (ascen == true) {
                                            await _fetchDataAsc(
                                                ascen, "category");
                                          } else if (ascen == false) {
                                            await _fetchDataAsc(
                                                ascen, "category");
                                          }
                                        },
                                        child: Text('Category',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10.0)),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Text("Qnt.",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0)),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Text("Location",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0)),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Text("Price (₹)",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0)),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Text("Status",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0)),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Text("Date",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0)),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Text("Actions",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0)),
                                  ),
                                ]),
                            for (var index = 0;
                                index < productList.length;
                                index++)
                              tableRowWidget(
                                  index + 1,
                                  productList[index]['name'],
                                  (productList[index]['brand'] == null)
                                      ? ""
                                      : productList[index]['brand'],
                                  productList[index]['category'],
                                  productList[index]['quantity'],
                                  productList[index]['location'],
                                  (productList[index]['price'] != "")
                                      ? productList[index]['price']
                                      : 00.00,
                                  productList[index]['status'],
                                  productList[index]['date_at'],
                                  productList[index]['id'],
                                  productList[index]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  TableRow tableRowWidget(Sno, name, BrandName, cate_name, items_no, location,
      price, status, date, iid, data) {
    var statuss = statusOF(status);
    final formattedDate = formatDate(date);
    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text("$Sno",
              style: GoogleFonts.alike(
                  fontWeight: FontWeight.normal, fontSize: 11)),
        ),
      ),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: CheckboxListTile(
                checkColor: Colors.white,
                activeColor: Colors.red,
                side: BorderSide(width: 2, color: Colors.green),
                value: (selected_pro[iid] == null) ? false : true,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selected_pro[iid] = true;
                    } else {
                      selected_pro.remove(iid);
                    }
                  });
                },
              ))),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$name",
              style: GoogleFonts.alike(
                  fontWeight: FontWeight.normal, fontSize: 11)),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("$BrandName",
            style:
                GoogleFonts.alike(fontWeight: FontWeight.normal, fontSize: 11)),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("$cate_name",
            style:
                GoogleFonts.alike(fontWeight: FontWeight.normal, fontSize: 11)),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("$items_no",
            style: GoogleFonts.alike(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            )),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("$location",
            style: GoogleFonts.alike(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            )),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("$price",
            style: GoogleFonts.alike(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            )),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text(statuss,
            style: GoogleFonts.alike(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: statuss == "Active" ? Colors.green : Colors.red)),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("$formattedDate",
            style:
                GoogleFonts.alike(fontWeight: FontWeight.normal, fontSize: 9)),
      ),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            padding: EdgeInsets.only(right: 20.0),
            margin: EdgeInsets.symmetric(vertical: 8.0),
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Details_product(
                                        header_name: "View details of product",
                                        MapData: data,
                                      )));
                        },
                        icon: Icon(
                          Icons.remove_red_eye_outlined,
                          size: 15,
                          color: Colors.green,
                        ))),
                SizedBox(width: 10),
                Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: IconButton(
                        onPressed: () async {
                          final temp = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => editStockScreen(
                                        data: data,
                                        header_name: "Edit product details",
                                      )));
                          if (temp == 'updated') {
                            Pro_Data();
                          }
                        },
                        icon: Icon(
                          Icons.edit,
                          size: 15,
                          color: Colors.blue,
                        )) ////
                    ),
                SizedBox(width: 10),
                Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: IconButton(
                        onPressed: () {
                          showExitPopup(iid);
                        },
                        icon: Icon(
                          Icons.delete_outline_outlined,
                          size: 15,
                          color: Colors.red,
                        ))),
              ],
            ),
          )),
    ]);
  }
////
///////// search Bar For Product  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Widget searchBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: (selected_pro.isNotEmpty && selected_pro != {})
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ////  Delete Selected Product +++++++++++++++++++++++++++++++++++++++
          if (selected_pro.isNotEmpty && selected_pro != {})
            themeButton3(context, () {
              selected_pro.forEach(
                  (k, v) async => await delete_Pro(k) //   showExitPopup(k)
                  );
              setState(() {
                selected_pro = {};
              });
            },
                label: "Delete selected items : ${selected_pro.length}",
                buttonColor: Colors.red,
                radius: 10.0),

          //////// Search ++++++++++
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.only(top: 20, right: 10, bottom: 10),
            padding: EdgeInsets.all(8.0),
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.25,
            child: TextField(
              controller: _controllers,
              onChanged: ((value) {
                _filterItems(value);
              }),
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: 'Search Product ,Category, Brand & Colors ....',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  border: InputBorder.none,
                  suffixIcon: (_controllers.text.isEmpty)
                      ? Icon(Icons.search, size: 30, color: Colors.blue)
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _controllers.clear();
                              productList2 = [];
                              Pro_Data();
                            });
                          },
                          child: Icon(Icons.search_off, color: Colors.red))),
            ),
          )
        ],
      ),
    );
  }

/////////   Search filter  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  var filteredItems = [];
  bool show_drop_list = false;
  List<String>? foodListSearch;

  ///
  List productList2 = [];
  void _filterItems(String query) {
    List<String> searchField = ['name', 'category', 'brand', 'location'];
    productList = [];
    finalProductList.forEach((e) {
      bool isFind = false;
      searchField.forEach((key) {
        if (!isFind &&
            e['$key'] != null &&
            e['$key'].toLowerCase().contains(query.toLowerCase())) {
          productList.add(e);
          isFind = true;
        }
      });
    });
    setState(() {});
  }
  ////////////////////  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//////////////////////==============================================================

///////// Alart Popup  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Future<bool> showExitPopup(iid_delete) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red,
                  size: 35,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'CRM App says',
                  style: themeTextStyle(
                      size: 20.0,
                      ftFamily: 'ms',
                      fw: FontWeight.bold,
                      color: themeBG2),
                ),
              ],
            ),
            content: Text(
              'Are you sure to delete this Product ?',
              style: themeTextStyle(
                  size: 16.0,
                  ftFamily: 'ms',
                  fw: FontWeight.normal,
                  color: Colors.black87),
            ),
            actions: [
              Container(
                height: 30,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'No',
                    style: themeTextStyle(
                        size: 16.0,
                        ftFamily: 'ms',
                        fw: FontWeight.normal,
                        color: Colors.red),
                  ),
                ),
              ),
              Container(
                height: 30,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: TextButton(
                  onPressed: () async {
                    await delete_Pro(iid_delete);
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'Yes',
                    style: themeTextStyle(
                        size: 16.0,
                        ftFamily: 'ms',
                        fw: FontWeight.normal,
                        color: themeBG4),
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }
/////////  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
}

/// Class CLose
