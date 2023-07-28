// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, prefer_final_fields, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_null_comparison, sort_child_properties_last, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, depend_on_referenced_packages, avoid_print, unnecessary_new

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slug_it/slug_it.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/firebase_Storage.dart';
import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';
import '../dashboard/components/header.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CategoryAdd extends StatefulWidget {
  const CategoryAdd({super.key});
  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final _formKey = GlobalKey<FormState>();

  var cate_name = "";
  var slug__url = "";
  var image_logo = "";

  String? _dropDownValue;
  String? _StatusValue;
  String Date_at = DateFormat('dd-MM-yyyy').format(DateTime.now());

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final CategoryController = TextEditingController();
  final SlugUrlController = TextEditingController();
  bool Tranding = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    CategoryController.dispose();
    SlugUrlController.dispose();
    super.dispose();
  }

  clearText() {
    SlugUrlController.clear();
    CategoryController.clear();
    _dropDownValue = null;
    _StatusValue = null;
  }
//////

  ///// File Picker ==========================================================
  var url_img;
  String? fileName;

  void clear_imageData() {
    fileName = null;
    url_img = null;
  }

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
        UploadFile(path!, fileName).then((value) {
          // print("image selected");
        });
        setState(() async {
          downloadURL = await FirebaseStorage.instance
              .ref()
              .child('media/$fileName')
              .getDownloadURL();
          url_img = downloadURL.toString();
          setState(() {
            url_img = downloadURL.toString();
          });
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
        fileName = results.files.single.name;
        Reference reference = FirebaseStorage.instance.ref('media/$fileName');
        final UploadTask uploadTask = reference.putData(UploadImage!);
        uploadTask.whenComplete(() => print("selected image"));
        setState(() async {
          downloadURL = await FirebaseStorage.instance
              .ref()
              .child('media/$fileName')
              .getDownloadURL();
          setState(() {
            url_img = downloadURL.toString();
          });

          //   print("$url_img  +++++++88888888+++++++++");
        });
      } else {
        themeAlert(context, 'Not find selected', type: "error");
        return null;
      }
    }
  }

/////////// firebase Storage +++++++++++++++++++
  ///
  String? downloadURL;
  List<String> myList = [];
  Future listExample() async {
    firebase_storage.ListResult result =
        await firebase_storage.FirebaseStorage.instance.ref('media').listAll();
    result.items.forEach((firebase_storage.Reference ref) async {
      var uri = await downloadURLExample("${ref.fullPath}");
      myList.add(uri);
    });
    return myList;
  }

  Future downloadURLExample(image_path) async {
    downloadURL =
        await FirebaseStorage.instance.ref().child(image_path).getDownloadURL();
    return downloadURL.toString();
  }

////

///////////  firebase property Database access  +++++++++++++++++++++++++++
  final Stream<QuerySnapshot> _crmStream =
      FirebaseFirestore.instance.collection('category').snapshots();
  CollectionReference _category =
      FirebaseFirestore.instance.collection('category');
////////

/////////////  Category data fetch From Firebase   +++++++++++++++++++++++++++++++++++++++++++++

  List StoreDocs = [];
  _CateData() async {
    StoreDocs = [];
    var collection = FirebaseFirestore.instance.collection('category');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      // ignore: unnecessary_cast
      Map data = queryDocumentSnapshot.data() as Map<String, dynamic>;
      StoreDocs.add(data);
      data["id"] = queryDocumentSnapshot.id;
    }
    setState(() {
      listExample();
      //print("$StoreDocs ++++++++");
    });
  }

/////////////

  var Perent_cat;
  var slugUrl;
  var image;
  var _Status;
  var Catename;
//////
  Map<String, dynamic>? data;
  Future Update_initial(id) async {
    DocumentSnapshot pathData =
        await FirebaseFirestore.instance.collection('category').doc(id).get();
    if (pathData.exists) {
      data = pathData.data() as Map<String, dynamic>?;
      setState(() {
        Perent_cat = data!['parent_cate'];
        slugUrl = data!['slug_url'];
        image = data!["image"];
        _Status = data!['status'];
        Catename = data!['category_name'];
      });
    }
  }

  ///

/////// add Category Data  =+++++++++++++++++++

  Future<void> addList() {
    return _category.add({
      'category_name': "$cate_name",
      'slug_url': "$slug__url",
      'parent_cate': "$_dropDownValue",
      'status': (_StatusValue == "Active")
          ? "1"
          : (_StatusValue == "Inactive")
              ? "2"
              : "0",
      'image': "$url_img",
      "date_at": "$Date_at"
    }).then((value) {
      setState(() {
        themeAlert(context, "Submitted Successfully ");
        _CateData();
      });
    }).catchError(
        (error) => themeAlert(context, 'Failed to Submit', type: "error"));
  }

//////////

////////// delete Category Data ++++++++++++++++++

  Future<void> deleteUser(id) {
    return _category.doc(id).delete().then((value) {
      setState(() {
        themeAlert(context, "Deleted Successfully ");
        _CateData();
      });
    }).catchError(
        (error) => themeAlert(context, 'Not find Data', type: "error"));
  }

  ////////////
  ///
