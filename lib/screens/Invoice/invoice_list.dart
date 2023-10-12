// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_this, non_constant_identifier_names, unnecessary_cast, avoid_print, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, prefer_final_fields, override_on_non_overriding_member, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_null_comparison, unnecessary_brace_in_string_interps, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable, sort_child_properties_last, depend_on_referenced_packages, avoid_types_as_parameter_names, unused_field, curly_braces_in_flow_control_structures, prefer_is_empty, unnecessary_new, prefer_collection_literals, unused_local_variable, deprecated_member_use, unused_element, camel_case_types

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/screens/Invoice/add_supplier_invoice_screen.dart';
import 'package:crm_demo/screens/Invoice/edit_invoice.dart';
import 'package:crm_demo/screens/Invoice/pdf.dart';
import 'package:crm_demo/screens/Invoice/view_invoice_screen.dart';
import 'package:crm_demo/themes/base_controller.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:firedart/generated/google/firestore/v1/document.pb.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  List<String> itemList = ['All', 'Sale', 'Buy'];
  var selectedFilter = 'Sale';
  TextEditingController startDate_controller = new TextEditingController();
  TextEditingController toDate_controller = new TextEditingController();
  var tableColum = {};
  var headerName = {};

///////////////////////// Order List Data fetch fn ++++++++++++++++++++++++++++

  List OrderList = [];
  List finalOrderList = [];

  OrderList_data({filter: ''}) async {
    OrderList = [];
    setState(() {
      progressWidget = true;
    });

    Map<dynamic, dynamic> w = {
      'table': "order",
      'orderBy': "-date_at",
    };
    var temp;
    if (filter == 'date_filter') {
      //var newDate = todayTimeStamp_for_query();
      var dateFrom = themeCustomeDate(startDate_controller.text);
      var dateTo = themeCustomeDate(toDate_controller.text);

      // TODO Query
      var query;
      if (!kIsWeb && Platform.isWindows) {
        query = await Firestore.instance
            .collection('order')
            .where("date_at", isGreaterThan: dateFrom)
            .where("date_at", isLessThan: dateTo);
      } else {
        query = await FirebaseFirestore.instance
            .collection('order')
            .where("date_at", isGreaterThan: dateFrom)
            .where("date_at", isLessThan: dateTo);
      }

      temp = await dbRawQuery(query);
    } else {
      temp = await dbFindDynamic(db, w);
    }
    setState(() {
      temp.forEach((k, v) {
        v['date'] = formatDate(v['date_at'], formate: "dd/MM/yyyy");
        v['statusIs'] =
            (v['status'] != null && v['status']) ? 'Active' : 'InActive';
        OrderList.add(v);
      });
      finalOrderList = OrderList;

      progressWidget = false;
    });

    SearchFn(selectedFilter, filter: 'filter');
  }
////////////////////////////////////////========================================

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
      // final output = await getTemporaryDirectory();
      // var filePath = "${output.path}/$fileName.pdf";
      // final file = File(filePath);
      // await file.writeAsBytes(byteList);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Invoice_pdf(BytesCode: byteList, PriceDetail: PriceDetail),
        ),
      );
    }
  }

/////////////////////////=======================================================
/////////////////////////  Add New Invoice +++++++++++++++++++++++++++
  addNewInvoice() async {
    final temp = await Navigator.push(
        context,
        (selectedFilter == 'Buy')
            ? MaterialPageRoute(
                builder: (_) =>
                    addInvoiceSupplierScreen(header_name: "Supplier"))
            : MaterialPageRoute(
                builder: (_) => addInvoiceScreen(header_name: "Customer")));

    if (temp == 'updated') {
      OrderList_data();
    }
  }

/////////////////////////  View Invoice Details  +++++++++++++++++++++++++++++
  viewInvoice(data) async {
    final temp = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => viewInvoiceScreen(
                header_name: "View Invoice Details", data: data)));
    if (temp == 'updated') {
      OrderList_data();
    }
  }

