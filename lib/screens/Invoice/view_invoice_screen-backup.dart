// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_this, non_constant_identifier_names, unnecessary_cast, avoid_print, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, prefer_final_fields, override_on_non_overriding_member, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_null_comparison, unnecessary_brace_in_string_interps, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable, sort_child_properties_last, depend_on_referenced_packages, avoid_types_as_parameter_names, unused_field, curly_braces_in_flow_control_structures, prefer_is_empty, unnecessary_new, prefer_collection_literals, unused_local_variable, deprecated_member_use, camel_case_types

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jkm_crm_admin/screens/Invoice/edit_invoice.dart';
import 'package:jkm_crm_admin/screens/Invoice/invoice_serv.dart';
import 'package:jkm_crm_admin/screens/Invoice/invoice_widgets.dart';
import 'package:jkm_crm_admin/screens/Invoice/pdf.dart';
import 'package:jkm_crm_admin/screens/product/product/product_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/generated/google/firestore/v1/document.pb.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';

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
  var OrderData;
  bool isWait = true;
  bool isGstColum = false;
  bool isDiscountColum = false;
  bool isUnitColum = false;

  _fnGetOrder() {
    OrderData = widget.data;

    OrderData['products'].forEach((i, val) {
      if (val['gst'] != '0') {
        isGstColum = true;
      }
      if (val['discount'] != '0') {
        isDiscountColum = true;
      }
      if (val['unit'] != '0') {
        isUnitColum = true;
      }
    });
    isWait = false;
    setState(() {});
  }

  @override
  void initState() {
    _fnGetOrder();
    super.initState();
  }

  ///////// PDF  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Future<void> savePdfFile(
      String fileName, Uint8List byteList, PriceDetail) async {
    if (kIsWeb) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Invoice_pdf(BytesCode: byteList, PriceDetail: PriceDetail),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Invoice_pdf(BytesCode: byteList, PriceDetail: PriceDetail),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //var OrderData = widget.data;
    double pageWidth = MediaQuery.of(context).size.width / 1.8;

    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 192, 192, 192),
        child: ListView(
          children: [
            //header ======================
            themeHeader2(context, "${widget.header_name}"),
            // formField =======================

            (isWait)
                ? pleaseWait(context)
                : Details_view(context, OrderData, pageWidth),
            // end form ====================================
          ],
        ),
      ),
    );
  }

