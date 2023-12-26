// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, prefer_final_fields, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_null_comparison, sort_child_properties_last, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, depend_on_referenced_packages, avoid_print, unnecessary_new, unused_field, unused_label, unrelated_type_equality_checks, file_names, unnecessary_cast

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/themes/theme_footer.dart';
import 'package:crm_demo/themes/theme_widgets.dart';

import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/firebase_functions.dart';
import '../../themes/global.dart';
import '../../themes/style.dart';
import '../../themes/base_controller.dart';
// import '../../themes/theme_widgets.dart';
import '../../themes/theme_header.dart';
import '../dashboard/components/header.dart';
import 'sub_admin_controller.dart';

class SubAdmin extends StatefulWidget {
  const SubAdmin({super.key});
  @override
  State<SubAdmin> createState() => _SubAdminState();
}

class _SubAdminState extends State<SubAdmin> {
////////// variable of Sub Admin ++++++++++++++++++++++++++++++++++++++++++++++++++
  var controllerr = new SubadminController();
  var baseController = new base_controller();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;

///////////=====================================================================
  var Tablelable = [
    "S.No",
    "Name",
    "Role",
    "Email",
    "Status",
    "Date At",
    "Action",
  ];

  @override
  void initState() {
    _SubAdmin_ListData(_number_select);
    super.initState();
  }
/////////////  Category data fetch From Firebase   ++++++++++++++++++++++++++++=

//////// Attribute data  ++++++++++++++++++++++++++++++++++++++++++++++++++++++=

  _SubAdmin_ListData(limitData) async {
    controllerr.StoreDocs = [];
    var temp = await controllerr.SubAdminData(limitData);
    var tempCate = await controllerr.CateData();

    temp.forEach((k, v) {
      controllerr.StoreDocs.add(v);
    });
    tempCate.forEach((k, v) {
      controllerr.Cate_Name_list[v['category_name']] = v['category_name'];
    });
    setState(() {
      controllerr.progressWidget = false;
    });
  }

  ///=========================================================================

  var firstName;
  var lastName;
  var _email;
  var _passwd;
  var _mobile;
  var _date;

//////
  Map<String, dynamic>? data;
  Future Update_initial(id) async {
    await All_Update_initial(id);
  }

  Future All_Update_initial(id) async {
    var dbData = await dbFind({'table': 'users', 'id': id});
    if (dbData.isNotEmpty) {
      data = dbData;
      setState(() {
        firstName = data!['first_name'];
        lastName = data!['last_name'];
        _email = data!["email"];
        _mobile = data!['mobile_no'];
        _passwd = data!['password'];
        _date = data!['date_at'];
        controllerr.User_Cate = data!['user_type'];
        controllerr.StatusValue = (data!['status'] == "1")
            ? "Active"
            : (data!['status'] == "2")
                ? "Inactive"
                : "Select";
      });
    }
  }

  ///

  ////////// register

  Add_Sub_user(String fname, String lname, String email, String mobile,
      String password, String user_Cate, String _Status, String date_at) async {
    final bytes = utf8.encode(email);
    final base64Str = base64.encode(bytes);

    Map<String, dynamic> w = {};

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      w = {
        'table': "users",
        "first_name": fname,
        "last_name": lname,
        "email": email,
        "mobile_no": controllerr.Mobile,
        "password": password,
        //"user_type": user_Cate,
        "user_type": user_Cate,
        "status": _Status,
        "avatar": "",
        "date_at": date_at,
        "uid": "$base64Str",
      };
      if (controllerr.UserIDcheck.contains(email) != true) {
        if (!kIsWeb && Platform.isWindows) {
          await win_dbSave(db, w);
          await _SubAdmin_ListData(_number_select);
        } else {
          await dbSave(db, w);
          await _SubAdmin_ListData(_number_select);
        }

        themeAlert(context, "Successfully Submitted");

        setState(() {
          controllerr.clearText();
          Add_Category = false;
        });
      } else {
        showSnackbar(context, Colors.red, "User Already Exists !!");
      }
    } else {
      showSnackbar(context, Colors.red, "Invalid Value!!");
      setState(() {
        _isLoading = false;
      });
    }
  }

