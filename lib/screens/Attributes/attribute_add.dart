// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, prefer_final_fields, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_null_comparison, sort_child_properties_last, unused_import, body_might_complete_normally_nullable, no_leading_underscores_for_local_identifiers, unused_field, depend_on_referenced_packages, avoid_print, sized_box_for_whitespace, unnecessary_new, unused_shown_name, unnecessary_cast, duplicate_ignore, await_only_futures
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';
import '../../themes/firebase_functions.dart';
import '../dashboard/components/header.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:intl/intl.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AttributeAdd extends StatefulWidget {
  const AttributeAdd({super.key});
  @override
  State<AttributeAdd> createState() => _AttributeAddState();
}

class _AttributeAddState extends State<AttributeAdd> {
  var db = (kIsWeb)
      ? FirebaseFirestore.instance
      : (!kIsWeb && Platform.isWindows)
          ? Firestore.instance
          : FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
//////
  final AttributeController = TextEditingController();
  final Sub_AttributeController = TextEditingController();
  String? _StatusValue = "Active";
  String Date_at = DateFormat('dd-MM-yyyy' "  hh:mm").format(DateTime.now());
  bool progressWidget = true;
/////
  clearText() {
    AttributeController.clear();
    _StatusValue = "Active";
  }

///////////  firebase property Database access  +++++++++++++++++++++++++++

  List StoreDocs = [];

  _AttributeData() async {
    StoreDocs = [];
    CollectionReference _attribute =
        FirebaseFirestore.instance.collection('attribute');
    var querySnapshot = await _attribute.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      // ignore: unnecessary_cast
      Map data = queryDocumentSnapshot.data() as Map<String, dynamic>;
      StoreDocs.add(data);
      data["id"] = queryDocumentSnapshot.id;
    }
    setState(() {
      progressWidget = false;
    });
  }

/////////////
  Color mycolor = Colors.grey;
  var Head_Name;
  var hexString;
  var _Status;
  Map value_color = {};
  List Color_list = [];
//////
  Map<String, dynamic>? dbData;
  Future Update_initial(id) async {
    Color_list = [];
    if (!kIsWeb && Platform.isWindows) {
      final _attribute = Firestore.instance.collection('attribute');
      final pathData = await _attribute.document(id).get();
      await refresh_sub_attribute(pathData);
    } else {
      DocumentSnapshot pathData = await FirebaseFirestore.instance
          .collection('attribute')
          .doc(id)
          .get();
      await refresh_sub_attribute(pathData);
    }
  }

  refresh_sub_attribute(pathData) {
    if (pathData.exists) {
      dbData = pathData.data() as Map<String, dynamic>?;
      setState(() {
        _Status = dbData!['status'];
        AttributeController.text = dbData!['attribute_name'];
        Sub_AttributeController.text = dbData!["attribute_name"];
        value_color = dbData!["value"];
        value_color.forEach((k, v) => Color_list.add(v));
        // print("$Color_list  ++++++");
      });
    }
  }

  ///

/////// add Category Data  =+++++++++++++++++++

  Future<void> addList() async {
    if (!kIsWeb && Platform.isWindows) {
      var attribute = await Firestore.instance.collection('attribute');
      await _saveAttr(attribute);
    } else {
      CollectionReference attribute =
          FirebaseFirestore.instance.collection('attribute');
      await _saveAttr(attribute);
    }

    if (Platform.isWindows) {
      All_AttributeData();
    } else {
      _AttributeData();
    }
    clearText();
  }

  // save attribute
  _saveAttr(attribute) {
    return attribute.add({
      'attribute_name': "${AttributeController.text}",
      "value": {},
      'status': "${(_StatusValue == 'Active') ? '1' : "2"}",
      "date_at": "$Date_at"
    }).then((value) {
      setState(() {
        themeAlert(context, "Added Successfully");
      });
    }).catchError(
        (error) => themeAlert(context, 'Failed to Submit', type: "error"));
  }

//////////

////////// delete Category Data ++++++++++++++++

  Future<void> deleteUser(id) {
    CollectionReference _attribute =
        FirebaseFirestore.instance.collection('attribute');
    return _attribute.doc(id).delete().then((value) {
      setState(() {
        themeAlert(context, "Deleted Successfully ");
      });
    }).catchError(
        (error) => themeAlert(context, 'Not find Data', type: "error"));
  }

  ////////////

