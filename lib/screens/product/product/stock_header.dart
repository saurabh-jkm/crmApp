import 'package:crm_demo/themes/style.dart';
import 'package:crm_demo/themes/theme_widgets.dart';
import 'package:flutter/material.dart';

Widget themeHeader2(context, headerLable, {secondButton: '', buttonFn: ''}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
    decoration: BoxDecoration(color: themeBG2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back, color: Colors.white)),
              SizedBox(width: 20.0),
              Text("${headerLable}")
            ],
          ),
        ),
        (secondButton != '')
            ? Container(
                child: themeButton3(context, buttonFn,
                    label: 'Add New', radius: 5.0),
              )
            : SizedBox()
      ],
    ),
  );
}
