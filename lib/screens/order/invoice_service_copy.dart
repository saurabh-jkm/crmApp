// ignore_for_file: prefer_const_constructors

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoiceService {
  Future<Uint8List> createInvoice() async {
    var myTheme = ThemeData.withFont(
      base: Font.ttf(await rootBundle.load("assets/OpenSans-Regular.ttf")),
    );
    final pdf = pw.Document(theme: myTheme);

    final image =
        (await rootBundle.load("assets/images/flutter_explained_logo.jpg"))
            .buffer
            .asUint8List();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(pw.MemoryImage(image),
                      width: 100, height: 100, fit: pw.BoxFit.cover),
                  pw.Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      pw.Text("Geetanjali Electromart Private Limited",
                          style: pw.TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: PdfColors.green400)),
                      pw.Text("D-1/140, New Kondli, New Delhi 110096, India"),
                      pw.SizedBox(height: 5.0),
                      pw.Text("www.geetanjalielectromart.com",
                          style: pw.TextStyle(
                              fontWeight: FontWeight.normal,
                              color: PdfColors.blue)),
                      pw.Text("info@geetanjalielectromart.net",
                          style: pw.TextStyle(
                              fontWeight: FontWeight.normal,
                              color: PdfColors.blue)),
                      pw.SizedBox(height: 5.0),
                      pw.Text("GSTIN: 07AAHCT5709R1ZL",
                          style: pw.TextStyle(fontWeight: FontWeight.bold)),
                      pw.Text("PAN: AAHCT5709R, CIN: U74999DL2019PTC356633",
                          style: pw.TextStyle(fontWeight: FontWeight.normal))
                    ],
                  )
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Text("Tax Invoice",
                  style:
                      pw.TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              pw.SizedBox(height: 8.0),
              pw.SizedBox(
                height: 80,
                child: pw.Row(
                  children: [
                    Expanded(
                      child: pw.Container(
                          padding: EdgeInsets.all(5),
                          decoration: pw.BoxDecoration(
                              border: Border.all(
                                  color: PdfColors.black, width: 1.5)),
                          child: pw.Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                pw.Text("Sold By",
                                    style: pw.TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: PdfColors.black)),
                                pw.SizedBox(height: 5),
                                pw.Text(
                                  "BK Vishwakarma1",
                                ),
                                pw.Text("9084928656"),
                                pw.Text("bkweb11@gmail.com",
                                    style: pw.TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: PdfColors.blue)),
                              ])),
                    ),
                    pw.SizedBox(width: 5),
                    Expanded(
                      child: pw.Container(
                          padding: EdgeInsets.all(5),
                          decoration: pw.BoxDecoration(
                              border: Border.all(
                                  color: PdfColors.black, width: 1.5)),
                          child: pw.Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                pw.Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text("Order Id :",
                                          style: pw.TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: PdfColors.black)),
                                      pw.Text("1123R09"),
                                    ]),
                                pw.Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text("Invoice Date :",
                                          style: pw.TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: PdfColors.black)),
                                      pw.Text("01/Apr/2023 04:18 pm"),
                                    ]),
                                pw.Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text("User ID :",
                                          style: pw.TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: PdfColors.black)),
                                      pw.Text("6000U79"),
                                    ]),
                              ])),
                    )
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