/////// Update

  Future<void> updatelist(id, Catename, _Status) {
    CollectionReference _attribute =
        FirebaseFirestore.instance.collection('attribute');
    return _attribute.doc(id).update({
      'attribute_name': "$Catename",
      'status': (_Status == "Active")
          ? "1"
          : (_Status == "Inactive")
              ? "2"
              : "",
      "date_at": "$Date_at"
    }).then((value) {
      themeAlert(context, "Successfully Update");
      setState(() {
        _Status = null;
        _StatusValue = null;
        AttributeController.clear();
        _AttributeData();
        updateWidget = false;
      });
    }).catchError(
        (error) => themeAlert(context, 'Failed to update', type: "error"));
  }

/////////

  @override
  void initState() {
    if (!kIsWeb && Platform.isWindows) {
      All_AttributeData();
    } else {
      _AttributeData();
    }

    super.initState();
  }

//////////// hhh

  All_AttributeData() async {
    // print("object   +++++++++++++++++++++");
    StoreDocs = [];
    final _attribute = Firestore.instance.collection('attribute');
    final documents = await _attribute.get();
    for (var document in documents) {
      Map data = document.map as Map<String, dynamic>;
      StoreDocs.add(data);
      data["id"] = document.id;
    }
    setState(() {
      progressWidget = false;
    });
  }

  Future All_Update_initial(id) async {
    Color_list = [];
    final _attribute = Firestore.instance.collection('attribute');
    final pathData = await _attribute.document(id).get();
    // DocumentSnapshot pathData =
    //     await FirebaseFirestore.instance.collection('attribute').doc(id).get();
    if (pathData != null) {
      dbData = pathData.map as Map<String, dynamic>?;

      _StatusValue = (dbData!['status'] == "1")
          ? "Active"
          : (dbData!['status'] == "2")
              ? "Inactive"
              : "";
      AttributeController.text = dbData!['attribute_name'];
      Sub_AttributeController.text = '';
      value_color = dbData!["value"];
      value_color.forEach((k, v) {
        Color_list.add(v);
      });
      // print("$Color_list  ++++++");

      if (this.mounted) {
        setState(() {
          Color_list = Color_list;
        });
      }
    }
  }

  /////// Update

  Future<void> All_updatelist(id, Catename, _Status) {
    final _attribute = Firestore.instance.collection('attribute');
    return _attribute.document(id).update({
      'attribute_name': "$Catename",
      'status': (_Status == "Active")
          ? "1"
          : (_Status == "Inactive")
              ? "2"
              : "",
      "date_at": "$Date_at"
    }).then((value) {
      themeAlert(context, "Successfully Update");
      setState(() {
        _Status = null;
        _StatusValue = null;
        AttributeController.clear();
        All_AttributeData();
        updateWidget = false;
      });
    }).catchError(
        (error) => themeAlert(context, 'Failed to update', type: "error"));
  }

///////// =============================================
  _fnAddSubAttribute(id) async {
    if (Sub_AttributeController.text.length < 1) {
      themeAlert(context, "Please Enter valid Sub Attribute Name",
          type: 'error');
      return false;
    }

    var tempColor = dbData!['value'];
    if (dbData!['attribute_name'] == 'Colors') {
      tempColor[Sub_AttributeController.text.trim()] = {
        "name": "${Sub_AttributeController.text.trim()}",
        "color": hexString,
        "status": 1,
        "date_at": "$Date_at",
      };
    } else {
      tempColor[Sub_AttributeController.text.trim()] = {
        "name": "${Sub_AttributeController.text.trim()}",
        "status": 1,
        "date_at": "$Date_at",
      };
    }

    dbData!['value'] = tempColor;
    Map<String, dynamic> where = {
      'table': "attribute",
      'id': id,
      'value': tempColor
    };
    if (!kIsWeb && Platform.isWindows) {
      await All_dbUpdate(db, where);
      await All_Update_initial(id);
    } else {
      await dbUpdate(db, where);
      await Update_initial(id);
    }

    _Status = null;
    Sub_AttributeController.clear();
  }

  ///

  bool updateWidget = false;
  bool update_subAttribute = false;
  var update_id;
  @override
  Widget build(BuildContext context) {
    return (progressWidget == true)
        ? Center(child: pleaseWait(context))
        : Scaffold(
            body: Container(
            child: ListView(
              children: [
                Header(
                  title: "Attribute",
                ),
                (Add_Attribute != true)
                    ? (updateWidget != true)
                        ? (update_subAttribute == true && updateWidget == false)
                            ? Update_Sub_Attribute(
                                context, update_id, "View/Add")
                            : listList(context, "Add / Edit")
                        : Update_Attribute(context, update_id, "Edit")
                    : listCon(context, "Add New Attribute")
              ],
            ),
          ));
  }