// //////////===================================================================

////////// delete Category Data ++++++++++++++++++

  Future<void> deleteUser(id) {
    CollectionReference _UsersSubAdmin =
        FirebaseFirestore.instance.collection('users');
    return _UsersSubAdmin.doc(id).delete().then((value) {
      setState(() {
        themeAlert(context, "Deleted Successfully ");
        _SubAdmin_ListData(_number_select);
      });
    }).catchError(
        (error) => themeAlert(context, 'Not find Data', type: "error"));
  }

  Future<void> win_deleteUser(id) {
    var _UsersSubAdmin = Firestore.instance.collection('users');
    return _UsersSubAdmin.document(id).delete().then((value) {
      setState(() {
        themeAlert(context, "Deleted Successfully ");
        _SubAdmin_ListData(_number_select);
      });
    }).catchError(
        (error) => themeAlert(context, 'Not find Data', type: "error"));
  }
  ////////////

/////// Update

  Future<void> updatelist(
      id, f_name, l_name, _email, _mobile, _passwd, user_cat, _Status) async {
    CollectionReference _UsersSubAdmin =
        FirebaseFirestore.instance.collection('users');
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await _UsersSubAdmin.doc(id).update({
        'first_name': f_name,
        "last_name": l_name,
        'email': _email,
        'mobile_no': "$_mobile",
        "password": _passwd,
        "user_type": user_cat,
        "status": (_Status == "Active")
            ? "1"
            : (_Status == "Inactive")
                ? "2"
                : "0",
        "date_at": controllerr.Date_at,
      }).then((value) {
        themeAlert(context, "Successfully Update");
        setState(() {
          updateWidget = false;
          _SubAdmin_ListData(_number_select);
        });
      }).catchError(
          (error) => themeAlert(context, 'Failed to update', type: "error"));
    } else {
      themeAlert(context, 'Fill the Required value!', type: "error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> win_updatelist(
      id, f_name, l_name, _email, _mobile, _passwd, user_cat, _Status) async {
    var _UsersSubAdmin = Firestore.instance.collection('users');
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await _UsersSubAdmin.document(id).update({
        'first_name': f_name,
        "last_name": l_name,
        'email': _email,
        'mobile_no': "$_mobile",
        "password": _passwd,
        "user_type": user_cat,
        "status": (_Status == "Active")
            ? "1"
            : (_Status == "Inactive")
                ? "2"
                : "0",
        "date_at": controllerr.Date_at,
      }).then((value) {
        themeAlert(context, "Successfully Update");
        setState(() {
          updateWidget = false;
          _SubAdmin_ListData(_number_select);
        });
      }).catchError(
          (error) => themeAlert(context, 'Failed to update', type: "error"));
    } else {
      themeAlert(context, 'Fill the Required value!', type: "error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  ///

  bool Add_Category = false;
  bool updateWidget = false;
  var update_id;
  @override
  Widget build(BuildContext context) {
    return (controllerr.progressWidget == true)
        ? Container(color: Colors.white, child: pleaseWait(context))
        : RawKeyboardListener(
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
                appBar: (is_mobile)
                    ? theme_appbar(context,
                        title: "Sub Users List",
                        bg: Colors.black38,
                        textColor: Colors.white)
                    : PreferredSize(
                        preferredSize: Size.fromHeight(0),
                        child: clientAppBar(),
                      ),
                bottomNavigationBar:
                    (is_mobile) ? theme_footer_android(context, 3) : SizedBox(),
                body: Container(
                  child: ListView(
                    children: [
                      if (!is_mobile)
                        // ? themeHeader_android(context, title: "Sub User")
                        // :
                        Header(
                          title: "Sub Users List",
                        ),
                      (view_SubAdmin_info != true)
                          ? (Add_Category != true)
                              ? (updateWidget != true)
                                  ? listList(context, "Add / Edit")
                                  : Update_SubAdmin_Data(
                                      context, update_id, "Edit")
                              : listCon(context, "Add New Sub Admin")
                          : View_SubAdmin_Data(context, "View Details")
                    ],
                  ),
                )),
          );
  }

//// Widget for Start_up
  Widget listCon(BuildContext context, sub_text) {
    return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(children: [
          Container(
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      Add_Category = false;
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
                        'Sub Admin',
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
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: Text("Role *",
                                      style: themeTextStyle(
                                          color: Colors.black,
                                          size: 15,
                                          fw: FontWeight.bold))),
                              Container(
                                height: 40,
                                width:
                                    MediaQuery.of(context).size.width * 0.785,
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  value: controllerr.User_Cate,
                                  underline: Container(),
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  iconSize: 35,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 5, 8, 10)),
                                  items: [
                                    for (MapEntry<String, String> e
                                        in controllerr.Cate_Name_list.entries)
                                      DropdownMenuItem(
                                        value: e.value,
                                        child: Text(e.key),
                                      ),
                                  ],
                                  onChanged: (val) {
                                    setState(
                                      () {
                                        controllerr.User_Cate = val!;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: defaultPadding),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("First name*",
                                        style: themeTextStyle(
                                            color: Colors.black,
                                            size: 15,
                                            fw: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    SizedBox(
                                      height: 45,
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.black),
                                        decoration:
                                            textInputDecoration.copyWith(
                                                labelText: "First Name",
                                                prefixIcon: Icon(
                                                  Icons.person,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                )),
                                        onChanged: (val) {
                                          setState(() {
                                            controllerr.fname = val;
                                          });
                                        },
                                        validator: (val) {
                                          if (val!.isNotEmpty) {
                                            return null;
                                          } else {
                                            return "Name cannot be empty";
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                                SizedBox(height: defaultPadding),
                                if (Responsive.isMobile(context))
                                  SizedBox(width: defaultPadding),
                                if (Responsive.isMobile(context))
                                  Container(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Last name",
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold)),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        height: 45,
                                        child: TextFormField(
                                          style: TextStyle(color: Colors.black),
                                          decoration:
                                              textInputDecoration.copyWith(
                                                  labelText: "Last Name",
                                                  prefixIcon: Icon(
                                                    Icons.person,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  )),
                                          onChanged: (val) {
                                            setState(() {
                                              controllerr.lname = val;
                                            });
                                          },
                                          validator: (val) {
                                            if (val!.isNotEmpty) {
                                              return null;
                                            } else {
                                              return "Name cannot be empty";
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  )),
                              ],
                            ),
                          ),
                          if (!Responsive.isMobile(context))
                            SizedBox(width: defaultPadding),
                          if (!Responsive.isMobile(context))
                            Expanded(
                              flex: 2,
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Last name",
                                      style: themeTextStyle(
                                          color: Colors.black,
                                          size: 15,
                                          fw: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    height: 45,
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.black),
                                      decoration: textInputDecoration.copyWith(
                                          labelText: "Last Name",
                                          prefixIcon: Icon(
                                            Icons.person,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                      onChanged: (val) {
                                        setState(() {
                                          controllerr.lname = val;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )),
                            ),
                        ],
                      ),
                      SizedBox(height: defaultPadding),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          child: Text("Email Id*",
                                              style: themeTextStyle(
                                                  color: Colors.black,
                                                  size: 15,
                                                  fw: FontWeight.bold))),
                                      SizedBox(height: 10),
                                      /////////   Email     TextFormField+++++++++++++++

                                      SizedBox(
                                        height: 45,
                                        child: TextFormField(
                                          style: TextStyle(color: Colors.black),
                                          decoration:
                                              textInputDecoration.copyWith(
                                                  labelText: "Email",
                                                  prefixIcon: Icon(
                                                    Icons.email,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  )),
                                          onChanged: (val) {
                                            setState(() {
                                              controllerr.email = val;
                                            });
                                          },

                                          // check tha validation
                                          validator: (val) {
                                            return RegExp(
                                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                    .hasMatch(val!)
                                                ? null
                                                : "Please enter a valid email";
                                          },
                                        ),
                                      ),
                                      /////
                                    ],
                                  ),
                                ),
                                if (Responsive.isMobile(context))
                                  SizedBox(height: defaultPadding),
                                if (Responsive.isMobile(context))
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            child: Text("Mobile*",
                                                style: themeTextStyle(
                                                    color: Colors.black,
                                                    size: 15,
                                                    fw: FontWeight.bold))),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          height: 45,
                                          child: TextFormField(
                                            style:
                                                TextStyle(color: Colors.black),
                                            decoration:
                                                textInputDecoration.copyWith(
                                                    labelText: "Mobile",
                                                    prefixIcon: Icon(
                                                      Icons.person,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    )),
                                            onChanged: (val) {
                                              setState(() {
                                                controllerr.Mobile = val;
                                              });
                                            },
                                            validator: (val) {
                                              if (val!.isNotEmpty) {
                                                return null;
                                              } else {
                                                return "Name cannot be empty";
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                          if (!Responsive.isMobile(context))
                            SizedBox(width: defaultPadding),
                          // On Mobile means if the screen is less than 850 we dont want to show it
                          if (!Responsive.isMobile(context))
                            Expanded(
                                flex: 2,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          child: Text("Mobile*",
                                              style: themeTextStyle(
                                                  color: Colors.black,
                                                  size: 15,
                                                  fw: FontWeight.bold))),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        height: 45,
                                        child: TextFormField(
                                          style: TextStyle(color: Colors.black),
                                          decoration:
                                              textInputDecoration.copyWith(
                                                  labelText: "Mobile",
                                                  prefixIcon: Icon(
                                                    Icons.phone_iphone_rounded,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  )),
                                          onChanged: (val) {
                                            setState(() {
                                              controllerr.Mobile = val;
                                            });
                                          },
                                          validator: (val) {
                                            if (val!.isNotEmpty) {
                                              return null;
                                            } else {
                                              return "Name cannot be empty";
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                        ],
                      ),
                      SizedBox(height: defaultPadding),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          child: Text("Password*",
                                              style: themeTextStyle(
                                                  color: Colors.black,
                                                  size: 15,
                                                  fw: FontWeight.bold))),
                                      SizedBox(height: 10),
                                      //// Passwd TextFormField ++++++++++++++++++++++++
                                      SizedBox(
                                        height: 45,
                                        child: TextFormField(
                                          style: TextStyle(color: Colors.black),
                                          obscureText: true,
                                          decoration:
                                              textInputDecoration.copyWith(
                                                  labelText: "Password",
                                                  prefixIcon: Icon(
                                                    Icons.lock,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  )),
                                          validator: (val) {
                                            if (val!.length < 6) {
                                              return "Password must be at least 6 characters";
                                            } else {
                                              return null;
                                            }
                                          },
                                          onChanged: (val) {
                                            setState(() {
                                              controllerr.password = val;
                                            });
                                          },
                                        ),
                                      ),
                                      ////
                                    ],
                                  ),
                                ),
                                if (Responsive.isMobile(context))
                                  SizedBox(height: defaultPadding),
                                if (Responsive.isMobile(context)) Status_Drowp()
                              ],
                            ),
                          ),
                          if (!Responsive.isMobile(context))
                            SizedBox(width: defaultPadding),
                          // On Mobile means if the screen is less than 850 we dont want to show it
                          if (!Responsive.isMobile(context))
                            Expanded(flex: 2, child: Status_Drowp()),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            themeButton3(context, () {
                              setState(() async {
                                await Add_Sub_user(
                                    controllerr.fname,
                                    controllerr.lname,
                                    controllerr.email,
                                    controllerr.Mobile,
                                    controllerr.password,
                                    controllerr.User_Cate,
                                    (controllerr.StatusValue == "Active")
                                        ? "1"
                                        : (controllerr.StatusValue ==
                                                "Inactive")
                                            ? "2"
                                            : "",
                                    controllerr.Date_at);

                                // clearText();
                              });
                            }, buttonColor: Colors.green, label: "Submit"),
                            SizedBox(
                              width: 10,
                            ),
                            themeButton3(context, () {
                              setState(() {
                                controllerr.clearText();
                              });
                            }, label: "Reset", buttonColor: Colors.black),
                            SizedBox(width: 20.0),
                          ])
                    ],
                  ))),
          SizedBox(
            height: 200,
          )
        ]));
  }

