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
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../themes/function.dart';
import '../../../../constants.dart';
import '../../../../responsive.dart';
import '../../../../themes/firebase_Storage.dart';
import '../../../../themes/firebase_functions.dart';
import '../../../../themes/style.dart';
import '../../../../themes/theme_widgets.dart';
import '../dashboard/components/header.dart';
import '../product/product/product_widgets.dart';
import './../dashboard/components/my_fields.dart';
import './../dashboard/components/recent_files.dart';
import './../dashboard/components/storage_details.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:slug_it/slug_it.dart';
import 'package:intl/intl.dart';

import 'invoice_controller.dart';

class viewInvoiceScreen extends StatefulWidget {
  const viewInvoiceScreen(
      {super.key, required this.header_name, required this.data});
  final String header_name;
  final Map data;
  @override
  State<viewInvoiceScreen> createState() => _viewInvoiceScreenState();
}

class _viewInvoiceScreenState extends State<viewInvoiceScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var OrderData = widget.data;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            //header ======================
            themeHeader2(context, "${widget.header_name}"),
            // formField =======================

            Details_view(context, OrderData)
            // end form ====================================
          ],
        ),
      ),
    );
  }

////////////////// @2 Detaials View ++++++++++++++++++++++++++++++++++++++++++++
  var tempList = [];
  var Price = 0;
  var Qty = 0;
  Widget Details_view(BuildContext context, OrderData) {
    Qty = 0;
    Price = 0;
    tempList = [];

    var ffff = OrderData["products"] as Map;
    var ff = new Map();
    if (ffff.isNotEmpty) {
      ffff.forEach((k, v) {
        setState(() {
          tempList.add(v["name"]);

          if (Qty == 0) {
            Qty = Qty + int.parse(v["quantity"]);
          } else {
            Qty = Qty + int.parse(v["quantity"]);
          }
          if (Price == 0) {
            Price = Price + int.parse(v["price"]);
          } else {
            Price = Price + int.parse(v["price"]);
          }
        });
      });
    }

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
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(thickness: 4, color: Colors.blue)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 240, 240),
                // borderRadius:
                //     const BorderRadius.all(Radius.circular(10)),
              ),
              child: (OrderData == null)
                  ? Center(child: CircularProgressIndicator())
                  : Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // width: 300,
                          // height: MediaQuery.of(context).size.height * 0.5,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: Offset(4, 4)),
                              ],
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                Divider(
                                  thickness: 2,
                                  color: const Color.fromARGB(62, 0, 0, 0),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                themeListRow(
                                    context, "Order ID", "${OrderData["id"]}",
                                    descColor: Colors.black,
                                    fontsize: 11,
                                    headColor: Colors.black),
                                Divider(
                                  thickness: 1,
                                  color: const Color.fromARGB(17, 0, 0, 0),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Products",
                                      style: themeTextStyle(
                                          size: 12.0,
                                          color: Colors.black,
                                          ftFamily: 'ms',
                                          fw: FontWeight.bold),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(left: 50),
                                        child: Text(": ",
                                            style: GoogleFonts.alike(
                                              color: Colors.black,
                                            ))),
                                    for (var i = 0; i < tempList.length; i++)
                                      Text("${tempList[i]} ,",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: GoogleFonts.alike(
                                            fontSize: 11,
                                            color: Colors.black,
                                          ))
                                  ],
                                ),
                                Divider(
                                  thickness: 1,
                                  color: const Color.fromARGB(17, 0, 0, 0),
                                ),
                                themeListRow(context, "Price", "$Price",
                                    descColor: Colors.black,
                                    fontsize: 11,
                                    headColor: Colors.black),
                                Divider(
                                  thickness: 1,
                                  color: const Color.fromARGB(17, 0, 0, 0),
                                ),
                                themeListRow(context, "Quantity", "$Qty",
                                    descColor: Colors.black,
                                    fontsize: 11,
                                    headColor: Colors.black),
                                Divider(
                                  thickness: 1,
                                  color: const Color.fromARGB(17, 0, 0, 0),
                                ),
                                themeListRow(
                                    context, "GST", "${OrderData["gst"]} ",
                                    descColor: Colors.black,
                                    fontsize: 11,
                                    headColor: Colors.black),
                                Divider(
                                  thickness: 1,
                                  color: const Color.fromARGB(17, 0, 0, 0),
                                ),
                                themeListRow(context, "Sub Total",
                                    "${OrderData["subtotal"]} ",
                                    descColor: Colors.black,
                                    fontsize: 11,
                                    headColor: Colors.black),
                                Divider(
                                  thickness: 1,
                                  color: const Color.fromARGB(17, 0, 0, 0),
                                ),
                                themeListRow(
                                    context, "Total", "${OrderData["total"]}",
                                    descColor: Colors.black,
                                    fontsize: 11,
                                    headColor: Colors.black),
                                SizedBox(height: defaultPadding),
                              ]),
                        ),
                        SizedBox(width: 100),
                        Container(
                          // width: 300,
                          // height: MediaQuery.of(context).size.height * 0.5,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: Offset(4, 4)),
                              ],
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                Divider(
                                  thickness: 2,
                                  color: const Color.fromARGB(62, 0, 0, 0),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                themeListRow(context, "Customer",
                                    "${OrderData["customer_name"]}",
                                    descColor: Colors.black,
                                    headColor: Colors.black),
                                Divider(
                                  thickness: 1,
                                  color: const Color.fromARGB(17, 0, 0, 0),
                                ),
                                themeListRow(context, "Mobile No.",
                                    "${OrderData["mobile"]}",
                                    descColor: Colors.black,
                                    headColor: Colors.black),
                                Divider(
                                  thickness: 1,
                                  color: const Color.fromARGB(17, 0, 0, 0),
                                ),
                                themeListRow(context, "Email Id",
                                    "${OrderData["email"]}",
                                    descColor: Colors.black,
                                    headColor: Colors.black),
                                Divider(
                                  thickness: 1,
                                  color: const Color.fromARGB(17, 0, 0, 0),
                                ),
                                themeListRow(context, "Address",
                                    "${OrderData["address"]}",
                                    descColor: Colors.black,
                                    headColor: Colors.black),
                                SizedBox(height: defaultPadding),
                              ]),
                        ),
                      ],
                    ))
        ],
      ),
    );
  }
}


/// Class CLose