//// Widget for Start_up
  Widget listCon(BuildContext context, sub_text) {
    return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius:
          //     const BorderRadius.all(Radius.circular(10)),
        ),
        child: ListView(children: [
          Container(
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      Add_Attribute = false;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.blue, size: 25),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Attribute',
                        style: themeTextStyle(
                            size: 18.0,
                            ftFamily: 'ms',
                            fw: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '$sub_text',
                        style: themeTextStyle(
                            size: 12.0,
                            ftFamily: 'ms',
                            fw: FontWeight.normal,
                            color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.all(defaultPadding),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Form(
                      key: _formKey,
                      child: Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Attribute Name*",
                              style: themeTextStyle(
                                  color: Colors.black,
                                  size: 15,
                                  fw: FontWeight.bold)),
                          Text_field(context, AttributeController,
                              "Attribute Name", "Enter Category Name"),
                        ],
                      ))),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: Text("Status",
                                style: themeTextStyle(
                                    color: Colors.black,
                                    size: 15,
                                    fw: FontWeight.bold))),
                        Container(
                          height: 40,
                          margin:
                              EdgeInsets.only(top: 10, bottom: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: DropdownButton(
                            dropdownColor: Colors.white,
                            hint: _StatusValue == null
                                ? Text(
                                    'Select',
                                    style: TextStyle(color: Colors.black),
                                  )
                                : Text(
                                    _StatusValue!,
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 1, 0, 0)),
                                  ),
                            isExpanded: true,
                            underline: Container(),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            iconSize: 35,
                            style:
                                TextStyle(color: Color.fromARGB(255, 1, 7, 7)),
                            items: ['Active', 'Inactive'].map(
                              (val) {
                                return DropdownMenuItem<String>(
                                  value: val,
                                  child: Text(val),
                                );
                              },
                            ).toList(),
                            onChanged: (val) {
                              setState(
                                () {
                                  _StatusValue = val!;
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    themeButton3(context, () {
                      addList();

                      setState(() {
                        Add_Attribute = false;
                      });
                    }, buttonColor: Colors.green, label: "Submit"),
                    SizedBox(
                      width: 10,
                    ),
                    themeButton3(context, () {
                      setState(() {
                        clearText();
                      });
                    }, label: "Reset", buttonColor: Colors.black),
                    SizedBox(width: 20.0),
                  ])
                ],
              )),
          SizedBox(
            height: 100,
          )
        ]));
  }

