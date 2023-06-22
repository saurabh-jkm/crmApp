import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
    print(base64);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 20),
        child:
            // ListView(
            //   children: [
            //   Text("${base64Encode(widget.BytesCode)} " ,style: TextStyle(color: Colors.black),),
            SfPdfViewer.memory(widget.BytesCode),
        //  ],
        // )
      ),
    );
  }
}