////////////////////////////// List ++++++++++++++++++++++++++++++++++++++++++++
  var _number_select = 50;
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
          HeadLine(
              context, Icons.admin_panel_settings, "Sub Admin", "$sub_text",
              () {
            setState(() {
              Add_Category = true;
            });
          }, buttonColor: Colors.blue, iconColor: Colors.black),
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: secondaryColor,
            ),
            child: Column(
              children: [
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
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text("",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                ),
                              ])
                        : TableRow(
                            decoration: BoxDecoration(
                                color: Theme.of(context).secondaryHeaderColor),
                            children: [
                                for (var index = 0;
                                    index < Tablelable.length;
                                    index++)
                                  LableText(Tablelable[index],
                                      fsize: 12.0, fw: FontWeight.bold),
                              ]),
                    for (var index = 0;
                        index < controllerr.StoreDocs.length;
                        index++)
                      (Responsive.isMobile(context))
                          ? tableRowWidget_mobile(controllerr.StoreDocs[index])
                          : tableRowWidget(
                              controllerr.StoreDocs[index],
                              "${index + 1}",
                            )
                  ],
                ),
              ],
            ),
          ),
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
                        _SubAdmin_ListData(newVal);
                        //  initFunctions(newVal);
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
            height: 200,
          ),
        ],
      ),
    );
  }

  TableRow tableRowWidget(
    data,
    sno,
  ) {
    var status = (data!["status"] == "1")
        ? "Active"
        : (data!["status"] == "2")
            ? "Inactive"
            : "";
    var iid = data!["id"];
    // (!kIsWeb && Platform.isWindows) ? "${data["id"]}" : "${data["uid"]}";
    return TableRow(children: [
      LableText("$sno"),
      LableText("${data["first_name"]} ${data["last_name"]}"),
      LableText("${data["user_type"]}"),
      LableText("${data["email"]}"),
      LableText("$status",
          color: status == "Active" ? Colors.green : Colors.red),
      LableText("${data["date_at"]}"),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Action_btn(context, iid)),
    ]);
  }

  TableRow tableRowWidget_mobile(data) {
    var iid = data["id"];

    var status = (data!["status"] == "1")
        ? "Active"
        : (data!["status"] == "2")
            ? "Inactive"
            : "";

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
                  themeListRow(context, "Name",
                      "${data["first_name"]} ${data["last_name"]}"),
                  themeListRow(context, "User Type", "${data["user_type"]}"),
                  themeListRow(context, "Email", "${data["email"]}"),
                  themeListRow(context, "Status", "$status"),
                  themeListRow(context, "Date", "${data["date_at"]}"),
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
                      Action_btn(context, data['id'])
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

/////////    Action Button For Web And Mobile ++++++++++++++++++++++++++++++++
  ///
  Widget Action_btn(BuildContext context, iid) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 40,
      child: Row(
        children: [
          ////// view Update Edit  Sub Admin+++++++++
          Container(
              height: 30,
              width: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      updateWidget = true;
                      update_id = iid;
                      if (!kIsWeb && Platform.isWindows) {
                        All_Update_initial(iid);
                      } else {
                        Update_initial(iid);
                      }
                    });
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.yellow,
                    size: 15,
                  )) ////
              ),
          ////// view delete  Sub Admin+++++++++++++++++++++++
          SizedBox(width: 10),
          Container(
              height: 30,
              width: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: IconButton(
                  onPressed: () {
                    showExitPopup(iid);
                  },
                  icon: Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.red,
                    size: 15,
                  ))),
          ///// view details Sub Admin+++++++++++++++++++
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
                      view_SubAdmin_info = true;
                      if (!kIsWeb && Platform.isWindows) {
                        All_Update_initial(iid);
                      } else {
                        Update_initial(iid);
                      }
                    });
                  },
                  icon: Icon(
                    Icons.visibility,
                    color: Colors.green,
                    size: 15,
                  ))),
        ],
      ),
    );
  }

  ///
  ///===============================================================================================

  bool passwordVisible = true;
