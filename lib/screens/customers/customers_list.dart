// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, prefer_final_fields, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_null_comparison, sort_child_properties_last, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, depend_on_referenced_packages, avoid_print, unnecessary_new, unused_field, unused_label, unrelated_type_equality_checks, file_names, unnecessary_cast, deprecated_colon_for_default_value, deprecated_member_use

import 'package:jkm_crm_admin/screens/customers/customer_controller.dart';
import 'package:jkm_crm_admin/screens/customers/customer_widgets.dart';
import 'package:jkm_crm_admin/themes/base_controller.dart';

import 'package:flutter/material.dart';

import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';
import '../dashboard/components/header.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  var controller = new customerController();
  var baseController = new base_controller();

  initFunctions(limit) async {
    await controller.init_functions(limit);
    await orderDetails();
    setState(() {});
  }

  // get order details
  orderDetails() async {
    await controller.getOrderData();
    setState(() {});
  }

  @override
  void initState() {
    initFunctions(_number_select);
    super.initState();
  }

  var _number_select = 50;
  @override
  Widget build(BuildContext context) {
    // print("${controller.listCustomer}  ==== kkk ====");

    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (e) {
        var rData =
            baseController.KeyPressFun(e, context, backtype: 'dashboard');
        if (rData != null && rData) {
          setState(() {});
        }
      },
      child: Scaffold(
        body: Container(
          color: themeBG2,
          child: Column(
            children: [
              Container(height: 70.0, child: Header(title: "Customer List")),
              CustomerList(context)
            ],
          ),
        ),
      ),
    );
  }

  // Body Part =================================================
  // change filter ===================================================
///////   filter work  ++++++++++++++++++++++

  changeFilter(val) {
    setState(() {
      controller.selectedFilter = val;
      controller.ctr_fn_search(filter: val);
    });
  }

//////search work======
  Widget CustomerList(context) {
    return Container(
      height: MediaQuery.of(context).size.height - 70,
      color: Colors.white,
      child: ListView(
        children: [
          Container(
              padding: EdgeInsets.all(10),
              color: themeBG4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  themeButton3(context, changeFilter,
                      arg: 'Customer',
                      label: 'Customer',
                      radius: 2.0,
                      borderColor: (controller.selectedFilter == 'Customer')
                          ? Colors.white
                          : Colors.white,
                      buttonColor: (controller.selectedFilter == 'Customer')
                          ? Color.fromARGB(255, 4, 141, 134)
                          : const Color.fromARGB(0, 110, 110, 110)),

                  SizedBox(width: 10.0),

                  themeButton3(context, changeFilter,
                      arg: 'Supplier',
                      label: 'Supplier',
                      radius: 2.0,
                      borderColor: (controller.selectedFilter == 'Supplier')
                          ? Colors.green
                          : Colors.white,
                      buttonColor: (controller.selectedFilter == 'Supplier')
                          ? Color.fromARGB(255, 4, 141, 134)
                          : const Color.fromARGB(0, 110, 110, 110)),
                  SizedBox(width: 10.0),

                  // themeButton3(context, changeFilter,
                  //     arg: 'Other',
                  //     label: 'Other',
                  //     radius: 2.0,
                  //     borderColor: (controller.selectedFilter == 'Other')
                  //         ? Colors.green
                  //         : Colors.white,
                  //     buttonColor: (controller.selectedFilter == 'Other')
                  //         ? Color.fromARGB(255, 4, 141, 134)
                  //         : const Color.fromARGB(0, 110, 110, 110)),
                  ////// filer  controller  ++++++++++++++++++++++++++++++++++
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 40.0,
                    width: 220.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: inputSearch(
                        context, controller.searchTextController, 'Search',
                        method: fnSearch),
                  )
                  ///// =====================================================
                ],
              )),
          SizedBox(
            height: 5,
          ),

          // table start
          TableHeading(context, controller.headintList,
              rowColor: Color.fromARGB(255, 94, 86, 204),
              textColor: Colors.white),

          for (String key in controller.listCustomer.keys)
            CustomerTableRow(context, controller.listCustomer[key], key,
                controller.listOrder,
                rowColor: Color.fromARGB(255, 162, 155, 255),
                textColor: const Color.fromARGB(255, 0, 0, 0),
                controller: controller),

          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Show",
                    style: themeTextStyle(
                        fw: FontWeight.normal, color: Colors.white, size: 15),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    padding: EdgeInsets.all(2),
                    height: 20,
                    color: Colors.white,
                    child: DropdownButton<int>(
                      dropdownColor: Colors.white,
                      iconEnabledColor: Colors.black,
                      hint: Text(
                        "$_number_select",
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      value: _number_select,
                      items: <int>[50, 100, 150, 200].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            "$value",
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        _number_select = newVal!;
                        initFunctions(newVal);
                      },
                      underline: SizedBox(),
                    ),
                  ),
                  Text(
                    "entries",
                    style: themeTextStyle(
                        fw: FontWeight.normal, color: Colors.white, size: 15),
                  ),
                ],
              ),
            )
          ]),

          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  // functions =================================================================
  fnSearch(search) async {
    await controller.ctr_fn_search();
    setState(() {});
  }
}

/// Class CLose