/////////////////////////=======================================================
  var baseController = new base_controller();
  @override
  Widget build(BuildContext context) {
    var fw = MediaQuery.of(context).size.width;
    tableColum = {
      1: 50.0,
      2: 100.0,
      3: 100.0,
      4: fw * 0.17,
      5: fw * 0.07,
      6: 90.0,
      7: 40.0,
      8: 60.0,
      9: 60.0,
      10: 80.0,
      11: fw * 0.1,
      12: fw * 0.1,
    };

    headerName = {
      1: '#',
      2: 'Order Id',
      3: 'Type',
      4: 'Product',
      5: 'Buyer/Seller',
      6: 'Mobile',
      7: 'Qnt',
      8: 'Unit',
      9: 'Price',
      10: 'Status',
      11: 'Date',
      12: 'Action',
    };

    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (e) {
        var rData =
            baseController.KeyPressFun(e, context, backtype: 'dashboard');
        if (rData != null && rData) {
          setState(() {});
        }
      },
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: ListView(
            children: [
              //header ======================
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
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
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              OrderList_data();
                            },
                            icon: Icon(Icons.refresh),
                            tooltip: 'Refresh',
                          ),
                          SizedBox(width: 20.0),
                          themeButton3(context, addNewInvoice,
                              label: (selectedFilter == 'Buy')
                                  ? "Buy Now"
                                  : "Sale New",
                              radius: 5.0),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              (progressWidget == true)
                  ? Center(child: pleaseWait(context))
                  : listList(context, itemList)
            ],
          ),
        ),
      ),
    );
  }

//////// ///////////////////////////////// @1  List  of Order       ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Widget listList(BuildContext context, itemList) {
    var _number_select = 10;
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    color: themeBG4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Row(
                        //   children: [
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(
                        //           "Orders List",
                        //           style: themeTextStyle(
                        //               fw: FontWeight.bold,
                        //               color: Colors.white,
                        //               size: 15),
                        //         ),
                        //         SizedBox(
                        //           height: 20,
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),

                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              color: Color.fromARGB(255, 200, 247, 242),
                              child: Row(
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      padding: EdgeInsets.only(top: 14),
                                      height: 35,
                                      width: 140.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Colors.white),
                                      child: formTimeInput(
                                          context, startDate_controller,
                                          label: 'Date From',
                                          method: datePick,
                                          arg: 'fromDate')),
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      padding: EdgeInsets.only(top: 14),
                                      height: 35,
                                      width: 140.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Colors.white),
                                      child: formTimeInput(
                                          context, toDate_controller,
                                          label: 'Date To',
                                          method: datePick,
                                          arg: 'toDate')),
                                  themeButton3(context, fnFilterController,
                                      arg: 'date_filter',
                                      label: 'Filter',
                                      radius: 2.0,
                                      borderColor: Colors.transparent,
                                      buttonColor:
                                          Color.fromARGB(255, 12, 121, 194)),
                                ],
                              ),
                            ),
                          ],
                        ), // end date filter container

                        // Right side buttons
                        Row(
                          children: [
                            // date picker filter  ================================

                            //SizedBox(width: 10.0),

                            themeButton3(context, changeFilter,
                                arg: 'Sale',
                                label: 'Sale',
                                radius: 2.0,
                                borderColor: (selectedFilter == 'Sale')
                                    ? Colors.white
                                    : Colors.white,
                                buttonColor: (selectedFilter == 'Sale')
                                    ? Color.fromARGB(255, 4, 141, 134)
                                    : const Color.fromARGB(0, 110, 110, 110)),

                            SizedBox(width: 10.0),

                            themeButton3(context, changeFilter,
                                arg: 'Buy',
                                label: 'Buy',
                                radius: 2.0,
                                borderColor: (selectedFilter == 'Buy')
                                    ? Colors.green
                                    : Colors.white,
                                buttonColor: (selectedFilter == 'Buy')
                                    ? Color.fromARGB(255, 4, 141, 134)
                                    : const Color.fromARGB(0, 110, 110, 110)),

                            // Container(
                            //   height: 30,
                            //   width: 100.0,
                            //   padding: EdgeInsets.only(top: 6.0),
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(3.0),
                            //       color: Colors.white),
                            //   child: inpuDropdDown(
                            //       context, 'Filter', itemList, selectedFilter,
                            //       method: changeFilter, style: 2),
                            // ),
                            // search
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.only(top: 14),
                                height: 35,
                                width: 270.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white),
                                child: SearchBox(context,
                                    label: "Search", searchFn: SearchFn))
                          ],
                        ),
                      ],
                    )),
                SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: themeBG4,
                      border: Border(
                          bottom: BorderSide(width: 3.0, color: Colors.white))),
                  child: Row(
                    children: [
                      for (int i in headerName.keys)
                        tableLable(context, i, headerName[i], tableColum),
                    ],
                  ),
                ),

                /*Table(
                  columnWidths: {
                    0: FlexColumnWidth(0.2),
                    1: FlexColumnWidth(0.2),
                    2: FlexColumnWidth(0.3),
                    3: FlexColumnWidth(0.5),
                    4: FlexColumnWidth(0.6),
                    5: FlexColumnWidth(0.5),
                    6: FlexColumnWidth(0.2),
                    7: FlexColumnWidth(0.2),
                    8: FlexColumnWidth(0.2),
                    9: FlexColumnWidth(0.3),
                    10: FlexColumnWidth(0.4),
                    11: IntrinsicColumnWidth()
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder(
                    horizontalInside: BorderSide(width: .5, color: Colors.grey),
                  ),
                  children: [
                    TableRow(
                        decoration: BoxDecoration(color: themeBG4),
                        children: [
                          TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text('#',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text('OrderId',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0)),
                              ),
                              width: 40,
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text('Type',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0)),
                              ),
                              width: 40,
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text("Product",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0)),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text("Buyer Name",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0)),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text("Mobile no.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0)),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Qnt.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0)),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Unit",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0)),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Price",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0)),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text("Status",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0)),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text("Date",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0)),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text("Action",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0)),
                            ),
                          ),
                        ]),
                    // for (var index = 0; index < OrderList.length; index++)
                    //   tableRowWidget(
                    //       "${index + 1}",
                    //       OrderList[index]['id'],
                    //       OrderList[index]['customer_name'],
                    //       OrderList[index]['mobile'],
                    //       OrderList[index]['total'],
                    //       OrderList[index]['status'],
                    //       OrderList[index]['date_at'],
                    //       OrderList[index],
                    //       dbData: OrderList[index])
                  ],
                ),*/
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
                      dbData: OrderList[index])
              ],
            ),
          ),
        ],
      ),
    );
  }