/////////////  Update widget for product Update+++++++++++++++++++++++++
  Widget Update_SubAdmin_Data(BuildContext context, id, sub_text) {
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
                      controllerr.clearText();
                      updateWidget = false;
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
                        'Sub Admin',
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
              child: (data == null)
                  ? Center(child: CircularProgressIndicator())
                  : Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Text("Role *",
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold))),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.785,
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: DropdownButton(
                                      dropdownColor: Colors.white,
                                      value: controllerr.User_Cate,
                                      underline: Container(),
                                      isExpanded: true,
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black,
                                      ),
                                      iconSize: 35,
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 5, 8, 10)),
                                      items: [
                                        for (MapEntry<String, String> e
                                            in controllerr
                                                .Cate_Name_list.entries)
                                          DropdownMenuItem(
                                            value: e.value,
                                            child: Text(e.key),
                                          ),
                                      ],
                                      onChanged: (val) {
                                        setState(
                                          () {
                                            controllerr.User_Cate = val!;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: defaultPadding),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Container(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("First name*",
                                            style: themeTextStyle(
                                                color: Colors.black,
                                                size: 15,
                                                fw: FontWeight.bold)),
                                        Container(
                                            height: 40,
                                            margin: EdgeInsets.only(
                                                top: 10, bottom: 10, right: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: TextFormField(
                                              initialValue: firstName,
                                              autofocus: false,
                                              onChanged: (val) {
                                                setState(() {
                                                  firstName = val;
                                                });
                                              },
                                              validator: (val) {
                                                if (val!.isNotEmpty) {
                                                  return null;
                                                } else {
                                                  return "Name cannot be empty";
                                                }
                                              },
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.person,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 15),
                                                hintText: "First Name",
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )),
                                      ],
                                    )),
                                    SizedBox(height: defaultPadding),
                                    if (Responsive.isMobile(context))
                                      SizedBox(width: defaultPadding),
                                    if (Responsive.isMobile(context))
                                      Container(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Last name",
                                              style: themeTextStyle(
                                                  color: Colors.black,
                                                  size: 15,
                                                  fw: FontWeight.bold)),
                                          Container(
                                              height: 40,
                                              margin: EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: TextFormField(
                                                initialValue: lastName,
                                                autofocus: false,
                                                onChanged: (val) {
                                                  setState(() {
                                                    lastName = val;
                                                  });
                                                },
                                                style: TextStyle(
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.person,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 20,
                                                          vertical: 15),
                                                  hintText: "Last Name",
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              )),
                                        ],
                                      )),
                                  ],
                                ),
                              ),
                              if (!Responsive.isMobile(context))
                                SizedBox(width: defaultPadding),
                              if (!Responsive.isMobile(context))
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Last name",
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold)),
                                      Container(
                                          height: 40,
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10, right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextFormField(
                                            initialValue: lastName,
                                            autofocus: false,
                                            onChanged: (val) {
                                              setState(() {
                                                lastName = val;
                                              });
                                            },
                                            style:
                                                TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 15),
                                              hintText: "Last Name",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                              ),
                                            ),
                                          )),
                                    ],
                                  )),
                                ),
                            ],
                          ),
                          SizedBox(height: defaultPadding),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              child: Text("Email*",
                                                  style: themeTextStyle(
                                                      color: Colors.black,
                                                      size: 15,
                                                      fw: FontWeight.bold))),
                                          /////////   Email     TextFormField+++++++++++++++

                                          Container(
                                              height: 40,
                                              margin: EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: TextFormField(
                                                initialValue: _email,
                                                autofocus: false,
                                                onChanged: (val) {
                                                  setState(() {
                                                    _email = val;
                                                  });
                                                },
                                                //     // check tha validation
                                                validator: (val) {
                                                  return RegExp(
                                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                          .hasMatch(val!)
                                                      ? null
                                                      : "Please enter a valid email";
                                                },
                                                style: TextStyle(
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.email,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 20,
                                                          vertical: 15),
                                                  hintText: "Email Id",
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              )),
                                          /////
                                        ],
                                      ),
                                    ),
                                    if (Responsive.isMobile(context))
                                      SizedBox(height: defaultPadding),
                                    if (Responsive.isMobile(context))
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                child: Text("Mobile*",
                                                    style: themeTextStyle(
                                                        color: Colors.black,
                                                        size: 15,
                                                        fw: FontWeight.bold))),
                                            Container(
                                                height: 40,
                                                margin: EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: TextFormField(
                                                  initialValue: _mobile,
                                                  autofocus: false,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      _mobile = val;
                                                    });
                                                  },
                                                  validator: (val) {
                                                    if (val!.isNotEmpty) {
                                                      return null;
                                                    } else if (val.length <
                                                        10) {
                                                      return "Mobile no. must be at least 10 characters";
                                                    } else {
                                                      return "Mobile cannot be empty";
                                                    }
                                                  },
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  decoration: InputDecoration(
                                                    prefixIcon: Icon(
                                                      Icons.person,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 15),
                                                    hintText: "Mobile No.",
                                                    hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              if (!Responsive.isMobile(context))
                                SizedBox(width: defaultPadding),
                              // On Mobile means if the screen is less than 850 we dont want to show it
                              if (!Responsive.isMobile(context))
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              child: Text("Mobile*",
                                                  style: themeTextStyle(
                                                      color: Colors.black,
                                                      size: 15,
                                                      fw: FontWeight.bold))),
                                          Container(
                                              height: 40,
                                              margin: EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: TextFormField(
                                                initialValue: _mobile,
                                                autofocus: false,
                                                onChanged: (val) {
                                                  setState(() {
                                                    _mobile = val;
                                                  });
                                                },
                                                validator: (val) {
                                                  if (val!.isNotEmpty) {
                                                    return null;
                                                  } else if (val.length < 10) {
                                                    return "Mobile no. must be at least 10 characters";
                                                  } else {
                                                    return "Mobile cannot be empty";
                                                  }
                                                },
                                                style: TextStyle(
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.person,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 20,
                                                          vertical: 15),
                                                  hintText: "Mobile No.",
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                    )),
                            ],
                          ),
                          SizedBox(height: defaultPadding),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              child: Text("Password*",
                                                  style: themeTextStyle(
                                                      color: Colors.black,
                                                      size: 15,
                                                      fw: FontWeight.bold))),
                                          //// Passwd TextFormField ++++++++++++++++++++++++
                                          Container(
                                              height: 40,
                                              margin: EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: TextFormField(
                                                obscureText: passwordVisible,
                                                initialValue: _passwd,
                                                autofocus: false,
                                                onChanged: (val) {
                                                  setState(() {
                                                    _passwd = val;
                                                  });
                                                },
                                                validator: (val) {
                                                  if (val!.length < 6) {
                                                    return "Password must be at least 6 characters";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                style: TextStyle(
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.person,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      passwordVisible
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                      color: Colors.blue,
                                                      size: 20,
                                                    ),
                                                    onPressed: () {
                                                      setState(
                                                        () {
                                                          passwordVisible =
                                                              !passwordVisible;
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 20,
                                                          vertical: 15),
                                                  hintText: "Password",
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                    if (Responsive.isMobile(context))
                                      SizedBox(height: defaultPadding),
                                    if (Responsive.isMobile(context))
                                      Status_Drowp()
                                  ],
                                ),
                              ),
                              if (!Responsive.isMobile(context))
                                SizedBox(width: defaultPadding),
                              // On Mobile means if the screen is less than 850 we dont want to show it
                              if (!Responsive.isMobile(context))
                                Expanded(flex: 2, child: Status_Drowp()),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                themeButton3(context, () {
                                  setState(() async {
                                    if (!kIsWeb && Platform.isWindows) {
                                      await win_updatelist(
                                          id,
                                          firstName,
                                          lastName,
                                          _email,
                                          _mobile,
                                          _passwd,
                                          controllerr.User_Cate,
                                          (controllerr.StatusValue != null)
                                              ? controllerr.StatusValue
                                              : controllerr.StatusValue);
                                    } else {
                                      await updatelist(
                                          id,
                                          firstName,
                                          lastName,
                                          _email,
                                          _mobile,
                                          _passwd,
                                          controllerr.User_Cate,
                                          (controllerr.StatusValue != null)
                                              ? controllerr.StatusValue
                                              : controllerr.StatusValue);
                                    }

                                    controllerr.clearText();
                                  });
                                }, buttonColor: Colors.green, label: "Update"),
                                SizedBox(
                                  width: 10,
                                ),
                                themeButton3(context, () {
                                  setState(() {
                                    controllerr.clearText();
                                  });
                                }, label: "Reset", buttonColor: Colors.black),
                                SizedBox(width: 20.0),
                              ])
                        ],
                      )))
        ]));
  }
