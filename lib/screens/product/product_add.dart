// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_this, non_constant_identifier_names, unnecessary_cast, avoid_print, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, prefer_final_fields, override_on_non_overriding_member, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_null_comparison, unnecessary_brace_in_string_interps, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable, sort_child_properties_last, depend_on_referenced_packages, avoid_types_as_parameter_names, unused_field, curly_braces_in_flow_control_structures, prefer_is_empty, unnecessary_new, prefer_collection_literals, unused_local_variable, deprecated_member_use

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/screens/product/product/add_product_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firedart/firestore/firestore.dart';
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
  List productList = [];
  Pro_Data() async {
    var temp2 = [];
    productList = [];
    Map<dynamic, dynamic> w = {
      'table': "product",
      //'status': "$_StatusValue",
    };
    var temp = (!kIsWeb && Platform.isWindows)
        ? await All_dbFindDynamic(db, w)
        : await dbFindDynamic(db, w);

    setState(() {
      temp.forEach((k, v) {
        productList.add(v);
      });
      filteredItems = productList;
      // print("$productList  ++++++++++++++++");
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

  addNewStock() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => addStockScreen()));
  }

///////// ======================================================================
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
                              // GestureDetector(
                              //     onTap: () {
                              //       Navigator.of(context).pop();
                              //     },
                              //     child: Icon(Icons.arrow_back, color: Colors.white)),
                              // SizedBox(width: 20.0),
                              Text("Stocks")
                            ],
                          ),
                        ),
                        Container(
                          child: themeButton3(context, addNewStock,
                              label: 'Add New', radius: 5.0),
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
                                      child: Text('S.No.',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        child: Text("Name",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        width: 40,
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Brand',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Text('Category Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Text("Qauntity",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Text("Price",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Text("Status",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Text("Date",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Text("Actions",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ]),
                            if (productList2.isEmpty)
                              for (var index = 0;
                                  index < productList.length;
                                  index++)
                                tableRowWidget(
                                    index + 1,
                                    productList[index]['name'],
                                    productList[index]['brand'],
                                    productList[index]['category'],
                                    productList[index]['quantity'],
                                    productList[index]['price'],
                                    productList[index]['status'],
                                    productList[index]['date_at'],
                                    productList[index]['id']),
                            if (productList2.isNotEmpty)
                              for (var index = 0;
                                  index < productList2.length;
                                  index++)
                                tableRowWidget(
                                    index + 1,
                                    productList2[index]['name'],
                                    productList2[index]['brand'],
                                    productList2[index]['category'],
                                    productList2[index]['quantity'],
                                    productList2[index]['price'],
                                    productList2[index]['status'],
                                    productList2[index]['date_at'],
                                    productList2[index]['id']),
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

  TableRow tableRowWidget(
      Sno, name, BrandName, cate_name, items_no, price, status, date, iid) {
    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$Sno",
              style: GoogleFonts.alike(
                  fontWeight: FontWeight.normal, fontSize: 11)),
        ),
      ),
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
        child: Text("$price",
            style: GoogleFonts.alike(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            )),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("$status",
            style: GoogleFonts.alike(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            )),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("$date",
            style:
                GoogleFonts.alike(fontWeight: FontWeight.normal, fontSize: 11)),
      ),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            // update_id = iid;
                            // Update_initial(iid);
                          });
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
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
                hintText: 'Search Product & Categories ....',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
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
    );
  }

/////////   Search Fuction  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  var filteredItems = [];
  bool show_drop_list = false;
  List<String>? foodListSearch;

  ///
  List productList2 = [];
  void _filterItems(String query) {
    productList2 = [];
    for (var i = 0; i < productList.length; i++) {
      String pro_name = productList[i]["name"];
      String pro_cat = productList[i]["category"];

      if (pro_name.toLowerCase() == query.toLowerCase() ||
          pro_cat.toLowerCase() == query.toLowerCase()) {
        setState(() {
          if (productList2.contains(productList[i])) {
          } else {
            productList2.add(productList[i]);
          }
        });
      } else {
        print("not fond  ++++++++++++++++++");
        setState(() {
          if (show_drop_list == false && _controllers.text.isNotEmpty) {
            show_drop_list = true;
          }
        });
      }
    }
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
/////////  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
}

/// Class CLose