///////////////////////////////////////////////

  tableRowWidget(String index, odID, user, buyer_mobile, _price, pro_status,
      pay_date, edata,
      {dbData: ''}) {
    var statuss = statusOF(pro_status);
    var productTitle = edata['title'];
    final formattedDate = formatDate(pay_date);
    var type =
        (edata['invoice_for'] == 'Customer' || edata['invoice_for'] == '')
            ? (edata['is_sale'] != null && edata['is_sale'] == 'Estimate')
                ? edata['is_sale']
                : "Sale"
            : (edata['is_sale'] != null && edata['is_sale'] == 'Estimate')
                ? "Buy\nEstimate"
                : "Buy";

    // if (_price == 5500) {
    //   print(edata['products']);
    // }
    var productList = edata['products'];
    var subList = {};
    if (productList.length > 1) {
      subList = productList;
    }
//////////////////// ++++++++++++++++++++++++++++++++++++++++++++++
    return Column(children: [
      //for
      Container(
          decoration: BoxDecoration(
              color: (matchString(type, 'Buy')) ? themeBG6 : themeBG5,
              border:
                  Border(bottom: BorderSide(width: 3.0, color: Colors.white))),
          child: Row(children: [
            Container(
              width: tableColum[1],
              child: Text(index, style: textStyle3),
            ),
            Container(
              width: tableColum[2],
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text("${edata['sr_no'] == null ? odID : edata['sr_no']}",
                    style: textStyle3),
              ),
            ),
            Container(
              width: tableColum[3],
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(child: Text("${type}", style: textStyle3)),
              ),
            ),
            Container(
              //verticalAlignment: TableCellVerticalAlignment.middle,
              width: tableColum[4],
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    child: Text("${productTitle}", style: textStyle3)),
              ),
            ),
            Container(
              width: tableColum[5],
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text('$user', style: textStyle3),
              ),
            ),
            Container(
              width: tableColum[6],
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text('$buyer_mobile', style: textStyle3),
              ),
            ),
            Container(
              width: tableColum[7],
              child: Text(
                  (edata['quantity'] != null) ? "${edata['quantity']}" : "-",
                  style: textStyle3),
            ),
            Container(
              width: tableColum[8],
              child: Text((edata['unit'] != null) ? "${edata['unit']}" : "-",
                  style: textStyle3),
            ),
            Container(
              width: tableColum[9],
              child:
                  Text((_price != null) ? "$_price" : "-", style: textStyle3),
            ),
            Container(
              width: tableColum[10],
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    margin: EdgeInsets.only(right: 20),
                    height: 25,
                    alignment: Alignment.center,
                    child: Text("$statuss",
                        style: GoogleFonts.alike(
                            color: (statuss == "Active")
                                ? Color.fromARGB(255, 10, 103, 139)
                                : const Color.fromARGB(255, 141, 28, 20),
                            fontSize: 12.5))),
              ),
            ),
            Container(
              width: tableColum[11],
              child: Text("$formattedDate", style: textStyle3),
            ),
            Container(
              width: tableColum[12],
              child: RowFor_Mobile_web(context, () async {
                final data = await InvoiceService(
                  PriceDetail: edata,
                ).createInvoice();
                // final data = await service.createInvoice();
                await savePdfFile("invoice", data, edata);
              }, () {
                setState(() {
                  viewInvoice(edata);
                });
              }, dbData: dbData),
            ),
          ])),

      for (var k in subList.keys)
        tableSubRow(context, k, subList[k], tableColum)
    ]);
  }

