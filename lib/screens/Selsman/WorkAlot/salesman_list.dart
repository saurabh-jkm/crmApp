// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, prefer_final_fields, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_null_comparison, sort_child_properties_last, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, depend_on_referenced_packages, avoid_print, unnecessary_new, unused_field, unused_label, unrelated_type_equality_checks, file_names, unnecessary_cast, unused_import, deprecated_colon_for_default_value, await_only_futures, unnecessary_brace_in_string_interps
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jkm_crm_admin/screens/Selsman/Track_History/track_controller.dart';
import 'package:jkm_crm_admin/screens/Selsman/Track_History/view_location.dart';
import 'package:jkm_crm_admin/screens/Selsman/WorkAlot/add_meet_widget.dart';
import 'package:jkm_crm_admin/screens/Selsman/WorkAlot/saler_contoller.dart';

import 'package:jkm_crm_admin/themes/base_controller.dart';
import 'package:jkm_crm_admin/themes/function.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../responsive.dart';
import '../../../themes/firebase_functions.dart';
import '../../../themes/global.dart';
import '../../../themes/style.dart';
import '../../../themes/theme_footer.dart';
import '../../../themes/theme_header.dart';
import '../../../themes/theme_widgets.dart';
import '../../Balance/balance_widget.dart';
import '../../Invoice/invoice_controller.dart';
import '../../customers/customer_widgets.dart';
import '../../dashboard/components/header.dart';
import 'view_page.dart';

class SalemanList extends StatefulWidget {
  const SalemanList({super.key});

  @override
  State<SalemanList> createState() => _SalemanListState();
}

class _SalemanListState extends State<SalemanList> {
  var controller = new SellerController();
  var baseController = new base_controller();

  fn_setstate() {
    setState(() {});
  }

  initFunctions(limit) async {
    await controller.sellerList(limit);
    await controller.getCustomerNameList();
    setState(() {});
  }

  // ==============================
  fn_change_state(key, val) {
    setState(() {
      if (key == 'ListShow') {
        controller.ListShow = val;
      }
    });
  }

  // date picker function =================================
  datePick(type) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      //print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        if (type == 'fromDate') {
          controller.startDate_controller.text = formattedDate;
        } else if (type == 'toDate') {
          controller.toDate_controller.text = formattedDate;
        }
      });
      FocusScope.of(context).requestFocus(FocusNode());
    } else {
      print("Date is not selected");
    }
  }

  // date filter ===================================================
  fnFilterController(filter) {
    initFunctions(_number_select);
  }

  @override
  void initState() {
    initFunctions(_number_select);
    super.initState();
  }

