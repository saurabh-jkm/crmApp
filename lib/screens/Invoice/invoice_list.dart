// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_this, non_constant_identifier_names, unnecessary_cast, avoid_print, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, prefer_final_fields, override_on_non_overriding_member, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_null_comparison, unnecessary_brace_in_string_interps, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable, sort_child_properties_last, depend_on_referenced_packages, avoid_types_as_parameter_names, unused_field, curly_braces_in_flow_control_structures, prefer_is_empty, unnecessary_new, prefer_collection_literals, unused_local_variable, deprecated_member_use, unused_element

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/screens/Invoice/pdf.dart';
import 'package:crm_demo/screens/Invoice/view_invoice_screen.dart';
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

import '../order/invoice_service.dart';
import '../order/syncPdf.dart';
import 'add_invoice_screen.dart';
import 'invoice_serv.dart';

// ignore: camel_case_types
class Invoice_List extends StatefulWidget {
  const Invoice_List({super.key});

  @override
  State<Invoice_List> createState() => _Invoice_ListState();
}

class _Invoice_ListState extends State<Invoice_List> {
  final _controllers = TextEditingController();
  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;
  @override
  void initState() {
    OrderList_data();
    super.initState();
  }

////////////  Product data fetch  ++++++++++++++++++++++++++++++++++++++++++++
  bool progressWidget = true;

///////////////////////// Order List Data fetch fn ++++++++++++++++++++++++++++

  List OrderList = [];
  OrderList_data() async {
    OrderList = [];
    Map<dynamic, dynamic> w = {
      'table': "order",
    };
    var temp = await dbFindDynamic(db, w);
    setState(() {
      temp.forEach((k, v) {
        OrderList.add(v);
      });

      progressWidget = false;
    });
    print("$OrderList  ++++++++");
  }
////////////////////////////////////////========================================

  ///////// PDF  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    if (kIsWeb) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Invoice_pdf(BytesCode: byteList),
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
          builder: (context) => Invoice_pdf(BytesCode: byteList),
        ),
      );
    }
  }

/////////////////////////=======================================================
/////////////////////////  Add New Invoice +++++++++++++++++++++++++++
  addNewInvoice() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => addInvoiceScreen(header_name: "Add New Invoice")));
  }

/////////////////////////  View Invoice Details  +++++++++++++++++++++++++++++
  viewInvoice(data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => viewInvoiceScreen(
                header_name: "View Invoice Details", data: data)));
  }
/////////////////////////=======================================================

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
                              Text("Invoice List", style: GoogleFonts.alike())
                            ],
                          ),
                        ),
                        Container(
                          child: themeButton3(context, addNewInvoice,
                              label: 'Add New', radius: 5.0),
                        )
                      ],
                    ),
                  ),

                  listList(context)
                ],
              ),
            ),
          );
  }

//////// ///////////////////////////////// @1  List  of Order       ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Widget listList(BuildContext context) {
    var _number_select = 10;
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius:
        //     const BorderRadius.all(Radius.circular(10)),
      ),
      child: ListView(
        children: [
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
                                    child: Text("Mobile no.",
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
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Date",
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
                      tableRowWidget(
                        "${index + 1}",
                        OrderList[index]['id'],
                        OrderList[index]['customer_name'],
                        OrderList[index]['mobile'],
                        OrderList[index]['total'],
                        OrderList[index]['status'],
                        OrderList[index]['date_at'],
                        OrderList[index],
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

///////////////////////////////////////////////
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

  TableRow tableRowWidget(String index, odID, user, buyer_mobile, _price,
      pro_status, pay_date, edata) {
    var statuss = statusOF(pro_status);
//////// Product Detailll ++++++++++++++++++++++
    // var pricett = price_de(price_details);
    // print("$price_details  ++++");
    final formattedDate = formatDate(pay_date);
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
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text('$buyer_mobile',
              style: GoogleFonts.alike(
                  fontWeight: FontWeight.normal, fontSize: 11)),
        ),
      ),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text((_price != null) ? "$_price.0 ₹" : "--/--",
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
                color: (statuss == "Active")
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Text("$statuss",
                  style: GoogleFonts.alike(
                      color: (statuss == "Active") ? Colors.green : Colors.red,
                      fontSize: 12.5))),
        ),
      ),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text("$formattedDate",
              style: GoogleFonts.alike(color: Colors.white, fontSize: 11))),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: RowFor_Mobile_web(
          context,
          () async {
            final data = await InvoiceService(
              PriceDetail: edata,
            ).createInvoice();
            // final data = await service.createInvoice();
            await savePdfFile("invoice", data);
          },
          () {
            setState(() {
              viewInvoice(edata);
              //  _Details_wd = true;
              // priceData["order_id"] = "$odID";
              // priceData["oder_Date"] = "$pay_date";
              // priceData["buyer_name"] = "$user";
              // priceData["buyer_mobile"] = "$buyer_mobile";
              // priceData["buyer_address"] = "$buyer_address";
              // priceData["buyer_email"] = "$buyer_email";
              // priceData["Pro_name"] = "${pricett["Pro_name"]}";
              // priceData["Pro_quantity"] = "${pricett["quantity"]}";
              // priceData["Pro_price"] = "${pricett["price"]}";
              // priceData["Pro_gst"] = "${pricett["Pro_gst"]}";
              // priceData["total_price"] = "${pricett["Pro_total_price"]}";

              // priceData["product_details"] = price_details;
            });
          },
          () {
            setState(() {
              // _Update_wd = true;
              // _Order_ID = odID;
              // Update_initial(odID);
            });
          },
        ),
      ),
    ]);
  }

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
}

/// Class CLose
