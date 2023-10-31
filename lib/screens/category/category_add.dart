// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, prefer_final_fields, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_null_comparison, sort_child_properties_last, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, depend_on_referenced_packages, avoid_print, unnecessary_new, unnecessary_cast, override_on_non_overriding_member, await_only_futures, unused_field

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/screens/category/category_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slug_it/slug_it.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/firebase_Storage.dart';
import '../../themes/firebase_functions.dart';
import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';
import '../../themes/base_controller.dart';
import '../dashboard/components/header.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CategoryAdd extends StatefulWidget {
  const CategoryAdd({super.key});
  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final _formKey = GlobalKey<FormState>();
  var controllerr = new categoryController();
  var baseController = new base_controller();
  bool Add_Category = false;
//////
  int limitData = 50;
  @override
  void initState() {
    CategoryData(limitData);
    super.initState();
  }

  CategoryData(limitData) async {
    var temp = await controllerr.Comman_Cate_Data(limitData);
    var tempImage = await controllerr.Image_data();
    var tempDrop = await controllerr.CateData();
    setState(() {
      temp.forEach((k, v) {
        controllerr.StoreDocs.add(v);
      });
      tempImage.forEach((k, v) {
        controllerr.Storage_image_List.add(v["image_url"]);
      });

      tempDrop.forEach((k, v) {
        if (v['category_name'] != '') {
          controllerr.Cate_Name_list[v['category_name']] = v['category_name'];
        }
      });
      controllerr.progressWidget = false;
    });
  }

  ///// File Picker ==========================================================

  pickFile() async {
    if (!kIsWeb) {
      final results = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg'],
        allowMultiple: false,
      );

      if (results != null) {
        final path = results.files.single.path;
        final fileName = results.files.single.name;

        // UploadFile(path!, fileName).then((value) {});

        setState(() async {
          controllerr.url_img = await uploadFile(path!, fileName, db);
          await CategoryData(limitData);
          // image_addList(url_img);
          // downloadURL = await FirebaseStorage.instance
          //     .ref()
          //     .child('media/$fileName')
          //     .getDownloadURL();
          // url_img = downloadURL.toString();
        });
      } else {
        themeAlert(context, 'Not find selected', type: "error");
      }
    } else if (kIsWeb) {
      final results = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg'],
      );
      if (results != null) {
        Uint8List? UploadImage = results.files.single.bytes;
        controllerr.fileName = results.files.single.name;
        Reference reference =
            FirebaseStorage.instance.ref('media/${controllerr.fileName}');
        final UploadTask uploadTask = reference.putData(UploadImage!);
        uploadTask.whenComplete(() => print("selected image"));
        setState(() async {
          controllerr.downloadURL = await FirebaseStorage.instance
              .ref()
              .child('media/${controllerr.fileName}')
              .getDownloadURL();
          setState(() {
            controllerr.url_img = controllerr.downloadURL.toString();
            // image_addList(url_img);
          });

          //   print("$url_img  +++++++88888888+++++++++");
        });
      } else {
        themeAlert(context, 'Not find selected', type: "error");
        return null;
      }
    }
  }

////////

  Future<void> addList() {
    CollectionReference _category =
        FirebaseFirestore.instance.collection('category');
    return _category.add({
      'category_name': "${controllerr.cate_name}",
      'slug_url': "${controllerr.slug__url}",
      'parent_cate': "${controllerr.PerentCate}",
      'status': (controllerr.StatusValue == "Active")
          ? "1"
          : (controllerr.StatusValue == "Inactive")
              ? "2"
              : "0",
      'image': "${controllerr.url_img}",
      "update_at": "",
      "date_at": "${controllerr.Date_at}"
    }).then((value) {
      themeAlert(context, "Submitted Successfully ");
      CategoryData(limitData);
    }).catchError(
        (error) => themeAlert(context, 'Failed to Submit', type: "error"));
  }

//////////

  var slugUrl = "";
  var image = "";
  var Catename = "";
