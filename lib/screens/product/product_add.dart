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
      print("$productList  ++++++++++++++++");
      progressWidget = false;
    });
  }

/////////////=====================================================================

  addNewStock() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => addStockScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return (progressWidget == true)
        ? Center(child: pleaseWait(context))
        : Scaffold(
            body: Container(
              color: Colors.white,
              child: Column(
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
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      border: TableBorder(
                        horizontalInside:
                            BorderSide(width: .5, color: Colors.grey),
                      ),
                      children: [
                        TableRow(
                            decoration: BoxDecoration(
                                color: Theme.of(context).secondaryHeaderColor),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text("Qauntity",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text("Price",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text("Status",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Text("Date",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ]),
                        for (var index = 0; index < productList.length; index++)
                          tableRowWidget(
                            index + 1,
                            productList[index]['name'],
                            productList[index]['brand'],
                            productList[index]['category'],
                            productList[index]['quantity'],
                            productList[index]['price'],
                            productList[index]['status'],
                            productList[index]['date_at'],
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  TableRow tableRowWidget(
      Sno, name, BrandName, cate_name, items_no, price, status, date) {
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
    ]);
  }
}

/// Class CLose