////////////////////////////// List ++++++++++++++++++++++++++++++++++++++++++++
  bool Add_Attribute = false;
  var _number_select = 10;
  Widget listList(BuildContext context, sub_text) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius:
        //     const BorderRadius.all(Radius.circular(10)),
      ),
      child: ListView(
        children: [
          HeadLine(context, Icons.line_style_sharp, "Attribute", "$sub_text",
              () {
            setState(() {
              Add_Attribute = true;
            });
          }, buttonColor: Colors.blue, iconColor: Colors.black),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: secondaryColor,
            ),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    color: Theme.of(context).secondaryHeaderColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Attribute List",
                              style: themeTextStyle(
                                  fw: FontWeight.bold,
                                  color: Colors.white,
                                  size: 15),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Show",
                                  style: themeTextStyle(
                                      fw: FontWeight.normal,
                                      color: Colors.white,
                                      size: 15),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  padding: EdgeInsets.all(2),
                                  height: 20,
                                  color: Colors.white,
                                  child: DropdownButton<int>(
                                    dropdownColor: Colors.white,
                                    iconEnabledColor: Colors.black,
                                    hint: Text(
                                      "$_number_select",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                    value: _number_select,
                                    items:
                                        <int>[10, 25, 50, 100].map((int value) {
                                      return new DropdownMenuItem<int>(
                                        value: value,
                                        child: new Text(
                                          value.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newVal) {
                                      setState(() {
                                        _number_select = newVal!;
                                      });
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
                            )
                          ],
                        ),
                        //     Container(
                        //         margin: EdgeInsets.symmetric(horizontal: 10),
                        //         height: MediaQuery.of(context).size.height * 0.05,
                        //         width: MediaQuery.of(context).size.width * 0.4,
                        //         child: SearchField())
                      ],
                    )),
                SizedBox(
                  height: 5,
                ),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder(
                    horizontalInside: BorderSide(width: .5, color: Colors.grey),
                  ),
                  children: [
                    (Responsive.isMobile(context))
                        ? TableRow(
                            decoration: BoxDecoration(
                                color: Theme.of(context).secondaryHeaderColor),
                            children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Category Details",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                ),
                              ])
                        : TableRow(
                            decoration: BoxDecoration(
                                color: Theme.of(context).secondaryHeaderColor),
                            children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('S.No.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Name",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text("Status",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text("Date",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text("Actions",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ]),
                    for (var index = 0; index < StoreDocs.length; index++)
                      (Responsive.isMobile(context))
                          ? tableRowWidget_mobile(
                              "${StoreDocs[index]["attribute_name"]}",
                              "${StoreDocs[index]["status"]}",
                              "${StoreDocs[index]["date_at"]}",
                              "${StoreDocs[index]["id"]}")
                          : tableRowWidget(
                              "${index + 1}",
                              "${StoreDocs[index]["attribute_name"]}",
                              "${StoreDocs[index]["status"]}",
                              "${StoreDocs[index]["date_at"]}",
                              "${StoreDocs[index]["id"]}"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow tableRowWidget(sno, name, status, date, iid) {
    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text("$sno",
              style: GoogleFonts.alike(
                  fontWeight: FontWeight.normal, fontSize: 11)),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text("$name",
              style: GoogleFonts.alike(
                  fontWeight: FontWeight.normal, fontSize: 11)),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text(
            (status == "1")
                ? "Active"
                : (status == "2")
                    ? "Inactive"
                    : "",
            style: GoogleFonts.alike(
              fontWeight: FontWeight.normal,
              color: (status == "1") ? Colors.green : Colors.red,
              fontSize: 11,
            )),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("$date",
            style:
                GoogleFonts.alike(fontWeight: FontWeight.normal, fontSize: 11)),
      ),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Row(
            children: [
              Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          updateWidget = true;
                          update_id = iid;
                          if (Platform.isWindows) {
                            All_Update_initial(iid);
                          } else {
                            Update_initial(iid);
                          }
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 15,
                        color: Colors.blue,
                      )) ////
                  ),
              SizedBox(width: 10),
              Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          update_subAttribute = true;
                          update_id = iid;
                          Head_Name = name;
                          if (kIsWeb) {
                            Update_initial(iid);
                          } else if (!kIsWeb) {
                            All_Update_initial(iid);
                          }
                        });
                      },
                      icon: Icon(
                        Icons.list,
                        size: 15,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      )) ////
                  ),
            ],
          )),
    ]);
  }

  TableRow tableRowWidget_mobile(name, status, date, iid) {
    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  themeListRow(context, "Name", "$name", fontsize: 11),
                  themeListRow(context, "Satus", "$status", fontsize: 11),
                  themeListRow(context, "Date", "$date", fontsize: 11),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 100.0,
                        child: Text(
                          "Action",
                          style: themeTextStyle(
                              size: 12.0,
                              color: Colors.white,
                              ftFamily: 'ms',
                              fw: FontWeight.bold),
                        ),
                      ),
                      Text(
                        ": ",
                        overflow: TextOverflow.ellipsis,
                        style: themeTextStyle(
                            size: 14,
                            color: Colors.white,
                            ftFamily: 'ms',
                            fw: FontWeight.normal),
                      ),
                      Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  updateWidget = true;
                                  update_id = iid;
                                  Update_initial(iid);
                                });
                              },
                              icon: Icon(
                                Icons.edit,
                                size: 15,
                                color: Colors.blue,
                              )) ////
                          ),
                      SizedBox(width: 10),
                      Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  update_subAttribute = true;
                                  update_id = iid;
                                  Update_initial(iid);
                                });
                              },
                              icon: Icon(
                                Icons.more_horiz_outlined,
                                size: 15,
                                color: Colors.green,
                              )) ////
                          ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      )
    ]);
  }