//////
  Map data = {};
  Future _Update_initial(id) async {
    Map<dynamic, dynamic> w = {'table': "category", 'id': id};
    data = await dbFind(w);
    if (data != null) {
      setState(() {
        print("$data  +++++++++");
        Catename = data['category_name'];
        controllerr.PerentCate = data['parent_cate'];
        slugUrl = data['slug_url'];
        image = data["image"];
        controllerr.StatusValue = (data['status'] == "1")
            ? "Active"
            : (data['status'] == "2")
                ? "Inactive"
                : "Select";
      });
    }
  }

  ///

  updatelist(id, Catename, slugUrl, _Status, _perentCate, image) async {
    Map<String, dynamic> w = {};
    w = {
      'table': "category",
      'category_name': "$Catename",
      "parent_cate": "${(_perentCate == null) ? '' : _perentCate}",
      'slug_url': "$slugUrl",
      'status': (_Status == "Active")
          ? "1"
          : (_Status == "Inactive")
              ? "2"
              : "0",
      "image": "$image",
      "update_at": "${controllerr.Date_at}"
    };

    w['id'] = update_id;

    var msg = await dbUpdate(db, w);
    themeAlert(context, "$msg");
    setState(() {
      controllerr.clearText();
      CategoryData(limitData);
      updateWidget = false;
    });
  }

  //////

  Future<void> All_addList() async {
    // print("$url_img  +++++++++++++");
    var _category = await Firestore.instance.collection('category');
    return _category.add({
      'category_name': "${controllerr.cate_name}",
      'slug_url': "${controllerr.slug__url}",
      'parent_cate': "${controllerr.PerentCate}",
      'status': (controllerr.StatusValue == "Active")
          ? "1"
          : (controllerr.StatusValue == "Inactive")
              ? "2"
              : "0",
      "image": (controllerr.url_img != "") ? "${controllerr.url_img}" : "",
      "update_at": "",
      "date_at": "${controllerr.Date_at}"
    }).then((value) {
      setState(() {
        themeAlert(context, "Submitted Successfully ");
        CategoryData(limitData);
        Add_Category = false;
      });
    }).catchError(
        (error) => themeAlert(context, 'Failed to Submit', type: "error"));
  }

//////////

