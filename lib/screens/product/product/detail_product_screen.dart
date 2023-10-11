// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_this, non_constant_identifier_names, unnecessary_cast, avoid_print, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, prefer_final_fields, override_on_non_overriding_member, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_null_comparison, unnecessary_brace_in_string_interps, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable, sort_child_properties_last, depend_on_referenced_packages, avoid_types_as_parameter_names, unused_field, curly_braces_in_flow_control_structures, prefer_is_empty, unnecessary_new, prefer_collection_literals, unused_local_variable, deprecated_member_use, camel_case_types

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/screens/product/product/product_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/generated/google/firestore/v1/document.pb.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../themes/function.dart';
import '../../../../constants.dart';
import '../../../../responsive.dart';
import '../../../../themes/firebase_Storage.dart';
import '../../../../themes/firebase_functions.dart';
import '../../../../themes/style.dart';
import '../../../../themes/theme_widgets.dart';
import '../../dashboard/components/header.dart';
import '../../dashboard/components/my_fields.dart';
import '../../dashboard/components/recent_files.dart';
import '../../dashboard/components/storage_details.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:slug_it/slug_it.dart';
import 'package:intl/intl.dart';
import 'product_widgets.dart';

class Details_product extends StatefulWidget {
  const Details_product(
      {super.key, required this.header_name, required this.MapData});
  final String header_name;
  final Map MapData;

  @override
  State<Details_product> createState() => _Details_productState();
}

class _Details_productState extends State<Details_product> {
  List<String> tableHeading = ['price', 'location', 'quantity'];
  var data = {};

  headListCreate(w_data) {
    data = w_data;
    if (w_data['item_list'] != null && w_data['item_list'] != '') {
      w_data['item_list'].forEach((k, vData) {
        if (vData.isNotEmpty) {
          vData.forEach((label, val) {
            if (!tableHeading.contains(label)) {
              tableHeading.add(label);
            }
          });
        }
      });
    }
    setState(() {});
    fnGetProductLog();
  }

  // get product log =======================
  var logDb = new Map();
  fnGetProductLog() async {
    logDb = await dbFindDynamic(
        db, {'table': 'product_log', 'product_id': '${widget.MapData['id']}'});

    //print(logDb);
    setState(() {});
  }

  @override
  void initState() {
    headListCreate(widget.MapData);
    super.initState();
  }

  fn_refresh() async {
    var w = {'table': 'product', 'id': widget.MapData['id']};
    var rData = await dbFind(w);
    setState(() {
      data = rData;
      data['id'] = widget.MapData['id'];
    });
    fnGetProductLog();
  }

  var controller = new ProductController();

  @override
  Widget build(BuildContext context) {
    logDb = logDb;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            //header ======================
            themeHeader2(context, "${widget.header_name}",
                refreshBUtton: 'Refresh', buttonFn: fn_refresh),
            // formField =======================
            Details_view(context, data, tableHeading)
            // end form ====================================
          ],
        ),
      ),
    );
  }

  Widget Details_view(BuildContext context, priceData, tableHeading) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          //color: Colors.white,
          ),
      child: ListView(
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(thickness: 4, color: Colors.blue)),
          Container(
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
              child: (priceData == {})
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.production_quantity_limits_sharp,
                                      size: 30,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Product Details",
                                      style: GoogleFonts.alike(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Divider(
                                        thickness: 4, color: Colors.blue)),
                                SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                              width: 3.0,
                                              color: Color.fromARGB(
                                                  31, 72, 86, 92)),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          for (String key in priceData.keys)
                                            productRow(
                                                context, key, priceData[key])
                                        ],
                                      ),
                                    ),
                                    // item list =========================
                                    Container(
                                      margin: EdgeInsets.only(left: 30.0),
                                      width: (MediaQuery.of(context)
                                              .size
                                              .width -
                                          (MediaQuery.of(context).size.width /
                                                  3 +
                                              120)),
                                      child: Column(
                                        children: [
                                          // heading

                                          productTableHeading(
                                              context, tableHeading),
                                          // details
                                          for (String key
                                              in priceData['item_list'].keys)
                                            productTableRow(
                                                context,
                                                key,
                                                priceData['item_list'],
                                                tableHeading)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // Log Sections =======================
                                SizedBox(height: 30.0),

                                Text(
                                  "Stock Log",
                                  style: themeTextStyle(
                                      size: 20.0, fw: FontWeight.bold),
                                ),

                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: Divider(
                                    color: themeBG2,
                                    thickness: 1.0,
                                  ),
                                  //child: SizedBox(height: 20.0),
                                ),

                                (logDb.isEmpty)
                                    ? SizedBox()
                                    : Container(
                                        margin: EdgeInsets.only(top: 10.0),
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                100),
                                        child: Column(
                                          children: [
                                            // heading

                                            productTableHeading(
                                                context, tableHeading),
                                            // details
                                            for (var key in logDb.keys)
                                              logTableRow(context, key,
                                                  logDb[key], tableHeading)
                                          ],
                                        ),
                                      ),
                              ]),
                        ],
                      ),
                    ))
        ],
      ),
    );
  }
}

/// Class CLose
