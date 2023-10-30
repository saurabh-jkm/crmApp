// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, prefer_final_fields, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_null_comparison, sort_child_properties_last, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, depend_on_referenced_packages, avoid_print, unnecessary_new, unused_field, unused_label, unrelated_type_equality_checks, file_names, unnecessary_cast

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/screens/customers/customer_controller.dart';
import 'package:crm_demo/screens/customers/customer_widgets.dart';
import 'package:flutter/material.dart';
import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';

class CustomerAllOrderList extends StatefulWidget {
  const CustomerAllOrderList({super.key, @required this.data, this.title});
  final data;
  final title;

  @override
  State<CustomerAllOrderList> createState() => _CustomerAllOrderListState();
}

class _CustomerAllOrderListState extends State<CustomerAllOrderList> {
  var controller = new orderController();
  bool isWait = true;

  initFunction() async {
    if (widget.data != null) {
      await controller.fn_set_order(widget.data['orderList']);
    }
    setState(() {
      isWait = false;
    });
  }

  @override
  void initState() {
    initFunction();
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}"),
        backgroundColor: themeBG2,
      ),
      body: (isWait)
          ? pleaseWait(context)
          : Container(
              color: themeBG2,
              child: Column(
                children: [CustomerList(context, controller)],
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

  // functions =================================================================
  fnSearch(search) async {
    await controller.ctr_fn_order_search();
    setState(() {});
  }
}

/// Class CLose
