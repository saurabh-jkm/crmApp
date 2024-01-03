// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, prefer_final_fields, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_null_comparison, sort_child_properties_last, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, depend_on_referenced_packages, avoid_print, unnecessary_new, unused_field, unused_label, unrelated_type_equality_checks, file_names, unnecessary_cast
import 'package:jkm_crm_admin/screens/Invoice/view_invoice_details.dart';
import 'package:jkm_crm_admin/screens/customers/customer_controller.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../themes/function.dart';
import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';
import '../Invoice/invoice_controller.dart';
import '../Invoice/invoice_serv.dart';
import '../Invoice/pdf.dart';

class CustomerAllOrderList extends StatefulWidget {
  const CustomerAllOrderList({super.key, @required this.data, this.title});
  final data;
  final title;

  @override
  State<CustomerAllOrderList> createState() => _CustomerAllOrderListState();
}

class _CustomerAllOrderListState extends State<CustomerAllOrderList> {
  var controllerr = new orderController();
  bool isWait = true;

  initFunction() async {
    if (widget.data != null) {
      await controllerr.fn_set_order(widget.data['orderList']);
    }
    setState(() {
      isWait = false;
    });
  }

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  Future<void> savePdfFile(
      String fileName, Uint8List byteList, PriceDetail) async {
    if (kIsWeb) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Invoice_pdf(BytesCode: byteList, PriceDetail: PriceDetail),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Invoice_pdf(BytesCode: byteList, PriceDetail: PriceDetail),
        ),
      );
    }
  }

  var controller = new invoiceController();
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (e) {
        var rData = controller.cntrKeyPressFun(e, context);
        if (rData != null && rData) {
          setState(() {});
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.title}"),
          backgroundColor: themeBG2,
        ),
        body: (isWait)
            ? pleaseWait(context)
            : Container(
                color: themeBG2,
                child: Column(
                  children: [CustomerList(context, controllerr)],
                ),
              ),
      ),
    );
  }

  // Body Part =================================================
  Widget CustomerList(context, controller) {
    return Container(
      height: MediaQuery.of(context).size.height - 70,
      color: Colors.white,
      child: (widget.data == null || widget.data['orderList'].isEmpty)
          ? Container(
              child: Center(
                child: Text(
                  "No have any order !!",
                  style: themeTextStyle(
                      color: const Color.fromARGB(255, 51, 45, 44)),
                ),
              ),
            )
          : ListView(
              children: [
                // search
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 60.0,
                        width: 220.0,
                        child: inputSearch(
                            context, controller.searchTextController, 'Search',
                            method: fnSearch),
                      )
                    ],
                  ),
                ),
                // table start

                TableHeading(context, controller.orderHeadintList,
                    rowColor: Color.fromARGB(255, 94, 86, 204),
                    textColor: Colors.white),
                for (var i = 0; i < controller.listOrder.length; i++)
                  orderTableRow(context, controller.listOrder[i], i,
                      rowColor: Color.fromARGB(255, 162, 155, 255),
                      textColor: const Color.fromARGB(255, 0, 0, 0)),
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
                                            builder: (_) => viewInvoiceScreenn(
                                                header_name:
                                                    "View Invoice Details",
                                                data: data)));
                                  },
                                  icon: Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Color.fromARGB(255, 49, 36, 163),
                                  ),
                                  tooltip: 'View'),
                              SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                  onPressed: () async {
                                    final datad = await InvoiceService(
                                      PriceDetail: data,
                                    ).createInvoice();
                                    // final data = await service.createInvoice();
                                    await savePdfFile("invoice", datad, data);
                                  },
                                  icon: Icon(
                                    Icons.download,
                                    color: Colors.green,
                                  ),
                                  tooltip: 'View'),
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

  // functions =================================================================
  fnSearch(search) async {
    await controllerr.ctr_fn_order_search();
    setState(() {});
  }
}

/// Class CLose