/////////////=====================================================================

  var controllerr = new invoiceController();
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (e) {
        var rData = controllerr.cntrKeyPressFun(e, context);
        if (rData != null && rData) {
          setState(() {});
        }
      },
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: clientAppBar(),
          ),
          bottomNavigationBar:
              (is_mobile) ? theme_footer_android(context, 1) : SizedBox(),
          body: (controller.secondScreen && controller.selectedSellerId != null)
              ? Container(
                  color: Colors.white,
                  child: ListView(children: [
                    _ImageSelect_Alert(context, controller.selectedSellerId,
                        controller.MeetingMap, controller.selectedSeller),
                  ]),
                )
              : CustomerList(context, "Seller List")),
    );
  }

  var _number_select = 50;
  var _number_select_meeting = 50;
  // Body Part =================================================
  Widget CustomerList(context, headLine) {
    return Container(
      height: MediaQuery.of(context).size.height - 70,
      color: Colors.white,
      child: ListView(
        children: [
          (is_mobile)
              ? themeHeader_android(context, title: "$headLine")
              : Container(height: 70.0, child: Header(title: "$headLine")),
          // search
          Container(
            color: Color.fromARGB(255, 94, 86, 204),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
          // dataList.add(data["notification"]);
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

  // table row
// Table Heading ==========================
  Widget CTableRow(context, data, srNo,
      {rowColor: '', textColor: '', controller: ''}) {
    List<dynamic> dataList = [];
    dataList.add('1');
    dataList.add('${data['name']}');
    dataList.add(data["notification"]);
    dataList.add('${data['date_at']}');
    dataList.add('action');
    _ImageSelect_Alert(
        context, data, controller.MeetingMap, controller.selectedSeller);
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
                      ],
                    ),
                  )
                : Expanded(
                    child: Container(
                      child: (dataList[i] == 'action')
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                  (is_mobile)
                                      ? IconButton(
                                          onPressed: () async {
                                            controller.MeetingMap =
                                                await controller.OrderList_data(
                                                    "${data['id']}",
                                                    _number_select_meeting);
                                            setState(() {
                                              controller.selectedSellerId =
                                                  data['id'];
                                              controller.deviceId =
                                                  data['DeviceId'];
                                              controller.selectedSeller = data;
                                              controller.secondScreen = true;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.list,
                                            color: Colors.white,
                                            size: 40,
                                          ))
                                      : themeButton3(context, () async {
                                          controller.MeetingMap =
                                              await controller.OrderList_data(
                                                  "${data['id']}",
                                                  _number_select_meeting);
                                          setState(() {
                                            controller.selectedSellerId =
                                                data['id'];
                                            controller.deviceId =
                                                data['DeviceId'];
                                            controller.selectedSeller = data;
                                            controller.secondScreen = true;
                                          });
                                        },
                                          label: "Meetings Info",
                                          radius: 10.0,
                                          buttonColor: Colors.green,
                                          btnHeightSize: 35.0),
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

  //////////////////   popup Box for Image selection ++++++++++++++++++++++++++++++++++++++
  var headerName = {
    1: '#',
    2: 'Customer',
    3: 'Type',
    4: 'Message',
    5: 'Assign At',
    6: 'Closing At',
    7: 'Status',
    8: 'Action',
  };
  var tableColum = {
    1: 40.0,
    2: 120.0,
    3: 70.0,
    4: 150.0,
    5: 80.0,
    6: 80.0,
    7: 60.0,
    8: 100.0,
  };
  Widget _ImageSelect_Alert(BuildContext context, Mdata, Map MapMeeting, data) {
    // print("$MapMeeting");
    return Container(
        child: (controller.ListShow)

////////////////////////////////////////////     Listt Of Meeting ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    await controller.sellerList(_number_select);
                                    // todo
                                    setState(() {
                                      controller.selectedSeller = {};
                                      controller.selectedSellerId = '';
                                      controller.secondScreen = false;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                    size: 35,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${(controller.selectedSeller != null) ? controller.selectedSeller['name'] : ''}',
                                style: themeTextStyle(
                                  color: Colors.blue,
                                  fw: FontWeight.bold,
                                  size: is_mobile ? 15.0 : 20.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                themeButton3(context, () {
                                  setState(() {
                                    controller.ListShow = false;
                                  });
                                },
                                    label: "+ New Meeting",
                                    buttonColor: Colors.green,
                                    fontSize: is_mobile ? 15.0 : 20.0,
                                    btnHeightSize: is_mobile ? 40.0 : 50.0,
                                    radius: 10.0),
                              ]),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: EdgeInsets.all(10),
                        color: themeBG4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 4.0),
                                  color: Color.fromARGB(255, 200, 247, 242),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          padding: EdgeInsets.only(top: 14),
                                          height: 35,
                                          width: 120.0,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: Colors.white),
                                          child: formTimeInput(context,
                                              controller.startDate_controller,
                                              label: 'Date From',
                                              method: datePick,
                                              arg: 'fromDate')),
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          padding: EdgeInsets.only(top: 14),
                                          height: 35,
                                          width: 120.0,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: Colors.white),
                                          child: formTimeInput(context,
                                              controller.toDate_controller,
                                              label: 'Date To',
                                              method: datePick,
                                              arg: 'toDate')),
                                      (is_mobile)
                                          ? IconButton(
                                              onPressed: () {
                                                fnFilterController;
                                              },
                                              icon: Icon(
                                                Icons.search,
                                                color: Colors.blue,
                                                size: 40,
                                              ))
                                          : themeButton3(
                                              context, fnFilterController,
                                              arg: 'date_filter',
                                              label: 'Filter',
                                              radius: 5.0,
                                              borderColor: Colors.transparent,
                                              buttonColor: Color.fromARGB(
                                                  255, 12, 121, 194)),
                                    ],
                                  ),
                                ),
                              ],
                            ), // end date filter container
                          ],
                        )),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: (MapMeeting.length * 70),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: themeBG4,
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 3.0,
                                              color: Colors.white))),
                                  child: Row(
                                    children: [
                                      for (int i in headerName.keys)
                                        tableLablee(context, i, headerName[i],
                                            tableColum),
                                    ],
                                  ),
                                ),
                                for (var i = 0; i < MapMeeting.length; i++)
                                  MeetingViewList(
                                    context,
                                    MapMeeting[i],
                                    i + 1,
                                    rowColor:
                                        Color.fromARGB(255, 217, 215, 239),
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // TableHeading(context, controller.MeetingheadList,
                    //     rowColor: Color.fromARGB(255, 94, 86, 204),
                    //     textColor: Colors.white),
                    // Container(
                    //     height: MediaQuery.of(context).size.height - 100,
                    //     child: ListView(children: [
                    //       // heading ==============================================================================
                    //       Container(
                    //         width: 400,
                    //         height: (controllerr.OrderList.length * 60),
                    //         child: ListView(
                    //           scrollDirection: Axis.horizontal,
                    //           shrinkWrap: true,
                    //           children: [
                    //             Container(
                    //               child: Column(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   // for (var index = 0;
                    //                   //     index < controllerr.OrderList.length;
                    //                   //     index++)
                    //                   //   tableRowWidget("${index + 1}",
                    //                   //       controllerr.OrderList[index],
                    //                   //       dbData: controllerr.OrderList[index])
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),

                    //       // for (int key in MapMeeting.keys)
                    //       //   MeetingTableRow(context, MapMeeting[key], key,
                    // rowColor: Color.fromARGB(255, 217, 215, 239),
                    // textColor: const Color.fromARGB(255, 0, 0, 0),
                    //       //       controllerr: controller),

                    //     ])),

                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        color: Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Show",
                              style: themeTextStyle(
                                  fw: FontWeight.normal,
                                  color: Colors.white,
                                  size: 15),
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
                                  "$_number_select_meeting",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                                value: _number_select_meeting,
                                items:
                                    <int>[50, 100, 150, 200].map((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(
                                      "$value",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newVal) async {
                                  setState(() {
                                    _number_select_meeting = newVal!;
                                  });

                                  await controller.OrderList_data(
                                      controller.selectedSellerId, newVal);
                                  setState(() {});
                                },
                                underline: SizedBox(),
                              ),
                            ),
                            Text(
                              "entries",
                              style: themeTextStyle(
                                  fw: FontWeight.normal,
                                  color: Colors.white,
                                  size: 15),
                            ),
                          ],
                        ),
                      )
                    ]),
                    SizedBox(
                      height: 100,
                    ),
                  ])
            : addNewMeet_widget(context, controller, fnFetchCutomerDetails,
                selectDate, controller.ListShow, fn_change_state, fn_setstate));
  }

