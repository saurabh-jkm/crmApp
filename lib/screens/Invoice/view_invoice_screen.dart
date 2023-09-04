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
  const viewInvoiceScreen({super.key, required this.header_name});
  final String header_name;

  @override
  State<viewInvoiceScreen> createState() => _viewInvoiceScreenState();
}

class _viewInvoiceScreenState extends State<viewInvoiceScreen> {
  @override
  void initState() {
    super.initState();
  }

  var priceData = {
    "order_id": "0KNbOzxfrp8w3SbxwJYU",
    "oder_Date": "17-08-2023",
    "buyer_name": "ssss335",
    "buyer_mobile": "3334445566",
    "buyer_address": "11113",
    "buyer_email": "sry@gmail.com",
    "Pro_name": "Water Heater",
    "Pro_quantity": "1",
    "Pro_price": "3.00 rs",
    "Pro_gst": "44",
    "total_price": "56.00 rs",
    "product_details": {
      "Product No. 1": {
        "total_price": "56",
        "gst": '44',
        "price": "3",
        "product_name": "Water Heater",
        "quantity": "125",
        "discount": "55"
      }
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            //header ======================
            themeHeader2(context, "${widget.header_name}"),
            // formField =======================

            Details_view(context, priceData)
            // end form ====================================
          ],
        ),
      ),
    );
  }

////////////////// @2 Detaials View ++++++++++++++++++++++++++++++++++++++++++++

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

    for (var i = 1; i <= ffff.length; i++) {
      print("${i} ${ff["Product No. ${i}___product_name"]}  ++++hhhhh++++");
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
}


/// Class CLose
