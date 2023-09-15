import 'package:crm_demo/screens/Invoice/view_invoice_screen.dart';
import 'package:crm_demo/screens/customers/customer_all_order_list.dart';
import 'package:crm_demo/themes/function.dart';
import 'package:crm_demo/themes/style.dart';
import 'package:flutter/material.dart';

// table row
// Table Heading ==========================
Widget CustomerTableRow(context, data, srNo, orderList,
    {rowColor: '', textColor: '', controller: ''}) {
  List<dynamic> dataList = [];

  dataList.add('1');
  dataList.add('${data['customer_name']}');
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
                                  if (controller != '') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                CustomerAllOrderList(
                                                  data: orderTempData,
                                                  title: data['customer_name'],
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
      '${(data['date_at'] == null) ? '-' : formatDate(data['date_at'], formate: 'DD/MM/yyyy')}');
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
