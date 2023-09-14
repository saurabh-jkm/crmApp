import 'package:crm_demo/themes/function.dart';
import 'package:crm_demo/themes/style.dart';
import 'package:flutter/material.dart';

// table row
// Table Heading ==========================
Widget CustomerTableRow(context, data, srNo, orderList,
    {rowColor: '', textColor: ''}) {
  List<dynamic> dataList = [];

  dataList.add('1');
  dataList.add('${data['customer_name']}');
  dataList.add('${(data['email'] == null) ? '-' : data['email']}');
  dataList.add('${(data['phone'] == null) ? '-' : data['phone']}');
  if (orderList != null &&
      orderList.isNotEmpty &&
      orderList[data['id']] != null) {
    var orderTempData = orderList[data['id']];
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
                                onPressed: () {},
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
