// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';

///////  Text_field 22 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
///
Widget Text_field(BuildContext context, ctr_name, lebel, hint) {
  return Container(
      height: 40,
      margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: ctr_name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please Enter value';
          }
        },
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          hintText: '$hint',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ));
}
///////////