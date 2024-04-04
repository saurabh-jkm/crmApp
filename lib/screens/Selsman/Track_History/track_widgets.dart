// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, unnecessary_string_interpolations, sized_box_for_whitespace, avoid_unnecessary_containers, unnecessary_brace_in_string_interps, non_constant_identifier_names, deprecated_colon_for_default_value, unused_local_variable

import 'package:jkm_crm_admin/themes/function.dart';
import 'package:jkm_crm_admin/themes/style.dart';
import 'package:flutter/material.dart';

import '../../Invoice/view_invoice_screen-backup.dart';

// Order Table Row ==========================
Widget orderTableRow(context, data, srNo,
    {rowColor: '', textColor: '', controller: ''}) {
  List<dynamic> dataList = [];
  srNo++;

  dataList.add('');

  dataList.add('${(data['id'] == null) ? '-' : data['id']}');
  dataList.add('${(data['title'] == null) ? '-' : data['title']}');
  dataList.add('${(data['discount'] == null) ? '-' : data['discount']}');
  dataList.add('${(data['subtotal'] == null) ? '-' : data['subtotal']}');
  dataList.add('${(data['gst'] == null) ? '-' : data['gst']}');
  dataList.add('${(data['total'] == null) ? '-' : data['total']}');
  dataList.add(
      '${(data['date_at'] == null) ? '-' : formatDate(data['date_at'], formate: 'dd/MM/yyyy')}');
  dataList.add('action');

  return Container(
    margin: EdgeInsets.only(bottom: 1.0),
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    decoration: BoxDecoration(color: (rowColor == '') ? themeBG2 : rowColor),
    child: Row(
      children: [
        for (var i = 0; i < dataList.length; i++)
          (i == 0)
              ? Container(
                  width: 40.0,
                  child: Container(
                    child: Text("${srNo}",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: (textColor == '')
                                ? Color.fromARGB(255, 201, 201, 201)
                                : textColor)),
                  ),
                )
              : Expanded(
                  child: Container(
                    child: (dataList[i] == 'action')
                        ? Row(children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => viewInvoiceScreen(
                                              header_name:
                                                  "View Invoice Details",
                                              data: data)));
                                },
                                icon: Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Color.fromARGB(255, 49, 36, 163),
                                ),
                                tooltip: 'View')
                          ])
                        : Text("${dataList[i]}",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: (textColor == '')
                                    ? Color.fromARGB(255, 201, 201, 201)
                                    : textColor)),
                  ),
                ),
      ],
    ),
  );
}
