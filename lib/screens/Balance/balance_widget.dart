// table header ===================================================
import 'package:flutter/material.dart';

import '../../themes/style.dart';

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
