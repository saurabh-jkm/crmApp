// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, prefer_final_fields, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_null_comparison, sort_child_properties_last, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, depend_on_referenced_packages, avoid_print, unnecessary_new, unused_field, unused_label, unrelated_type_equality_checks, file_names, unnecessary_cast, unused_import, deprecated_colon_for_default_value, await_only_futures, unnecessary_brace_in_string_interps
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/screens/Selsman/Track_History/track_controller.dart';
import 'package:crm_demo/screens/Selsman/Track_History/view_location.dart';
import 'package:crm_demo/screens/Selsman/WorkAlot/saler_contoller.dart';

import 'package:crm_demo/themes/base_controller.dart';
import 'package:crm_demo/themes/function.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../responsive.dart';
import '../../../themes/firebase_functions.dart';
import '../../../themes/style.dart';
import '../../../themes/theme_widgets.dart';
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

  initFunctions() async {
    await controller.sellerList();
    await controller.getCustomerNameList();
    setState(() {});
  }

  @override
  void initState() {
    initFunctions();
    super.initState();
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
        body: Container(
          color: themeBG2,
          child: Column(
            children: [
              Container(height: 70.0, child: Header(title: "Salesman List")),
              CustomerList(context)
            ],
          ),
        ),
      ),
    );
  }

//
  // Body Part =================================================
  Widget CustomerList(context) {
    return Container(
      height: MediaQuery.of(context).size.height - 70,
      color: Colors.white,
      child: ListView(
        children: [
          // search
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Container(
                  height: 60.0,
                  width: 220.0,
                  child: inputSearch(
                      context, controller.searchTextController, 'Search',
                      method: () {}),
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

    dataList.add('${data['date_at']}');
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
                                  themeButton3(context, () async {
                                    controller.MeetingMap =
                                        await controller.OrderList_data(
                                            "${data['id']}");
                                    _ImageSelect_Alert(
                                        context, data, controller.MeetingMap);
                                  },
                                      label: "Meetings Info",
                                      radius: 10,
                                      buttonColor: Colors.green,
                                      btnHeightSize: 35),
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
  bool ListShow = true;
  void _ImageSelect_Alert(BuildContext context, Mdata, MapMeeting) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setStatee) {
            controller.sellerId = "${Mdata['id']}";
            return AlertDialog(
              backgroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    15.0,
                  ),
                ),
              ),
              // contentPadding: EdgeInsets.only(
              //   top: 10.0,
              // ),
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GoogleText(
                          text: "Meetings Info",
                          fsize: 20.0,
                          fweight: FontWeight.bold,
                          color: Colors.black),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.black38,
                          ))
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.black12,
                  )
                ],
              ),
              content: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width - 450,
                child: SingleChildScrollView(
                  child: (ListShow == true)

////////////////////////////////////////////     Listt Of Meeting ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  themeButton3(context, () {
                                    setStatee(() {
                                      ListShow = false;
                                    });
                                  }, label: "+ New Meeting Asign", radius: 5.0),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TableHeading(context, controller.MeetingheadList,
                                  rowColor: Color.fromARGB(255, 94, 86, 204),
                                  textColor: Colors.white),
                              for (int key in MapMeeting.keys)
                                MeetingTableRow(
                                    context,
                                    MapMeeting[key],
                                    key,
                                    rowColor:
                                        Color.fromARGB(255, 217, 215, 239),
                                    textColor:
                                        const Color.fromARGB(255, 0, 0, 0),
                                    controllerr: controller,
                                    setStatee),
                            ])
                      :

