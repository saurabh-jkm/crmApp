// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unused_import

import 'package:flutter/material.dart';
import 'package:jkm_crm_admin/themes/style.dart';
import 'package:jkm_crm_admin/themes/theme_widgets.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: GoogleText(
        text: "Error",
        color: Colors.white,
        fsize: 15.0,
      )),
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_rounded,
              color: const Color.fromARGB(255, 231, 24, 9),
              size: 80,
            ),
            SizedBox(
              height: 10,
            ),
            GoogleText(
                text: "Not available for this platform",
                fweight: FontWeight.bold,
                fsize: 20.0,
                fstyle: FontStyle.italic),
          ],
        )),
      ),
    );
  }
}