/////////////  ==============================================

  bool updateWidget = false;
  var update_id;
  @override
  Widget build(BuildContext context) {
    return (controllerr.progressWidget == true)
        ? Center(child: pleaseWait(context))
        : Scaffold(
            body: Container(
            child: ListView(
              children: [
                Header(
                  title: "Category",
                ),
                (Add_Category != true)
                    ? (updateWidget != true)
                        ? listList(context, "Add / Edit")
                        : Update_Category(context, update_id, "Edit")
                    : listCon(context, "Add New Category")
              ],
            ),
          ));
    // });
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
                      Add_Category = false;
                      controllerr.clearText();
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
                        'Category',
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
                    child: Row(
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
                                  Text("Category Name*",
                                      style: themeTextStyle(
                                          color: Colors.black,
                                          size: 15,
                                          fw: FontWeight.bold)),
                                  Text_field(
                                      context,
                                      controllerr.CategoryController,
                                      "Category Name",
                                      "Enter Category Name"),
                                ],
                              )),
                              SizedBox(height: defaultPadding),
                              if (Responsive.isMobile(context))
                                SizedBox(width: defaultPadding),
                              if (Responsive.isMobile(context))
                                Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Slug Url",
                                        style: themeTextStyle(
                                            color: Colors.black,
                                            size: 15,
                                            fw: FontWeight.bold)),
                                    Text_field(
                                        context,
                                        controllerr.SlugUrlController,
                                        "Slug Url",
                                        "Enter Slug Url"),
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
                                Text("Slug Url",
                                    style: themeTextStyle(
                                        color: Colors.black,
                                        size: 15,
                                        fw: FontWeight.bold)),
                                Text_field(
                                    context,
                                    controllerr.SlugUrlController,
                                    "Slug Url",
                                    "Enter Slug Url"),
                              ],
                            )),
                          ),
                      ],
                    ),
                  ),
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
                                    margin: EdgeInsets.only(
                                        top: 10, bottom: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: DropdownButton(
                                      dropdownColor: Colors.white,
                                      hint: controllerr.StatusValue == null
                                          ? Text(
                                              'Select',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          : Text(
                                              controllerr.StatusValue!,
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 1, 0, 0)),
                                            ),
                                      isExpanded: true,
                                      underline: Container(),
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black,
                                      ),
                                      iconSize: 35,
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 1, 7, 7)),
                                      items:
                                          ['Select', 'Inactive', 'Active'].map(
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
                            ),
                            SizedBox(height: defaultPadding),
                            if (Responsive.isMobile(context))
                              SizedBox(width: defaultPadding),
                            if (Responsive.isMobile(context))
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: Text(
                                            "Parent Category ${controllerr.PerentCate}",
                                            style: themeTextStyle(
                                                color: Colors.black,
                                                size: 15,
                                                fw: FontWeight.bold))),
                                    Container(
                                      height: 40,
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
                                        value: controllerr.Cate_Name_list
                                                .containsKey(
                                                    controllerr.PerentCate)
                                            ? controllerr.PerentCate
                                            : '',
                                        underline: Container(),
                                        isExpanded: true,
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black,
                                        ),
                                        iconSize: 35,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 5, 8, 10)),
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
                                              controllerr.PerentCate = val!;
                                            },
                                          );
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Text("Parent Category",
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold))),
                                  Container(
                                    height: 40,
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
                                      value: controllerr.PerentCate,
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
                                            controllerr.PerentCate = val!;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Icon Image*",
                                style: themeTextStyle(
                                    size: 15, fw: FontWeight.bold)),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 45,
                              margin: EdgeInsets.only(
                                  top: 10, bottom: 10, right: 10),
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      CategoryData(limitData);
                                      _ImageSelect_Alert(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  31, 232, 226, 226)),
                                          color: Color.fromARGB(
                                              255, 237, 235, 235)),
                                      child: Text(
                                        "Choose File",
                                        style: themeTextStyle(size: 15),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  (controllerr.url_img == "")
                                      ? Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("No file choosen",
                                                style: themeTextStyle(
                                                    size: 15,
                                                    color: Colors.black38)),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "file selected",
                                              style: themeTextStyle(
                                                  size: 12,
                                                  fw: FontWeight.w400,
                                                  color: themeBG4),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                            ////
                            SizedBox(height: defaultPadding),
                          ],
                        ),
                      ),
                      if (!Responsive.isMobile(context))
                        SizedBox(width: defaultPadding),
                      if (!Responsive.isMobile(context))
                        Expanded(
                          flex: 2,
                          child: SizedBox(width: defaultPadding),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      (controllerr.url_img != "")
                          ? Image.network(
                              controllerr.url_img,
                              height: 100,
                              width: 100,
                              fit: BoxFit.contain,
                            )
                          : Icon(Icons.photo, size: 12)
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    themeButton3(context, () {
                      if (_formKey.currentState!.validate() &&
                          controllerr.url_img != null) {
                        setState(() async {
                          controllerr.cate_name =
                              controllerr.CategoryController.text;
                          controllerr.slug__url =
                              controllerr.SlugUrlController.text;
                          if (!kIsWeb && Platform.isWindows) {
                            await All_addList();
                          } else {
                            await addList();
                          }
                          controllerr.clearText();
                        });
                      } else {
                        themeAlert(context, 'Image value required!',
                            type: "error");
                      }
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
              )),
          SizedBox(
            height: 100,
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
          HeadLine(context, Icons.category_outlined, "Category", "$sub_text",
              () {
            setState(() {
              Add_Category = true;
            });
          }, buttonColor: Colors.blue, iconColor: Colors.black),
          Container(
            margin: EdgeInsets.all(10),
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
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Category List",
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
                                    child: SizedBox(
                                      child: Text('Logo',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      width: 40,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Category Name",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text("Parent Category",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
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
                    for (var index = 0;
                        index < controllerr.StoreDocs.length;
                        index++)
                      (Responsive.isMobile(context))
                          ? tableRowWidget_mobile(
                              "${controllerr.StoreDocs[index]["image"]}",
                              "${controllerr.StoreDocs[index]["category_name"]}",
                              "${controllerr.StoreDocs[index]["parent_cate"]}",
                              (controllerr.StoreDocs[index]["status"] == "1")
                                  ? "Active"
                                  : (controllerr.StoreDocs[index]["status"] ==
                                          "2")
                                      ? "Inactive"
                                      : "Select",
                              "${controllerr.StoreDocs[index]["date_at"]}",
                              "${controllerr.StoreDocs[index]["id"]}")
                          : tableRowWidget(
                              "${index + 1}", controllerr.StoreDocs[index]),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          _number_select = newVal!;
                          CategoryData(newVal);
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
              ),
            ],
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  TableRow tableRowWidget(sno, data) {
    var status = (data["status"] == "1")
        ? "Active"
        : (data["status"] == "2")
            ? "Inactive"
            : "Select";

    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$sno",
              style: GoogleFonts.alike(
                  fontWeight: FontWeight.normal, fontSize: 11)),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        // horizentalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              alignment: Alignment.topLeft,
              height: 60,
              width: 60,
              child: Image(
                  image: (data["image"] != null)
                      ? NetworkImage(
                          data["image"],
                        )
                      : (data["image"] == "")
                          ? NetworkImage(
                              "https://shopnguyenlieumypham.com/wp-content/uploads/no-image/product-456x456.jpg",
                            )
                          : NetworkImage(
                              "https://shopnguyenlieumypham.com/wp-content/uploads/no-image/product-456x456.jpg",
                            ),
                  fit: BoxFit.contain),
            )),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${data["category_name"]}",
              style: GoogleFonts.alike(
                  fontWeight: FontWeight.normal, fontSize: 11)),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("${data["parent_cate"]}",
            style:
                GoogleFonts.alike(fontWeight: FontWeight.normal, fontSize: 11)),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("$status",
            style: GoogleFonts.alike(
                fontWeight: FontWeight.normal,
                fontSize: 11,
                color: (status == "Active") ? Colors.green : Colors.red)),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("${data["date_at"]}",
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
                          update_id = data["id"];
                          _Update_initial(data["id"]);
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 15,
                        color: Colors.blue,
                      )) ////
                  ),
              /*SizedBox(width: 10),
              Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: IconButton(
                      tooltip: "Delete",
                      onPressed: () {
                        showExitPopup(iid);
                      },
                      icon: Icon(
                        Icons.delete_outline_outlined,
                        size: 15,
                        color: Colors.red,
                      ))),*/
            ],
          )),
    ]);
  }

  TableRow tableRowWidget_mobile(Iimage, name, pName, status, date, iid) {
    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(5),
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 214, 214, 214),
                  image: DecorationImage(
                      image: (Iimage != "null" && Iimage.isNotEmpty)
                          ? NetworkImage(
                              Iimage,
                            )
                          : NetworkImage(
                              "https://shopnguyenlieumypham.com/wp-content/uploads/no-image/product-456x456.jpg",
                            ),
                      fit: BoxFit.contain)),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  themeListRow(context, "Product Name", "$name", fontsize: 11),
                  themeListRow(context, "Category Name", "$pName",
                      fontsize: 11),
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
                                  _Update_initial(iid);
                                });
                              },
                              icon: Icon(
                                Icons.edit,
                                size: 15,
                                color: Colors.blue,
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
  ///========================================================================
  ///========================================================================
  ///========================================================================
  ///========================================================================
  Widget Update_Category(BuildContext context, id, sub_text) {
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
                      controllerr.clearText();
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
                        'Category',
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
                  : Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Category Name*",
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
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        initialValue: Catename,
                                        autofocus: false,
                                        onChanged: (value) => Catename = value,
                                        // controller: ctr_name,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Enter Category Name";
                                          }
                                          return null;
                                        },
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          hintText: "Category Name",
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )),
                                  // SizedBox(height: defaultPadding),
                                  // if (Responsive.isMobile(context))
                                  //   SizedBox(width: defaultPadding),
                                  // if (Responsive.isMobile(context))
                                  //   Container(
                                  //       height: 40,
                                  //       margin: EdgeInsets.only(
                                  //           top: 10, bottom: 10, right: 10),
                                  //       decoration: BoxDecoration(
                                  //         color: Colors.white,
                                  //         borderRadius:
                                  //             BorderRadius.circular(10),
                                  //       ),
                                  //       child: TextFormField(
                                  //         initialValue: slugUrl,
                                  //         autofocus: false,
                                  //         onChanged: (value) => slugUrl = value,
                                  //         // controller: ctr_name,
                                  //         validator: (value) {
                                  //           if (value == null ||
                                  //               value.isEmpty) {
                                  //             return "Enter Slug Url";
                                  //           }
                                  //           return null;
                                  //         },
                                  //         style: TextStyle(color: Colors.black),
                                  //         decoration: InputDecoration(
                                  //           border: InputBorder.none,
                                  //           contentPadding:
                                  //               EdgeInsets.symmetric(
                                  //                   horizontal: 20,
                                  //                   vertical: 15),
                                  //           hintText: "Slug Url",
                                  //           hintStyle: TextStyle(
                                  //             color: Colors.grey,
                                  //             fontSize: 16,
                                  //           ),
                                  //         ),
                                  //       )),
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
                                    Text("Slug Url",
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
                                          initialValue: slugUrl,
                                          autofocus: false,
                                          onChanged: (value) => slugUrl = value,
                                          // controller: ctr_name,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Enter Slug Url";
                                            }
                                            return null;
                                          },
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 15),
                                            hintText: "Slug Url",
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
                        //status
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
                                            child: Text("Status",
                                                style: themeTextStyle(
                                                    color: Colors.black,
                                                    size: 15,
                                                    fw: FontWeight.bold))),
                                        Container(
                                          height: 40,
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10, right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: DropdownButton(
                                            dropdownColor: Colors.white,
                                            hint: controllerr.StatusValue ==
                                                    null
                                                ? Text(
                                                    'Select',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                : Text(
                                                    controllerr.StatusValue!,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                            isExpanded: true,
                                            underline: Container(),
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.black,
                                            ),
                                            iconSize: 35,
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0)),
                                            items: [
                                              'Select',
                                              'Inactive',
                                              'Active'
                                            ].map(
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
                                                  controllerr.StatusValue =
                                                      val!;
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Text_field(context,"category_name","Category Name","Enter Category Name"),
                                  // SizedBox(height: defaultPadding),
                                  // if (Responsive.isMobile(context))
                                  //   SizedBox(width: defaultPadding),
                                  // if (Responsive.isMobile(context))

                                  //   Text_field(context,"slug_url","Slug Url","Enter Slug Url"),

                                  // Container(
                                  //   child: Column(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     children: [
                                  //       Container(
                                  //           child: Text("Parent Category",
                                  //               style: themeTextStyle(
                                  //                   color: Colors.black,
                                  //                   size: 15,
                                  //                   fw: FontWeight.bold))),
                                  //       Container(
                                  //         height: 40,
                                  //         margin: EdgeInsets.only(
                                  //             top: 10, bottom: 10, right: 10),
                                  //         decoration: BoxDecoration(
                                  //           color: Colors.white,
                                  //           borderRadius:
                                  //               BorderRadius.circular(10),
                                  //         ),
                                  //         padding: EdgeInsets.only(
                                  //             left: 10, right: 10),
                                  //         child: DropdownButton(
                                  //           dropdownColor: Colors.white,
                                  //           hint: _dropDownValue == null
                                  //               ? Text(
                                  //                   'select',
                                  //                   style: TextStyle(
                                  //                       color: Colors.black),
                                  //                 )
                                  //               : Text(
                                  //                   _dropDownValue!,
                                  //                   style: TextStyle(
                                  //                       color: Colors.black),
                                  //                 ),
                                  //           underline: Container(),
                                  //           isExpanded: true,
                                  //           icon: Icon(
                                  //             Icons.arrow_drop_down,
                                  //             color: Colors.black,
                                  //           ),
                                  //           iconSize: 35,
                                  //           style: TextStyle(
                                  //               color: Color.fromARGB(
                                  //                   255, 1, 1, 2)),
                                  //           items: [
                                  //             'Select',
                                  //             'One',
                                  //             'Two',
                                  //             'Three'
                                  //           ].map(
                                  //             (val) {
                                  //               return DropdownMenuItem<
                                  //                   String>(
                                  //                 value: val,
                                  //                 child: Text(val),
                                  //               );
                                  //             },
                                  //           ).toList(),
                                  //           onChanged: (val) {
                                  //             setState(
                                  //               () {
                                  //                 _dropDownValue = val!;
                                  //               },
                                  //             );
                                  //           },
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // )
                                  SizedBox()
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
                                            child: Text("Parent Category ",
                                                style: themeTextStyle(
                                                    color: Colors.black,
                                                    size: 15,
                                                    fw: FontWeight.bold))),
                                        Container(
                                          height: 40,
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: DropdownButton(
                                            dropdownColor: Colors.white,
                                            value: controllerr.Cate_Name_list
                                                    .containsKey(
                                                        controllerr.PerentCate)
                                                ? controllerr.PerentCate
                                                : '',
                                            underline: Container(),
                                            isExpanded: true,
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.black,
                                            ),
                                            iconSize: 35,
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 5, 8, 10)),
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
                                                  controllerr.PerentCate = val!;
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                          ],
                        ),
                        (controllerr.url_img == "" && image == "null")
                            ? SizedBox()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      width: 100,
                                      child: Column(
                                        children: [
                                          (controllerr.url_img == "")
                                              ? Image.network(
                                                  "$image",
                                                  height: 100,
                                                  fit: BoxFit.contain,
                                                )
                                              : Image.network(
                                                  controllerr.url_img,
                                                  height: 100,
                                                  fit: BoxFit.contain,
                                                ),
                                          GestureDetector(
                                            onTap: () {
                                              // return  "Image Removed Successfully";
                                              print(
                                                  "Image Removed Successfully");
                                            },
                                            child: Container(
                                                alignment: Alignment.center,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    color: Colors.red),
                                                child: Text(
                                                  "Remove Image",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11),
                                                )),
                                          )
                                        ],
                                      )),
                                ],
                              ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Upload Image Here",
                                      style: themeTextStyle(
                                          size: 15, fw: FontWeight.bold)),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 40,
                                    margin: EdgeInsets.only(
                                        top: 10, bottom: 10, right: 10),
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            CategoryData(limitData);
                                            _ImageSelect_Alert(context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white),
                                                color: Colors.grey),
                                            child: Text(
                                              "Choose File",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        (controllerr.url_img == "")
                                            ? Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("No file choosen",
                                                      style: themeTextStyle(
                                                          size: 15,
                                                          color:
                                                              Colors.black38)),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "file selected",
                                                    style: themeTextStyle(
                                                        size: 12,
                                                        fw: FontWeight.w400,
                                                        color: themeBG4),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                  ////
                                  SizedBox(height: defaultPadding),
                                ],
                              ),
                            ),

                            if (!Responsive.isMobile(context))
                              SizedBox(width: defaultPadding),
                            // On Mobile means if the screen is less than 850 we dont want to show it
                            if (!Responsive.isMobile(context))
                              Expanded(
                                flex: 2,
                                child: SizedBox(width: defaultPadding),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              themeButton3(context, () {
                                setState(() {
                                  updatelist(
                                      id,
                                      Catename,
                                      slugUrl,
                                      controllerr.StatusValue,
                                      controllerr.PerentCate,
                                      (controllerr.url_img == "")
                                          ? image
                                          : controllerr.url_img);
                                });
                              }, buttonColor: Colors.blue, label: "Update"),
                              SizedBox(height: 20.0),
                            ])
                      ],
                    )),
        ]));
  }
