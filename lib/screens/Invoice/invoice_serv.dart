// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names, prefer_typing_uninitialized_variables, depend_on_referenced_packages, unnecessary_cast, unnecessary_new, prefer_collection_literals, unnecessary_string_interpolations
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../../themes/function.dart';

String Date_at = DateFormat('dd-MM-yyyy').format(DateTime.now());

class InvoiceService {
  InvoiceService({
    this.PriceDetail,
  }) : super();

  final PriceDetail;

  Future<Uint8List> createInvoice() async {
    Map tt = PriceDetail["products"];
    var myTheme = ThemeData.withFont(
      base: Font.ttf(await rootBundle.load("assets/OpenSans-Regular.ttf")),
    );
    final pdf = pw.Document(theme: myTheme);

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
              Container(
                  child: pw.Row(children: [
                pw.Expanded(
                    child: Container(
                        padding: EdgeInsets.all(4),
                        height: 80,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: PdfColors.black, width: 1)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Customer Name",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: PdfColors.black)),
                              Text("Mobile No.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: PdfColors.black)),
                              Text("Email Id",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: PdfColors.black)),
                              Text("Address",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: PdfColors.black)),
                            ]))),
                pw.Expanded(
                  child: pw.Container(
                      padding: EdgeInsets.all(4),
                      height: 80,
                      decoration: BoxDecoration(
                          border: Border.all(color: PdfColors.black, width: 1)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            pw.Text("${PriceDetail["customer_name"]}",
                                style: pw.TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: PdfColors.black)),
                            pw.Text("${PriceDetail["mobile"]}",
                                style: pw.TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: PdfColors.black)),
                            pw.Text("${PriceDetail["email"]}",
                                style: pw.TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: PdfColors.black)),
                            pw.Text("${PriceDetail["address"]}",
                                style: pw.TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: PdfColors.black)),
                          ])),
                )
              ])),
              Container(
                  child: pw.Row(children: [
                pw.Expanded(
                    child: Container(
                        padding: EdgeInsets.all(4),
                        height: 60,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: PdfColors.black, width: 1)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Invoice No.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: PdfColors.black)),
                              Text("Invoice Id",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: PdfColors.black)),
                              Text("Dated",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: PdfColors.black)),
                            ]))),
                pw.Expanded(
                    child: Container(
                        height: 60,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: PdfColors.black, width: 1),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("IN-120",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal,
                                      color: PdfColors.black)),
                              Text("${PriceDetail["id"]}",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal,
                                      color: PdfColors.black)),
                              Text("${PriceDetail["invoice_date"]}",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal,
                                      color: PdfColors.black)),
                            ])))
              ])),
              pw.SizedBox(height: 20),
              pw.Container(
                decoration: pw.BoxDecoration(
                    border: Border.all(color: PdfColors.black, width: 1.0)),
                height: 35,
                child: pw.Row(
                  children: [
                    Container(
                        padding: EdgeInsets.all(5),
                        width: 40,
                        decoration: BoxDecoration(
                            border: Border.all(color: PdfColors.black)),
                        alignment: Alignment.center,
                        child: Text("S.no.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: PdfColors.black))),
                    Container(
                        padding: EdgeInsets.all(2),
                        width: 180,
                        decoration: BoxDecoration(
                            border: Border.all(color: PdfColors.black)),
                        alignment: Alignment.center,
                        child: Text("Item Description",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: PdfColors.black))),
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
                            child: Text("Qty.",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black)))),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.center,
                            child: Text("Disc ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black)))),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.center,
                            child: Text("GST %",
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
                            border:
                                Border.all(color: PdfColors.black, width: 1.0)),
                        alignment: Alignment.topCenter,
                        child: Column(children: [
                          for (var i = 0; i < tt.length; i++)
                            Text("${"${i + 1}"}",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                    color: PdfColors.black))
                        ])),
                    pw.Container(
                        padding: EdgeInsets.all(2),
                        width: 180,
                        decoration: BoxDecoration(
                            border: Border.all(color: PdfColors.black)),
                        alignment: Alignment.topCenter,
                        child: Column(children: [
                          for (var i = 0; i < tt.length; i++)
                            Text("${tt["$i"]["name"]} ",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                    color: PdfColors.black))
                        ])),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.topCenter,
                            child: Column(children: [
                              for (var i = 0; i < tt.length; i++)
                                Text("${tt["$i"]["price"]} ",
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
                            alignment: Alignment.topCenter,
                            child: Column(children: [
                              for (var i = 0; i < tt.length; i++)
                                Text("${tt["$i"]["quantity"]} ",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                        color: PdfColors.black))
                            ])
                            // for (var i = 1; i <= eedata.length; i++)
                            )),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            alignment: Alignment.topCenter,
                            child: Column(children: [
                              for (var i = 0; i < tt.length; i++)
                                Text("${tt["$i"]["discount"]}",
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
                            alignment: Alignment.topCenter,
                            child: Column(children: [
                              for (var i = 0; i < tt.length; i++)
                                Text("${tt["$i"]["gst_per"]} %",
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
                            alignment: Alignment.topCenter,
                            child: Column(children: [
                              for (var i = 0; i < tt.length; i++)
                                Text("${tt["$i"]["total"]} /-",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                        color: PdfColors.black))
                            ])))
                  ],
                ),
              ),

              pw.Container(
                decoration: pw.BoxDecoration(
                    border: Border.all(color: PdfColors.black, width: 1.0)),
                height: 35,
                child: pw.Row(
                  children: [
                    SizedBox(width: 40),
                    Container(
                        padding: EdgeInsets.all(2),
                        width: 180,
                        // decoration: BoxDecoration(
                        //     //   border: Border.all(color: PdfColors.black)
                        //     ),
                        alignment: Alignment.center,
                        child: Text("Total",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: PdfColors.black))),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: PdfColors.black)),
                            padding: EdgeInsets.only(right: 10),
                            alignment: Alignment.centerRight,
                            child: Text("${PriceDetail["total"]} Rs /-",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black)))),
                  ],
                ),
              ),

              ///////////  =============================================================================================
            ],
          );
        },
      ),
    );
    return pdf.save();
  }
}
