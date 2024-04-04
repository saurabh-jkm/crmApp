// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, non_constant_identifier_names, deprecated_colon_for_default_value, prefer_typing_uninitialized_variables

import 'package:jkm_crm_admin/screens/customers/customer_all_order_list.dart';
import 'package:jkm_crm_admin/themes/function.dart';
import 'package:jkm_crm_admin/themes/style.dart';
import 'package:flutter/material.dart';

// table row
// Table Heading ==========================
Widget CustomerTableRow(context, data, srNo, orderList,
    {rowColor: '', textColor: '', controller: ''}) {
  List<dynamic> dataList = [];

  dataList.add('1');
  dataList.add('${data['name']}');
  dataList.add('${(data['type'] == null) ? "-" : data['type']}');
  dataList.add('${(data['email'] == null) ? '-' : data['email']}');
  dataList.add('${(data['phone'] == null) ? '-' : data['phone']}');
  var orderTempData;
  if (orderList != null &&
      orderList.isNotEmpty &&
      orderList[data['id']] != null) {
    orderTempData = orderList[data['id']];
    // total order
    dataList.add(
        '${(orderTempData['no_of_order'] == null) ? '-' : orderTempData['no_of_order']}');
    //  total pay
    dataList.add(
        '${(orderTempData['total_pay_order'] == null) ? '-' : orderTempData['total_pay_order']}');
  } else {
    dataList.add('-');
    dataList.add('-');
  }

  dataList.add('${(data['addresss'] == null) ? '-' : data['addresss']}');
  dataList.add('${(data['status']) ? "Active" : "Disabled"}');
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
              ? SizedBox(
                  width: 40.0,
                  child: SizedBox(
                    child: Text("$srNo",
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
                                  if (controller != '') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                CustomerAllOrderList(
                                                  data: orderTempData,
                                                  title: data['name'],
                                                )));
                                    // controller.fnViewOrderDetails(
                                    //   context,orderTempData
                                    // );
                                  }
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
