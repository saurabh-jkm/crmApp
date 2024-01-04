// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, prefer_final_fields, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_null_comparison, sort_child_properties_last, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, depend_on_referenced_packages, avoid_print, unnecessary_new, unused_field, unused_label, unrelated_type_equality_checks, file_names, unnecessary_cast, unused_import, deprecated_colon_for_default_value, await_only_futures, unnecessary_brace_in_string_interps
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jkm_crm_admin/screens/Selsman/Track_History/error_screen.dart';
import 'package:jkm_crm_admin/screens/Selsman/Track_History/track_controller.dart';
import 'package:jkm_crm_admin/screens/Selsman/Track_History/view_location.dart';

import 'package:jkm_crm_admin/themes/base_controller.dart';
import 'package:jkm_crm_admin/themes/function.dart';
import 'package:jkm_crm_admin/themes/global.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../themes/style.dart';
import '../../../themes/theme_footer.dart';
import '../../../themes/theme_header.dart';
import '../../../themes/theme_widgets.dart';
import '../../customers/customer_widgets.dart';
import '../../dashboard/components/header.dart';
import 'track_widgets.dart';

class TrackHistory extends StatefulWidget {
  const TrackHistory({super.key});

  @override
  State<TrackHistory> createState() => _TrackHistoryState();
}

class _TrackHistoryState extends State<TrackHistory> {
  var controller = new trackController();
  var baseController = new base_controller();

  initFunctions(limit) async {
    await controller.init_functions(limit);
    await orderDetails();
    for (String key in controller.listCustomer.keys) {
      controller.loc =
          (controller.listCustomer[key]["location_points"] != null &&
                  controller.listCustomer[key]["location_points"] != 'null')
              ? jsonDecode(controller.listCustomer[key]["location_points"])
              : [];

      for (var i = 0; i < controller.loc.length; i++) {
        controller.distance = await controller.calculateDistance(
            controller.loc[0][0],
            controller.loc[0][1],
            controller.loc[controller.loc.length - 1][0],
            controller.loc[controller.loc.length - 1][1]);
      }
      if (this.mounted) {
        setState(() {
          controller.tempLocation.add(controller.distance);
        });
      }
    }
  }

  // get order details
  orderDetails() async {
    await controller.getOrderData();
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    initFunctions(_number_select);
    super.initState();
  }

  Future<void> delete_Pro(id) {
    // var db = FirebaseFirestore.instance;
    if (!kIsWeb && Platform.isWindows) {
      final _product = Firestore.instance.collection('client_location');
      return _product.document(id).delete().then((value) {
        setState(() {
          initFunctions(_number_select);
          themeAlert(context, "Deleted Successfully ");
        });
      }).catchError(
          (error) => themeAlert(context, 'Not find Data', type: "error"));
    } else {
      CollectionReference _product =
          FirebaseFirestore.instance.collection('client_location');
      return _product.doc(id).delete().then((value) {
        setState(() {
          initFunctions(_number_select);
          themeAlert(context, "Deleted Successfully ");
        });
      }).catchError(
          (error) => themeAlert(context, 'Not find Data', type: "error"));
    }
  }

/////////////=====================================================================

  @override
  Widget build(BuildContext context) {
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
        bottomNavigationBar:
            (is_mobile) ? theme_footer_android(context, 1) : SizedBox(),
        body: Container(color: themeBG2, child: CustomerList(context)),
      ),
    );
  }

  var _number_select = 50;
//
  // Body Part =================================================
  Widget CustomerList(context) {
    return Container(
      height: MediaQuery.of(context).size.height - 70,
      color: Colors.white,
      child: ListView(
        children: [
          (is_mobile)
              ? themeHeader_android(context, title: "Track History")
              : Container(
                  height: 70.0, child: Header(title: "Track History List")),
          // search
          Container(
            // margin: EdgeInsets.symmetric(horizontal: 10),
            color: Color.fromARGB(255, 94, 86, 204),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ////  Delete Selected Product +++++++++++++++++++++++++++++++++++++++
                (controller.selected_pro.isNotEmpty &&
                        controller.selected_pro != {})
                    ? themeButton3(context, () {
                        controller.selected_pro.forEach((k, v) async =>
                                await delete_Pro(k) //   showExitPopup(k)
                            );
                        setState(() {
                          controller.selected_pro = {};
                        });
                      },
                        label:
                            "Delete History : ${controller.selected_pro.length}",
                        buttonColor: Colors.red,
                        radius: 10.0)
                    : SizedBox(),

                Container(
                  margin: EdgeInsets.all(2),
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: inputSearch(
                      context, controller.searchTextController, 'Search',
                      method: fnSearch),
                )
              ],
            ),
          ),

          // table start

          TableHeading(context, controller.headintList,
              rowColor: Color.fromARGB(255, 94, 86, 204),
              textColor: Colors.white),

          for (String key in controller.listCustomer.keys)
            CTableRow(context, controller.listCustomer[key], key,
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

  // table row
// Table Heading ==========================
  Widget CTableRow(context, data, srNo,
      {rowColor: '', textColor: '', controller: ''}) {
    var distance;
    int no = int.parse("${srNo}") - 1;

    List<dynamic> dataList = [];
    dataList.add('1');
    dataList.add('${data['name']}');

    dataList.add(
        "${(controller.tempLocation[no] != null) ? double.parse((controller.tempLocation[no]).toStringAsFixed(2)) : "0"} Km");
    dataList.add(
        '${(data['date'] == null) ? '-' : formatDate(data['date'], formate: 'dd/MM/yyyy')}');
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
                    width: 50.0,
                    child: Row(
                      children: [
                        Text(
                          "${srNo}",
                          style: TextStyle(
                              fontSize: 12.0,
                              color: (textColor == '')
                                  ? Color.fromARGB(255, 201, 201, 201)
                                  : textColor),
                        ),
                        Container(
                          width: 25.0,
                          child: CheckboxListTile(
                            checkColor: Colors.white,
                            activeColor: Colors.red,
                            side: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 74, 83, 75)),
                            value: (controller.selected_pro[data["id"]] == null)
                                ? false
                                : true,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  controller.selected_pro[data["id"]] = true;
                                } else {
                                  controller.selected_pro.remove(data["id"]);
                                }
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  )
                : Expanded(
                    child: Container(
                      child: (dataList[i] == 'action')
                          ? Row(children: [
                              IconButton(
                                  onPressed: () {
                                    if (controller != '') {
                                      nextScreen(
                                          context,
                                          Platform.isWindows
                                              ? ErrorScreen()
                                              : View_Location_Screen(
                                                  client_location: json.decode(
                                                      data[
                                                          'location_points'])));
                                    }
                                  },
                                  icon: Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Colors.white,
                                  ),
                                  tooltip: 'View')
                            ])
                          : Text("${dataList[i]}",
                              maxLines: 2,
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
}

/// Class CLose