////////////////////////////////////////////   New Add Meeting ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setStatee(() {
                                        ListShow = true;
                                      });
                                    },
                                    icon: Icon(Icons.arrow_back_rounded,
                                        color: Colors.black, size: 30))
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Form(
                              key: controller.formKeyInvoice,
                              child: Column(
                                children: <Widget>[
                                  ///    Add TextFormFields and ElevatedButton here.
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              themeSpaceVertical(5.0),
                                              Row(
                                                children: [
                                                  Icon(Icons.person,
                                                      color: Colors.black,
                                                      size: 30),
                                                  themeHeading2(
                                                      "Customer Details "),
                                                ],
                                              ),

                                              themeSpaceVertical(4.0),
                                              Row(
                                                children: [
                                                  // fireld 1 ==========================
                                                  Expanded(
                                                      child: autoCompleteFormInput(
                                                          controller
                                                              .ListCustomer,
                                                          "Customer Name",
                                                          controller
                                                              .Customer_nameController,
                                                          method:
                                                              fnFetchCutomerDetails)),

                                                  Expanded(
                                                    child: formInput(
                                                      context,
                                                      "Mobile No.",
                                                      controller
                                                          .Customer_MobileController,
                                                      padding: 8.0,
                                                      isNumber: true,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: formInput(
                                                        context,
                                                        "Email Id",
                                                        controller
                                                            .Customer_emailController,
                                                        padding: 8.0),
                                                  ),
                                                ],
                                              ),

                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: formInput(
                                                        context,
                                                        "Address",
                                                        controller
                                                            .Customer_addressController,
                                                        padding: 8.0),
                                                  ),
                                                  Expanded(
                                                    child: formInput(
                                                        context,
                                                        "Pin Code",
                                                        controller
                                                            .Customer_pincodeController,
                                                        padding: 8.0),
                                                  ),
                                                  Expanded(
                                                    child: formInput(
                                                        context,
                                                        "Shop No.",
                                                        controller
                                                            .Customer_shopNoController,
                                                        padding: 8.0),
                                                  ),
                                                ],
                                              ),

                                              // Row(
                                              //   children: [
                                              //     // fireld 1 ==========================
                                              //     Expanded(
                                              //         child: autoCompleteFormInput(
                                              //             controller.ListType,
                                              //             "Customer Type",
                                              //             controller
                                              //                 .Customer_TypeController,
                                              //             method: fnFetchCutomerDetails)),
                                              //     // fireld 2 ==========================
                                              //     Expanded(
                                              //       child: Text(""),
                                              //     ),
                                              //   ],
                                              // ),
                                              // 2nd row =============================================
                                              // Header End ============================

                                              themeSpaceVertical(10.0),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.meeting_room,
                                                        color: Colors.black,
                                                        size: 30),
                                                    themeHeading2(
                                                        "Next Meeting "),
                                                  ],
                                                ),
                                              ),

                                              Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              10, 0, 0, 0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Colors.black)),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10, left: 10),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                                onTap: () {
                                                                  selectDate(
                                                                      context,
                                                                      setStatee);
                                                                },
                                                                child:
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                10,
                                                                            left:
                                                                                10),
                                                                        decoration: BoxDecoration(
                                                                            boxShadow:
                                                                                themeBox,
                                                                            color: Colors
                                                                                .white,
                                                                            borderRadius: BorderRadius.circular(
                                                                                5)),
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                5),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.calendar_today,
                                                                              size: 30,
                                                                              color: Colors.blue,
                                                                            ),
                                                                            SizedBox(width: 10),
                                                                            Text(
                                                                              (controller.Next_date == "") ? "     Select date     " : controller.Next_date,
                                                                              style: GoogleFonts.alike(fontSize: 13.0, color: (controller.Next_date == "") ? Colors.blue : Colors.green),
                                                                            ),
                                                                            SizedBox(width: 10),
                                                                          ],
                                                                        ))),
                                                            (controller.Next_date ==
                                                                    "")
                                                                ? SizedBox()
                                                                : IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      setStatee(
                                                                          () {
                                                                        controller.Next_date =
                                                                            "";
                                                                      });
                                                                    },
                                                                    icon: Icon(
                                                                      Icons
                                                                          .cancel,
                                                                      color: Colors
                                                                          .red,
                                                                      size: 30,
                                                                    ))
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      myFormField(
                                                          context,
                                                          controller
                                                              .Customer_NextFollowUp_Controller,
                                                          "Comments",
                                                          maxLine: 4),
                                                    ],
                                                  ))

                                              //field
                                            ],
                                          )),
                                        ),
                                      ]),
                                  // auto complete =================================

                                  themeSpaceVertical(5.0),

                                  Divider(
                                    thickness: 2.0,
                                    color: Colors.black12,
                                  ),
                                ],
                              ),
                            ),
                            themeSpaceVertical(5.0),
                            themeButton3(context,
                                label: "Submit",
                                btnHeightSize: 45.0,
                                btnWidthSize: 250.0,
                                buttonColor: themeBG4,
                                radius: 10.0,
                                fontSize: 20, () async {
                              await controller.insertInvoiceDetails(context);
                              // Navigator.of(context).pop();
                            }),
                            themeSpaceVertical(10.0),
                          ],
                        ),
                ),
              ),
            );
          });
        });
  }

// Table Heading ==========================
  Widget MeetingTableRow(context, data, srNo, Setstate,
      {rowColor: '', textColor: '', controllerr: ''}) {
    List<dynamic> dataList = [];
    var status = MeetingStatusOF(data['status']);
    dataList.add('1');
    dataList.add('${data['customer_name']}');
    dataList.add('${data['next_follow_up']}');
    dataList.add('${data['next_follow_up_date']}');
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
                              ////// view Update Edit  Sub Admin+++++++++
                              // Container(
                              //     height: 40,
                              //     width: 40,
                              //     alignment: Alignment.center,
                              //     decoration: BoxDecoration(
                              //       color: Colors.blue.withOpacity(0.2),
                              //       borderRadius: const BorderRadius.all(
                              //           Radius.circular(10)),
                              //     ),
                              //     child: IconButton(
                              //         onPressed: () {
                              //           // setState(() {
                              //           //   updateWidget = true;
                              //           //   update_id = iid;
                              //           //   if (!kIsWeb && Platform.isWindows) {
                              //           //     All_Update_initial(iid);
                              //           //   } else {
                              //           //     Update_initial(iid);
                              //           //   }
                              //           // });
                              //         },
                              //         icon: Icon(
                              //           Icons.edit,
                              //           color: Colors.blue,
                              //           size: 20,
                              //         )) ////
                              //     ),

                              ////// view delete  Sub Admin+++++++++++++++++++++++
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

                                        Setstate(() {
                                          controller.OrderList_data(
                                              "${data['id']}");
                                        });
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

//////////////////////////////////////////==========
  // Fetch all detials
  fnFetchCutomerDetails() {
    var tName = controller.Customer_nameController.text;
    var tempData = (tName != '' && controller.CustomerArr[tName] != null)
        ? controller.CustomerArr[tName]
        : {};
    if (tempData.isNotEmpty) {
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
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setstate(() {
        selectedDate = picked;
        controller.Next_date = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  ///
}

/// Class CLose