///////////////////////////

//////////////////   popup Box for Image selection ++++++++++++++++++++++++++++++++++++++

  void _ImageSelect_Alert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setStatee) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20.0,
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
                      Text(
                        "Media",
                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                      ),
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
                width: MediaQuery.of(context).size.width - 400,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              "All Media ",
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                            ),
                          ),
                          themeButton3(context, () {
                            setState(() {
                              pickFile();
                              Navigator.of(context).pop();
                            });
                          }, label: "Add New", buttonColor: Colors.blue),
                        ],
                      ),
                      Divider(
                        thickness: 1.5,
                        color: Colors.black,
                      ),
                      if (!Responsive.isMobile(context))
                        All_media(context, setStatee),
                      if (Responsive.isMobile(context))
                        All_media_mobile(context, setStatee)
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

//////////////////////////////////////////==========

////////  Data bases Image call  +++++++++++++++++++++++++++++++
  List<String> _selectedOptions = [];
  Widget All_media(BuildContext context, setStatee) {
    return Container(
      height: 500,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: controllerr.Storage_image_List.length,
        itemBuilder: (_, index) => Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              image: DecorationImage(
                image: NetworkImage('${controllerr.Storage_image_List[index]}'),
                fit: BoxFit.contain,
              ),
            ),
            alignment: Alignment.topLeft,
            child: CheckboxListTile(
              checkColor: Colors.white,
              activeColor: Colors.green,
              side: BorderSide(width: 2, color: Colors.red),
              value: _selectedOptions
                  .contains(controllerr.Storage_image_List[index]),
              onChanged: (value) {
                setState(() {
                  if (value != null && _selectedOptions.isEmpty) {
                    setState(() {
                      _selectedOptions
                          .add(controllerr.Storage_image_List[index]);
                      controllerr.url_img = _selectedOptions[0];
                      Navigator.pop(context);
                    });
                  } else if (_selectedOptions != null &&
                      _selectedOptions.isNotEmpty) {
                    setState(() {
                      _selectedOptions[0] =
                          "${controllerr.Storage_image_List[index]}";
                      controllerr.url_img = _selectedOptions[0];
                      Navigator.pop(context);
                    });
                  } else {
                    _selectedOptions
                        .remove(controllerr.Storage_image_List[index]);
                  }
                });
              },
            )),
      ),
    );
  }