/////////

/////////////  Update widget for product Update+++++++++++++++++++++++++
  Widget Update_Attribute(BuildContext context, id, sub_text) {
    return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius:
          //     const BorderRadius.all(Radius.circular(10)),
        ),
        child: ListView(children: [
          Container(
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      updateWidget = false;
                      Head_Name = null;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.blue, size: 25),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Attribute',
                        style: themeTextStyle(
                            size: 18.0,
                            ftFamily: 'ms',
                            fw: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '$sub_text',
                        style: themeTextStyle(
                            size: 12.0,
                            ftFamily: 'ms',
                            fw: FontWeight.normal,
                            color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.all(defaultPadding),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Attribute Name*",
                          style: themeTextStyle(
                              color: Colors.black,
                              size: 15,
                              fw: FontWeight.bold)),
                      Container(
                          height: 40,
                          margin:
                              EdgeInsets.only(top: 10, bottom: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            autofocus: false,
                            controller: AttributeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Attribute Name";
                              }
                              return null;
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              hintText: "Attibute Name ",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          )),
                    ],
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Status",
                          style: themeTextStyle(
                              color: Colors.black,
                              size: 15,
                              fw: FontWeight.bold)),
                    ],
                  ),
                  Container(
                    height: 40,
                    margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: DropdownButton(
                      dropdownColor: Colors.white,
                      hint: _StatusValue == null
                          ? Text(
                              '$_Status',
                              style: TextStyle(color: Colors.black),
                            )
                          : Text(
                              _StatusValue!,
                              style: TextStyle(color: Colors.black),
                            ),
                      isExpanded: true,
                      underline: Container(),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      iconSize: 35,
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      items: ['Select', 'Active', 'Inactive'].map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(
                          () {
                            _StatusValue = val!;
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    themeButton3(context, () {
                      if (AttributeController != null && _StatusValue != null) {
                        setState(() {
                          if (kIsWeb) {
                            updatelist(
                                id, AttributeController.text, _StatusValue);
                          } else if (!kIsWeb) {
                            All_updatelist(
                                id, AttributeController.text, _StatusValue);
                          }
                        });
                      } else {
                        themeAlert(context, 'Please Enter Required value!',
                            type: "error");
                      }
                    }, buttonColor: Colors.green, label: "Update"),
                    SizedBox(
                      width: 10,
                    ),
                    themeButton3(context, () {
                      setState(() {
                        clearText();
                        _Status = null;
                        _StatusValue = "";
                        AttributeController.clear();
                      });
                    }, label: "Reset", buttonColor: Colors.black),
                    SizedBox(width: 20.0),
                  ])
                ],
              )),
          SizedBox(
            height: 100,
          )
        ]));
  }
///////////////////////////

