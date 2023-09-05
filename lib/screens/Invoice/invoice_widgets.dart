import 'package:crm_demo/themes/style.dart';
import 'package:crm_demo/themes/theme_widgets.dart';
import 'package:flutter/material.dart';

Widget totalWidgets(context, label, value) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    margin: EdgeInsets.symmetric(horizontal: 3.0),
    decoration: BoxDecoration(
        color: Color.fromARGB(255, 240, 243, 245),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        border: Border.all(width: 0.6, color: themeBG2)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "$label",
          style:
              themeTextStyle(size: 10.0, fw: FontWeight.bold, color: themeBG2),
        ),
        Text(
          "$value",
          style: themeTextStyle(size: 16.0),
        )
      ],
    ),
  );
}
