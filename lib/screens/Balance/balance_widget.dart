// table header ===================================================
// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:flutter/material.dart';

import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';

Widget tableLable(context, i, label, tableColum) {
  return Expanded(
    // width: tableColum[i],
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text('$label',
          style: themeTextStyle(
              size: 12.0, color: Colors.black, fw: FontWeight.bold)),
    ),
  );
}

Widget headerB(BuildContext context, Title) {
  return Container(
    child: Row(
      children: [
        GestureDetector(
          onTap: () async {},
          child: Icon(
            Icons.view_list_sharp,
            size: 35,
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 10.0),
        GoogleText(text: "$Title", color: Colors.white)
      ],
    ),
  );
}