///////////////////////////

//1234
  bool view_SubAdmin_info = false;
/////////////  Update widget for product Update+++++++++++++++++++++++++
  Widget View_SubAdmin_Data(BuildContext context, sub_text) {
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
                      view_SubAdmin_info = false;
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
                        'Sub Admin',
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
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 2,
                color: Colors.black,
              )),
          Container(
              padding: EdgeInsets.all(defaultPadding),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black12,
                // borderRadius:
                //     const BorderRadius.all(Radius.circular(10)),
              ),
              child: (data == null)
                  ? Center(child: CircularProgressIndicator())
                  : Column(children: [
                      themeListRow(
                          context, "First Name", "$firstName $lastName",
                          descColor: Colors.black, headColor: Colors.black),
                      SizedBox(height: defaultPadding),
                      themeListRow(context, "Role", "${controllerr.User_Cate}",
                          descColor: Colors.black, headColor: Colors.black),
                      SizedBox(height: defaultPadding),
                      themeListRow(context, "Email Id", "$_email",
                          descColor: Colors.black, headColor: Colors.black),
                      SizedBox(height: defaultPadding),
                      themeListRow(context, "Mobile No.", "$_mobile",
                          descColor: Colors.black, headColor: Colors.black),
                      SizedBox(height: defaultPadding),
                      themeListRow(
                          context, "Status", "${controllerr.StatusValue}",
                          descColor: Colors.black, headColor: Colors.black),
                      SizedBox(height: defaultPadding),
                      themeListRow(context, "Date At", "$_date",
                          descColor: Colors.black, headColor: Colors.black),
                    ]))
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
          onChanged: (val) {
            setState(() {
              ctr_name = val;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Enter value';
            }
            return null;
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

  Future<bool> showExitPopup(iid_delete) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red,
                  size: 35,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'CRM App says',
                  style: themeTextStyle(
                      size: 20.0,
                      ftFamily: 'ms',
                      fw: FontWeight.bold,
                      color: themeBG2),
                ),
              ],
            ),
            content: Text(
              'Are you sure to delete this sub admin ?',
              style: themeTextStyle(
                  size: 16.0,
                  ftFamily: 'ms',
                  fw: FontWeight.normal,
                  color: Colors.black87),
            ),
            actions: [
              Container(
                height: 30,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'No',
                    style: themeTextStyle(
                        size: 16.0,
                        ftFamily: 'ms',
                        fw: FontWeight.normal,
                        color: Colors.red),
                  ),
                ),
              ),
              Container(
                height: 30,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      if (!kIsWeb) {
                        win_deleteUser(iid_delete);
                      } else {
                        deleteUser(iid_delete);
                      }

                      Navigator.of(context).pop(false);
                    });
                  },
                  child: Text(
                    'Yes',
                    style: themeTextStyle(
                        size: 16.0,
                        ftFamily: 'ms',
                        fw: FontWeight.normal,
                        color: themeBG4),
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  Widget Status_Drowp() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: Text("Status",
                  style: themeTextStyle(
                      color: Colors.black, size: 15, fw: FontWeight.bold))),
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
              hint: controllerr.StatusValue == ""
                  ? Text(
                      "Select",
                      style: TextStyle(color: Colors.black),
                    )
                  : Text(
                      controllerr.StatusValue!,
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
              items: ['Select', 'Inactive', 'Active'].map(
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
                    controllerr.StatusValue = val!;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Class CLose
