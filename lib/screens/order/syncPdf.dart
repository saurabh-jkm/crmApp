// ignore_for_file: camel_case_types, prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_typing_uninitialized_variables, library_private_types_in_public_api, avoid_print, prefer_const_constructors, file_names, unused_local_variable, sort_child_properties_last, avoid_web_libraries_in_flutter, use_super_parameters

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'dart:html' as html;

/// Represents Homepage for Navigation
class PDFview_Web_mobile extends StatefulWidget {
  PDFview_Web_mobile({Key? key, @required this.BytesCode}) : super(key: key);
  final BytesCode;

  @override
  _PDFview_Web_mobile createState() => _PDFview_Web_mobile();
}

class _PDFview_Web_mobile extends State<PDFview_Web_mobile> {
  @override
  void initState() {
    // print("${widget.BytesCode}  +++++++");
    var base64 = base64Encode(widget.BytesCode);
    // print(base64);
    super.initState();
  }

  // void downloadDocument() {
  //   final blob = html.Blob([widget.BytesCode]);
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //   final anchor = html.AnchorElement(href: url);
  //   anchor.target = '_blank'; // Open in a new tab/window
  //   anchor.download = 'sample_document.pdf'; // Set the desired file name
  //   anchor.click(); // Trigger the download
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Invoice View'),
      ),
      body: Container(
        color: Colors.white,

        child:
            // ListView(
            //   children: [
            //   Text("${base64Encode(widget.BytesCode)} " ,style: TextStyle(color: Colors.black),),
            SfPdfViewer.memory(widget.BytesCode),
        //  ],
        // )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.download),
        backgroundColor: Colors.green,
        onPressed: () {
          setState(() {
            // downloadDocument();
          });
        },
      ),
    );
  }
}