//////////

////////  Data bases Image call   MOBILE +++++++++++++++++++++++++++++++

  Widget All_media_mobile(BuildContext context, setStatee) {
    return Container(
      height: 500,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: controllerr.Storage_image_List.length, // <-- required
        itemBuilder: (_, index) => Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              image: DecorationImage(
                image: NetworkImage('${controllerr.Storage_image_List[index]}'),
                fit: BoxFit.contain,
              ),
            ),
            child: CheckboxListTile(
              checkColor: Colors.white,
              activeColor: Colors.green,
              side: BorderSide(width: 2, color: Colors.red),
              value: _selectedOptions
                  .contains(controllerr.Storage_image_List[index]),
              onChanged: (value) {
                setState(() {
                  if (value != null && _selectedOptions.isEmpty) {
                    setState(() {
                      _selectedOptions
                          .add(controllerr.Storage_image_List[index]);
                      controllerr.url_img = _selectedOptions[0];
                      Navigator.pop(context);
                    });
                  } else if (_selectedOptions != null &&
                      _selectedOptions.isNotEmpty) {
                    setState(() {
                      _selectedOptions[0] =
                          "${controllerr.Storage_image_List[index]}";
                      controllerr.url_img = _selectedOptions[0];
                      Navigator.pop(context);
                    });
                  } else {
                    _selectedOptions
                        .remove(controllerr.Storage_image_List[index]);
                  }
                });
              },
            )),
      ),
    );
  }
//////////

  //////////
  Slug_gen(String text) {
    var listtt = [];
    var slus_string = "";
    String slug = SlugIT().makeSlug(text);

    for (var index = 0; index < controllerr.StoreDocs.length; index++) {
      listtt.add("${controllerr.StoreDocs[index]['slug_url']}");
    }

    slus_string = slug;
    if (listtt.contains("$slus_string")) {
      setState(() {
        controllerr.SlugUrlController.text = "$slus_string${listtt.length}";
      });
    } else {
      setState(() {
        controllerr.SlugUrlController.text = slus_string;
      });
    }
  }

/////
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
          onChanged: (ctr_name == controllerr.CategoryController)
              ? (value) {
                  Slug_gen("$value");
                }
              : (value) {},
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

  ///
}

/// Class CLose