////////////////// @2 Detaials View ++++++++++++++++++++++++++++++++++++++++++++
  // var tempList = [];
  // var Price = 0.0;
  // var Qty = 0;
  Widget Details_view(BuildContext context, OrderData, pageWidth) {
    // Qty = 0;
    // Price = 0;
    // tempList = [];

    // var ffff = OrderData["products"] as Map;
    // var ff = new Map();OrderData["total"]
    int intbalance = int.parse(OrderData["balance"]);

    String Balance = NumberFormat('#,##,###').format(intbalance);
    String Total = NumberFormat('#,##,###').format(OrderData["total"]);

    return Container(
      child: Column(
        children: [
          Container(
            width: pageWidth,
            margin: EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: themeBG,
                      onPrimary: Colors.white,
                      shadowColor: Colors.greenAccent,
                      elevation: 3,
                      minimumSize: Size(100, 40), //////// HERE
                    ),
                    onPressed: () async {
                      final data = await InvoiceService(
                        PriceDetail: OrderData,
                      ).createInvoice();
                      // final data = await service.createInvoice();
                      await savePdfFile("invoice", data, OrderData);
                    },
                    child: Row(
                      children: [
                        Text("Download"),
                        SizedBox(width: 10.0),
                        Icon(Icons.download)
                      ],
                    )),
                SizedBox(width: 20.0),
                ElevatedButton(
                    onPressed: () async {
                      final temp = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => editInvoice(
                                    data: OrderData,
                                    header_name: "Edit Invoice",
                                  )));

                      if (temp == "updated") {
                        Navigator.pop(context, 'updated');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: themeBG2,
                      onPrimary: Colors.white,
                      shadowColor: Colors.greenAccent,
                      elevation: 3,
                      minimumSize: Size(100, 40), //////// HERE
                    ),
                    child: Row(
                      children: [
                        Text("Edit"),
                        SizedBox(width: 10.0),
                        Icon(Icons.edit)
                      ],
                    ))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(color: Colors.white),
                width: pageWidth,
                child: Stack(
                  children: [
                    // water mark
                    (OrderData["is_sale"] != null &&
                            OrderData["is_sale"].toLowerCase() == 'estimate')
                        ? Positioned(
                            top: 200.0,
                            child: RotationTransition(
                              turns: new AlwaysStoppedAnimation(11 / 180),
                              child: Text("${OrderData["is_sale"]}",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 243, 243, 243),
                                      fontSize: 130.0)),
                            ),
                          )
                        : SizedBox(),

                    // page data start
                    Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  "${(OrderData["is_sale"] != null && OrderData["is_sale"].toLowerCase() == 'estimate') ? "Estimate" : 'Invoice'}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: themeBG2)),
                            ]),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Geetanjali Electromart Private Limited",
                                    style: textStyle2),
                                Text(
                                  "D-1/140, New Kondli, New Delhi 110096, India",
                                  style: textStyle2,
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  "www.geetanjalielectromart.com",
                                  style: textStyle1,
                                ),
                                Text(
                                  "info@geetanjalielectromart.net",
                                  style: textStyle1,
                                ),
                              ],
                            ),
                            Column(children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("e-Invoice",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ]),
                              /////// Invoice Data fetch  ++++++++

                              ////////  ============================
                            ])
                          ],
                        ),

                        SizedBox(height: 20),
                        Container(
                            child: Row(children: [
                          Expanded(
                              child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: themeBG2, width: 1)),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Customer Name",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: themeBG2)),
                                        Text("Mobile No.",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: themeBG2)),
                                        Text("Email Id",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: themeBG2)),
                                        Text("Address",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: themeBG2)),
                                      ]))),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: themeBG2, width: 1)),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${OrderData["customer_name"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: themeBG2)),
                                      Text("${OrderData["mobile"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: themeBG2)),
                                      Text("${OrderData["email"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: themeBG2)),
                                      Text("${OrderData["address"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: themeBG2)),
                                    ])),
                          )
                        ])),
                        Container(
                            child: Row(children: [
                          Expanded(
                              child: Container(
                                  height: 70,
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: themeBG2, width: 1)),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Invoice Id",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: themeBG2)),
                                        Text("Dated",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: themeBG2)),
                                      ]))),
                          Expanded(
                              child: Container(
                                  height: 70,
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: themeBG2, width: 1),
                                  ),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("${OrderData["id"]}",
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal,
                                                color: themeBG2)),
                                        Text("${OrderData["invoice_date"]}",
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal,
                                                color: themeBG2)),
                                      ])))
                        ])),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: themeBG2, width: 1.0)),
                          height: 35,
                          child: Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(5),
                                  width: 40,
                                  alignment: Alignment.center,
                                  child:
                                      Text("S.no.", style: textStyleHeading1)),
                              Container(
                                  padding: EdgeInsets.all(2),
                                  width: 180,
                                  alignment: Alignment.centerLeft,
                                  child:
                                      Text("Item", style: textStyleHeading1)),
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text("Price (₹)",
                                          style: textStyleHeading1))),
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text("Qty.",
                                          style: textStyleHeading1))),
                              (isDiscountColum)
                                  ? Expanded(
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text("Disc(₹) ",
                                              style: textStyleHeading1)))
                                  : SizedBox(),
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text("SubTotal(₹)",
                                          style: textStyleHeading1))),
                              (isGstColum)
                                  ? Expanded(
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text("GST (%) ",
                                              style: textStyleHeading1)))
                                  : SizedBox(),
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text("Amount(₹)",
                                          style: textStyleHeading1))),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: themeBG2, width: 1.0)),
                          child: Column(
                            children: [
                              for (var key in OrderData['products'].keys)
                                invoiceItemRow(
                                    context, key, OrderData['products'],
                                    isGstColum: isGstColum,
                                    isDiscountColum: isDiscountColum)
                            ],
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: themeBG2, width: 1.0)),
                          height: 35,
                          child: Row(
                            children: [
                              SizedBox(width: 40),
                              Container(
                                  padding: EdgeInsets.all(2),
                                  width: 180,
                                  alignment: Alignment.center,
                                  child: Text("Total",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: themeBG2))),
                              Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color: themeBG2)),
                                      padding: EdgeInsets.only(right: 10),
                                      alignment: Alignment.centerRight,
                                      child: Text("$Total Rs /-",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: themeBG2)))),
                            ],
                          ),
                        ),

                        // paid -------------------------------------------
                        (OrderData["payment"] == null ||
                                OrderData["payment"] == '')
                            ? SizedBox()
                            : Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: themeBG2, width: 1.0)),
                                height: 35,
                                child: Row(
                                  children: [
                                    SizedBox(width: 40),
                                    Container(
                                        padding: EdgeInsets.all(2),
                                        width: 180,
                                        alignment: Alignment.center,
                                        child: Text("Paid",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: themeBG2))),
                                    Expanded(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: themeBG2)),
                                            padding: EdgeInsets.only(right: 10),
                                            alignment: Alignment.centerRight,
                                            child: Text("$Total Rs /-",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: themeBG2)))),
                                  ],
                                ),
                              ),

                        // Balance -------------------------------------------
                        (OrderData["balance"] == null)
                            ? SizedBox()
                            : Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: themeBG2, width: 1.0)),
                                height: 35,
                                child: Row(
                                  children: [
                                    SizedBox(width: 40),
                                    Container(
                                        padding: EdgeInsets.all(2),
                                        width: 180,
                                        alignment: Alignment.center,
                                        child: Text("Balance",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: themeBG2))),
                                    Expanded(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: themeBG2)),
                                            padding: EdgeInsets.only(right: 10),
                                            alignment: Alignment.centerRight,
                                            child: Text("$Balance Rs /-",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: themeBG2)))),
                                  ],
                                ),
                              ),

                        ///////////  =============================================================================================
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 100)
        ],
      ),
    );

    /*return Container(
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
    );*/
  }
}

/// Class CLose
