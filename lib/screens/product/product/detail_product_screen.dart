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
  @override
  void initState() {
    super.initState();
  }

  var controller = new ProductController();

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
            Details_view(context, widget.MapData)
            // end form ====================================
          ],
        ),
      ),
    );
  }

  Widget Details_view(BuildContext context, priceData) {
    var Location = priceData["item_location"];
    List Loca = [];

    Location.forEach((k, v) {
      setState(() {
        Loca.add('${k} & ${v}');
      });
    });
    // print("$Loca ++++");
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(thickness: 4, color: Colors.blue)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
              child: (priceData == {})
                  ? Center(child: CircularProgressIndicator())
                  : Row(
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
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(
                                      thickness: 4, color: Colors.blue)),
                              SizedBox(height: 20),
                              themeListRow(context, "Product Name",
                                  "${priceData["name"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              themeListRow(
                                  context, "Product's ID", "${priceData["id"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              themeListRow(
                                  context, "Price", "${priceData["price"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              themeListRow(context, "Quantity",
                                  "${priceData["quantity"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              themeListRow(context, "Category",
                                  "${priceData["category"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              themeListRow(
                                  context, "Watt", "${priceData["watt"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              themeListRow(context, "Status",
                                  statusOF(priceData["status"]),
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              themeListRow(
                                  context, "Brand", "${priceData["brand"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              themeListRow(
                                  context, "Size", "${priceData["sizes"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              themeListRow(
                                  context, "Color", "${priceData["colors"]}",
                                  descColor: Colors.black,
                                  headColor: Colors.black),
                              SizedBox(height: defaultPadding),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      "Location & Qauntity",
                                      style: themeTextStyle(
                                          size: 12.0,
                                          color: Colors.black,
                                          ftFamily: 'ms',
                                          fw: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                      child: Column(
                                    children: [
                                      for (var i = 0; i < Loca.length; i++)
                                        Text(": ${Loca[i]}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: GoogleFonts.alike(
                                              color: Colors.black,
                                            )),
                                    ],
                                  ))
                                ],
                              )
                            ]),
                      ],
                    ))
        ],
      ),
    );
  }
}

/// Class CLose