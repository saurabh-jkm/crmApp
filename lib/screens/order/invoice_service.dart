// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names, prefer_typing_uninitialized_variables, depend_on_referenced_packages, unnecessary_cast, unnecessary_new, prefer_collection_literals, unnecessary_string_interpolations
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

String Date_at = DateFormat('dd-MM-yyyy').format(DateTime.now());

class PdfInvoiceService {
  const PdfInvoiceService(
      {required this.buyername,
      required this.orderID,
      required this.category,
      required this.oderDate,
      required this.BuyerMobile,
      required this.BuyerEmail,
      required this.BuyerAddress,
      required this.PriceDetail})
      : super();
  final Map PriceDetail;

  final orderID;

  final category;
  final oderDate;
  final buyername;
  final BuyerMobile;
  final BuyerEmail;
  final BuyerAddress;

  Future<Uint8List> createInvoice() async {
    var ffff = PriceDetail as Map;
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

    var myTheme = ThemeData.withFont(
      base: Font.ttf(await rootBundle.load("assets/OpenSans-Regular.ttf")),
    );
    final pdf = pw.Document(theme: myTheme);
    // final image =
    //     (await rootBundle.load("assets/images/qrr.png")).buffer.asUint8List();
    final qrrrImage = pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                pw.Text("Invoice",
                    style: pw.TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25)),
              ]),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      pw.Text("Geetanjali Electromart Private Limited",
                          style: pw.TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: PdfColors.black)),
                      pw.Text("D-1/140, New Kondli, New Delhi 110096, India"),
                      pw.SizedBox(height: 5.0),
                      pw.Text("www.geetanjalielectromart.com",
                          style: pw.TextStyle(
                              fontWeight: FontWeight.normal,
                              color: PdfColors.black)),
                      pw.Text("info@geetanjalielectromart.net",
                          style: pw.TextStyle(
                              fontWeight: FontWeight.normal,
                              color: PdfColors.black)),
                    ],
                  ),
                  pw.Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      pw.Text("e-Invoice",
                          style: pw.TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                    /////// Invoice Data fetch  ++++++++
                    pw.BarcodeWidget(
                        data: "https://insaaf99.com/",
                        barcode: pw.Barcode.qrCode(),
                        width: 80,
                        height: 80),
                    ////////  ============================
                  ])
                ],
              ),

              pw.SizedBox(height: 20),
              pw.Container(
                decoration: pw.BoxDecoration(
                    border: Border.all(color: PdfColors.black, width: 1.0)),
                height: 250,
                child: pw.Row(
                  children: [
                    Expanded(
                      child: pw.Container(
                          decoration: pw.BoxDecoration(
                              border: Border.all(
                                  color: PdfColors.black, width: 0.5)),
                          child: pw.Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                pw.Container(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          pw.Text("Mr. $buyername",
                                              style: pw.TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: PdfColors.black)),
                                          pw.Text("$BuyerMobile",
                                              style: pw.TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: PdfColors.black)),
                                          pw.Text("$BuyerEmail",
                                              style: pw.TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: PdfColors.black)),
                                        ])),
                                pw.Divider(color: PdfColors.black),
                                pw.Container(
                                  padding: EdgeInsets.all(4),
                                  child: pw.Text("$BuyerAddress",
                                      style: pw.TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: PdfColors.black)),
                                )
                              ])),
                    ),
                    Expanded(
                      child: pw.Container(
                          decoration: pw.BoxDecoration(
                              border: Border.all(
                                  color: PdfColors.black, width: 0.5)),
                          child: pw.Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    child: pw.Row(children: [
                                  pw.Expanded(
                                      child: Container(
                                          padding: EdgeInsets.all(4),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: PdfColors.black)),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Invoice No.",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            PdfColors.black)),
                                                Text("IN-120",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            PdfColors.black)),
                                              ]))),
                                  pw.Expanded(
                                      child: Container(
                                          height: 50,
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: PdfColors.black),
                                          ),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Dated",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            PdfColors.black)),
                                                Text("$Date_at",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            PdfColors.black)),
                                              ])))
                                ])),
                                Container(
                                    child: pw.Row(children: [
                                  pw.Expanded(
                                      child: Container(
                                          padding: EdgeInsets.all(4),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: PdfColors.black)),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Order Id",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            PdfColors.black)),
                                                Text("$orderID",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            PdfColors.black)),
                                              ]))),
                                  pw.Expanded(
                                      child: Container(
                                          height: 50,
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: PdfColors.black),
                                          ),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Order Date",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            PdfColors.black)),
                                                Text("$oderDate",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            PdfColors.black)),
                                              ])))
                                ])),
                                Container(
                                    child: pw.Row(children: [
                                  pw.Expanded(
                                      child: Container(
                                          padding: EdgeInsets.all(4),
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: PdfColors.black)),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Buyer's ID ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            PdfColors.black)),
                                                Text("$orderID",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            PdfColors.black)),
                                              ]))),
                                  pw.Expanded(
                                      child: Container(
                                          height: 50,
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: PdfColors.black),
                                          ),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Buy's Date",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            PdfColors.black)),
                                                Text("01/Apr/2023 04:18 pm",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            PdfColors.black)),
                                              ])))
                                ])),
                                // +++
                              ])),
                    )
                  ],
                ),
              ),

              pw.Container(
                decoration: pw.BoxDecoration(
                    border: Border.all(color: PdfColors.black, width: 1.0)),
                height: 35,
                child: pw.Row(
                  children: [
                    Container(
                        padding: EdgeInsets.all(2),
                        width: 40,
                        decoration: BoxDecoration(
                            border: Border.all(color: PdfColors.black)),
                        alignment: Alignment.center,
                        child: Text("S.No.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: PdfColors.black))),
                    Container(
                        padding: EdgeInsets.all(2),
                        width: 180,
                        decoration: BoxDecoration(
                            border: Border.all(color: PdfColors.black)),
                        alignment: Alignment.center,
                        child: Text("Description of Goods",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: PdfColors.black))),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.center,
                            child: Text("Quantity",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black)))),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.center,
                            child: Text("Price",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black)))),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.center,
                            child: Text("GST",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black)))),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.center,
                            child: Text("Disc %",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black)))),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.center,
                            child: Text("Amount",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black)))),
                  ],
                ),
              ),
              pw.Container(
                decoration: pw.BoxDecoration(
                    border: Border.all(color: PdfColors.black, width: 1.0)),
                height: 100,
                child: pw.Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 40,
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            border: Border.all(color: PdfColors.black)),
                        alignment: Alignment.topLeft,
                        child: Text("1")),
                    pw.Container(
                        padding: EdgeInsets.all(2),
                        width: 180,
                        decoration: BoxDecoration(
                            border: Border.all(color: PdfColors.black)),
                        alignment: Alignment.topLeft,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var i = 1; i <= PriceDetail.length; i++)
                                Text("${ff["Product No. ${i}___product_name"]}",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: PdfColors.black))
                            ])),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.topLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var i = 1; i <= PriceDetail.length; i++)
                                    Text("${ff["Product No. ${i}___quantity"]}",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: PdfColors.black))
                                ]))),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.topLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var i = 1; i <= PriceDetail.length; i++)
                                    Text("${ff["Product No. ${i}___price"]}",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.normal,
                                            color: PdfColors.black))
                                ]))),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.topLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var i = 1; i <= PriceDetail.length; i++)
                                    Text("${ff["Product No. ${i}___gst"]}",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.normal,
                                            color: PdfColors.black))
                                ]))),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.topLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var i = 1; i <= PriceDetail.length; i++)
                                    Text("${ff["Product No. ${i}___discount"]}",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.normal,
                                            color: PdfColors.black))
                                ]))),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.topLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var i = 1; i <= PriceDetail.length; i++)
                                    Text(
                                        "${ff["Product No. ${i}___total_price"]}",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.normal,
                                            color: PdfColors.black))
                                ]))),
                  ],
                ),
              ),

              pw.Container(
                decoration: pw.BoxDecoration(
                    border: Border.all(color: PdfColors.black, width: 1.0)),
                height: 35,
                child: pw.Row(
                  children: [
                    Container(
                        padding: EdgeInsets.all(2),
                        width: 40,
                        decoration: BoxDecoration(
                            border: Border.all(color: PdfColors.black)),
                        alignment: Alignment.center,
                        child: Text("")),
                    Container(
                        padding: EdgeInsets.all(2),
                        width: 180,
                        decoration: BoxDecoration(
                            border: Border.all(color: PdfColors.black)),
                        alignment: Alignment.center,
                        child: Text("Total",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: PdfColors.black))),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.center,
                            child: Text("2",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black)))),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.center,
                            child: Text(""))),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.center,
                            child: Text(""))),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.center,
                            child: Text(""))),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.center,
                            child: Text("2400 rs",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black)))),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              ///////  Price detailes ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
              pw.Container(
                  padding: EdgeInsets.all(1.2),
                  color: PdfColors.blue900,
                  child: pw.Column(children: [
                    pw.Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 35,
                      child: pw.Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Product Name",
                                style: pw.TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.white)),
                            pw.Text("Amount (INR)",
                                style: pw.TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.white)),
                          ]),
                    ),
                    pw.Container(
                      height: 35,
                      margin: EdgeInsets.symmetric(vertical: 1),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      color: PdfColors.white,
                      child: pw.Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Red 60v",
                                style: pw.TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black)),
                            pw.Text("593 Rs"),
                          ]),
                    ),
                    pw.Container(
                      height: 35,
                      margin: EdgeInsets.symmetric(vertical: 1),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      color: PdfColors.white,
                      child: pw.Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Shipping Charges",
                                style: pw.TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black)),
                            pw.Text("20 Rs"),
                          ]),
                    ),
                    pw.Container(
                      height: 35,
                      margin: EdgeInsets.symmetric(vertical: 1),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      color: PdfColors.white,
                      child: pw.Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Invoice Amount",
                                style: pw.TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black)),
                            pw.Text("613 Rs"),
                          ]),
                    ),
                  ])),
              ///////////=============================================================================================

              /////////  Payment details +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
              // CustomRow("Payment Date", "Payment type", "Payment Reference ID", "Payment Amount (INR)",""),

              pw.SizedBox(height: 20),
              pw.Container(
                  padding: EdgeInsets.all(1.2),
                  color: PdfColors.blue900,
                  child: pw.Column(children: [
                    pw.Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 35,
                      child: pw.Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Payment Date",
                                style: pw.TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: PdfColors.white)),
                            pw.Text("Payment type",
                                style: pw.TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: PdfColors.white)),
                            pw.Text("Reference ID",
                                style: pw.TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: PdfColors.white)),
                            pw.Text("Amount (INR)",
                                style: pw.TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: PdfColors.white)),
                          ]),
                    ),
                    pw.Container(
                      height: 35,
                      margin: EdgeInsets.symmetric(vertical: 1),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      color: PdfColors.white,
                      child: pw.Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            pw.Text("2023-04-01 16:17:49",
                                style: pw.TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black)),
                            pw.Container(width: 1, color: PdfColors.blue900),
                            pw.Text("upi",
                                style: pw.TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black)),
                            pw.Container(width: 1, color: PdfColors.blue900),
                            pw.Text("pay_LYV40eMjJ1TYpe",
                                style: pw.TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black)),
                            pw.Container(width: 1, color: PdfColors.blue900),
                            pw.Text("613 Rs",
                                style: pw.TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black)),
                          ]),
                    ),
                  ])),

              ///////////  =============================================================================================
            ],
          );
        },
      ),
    );
    return pdf.save();
  }
}