/////////////  Update widget for product Update++++++++++++++++++++++
  Widget Update_Sub_Attribute(BuildContext context, id, sub_text) {
    return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius:
          //     const BorderRadius.all(Radius.circular(10)),
        ),
        child: ListView(children: [
          Container(
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      update_subAttribute = false;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.blue, size: 25),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '$Head_Name Attribute',
                        style: themeTextStyle(
                            size: 18.0,
                            ftFamily: 'ms',
                            fw: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '$sub_text',
                        style: themeTextStyle(
                            size: 12.0,
                            ftFamily: 'ms',
                            fw: FontWeight.normal,
                            color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.all(defaultPadding),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Add New",
                                    style: themeTextStyle(
                                        color: Colors.black,
                                        size: 15,
                                        fw: FontWeight.bold)),
                                Text_field(
                                    context,
                                    Sub_AttributeController,
                                    "Enter Sub Attribute Name",
                                    "Sub Attribute Name "),

                                // add button =========================
                                themeButton3(context, () {
                                  if (Sub_AttributeController.text.isNotEmpty) {
                                    _fnAddSubAttribute(id);
                                  } else {
                                    themeAlert(
                                        context, 'Please Enter Required value!',
                                        type: "error");
                                  }
                                }, buttonColor: Colors.green, label: "Add New"),
                              ],
                            )),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Attribute List",
                                    style: themeTextStyle(
                                        color: Colors.black,
                                        size: 15,
                                        fw: FontWeight.bold)),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Table(
                                border: TableBorder.all(
                                    color: Colors.black26, width: 1.5),
                                children: [
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("S.No.",
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Data",
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Indentity",
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Status",
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold)),
                                    ),
                                  ]),
                                  for (var i = 0; i < Color_list.length; i++)
                                    TableRow(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text("${i + 1}",
                                            style: themeTextStyle(
                                                color: Colors.black,
                                                size: 15,
                                                fw: FontWeight.normal)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                            "${Color_list[i]["name"]}"
                                                .toUpperCase(),
                                            style: themeTextStyle(
                                                color: Colors.black,
                                                size: 15, // Sizes
                                                fw: FontWeight.normal)),
                                      ),
                                      (Head_Name != "Sizes")
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Pick a color!'),
                                                          content:
                                                              SingleChildScrollView(
                                                            child: ColorPicker(
                                                              pickerColor:
                                                                  mycolor, //default color
                                                              onColorChanged:
                                                                  (Color
                                                                      color) {
                                                                //on color picked
                                                                setState(
                                                                    () async {
                                                                  mycolor =
                                                                      color;
                                                                  hexString = color
                                                                      .value
                                                                      .toRadixString(
                                                                          16)
                                                                      .padLeft(
                                                                          9,
                                                                          '0x');
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              child:
                                                                  Text('DONE'),
                                                              onPressed: () {
                                                                setState(() {
                                                                  var tempColor =
                                                                      dbData![
                                                                          'value'];
                                                                  tempColor[
                                                                      "${Color_list[i]["name"]}"] = {
                                                                    "name":
                                                                        "${Color_list[i]["name"]}",
                                                                    "color":
                                                                        "$hexString",
                                                                    "status":
                                                                        "${Color_list[i]["status"]}",
                                                                    "date_at":
                                                                        "$Date_at",
                                                                  };
                                                                  dbData!['value'] =
                                                                      tempColor;
                                                                  Map<String,
                                                                          dynamic>
                                                                      where = {
                                                                    'table':
                                                                        "attribute",
                                                                    'id': id,
                                                                    'value':
                                                                        tempColor
                                                                  };

                                                                  if (!kIsWeb &&
                                                                      Platform
                                                                          .isWindows) {
                                                                    All_dbUpdate(
                                                                      db,
                                                                      where,
                                                                    );
                                                                  } else {
                                                                    dbUpdate(db,
                                                                        where);
                                                                  }
                                                                  Update_initial(
                                                                      id);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                });

                                                                //dismiss the color picker
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: Container(
                                                  width: 10.0,
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15),
                                                    height: 30,
                                                    width: 10,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 5.0),
                                                        color: (Color_list[i]
                                                                    ['color'] ==
                                                                null)
                                                            ? Color.fromARGB(
                                                                0, 0, 0, 0)
                                                            : Color(int.parse(
                                                                Color_list[i][
                                                                        'color']
                                                                    .toString()))),
                                                  ),
                                                ),
                                              ))
                                          : SizedBox(),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                            "${Color_list[i]["status"]}",
                                            style: themeTextStyle(
                                                color: Colors.black,
                                                size: 15,
                                                fw: FontWeight.normal)),
                                      ),
                                    ]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(width: 20.0),
                  ])
                ],
              )),
          SizedBox(
            height: 100,
          )
        ]));
  }
///////////////////////////

///////  Text_field 22 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ///
  Widget Text_field(BuildContext context, ctr_name, lebel, hint) {
    return Container(
        height: 40,
        margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: ctr_name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Enter value';
            }
          },
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            hintText: '$hint',
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ));
  }
///////////
}

/// Class CLose
