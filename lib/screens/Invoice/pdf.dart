// ignore_for_file: camel_case_types, prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_typing_uninitialized_variables, library_private_types_in_public_api, avoid_print, prefer_const_constructors, file_names, unused_local_variable, sort_child_properties_last, avoid_web_libraries_in_flutter, use_build_context_synchronously, unused_shown_name

import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:crm_demo/themes/style.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
// import 'dart:html' as html;

/// Represents Homepage for Navigation
class Invoice_pdf extends StatefulWidget {
  Invoice_pdf({Key? key, @required this.BytesCode, required this.PriceDetail})
      : super(key: key);
  final BytesCode;
  final PriceDetail;
  @override
  _Invoice_pdf createState() => _Invoice_pdf();
}

class _Invoice_pdf extends State<Invoice_pdf> {
  @override
  void initState() {
    // print("${widget.BytesCode}  +++++++");
    var base64 = base64Encode(widget.BytesCode);
    // print(base64);
    super.initState();
  }

  void downloadDocument() async {
    if (!kIsWeb && Platform.isWindows) {
      // for windows ==============================================
      final directory = await getDownloadsDirectory();
      final file = File("${directory?.path}/gitanjali-shop-invoice.pdf");
      final pdfBytes = widget.BytesCode;
      await file.writeAsBytes(pdfBytes.toList());
      themeAlert(context, "Successfully Downloaded !!");
    } else if (kIsWeb) {
      // for web ==============================================
      //final blob = html.Blob([widget.BytesCode]);
      // final url = html.Url.createObjectUrlFromBlob(blob);
      // final anchor = html.AnchorElement(href: url);
      // anchor.target = '_blank'; // Open in a new tab/window
      // anchor.download = 'sample_document.pdf'; // Set the desired file name
      // anchor.click(); // Trigger the download
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Invoice View'),
      ),
      body: Container(
        color: Colors.white,
        child: PdfPreview(
          build: (format) => _generatePdf(format, widget.PriceDetail),
        ),

        //SfPdfViewer.memory(widget.BytesCode),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.download),
      //   backgroundColor: Colors.green,
      //   onPressed: () {
      //     setState(() {
      //       downloadDocument();
      //     });
      //   },
      // ),
    );
  }
///////   Pdf  Print++++++++++++++++++++++++++++++++++++++++