/////// Update

  Future<void> updatelist(id, Catename, slugUrl, _Status, _perentCate, image) {
    return _category.doc(id).update({
      'category_name': "$Catename",
      "parent_cate": "$_perentCate",
      'slug_url': "$slugUrl",
      'status': (_Status == "Active")
          ? "1"
          : (_Status == "Inactive")
              ? "2"
              : "0",
      "image": "$image",
      "date_at": "$Date_at"
    }).then((value) {
      themeAlert(context, "Successfully Update");
      setState(() {
        updateWidget = false;
        _CateData();
      });
    }).catchError(
        (error) => themeAlert(context, 'Failed to update', type: "error"));
  }

  ///

///////////    Creating SLug Url Function +++++++++++++++++++++++++++++++++++++++
  Slug_gen(String text) {
    var slus_string;
    String slug = SlugIT().makeSlug(text);
    setState(() {
      slus_string = slug;
      SlugUrlController.text = slus_string;
    });
  }
///// ++++++++++++++++++++++++++++++++++++++

  bool Add_Category = false;

  @override
  void initState() {
    _CateData();
    super.initState();
  }

  bool updateWidget = false;
  var update_id;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _crmStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //////
          if (snapshot.hasError) {
            themeAlert(context, '"Something went wrong"', type: "error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          ////////
          return Scaffold(
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
        });
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
                                  Text_field(context, CategoryController,
                                      "Category Name", "Enter Category Name"),
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
                                    Text_field(context, SlugUrlController,
                                        "Slug Url", "Enter Slug Url"),
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
                                Text_field(context, SlugUrlController,
                                    "Slug Url", "Enter Slug Url"),
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
                                      hint: _StatusValue == null
                                          ? Text(
                                              'Select',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          : Text(
                                              _StatusValue!,
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
                                            _StatusValue = val!;
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
                                        child: Text("Parent Category",
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
                                        hint: _dropDownValue == null
                                            ? Text(
                                                'Select',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )
                                            : Text(
                                                _dropDownValue!,
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
                                            color:
                                                Color.fromARGB(255, 4, 6, 7)),
                                        items: ['Select', 'One', 'Two', 'Three']
                                            .map(
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
                                              _dropDownValue = val!;
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
                                      hint: _dropDownValue == null
                                          ? Text(
                                              'Select',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          : Text(
                                              _dropDownValue!,
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
                                          color: Color.fromARGB(255, 4, 6, 7)),
                                      items:
                                          ['Select', 'One', 'Two', 'Three'].map(
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
                                            _dropDownValue = val!;
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
                                  (url_img == null || url_img.isEmpty)
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
                      (url_img != null && url_img.isNotEmpty)
                          ? Image.network(
                              url_img,
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
                          url_img != null) {
                        setState(() {
                          cate_name = CategoryController.text;
                          slug__url = SlugUrlController.text;
                          addList();
                          clearText();
                          clear_imageData();
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
                              "Category List",
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
                                      items: <int>[10, 25, 50, 100]
                                          .map((int value) {
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
                                      }),
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
                        Container(height: 40, width: 300, child: SearchField())
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
                    for (var index = 0; index < StoreDocs.length; index++)
                      (Responsive.isMobile(context))
                          ? tableRowWidget_mobile(
                              "${StoreDocs[index]["image"]}",
                              "${StoreDocs[index]["category_name"]}",
                              "${StoreDocs[index]["parent_cate"]}",
                              (StoreDocs[index]["status"] == "1")
                                  ? "Active"
                                  : (StoreDocs[index]["status"] == "2")
                                      ? "Inactive"
                                      : "Select",
                              "${StoreDocs[index]["date_at"]}",
                              "${StoreDocs[index]["id"]}")
                          : tableRowWidget(
                              "${index + 1}",
                              "${StoreDocs[index]["image"]}",
                              "${StoreDocs[index]["category_name"]}",
                              "${StoreDocs[index]["parent_cate"]}",
                              (StoreDocs[index]["status"] == "1")
                                  ? "Active"
                                  : (StoreDocs[index]["status"] == "2")
                                      ? "Inactive"
                                      : "Select",
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

  TableRow tableRowWidget(sno, Iimage, name, pName, status, date, iid) {
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
                  image: (Iimage != "null" && Iimage.isNotEmpty)
                      ? NetworkImage(
                          Iimage,
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
          child: Text("$name",
              style: GoogleFonts.alike(
                  fontWeight: FontWeight.normal, fontSize: 11)),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("$pName",
            style:
                GoogleFonts.alike(fontWeight: FontWeight.normal, fontSize: 11)),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("$status",
            style:
                GoogleFonts.alike(fontWeight: FontWeight.normal, fontSize: 11)),
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
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: IconButton(
                      onPressed: () {
                        showExitPopup(iid);
                      },
                      icon: Icon(
                        Icons.delete_outline_outlined,
                        size: 15,
                        color: Colors.red,
                      ))),
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
                            color: Colors.red.withOpacity(0.1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: IconButton(
                              onPressed: () {
                                showExitPopup(iid);
                              },
                              icon: Icon(
                                Icons.delete_outline_outlined,
                                size: 15,
                                color: Colors.red,
                              ))),
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
                                  SizedBox(height: defaultPadding),
                                  if (Responsive.isMobile(context))
                                    SizedBox(width: defaultPadding),
                                  if (Responsive.isMobile(context))
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
                                            hint: _StatusValue == null
                                                ? Text(
                                                    '$_Status',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                : Text(
                                                    _StatusValue!,
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
                                                  _StatusValue = val!;
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Text_field(context,"category_name","Category Name","Enter Category Name"),
                                  SizedBox(height: defaultPadding),
                                  if (Responsive.isMobile(context))
                                    SizedBox(width: defaultPadding),
                                  if (Responsive.isMobile(context))

                                    //   Text_field(context,"slug_url","Slug Url","Enter Slug Url"),

                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              child: Text("Parent Category",
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
                                              hint: _dropDownValue == null
                                                  ? Text(
                                                      '$Perent_cat',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )
                                                  : Text(
                                                      _dropDownValue!,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                              underline: Container(),
                                              isExpanded: true,
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.black,
                                              ),
                                              iconSize: 35,
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 1, 1, 2)),
                                              items: [
                                                'Select',
                                                'One',
                                                'Two',
                                                'Three'
                                              ].map(
                                                (val) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: val,
                                                    child: Text(val),
                                                  );
                                                },
                                              ).toList(),
                                              onChanged: (val) {
                                                setState(
                                                  () {
                                                    _dropDownValue = val!;
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            child: Text("Parent Category",
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
                                            hint: _dropDownValue == null
                                                ? Text(
                                                    '$Perent_cat',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                : Text(
                                                    _dropDownValue!,
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
                                                    255, 8, 14, 18)),
                                            items: [
                                              'Select',
                                              'One',
                                              'Two',
                                              'Three'
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
                                                  _dropDownValue = val!;
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
                        (url_img == null && image == "null")
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
                                          (url_img == null || url_img.isEmpty)
                                              ? Image.network(
                                                  "$image",
                                                  height: 100,
                                                  fit: BoxFit.contain,
                                                )
                                              : Image.network(
                                                  url_img,
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
                                        (url_img == null || url_img.isEmpty)
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
                                      _StatusValue,
                                      _dropDownValue,
                                      (url_img == null || url_img.isEmpty)
                                          ? image
                                          : url_img);

                                  clearText();
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
                height: 400,
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
        itemCount: myList.length,
        itemBuilder: (_, index) => Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              image: DecorationImage(
                image: NetworkImage('${myList[index]}'),
                fit: BoxFit.contain,
              ),
            ),
            alignment: Alignment.topLeft,
            child: CheckboxListTile(
              checkColor: Colors.white,
              activeColor: Colors.green,
              side: BorderSide(width: 2, color: Colors.red),
              value: _selectedOptions.contains(myList[index]),
              onChanged: (value) {
                setState(() {
                  if (value != null && _selectedOptions.isEmpty) {
                    setState(() {
                      _selectedOptions.add(myList[index]);
                      url_img = _selectedOptions[0];
                      Navigator.pop(context);
                    });
                  } else if (_selectedOptions != null &&
                      _selectedOptions.isNotEmpty) {
                    setState(() {
                      _selectedOptions[0] = "${myList[index]}";
                      url_img = _selectedOptions[0];
                      Navigator.pop(context);
                    });
                  } else {
                    _selectedOptions.remove(myList[index]);
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
        itemCount: myList.length, // <-- required
        itemBuilder: (_, index) => Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              image: DecorationImage(
                image: NetworkImage('${myList[index]}'),
                fit: BoxFit.contain,
              ),
            ),
            child: CheckboxListTile(
              checkColor: Colors.white,
              activeColor: Colors.green,
              side: BorderSide(width: 2, color: Colors.red),
              value: _selectedOptions.contains(myList[index]),
              onChanged: (value) {
                setState(() {
                  if (value != null && _selectedOptions.isEmpty) {
                    setState(() {
                      _selectedOptions.add(myList[index]);
                      url_img = _selectedOptions[0];
                      Navigator.pop(context);
                    });
                  } else if (_selectedOptions != null &&
                      _selectedOptions.isNotEmpty) {
                    setState(() {
                      _selectedOptions[0] = "${myList[index]}";
                      url_img = _selectedOptions[0];
                      Navigator.pop(context);
                    });
                  } else {
                    _selectedOptions.remove(myList[index]);
                  }
                });
              },
            )),
      ),
    );
  }
//////////

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
          onChanged: (ctr_name == CategoryController)
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
              'Are you sure to delete this Categorys ?',
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
                      deleteUser(iid_delete);

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
}

/// Class CLose