// Table Heading ==========================
  Widget MeetingTableRow(context, data, srNo,
      {rowColor: '', textColor: '', controllerr: ''}) {
    List<dynamic> dataList = [];
    var status = MeetingStatusOF(data['status']);

    dataList.add('1');
    dataList.add('${data['customer_name']}');
    dataList.add('${data['customer_type']}');
    dataList.add('${data['next_follow_up']}');
    dataList.add('${data['next_follow_up_date']}');
    dataList.add(
        '${(data['update_tsmp'] != null) ? formatDate(data['update_tsmp'], formate: "dd-MM-yyyy h:mm a") : "--/--"}');
    dataList.add('${status}');
    dataList.add('action');

    return Container(
      margin: EdgeInsets.only(bottom: 2.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
          border:
              Border.all(color: (status == "Done") ? Colors.red : Colors.green),
          color: (rowColor == '') ? themeBG2 : rowColor),
      child: Row(
        children: [
          for (var i = 0; i < dataList.length; i++)
            (i == 0)
                ? Container(
                    width: 40.0,
                    child: Row(
                      children: [
                        Text(
                          "${srNo + 1}",
                          style: TextStyle(
                              fontSize: 12.0,
                              color: (textColor == '')
                                  ? Color.fromARGB(255, 201, 201, 201)
                                  : textColor),
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: Container(
                      child: (dataList[i] == 'action')
                          ? Row(children: [
                              SizedBox(width: 10),
                              Container(
                                  height: 40,
                                  width: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.2),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: IconButton(
                                      onPressed: () async {
                                        await win_dbDelete(
                                            context, controller.db, {
                                          "table": "follow_up",
                                          "id": "${data["id"]}"
                                        });

                                        //  await   controller.OrderList_data(
                                        //         "${data['id']}",
                                        //         _number_select_meeting);

                                        await controller.OrderList_data(
                                            controller.selectedSellerId,
                                            _number_select_meeting);

                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.delete_outline_outlined,
                                        color: Colors.red,
                                        size: 20,
                                      ))),
                              ///// view details Sub Admin+++++++++++++++++++
                              SizedBox(width: 10),
                              Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      if (controller != '') {
                                        nextScreen(
                                            context,
                                            MeetingView(
                                              MapData: data,
                                            ));
                                      }
                                    },
                                    icon: Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.green,
                                    ),
                                    tooltip: 'View'),
                              ),
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

  Widget MeetingViewList(BuildContext context, data, index, {rowColor: ""}) {
    var status = MeetingStatusOF(data['status']);
    return Container(
      margin: EdgeInsets.only(bottom: 2.0),
      padding: EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
          border:
              Border.all(color: (status == "Done") ? Colors.red : Colors.green),
          color: (rowColor == '') ? themeBG2 : rowColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          tableDetails(context, index, " ${index}", tableColum[1]),
          tableDetails(context, index, data["customer_name"], tableColum[2]),
          tableDetails(context, index, data["customer_type"], tableColum[3]),
          tableDetails(
              context, index, data["meeting_conversation"], tableColum[4]),
          tableDetails(
              context, index, data["next_follow_up_date"], tableColum[5]),
          tableDetails(context, index, data["update_at"], tableColum[6]),
          tableDetails(context, index, status, tableColum[7]),
          Container(
              width: tableColum[8],
              child: Row(children: [
                Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: IconButton(
                        onPressed: () async {
                          await win_dbDelete(context, controller.db,
                              {"table": "follow_up", "id": "${data["id"]}"});

                          //  await   controller.OrderList_data(
                          //         "${data['id']}",
                          //         _number_select_meeting);

                          await controller.OrderList_data(
                              controller.selectedSellerId,
                              _number_select_meeting);

                          setState(() {});
                        },
                        icon: Icon(
                          Icons.delete_outline_outlined,
                          color: Colors.red,
                          size: 20,
                        ))),
                ///// view details Sub Admin+++++++++++++++++++
                SizedBox(width: 10),
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: IconButton(
                      onPressed: () {
                        if (controller != '') {
                          nextScreen(
                              context,
                              MeetingView(
                                MapData: data,
                              ));
                        }
                      },
                      icon: Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.green,
                      ),
                      tooltip: 'View'),
                ),
              ]))
        ],
      ),
    );
  }

//////////////////////////////////////////==========
  // Fetch all detials
  fnFetchCutomerDetails() {
    var tName = controller.Customer_nameController.text;
    var tempData = (tName != '' && controller.CustomerArr[tName] != null)
        ? controller.CustomerArr[tName]
        : {};
    if (tempData.isNotEmpty) {
      controller.customerId = tempData['id'];
      controller.Customer_MobileController.text = tempData['mobile'];
      controller.Customer_emailController.text = tempData['email'];
      controller.Customer_addressController.text = tempData['address'];
      controller.Customer_TypeController.text = tempData['type'];
      setState(() {});
    }
  }

  ///
  ///

  selectDate(BuildContext context, setstate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: controller.selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != controller.selectedDate) {
      setState(() {
        controller.selectedDate = picked;
        controller.Next_date =
            DateFormat('dd-MM-yyyy').format(controller.selectedDate);
      });
    }
  }

  // functions =================================================================
  fnSearch(search) async {
    await controller.ctr_fn_search();
    setState(() {});
  }
}/// Class CLose