/////////////////////////////////////  Row GOt Action Button  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ///

  Widget RowFor_Mobile_web(BuildContext context, _invoice, _details_view,
      {dbData: ''}) {
    return Padding(
        padding: EdgeInsets.only(bottom: 1.0, right: 10.0),
        child: Row(
          children: [
            Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 10, 103, 139),
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
                  color: Color.fromARGB(255, 10, 103, 139),
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
                  color: Color.fromARGB(255, 10, 103, 139),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: IconButton(
                    onPressed: () async {
                      final temp = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => editInvoice(
                                    data: dbData,
                                    header_name: "Edit Invoice",
                                  )));
                      if (temp == 'updated') {
                        OrderList_data();
                      }
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.yellow,
                      size: 15,
                    ))),
          ],
        ));
  }

  // search ==================================================

  SearchFn(query, {filter: ''}) {
    List<String> searchField = [
      'id',
      'customer_name',
      'type',
      'title',
      'sr_no',
      'is_sale',
      'customer_mobile',
      'date',
      'statusIs'
    ];
    if (filter != '') {
      searchField = ['type'];
      query = (query == 'All') ? '' : query;
    }
    OrderList = [];

    finalOrderList.forEach((e) {
      bool isFind = false;
      searchField.forEach((key) {
        var val = '${e['$key']}';
        if (!isFind &&
            e['$key'] != null &&
            val.toLowerCase().contains(query.toLowerCase())) {
          OrderList.add(e);
          isFind = true;
        }
      });
    });
    setState(() {});
  }

  // date filter ===================================================
  fnFilterController(filter) {
    OrderList_data(filter: filter);
  }

  // change filter ===================================================
  changeFilter(val) {
    setState(() {
      selectedFilter = val;
      SearchFn(val, filter: 'filter');
    });
  }

  // date picker function =================================
  datePick(type) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      //print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        if (type == 'fromDate') {
          startDate_controller.text = formattedDate;
        } else if (type == 'toDate') {
          toDate_controller.text = formattedDate;
        }
      });
      FocusScope.of(context).requestFocus(FocusNode());
    } else {
      print("Date is not selected");
    }
  }

  // table header ===================================================
  Widget tableLable(context, i, label, tableColum) {
    return Container(
      width: tableColum[i],
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text('$label',
            style: themeTextStyle(
                size: 12.0, color: Colors.white, fw: FontWeight.bold)),
      ),
    );
  }

  Widget subTableLabel(context, i, label, tableColum) {
    return Container(
      width: tableColum[i],
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text('$label',
            style: themeTextStyle(size: 12.0, color: Colors.black)),
      ),
    );
  }

  // sub row =======================================================
  Widget tableSubRow(context, k, data, tableColum) {
    return Container(
      decoration: BoxDecoration(
          color: themeBG7,
          border: Border(bottom: BorderSide(width: 3.0, color: Colors.white))),
      child: Row(
        children: [
          subTableLabel(context, 1, '', tableColum),
          subTableLabel(context, 2, '', tableColum),
          subTableLabel(context, 3, '', tableColum),
          subTableLabel(context, 4, data['name'], tableColum),
          subTableLabel(context, 5, '', tableColum),
          subTableLabel(context, 6, '', tableColum),
          subTableLabel(context, 7, data['quantity'], tableColum),
          subTableLabel(context, 8, data['unit'], tableColum),
          subTableLabel(context, 9, data['price'], tableColum),
        ],
      ),
    );
  }

/////////////////////////////////////////////=====================================================
}

/// Class CLose
