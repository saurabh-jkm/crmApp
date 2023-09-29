// ignore_for_file: camel_case_types, prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_typing_uninitialized_variables, library_private_types_in_public_api, avoid_print, prefer_const_constructors, file_names, unused_local_variable, sort_child_properties_last, avoid_web_libraries_in_flutter, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:crm_demo/themes/style.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';

// import 'dart:html' as html;

/// Represents Homepage for Navigation
class Invoice_pdf extends StatefulWidget {
  Invoice_pdf({Key? key, @required this.BytesCode}) : super(key: key);
  final BytesCode;

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
        child: SfPdfViewer.memory(widget.BytesCode),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.download),
        backgroundColor: Colors.green,
        onPressed: () {
          setState(() {
            downloadDocument();
          });
        },
      ),
    );
  }
}