  Future<Uint8List> _generatePdf(PdfPageFormat format, PriceDetail) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    Map tt = PriceDetail["products"];
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Stack(children: [
            if (PriceDetail["is_sale"] != null &&
                PriceDetail["is_sale"] == 'estimate')
              pw.Positioned(
                top: 200.0,
                child: pw.Text("${PriceDetail["is_sale"]}",
                    style: pw.TextStyle(
                        //color: PdfColors.black,
                        color: PdfColor.fromHex('#f2f2f2'),
                        fontSize: 100.0)),
              )
            else
              pw.SizedBox(),
            pw.Column(
              children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text("Invoice",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    ]),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Geetanjali Electromart Private Limited",
                            style: pw.TextStyle(
                                fontSize: 15,
                                fontWeight: pw.FontWeight.normal,
                                color: PdfColors.black)),
                        pw.Text("D-1/140, New Kondli, New Delhi 110096, India"),
                        pw.SizedBox(height: 5.0),
                        pw.Text("www.geetanjalielectromart.com",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                color: PdfColors.black)),
                        pw.Text("info@geetanjalielectromart.net",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                color: PdfColors.black)),
                      ],
                    ),
                    pw.Column(children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text("e-Invoice",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
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
                    child: pw.Row(children: [
                  pw.Expanded(
                      child: pw.Container(
                          padding: pw.EdgeInsets.all(4),
                          height: 80,
                          decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  color: PdfColors.black, width: 1)),
                          child: pw.Column(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("Customer Name",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.black)),
                                pw.Text("Mobile No.",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.black)),
                                pw.Text("Email Id",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.black)),
                                pw.Text("Address",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.black)),
                              ]))),
                  pw.Expanded(
                    child: pw.Container(
                        padding: pw.EdgeInsets.all(4),
                        height: 80,
                        decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                                color: PdfColors.black, width: 1)),
                        child: pw.Column(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text("${PriceDetail["customer_name"]}",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      color: PdfColors.black)),
                              pw.Text("${PriceDetail["mobile"]}",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      color: PdfColors.black)),
                              pw.Text("${PriceDetail["email"]}",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      color: PdfColors.black)),
                              pw.Text("${PriceDetail["address"]}",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      color: PdfColors.black)),
                            ])),
                  )
                ])),
                pw.Container(
                    child: pw.Row(children: [
                  pw.Expanded(
                      child: pw.Container(
                          padding: pw.EdgeInsets.all(4),
                          height: 40,
                          decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  color: PdfColors.black, width: 1)),
                          child: pw.Column(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                // Text("Invoice No.",
                                //     style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         color: PdfColors.black)),
                                pw.Text("Invoice Id",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.black)),
                                pw.Text("Dated",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.black)),
                              ]))),
                  pw.Expanded(
                      child: pw.Container(
                          height: 40,
                          padding: pw.EdgeInsets.all(4),
                          decoration: pw.BoxDecoration(
                            border:
                                pw.Border.all(color: PdfColors.black, width: 1),
                          ),
                          child: pw.Column(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                // Text("IN-120",
                                //     style: TextStyle(
                                //         fontSize: 11,
                                //         fontWeight: FontWeight.normal,
                                //         color: PdfColors.black)),
                                pw.Text("${PriceDetail["id"]}",
                                    style: pw.TextStyle(
                                        fontSize: 11,
                                        fontWeight: pw.FontWeight.normal,
                                        color: PdfColors.black)),
                                pw.Text("${PriceDetail["invoice_date"]}",
                                    style: pw.TextStyle(
                                        fontSize: 11,
                                        fontWeight: pw.FontWeight.normal,
                                        color: PdfColors.black)),
                              ])))
                ])),
                pw.SizedBox(height: 20),
                pw.Container(
                  decoration: pw.BoxDecoration(
                      border:
                          pw.Border.all(color: PdfColors.black, width: 1.0)),
                  height: 35,
                  child: pw.Row(
                    children: [
                      pw.Container(
                          padding: pw.EdgeInsets.all(5),
                          width: 40,
                          decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.black)),
                          alignment: pw.Alignment.center,
                          child: pw.Text("S.no.",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.black))),
                      pw.Container(
                          padding: pw.EdgeInsets.all(2),
                          width: 180,
                          decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.black)),
                          alignment: pw.Alignment.center,
                          child: pw.Text("Item Description",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.black))),
                      pw.Expanded(
                          child: pw.Container(
                              decoration: pw.BoxDecoration(
                                  border:
                                      pw.Border.all(color: PdfColors.black)),
                              alignment: pw.Alignment.center,
                              child: pw.Text("Price",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.black)))),
                      pw.Expanded(
                          child: pw.Container(
                              decoration: pw.BoxDecoration(
                                  border:
                                      pw.Border.all(color: PdfColors.black)),
                              alignment: pw.Alignment.center,
                              child: pw.Text("Qty.",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.black)))),
                      pw.Expanded(
                          child: pw.Container(
                              decoration: pw.BoxDecoration(
                                  border:
                                      pw.Border.all(color: PdfColors.black)),
                              alignment: pw.Alignment.center,
                              child: pw.Text("Disc ",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.black)))),
                      pw.Expanded(
                          child: pw.Container(
                              decoration: pw.BoxDecoration(
                                  border:
                                      pw.Border.all(color: PdfColors.black)),
                              alignment: pw.Alignment.center,
                              child: pw.Text("GST %",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.black)))),
                      pw.Expanded(
                          child: pw.Container(
                              decoration: pw.BoxDecoration(
                                  border:
                                      pw.Border.all(color: PdfColors.black)),
                              alignment: pw.Alignment.center,
                              child: pw.Text("Amount",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.black)))),
                    ],
                  ),
                ),
                pw.Container(
                  decoration: pw.BoxDecoration(
                      border:
                          pw.Border.all(color: PdfColors.black, width: 1.0)),
                  height: 100,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                          width: 40,
                          padding: pw.EdgeInsets.all(2),
                          decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  color: PdfColors.black, width: 1.0)),
                          alignment: pw.Alignment.topCenter,
                          child: pw.Column(children: [
                            for (var i = 0; i < tt.length; i++)
                              pw.Text("${"${i + 1}"}",
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.normal,
                                      color: PdfColors.black))
                          ])),
                      pw.Container(
                          padding: pw.EdgeInsets.all(2),
                          width: 180,
                          decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.black)),
                          alignment: pw.Alignment.topCenter,
                          child: pw.Column(children: [
                            for (var i = 0; i < tt.length; i++)
                              pw.Text("${tt["$i"]["name"]} ",
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.normal,
                                      color: PdfColors.black))
                          ])),
                      pw.Expanded(
                          child: pw.Container(
                              padding: pw.EdgeInsets.all(2),
                              decoration: pw.BoxDecoration(
                                  border:
                                      pw.Border.all(color: PdfColors.black)),
                              alignment: pw.Alignment.topCenter,
                              child: pw.Column(children: [
                                for (var i = 0; i < tt.length; i++)
                                  pw.Text("${tt["$i"]["price"]} ",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.normal,
                                          color: PdfColors.black))
                              ]))),
                      pw.Expanded(
                          child: pw.Container(
                              padding: pw.EdgeInsets.all(2),
                              decoration: pw.BoxDecoration(
                                  border:
                                      pw.Border.all(color: PdfColors.black)),
                              alignment: pw.Alignment.topCenter,
                              child: pw.Column(children: [
                                for (var i = 0; i < tt.length; i++)
                                  pw.Text("${tt["$i"]["quantity"]} ",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.normal,
                                          color: PdfColors.black))
                              ])
                              // for (var i = 1; i <= eedata.length; i++)
                              )),
                      pw.Expanded(
                          child: pw.Container(
                              padding: pw.EdgeInsets.all(2),
                              decoration: pw.BoxDecoration(
                                  border:
                                      pw.Border.all(color: PdfColors.black)),
                              alignment: pw.Alignment.topCenter,
                              child: pw.Column(children: [
                                for (var i = 0; i < tt.length; i++)
                                  pw.Text("${tt["$i"]["discount"]}",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.normal,
                                          color: PdfColors.black))
                              ]))),
                      pw.Expanded(
                          child: pw.Container(
                              padding: pw.EdgeInsets.all(2),
                              decoration: pw.BoxDecoration(
                                  border:
                                      pw.Border.all(color: PdfColors.black)),
                              alignment: pw.Alignment.topCenter,
                              child: pw.Column(children: [
                                for (var i = 0; i < tt.length; i++)
                                  pw.Text("${tt["$i"]["gst_per"]} %",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.normal,
                                          color: PdfColors.black))
                              ]))),
                      pw.Expanded(
                          child: pw.Container(
                              padding: pw.EdgeInsets.all(2),
                              decoration: pw.BoxDecoration(
                                  border:
                                      pw.Border.all(color: PdfColors.black)),
                              alignment: pw.Alignment.topCenter,
                              child: pw.Column(children: [
                                for (var i = 0; i < tt.length; i++)
                                  pw.Text("${tt["$i"]["total"]} /-",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.normal,
                                          color: PdfColors.black))
                              ])))
                    ],
                  ),
                ),

                pw.Container(
                  decoration: pw.BoxDecoration(
                      border:
                          pw.Border.all(color: PdfColors.black, width: 1.0)),
                  height: 35,
                  child: pw.Row(
                    children: [
                      pw.SizedBox(width: 40),
                      pw.Container(
                          padding: pw.EdgeInsets.all(2),
                          width: 180,
                          // decoration: BoxDecoration(
                          //     //   border: Border.all(color: PdfColors.black)
                          //     ),
                          alignment: pw.Alignment.center,
                          child: pw.Text("Total",
                              style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.black))),
                      pw.Expanded(
                          child: pw.Container(
                              decoration: pw.BoxDecoration(
                                  border:
                                      pw.Border.all(color: PdfColors.black)),
                              padding: pw.EdgeInsets.only(right: 10),
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text("${PriceDetail["total"]} Rs /-",
                                  style: pw.TextStyle(
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.black)))),
                    ],
                  ),
                ),

                ///////////  =============================================================================================
              ],
            )
          ]);
        },
      ),
    );

    return pdf.save();
  }
}
