// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_this

import 'dart:convert';
import 'dart:io';
import 'package:crm_demo/screens/product/update_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';
import '../dashboard/components/header.dart';
import '../dashboard/components/my_fields.dart';
import '../dashboard/components/recent_files.dart';
import '../dashboard/components/storage_details.dart';
import 'package:file_picker/file_picker.dart';

import 'package:intl/intl.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({super.key});
  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  final _formKey = GlobalKey<FormState>();
  final CategoryController = TextEditingController();
  final offerController = TextEditingController();
  final mrpController = TextEditingController();
  final NoitemController = TextEditingController();
  final SlugUrlController = TextEditingController();
  final DiscountController = TextEditingController();

  final NameController = TextEditingController();
  var pro_name = "";
  var slug__url = "";
  var image_logo = "";
  String _dropDownValue = "Select";
  String _StatusValue = "Select";
  String _sizeValue = "Select";
  String _brandValue = "Select";
  String Date_at = DateFormat('dd-MM-yyyy').format(DateTime.now());

  bool Tranding = false;
  bool Feature = false;
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
  }

  // File Picker ==========================================================
  // Codec<String, String> stringToBase64 = utf8.fuse(base64);
  var uploadedDoc;
  var imagePri;
// result;
  String? fileName;
  PlatformFile? pickedfile;
  bool isLoading = false;
  File? fileToDisplay;

  void clear_upload() {
    fileName = null;
  }

  pickFile() async {
    if (!kIsWeb) {
      try {
        setState(() {
          isLoading = true;
        });
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['png', 'jpeg', 'jpg'],
          allowMultiple: false,
        );
        if (result != null) {
          fileName = result.files.first.name;
          pickedfile = result.files.first;
          fileToDisplay = File(pickedfile!.path.toString());
          setState(() {
            List<int> imageBytes = fileToDisplay!.readAsBytesSync();
            uploadedDoc = base64Encode(imageBytes);
            // _controllers['doc'] = uploadedDoc;
          });
          // print('File name $uploadedDoc');
        }
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          var webImage = f;
          uploadedDoc = base64.encode(webImage);
          imagePri = base64.decode(uploadedDoc);
        });
      }
    }
  }

  ///

  ///////////  firebase property
  final Stream<QuerySnapshot> _crmStream =
      FirebaseFirestore.instance.collection('product').snapshots();
  final List StoreDocs = [];
  var db = FirebaseFirestore.instance;
  CollectionReference _product =
      FirebaseFirestore.instance.collection('product');
  ////////////++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  _getUser() async {
    var collection = FirebaseFirestore.instance.collection('product');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map data = queryDocumentSnapshot.data() as Map<String, dynamic>;
      StoreDocs.add(data);
      data["id"] = queryDocumentSnapshot.id;
    }
    // setState(() {
    print("$StoreDocs");
    // });

    //   _crmStream.data!.docs.map((DocumentSnapshot document)
    //   {
    //   Map Docs = document.data() as Map<String, dynamic>;
    //   StoreDocs.add(Docs);
    //   Docs["id"] = document.id;
    // })
    // .toList();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // dynamic userData = (prefs.getString("$_category"));
    // if (userData != null) {
    //   setState(() {
    //     cat_data = jsonDecode(userData) as Map<dynamic, dynamic>;
    //     print("$cat_data  ++++++++++");
    //   });
    // }
  }

  /// add list
  Future<void> addList() {
    return _product
        .add({
          'name': "${NameController.text}",
          "Offer": "${offerController.text}",
          'discount': "${DiscountController.text}",
          "mrp": "${mrpController.text}",
          "No_Of_Item": "${NoitemController.text}",
          'product_name': "$pro_name",
          'slug_url': "$slug__url",
          'parent_cate': "$_dropDownValue",
          'status': "$_StatusValue",
          'size': "$_sizeValue",
          'brand': "$_brandValue",
          'image': "$uploadedDoc",
          "date_at": "$Date_at"
        })
        .then((value) => themeAlert(context, "Successfully Submit"))
        .catchError(
            (error) => themeAlert(context, 'Failed to Submit', type: "error"));
  }

  ///
  ///delete
  Future<void> deleteUser(id) {
    return _product
        .doc(id)
        .delete()
        .then((value) => themeAlert(context, "Deleted Successfully "))
        .catchError(
            (error) => themeAlert(context, 'Not find Data', type: "error"));
  }

  ///

  @override
  void initState() {
    // TODO: implement initState
    _getUser();
    super.initState();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _crmStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //////
          if (snapshot.hasError) {
            print("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map Docs = document.data() as Map<String, dynamic>;
            //StoreDocs.add(Docs);
            // Docs["id"] = document.id;
            //print("$StoreDocs");
          }).toList();
          ////////

          return Scaffold(
              body: Container(
            child: ListView(
              children: [
                Header(
                  title: "Product Info",
                ),
                SizedBox(height: defaultPadding),

//////////   TaBar  for Product add Form And List ++++++++++++++++++++++++++++++++++++++

                DefaultTabController(
                    length: 2,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            // padding: EdgeInsets.all(defaultPadding),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5.0)),
                            child: TabBar(
                              indicator: BoxDecoration(
                                  color: themeBG3,
                                  borderRadius: BorderRadius.circular(5.0)),
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.white,
                              tabs: [
                                Tab(text: "Add"),
                                Tab(text: "List"),
                              ],
                            ),
                          ),
                          Expanded(
                              child: TabBarView(
                            children: [
                              //Start_up(context),
                              listCon(context, 'tab1'),
                              listList(context, 'tab2'),
                            ],
                          )),
                        ],
                      ),
                    )),

////////////////////     Tabbar End Here ++++++++++++++++++++++++++++++
              ],
            ),
          ));
        });
  }

//// ///////////   Widget for Product Add Form  ++++++++++++++++++++++++++++++++++++++++++

  Widget listCon(BuildContext context, tab) {
    return Container(
        // color: themeBG,
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: ListView(children: [
          Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Colors.white,
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
                                  Text("Name*",
                                      style: themeTextStyle(
                                          color: Colors.black,
                                          size: 15,
                                          fw: FontWeight.bold)),
                                  Text_field(context, NameController, "Name",
                                      "Enter Name"),
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
                        SizedBox(height: defaultPadding),
                        if (Responsive.isMobile(context))
                          SizedBox(width: defaultPadding),
                        if (Responsive.isMobile(context))
                          Expanded(
                            flex: 2,
                            child: Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("No Item",
                                    style: themeTextStyle(
                                        color: Colors.black,
                                        size: 15,
                                        fw: FontWeight.bold)),
                                Text_field(context, NoitemController,
                                    " No Item", "Enter No Item"),
                              ],
                            )),
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
                                Text("No Item",
                                    style: themeTextStyle(
                                        color: Colors.black,
                                        size: 15,
                                        fw: FontWeight.bold)),
                                Text_field(context, NoitemController, "No Item",
                                    "Enter No Item"),
                              ],
                            )),
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
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: DropdownButton(
                                      dropdownColor:
                                          Color.fromARGB(255, 248, 247, 247),
                                      hint: _StatusValue == null
                                          ? Text('Dropdown')
                                          : Text(
                                              _StatusValue,
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
                                          color: Color.fromARGB(255, 3, 5, 6)),
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

                            // Text_field(context,"category_name","Category Name","Enter Category Name"),
                            SizedBox(height: defaultPadding),
                            if (Responsive.isMobile(context))
                              SizedBox(width: defaultPadding),
                            if (Responsive.isMobile(context))

                              //   Text_field(context,"slug_url","Slug Url","Enter Slug Url"),

                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: Text("Select Category",
                                            style: themeTextStyle(
                                                color: Colors.black,
                                                size: 15,
                                                fw: FontWeight.bold))),
                                    Container(
                                      height: 40,
                                      margin: EdgeInsets.only(
                                          top: 10, bottom: 10, right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: DropdownButton(
                                        dropdownColor:
                                            Color.fromARGB(255, 248, 247, 247),
                                        hint: _dropDownValue == null
                                            ? Text('Dropdown')
                                            : Text(
                                                _dropDownValue,
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
                                            color:
                                                Color.fromARGB(255, 4, 6, 8)),
                                        items: [
                                          'Select',
                                          'bajaj',
                                          'hawels',
                                          'syska'
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
                                      child: Text("Select Category",
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold))),
                                  Container(
                                    height: 40,
                                    margin: EdgeInsets.only(
                                        top: 10, bottom: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: DropdownButton(
                                      dropdownColor:
                                          Color.fromARGB(255, 248, 247, 247),
                                      hint: _dropDownValue == null
                                          ? Text('Dropdown')
                                          : Text(
                                              _dropDownValue,
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
                                          color: Color.fromARGB(255, 5, 8, 10)),
                                      items: [
                                        'Select',
                                        'bajaj',
                                        'hawels',
                                        'syska'
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

                  //second field

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
                                Text("MRP",
                                    style: themeTextStyle(
                                        color: Colors.black,
                                        size: 15,
                                        fw: FontWeight.bold)),
                                Text_field(
                                    context, mrpController, "MRP", "Enter MRP"),
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
                                  Text("Offer Price",
                                      style: themeTextStyle(
                                          color: Colors.black,
                                          size: 15,
                                          fw: FontWeight.bold)),
                                  Text_field(context, offerController,
                                      "Offer Price", "Enter Offer Price"),
                                ],
                              )),
                          ],
                        ),
                      ),
                      SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context))
                        SizedBox(width: defaultPadding),
                      if (Responsive.isMobile(context))
                        Expanded(
                          flex: 2,
                          child: Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Discount",
                                  style: themeTextStyle(
                                      color: Colors.black,
                                      size: 15,
                                      fw: FontWeight.bold)),
                              Text_field(context, CategoryController,
                                  "Discount", "Enter Discount"),
                            ],
                          )),
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
                              Text("Discount",
                                  style: themeTextStyle(
                                      color: Colors.black,
                                      size: 15,
                                      fw: FontWeight.bold)),
                              Text_field(context, DiscountController,
                                  "Discount", "Enter Discount"),
                            ],
                          )),
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
                              Text("Offer Price",
                                  style: themeTextStyle(
                                      color: Colors.black,
                                      size: 15,
                                      fw: FontWeight.bold)),
                              Text_field(context, offerController,
                                  "Offer Price", "Enter Offer Price"),
                            ],
                          )),
                        ),
                    ],
                  ),
                  // Size option

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
                                      child: Text("Size",
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold))),
                                  Container(
                                    height: 40,
                                    margin: EdgeInsets.only(
                                        top: 10, bottom: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: DropdownButton(
                                      dropdownColor:
                                          Color.fromARGB(255, 248, 247, 247),
                                      hint: _sizeValue == null
                                          ? Text('Dropdown')
                                          : Text(
                                              _sizeValue,
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
                                          color: Color.fromARGB(255, 6, 8, 10)),
                                      items: [
                                        'Select',
                                        'small',
                                        'large',
                                        'extralarge'
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
                                            _sizeValue = val!;
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: Text("Select Brand",
                                            style: themeTextStyle(
                                                color: Colors.black,
                                                size: 15,
                                                fw: FontWeight.bold))),
                                    Container(
                                      height: 40,
                                      margin: EdgeInsets.only(
                                          top: 10, bottom: 10, right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: DropdownButton(
                                        dropdownColor:
                                            Color.fromARGB(255, 248, 247, 247),
                                        hint: _brandValue == null
                                            ? Text('Dropdown')
                                            : Text(
                                                _brandValue,
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
                                                255, 14, 18, 22)),
                                        items: ['Select', 'apple', 'del', 'hp']
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
                                              _brandValue = val!;
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
                                      child: Text("Select Brand",
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold))),
                                  Container(
                                    height: 40,
                                    margin: EdgeInsets.only(
                                        top: 10, bottom: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: DropdownButton(
                                      dropdownColor:
                                          Color.fromARGB(255, 248, 247, 247),
                                      hint: _brandValue == null
                                          ? Text('Dropdown')
                                          : Text(
                                              _brandValue,
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
                                          color:
                                              Color.fromARGB(255, 9, 12, 15)),
                                      items:
                                          ['Select', 'apple', 'del', 'hp'].map(
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
                                            _brandValue = val!;
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
                            Text("Icon Image",
                                style: themeTextStyle(
                                    size: 15, fw: FontWeight.bold)),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 55,
                              margin: EdgeInsets.only(
                                  top: 10, bottom: 10, right: 10),
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _LogoutAlert(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  31, 242, 238, 238)),
                                          color: Color.fromARGB(
                                              255, 251, 250, 250)),
                                      child: Text(
                                        "Choose File",
                                        style: themeTextStyle(size: 15),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  (uploadedDoc == null || uploadedDoc.isEmpty)
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
                      // On Mobile means if the screen is less than 850 we dont want to show it
                      if (!Responsive.isMobile(context))
                        Expanded(
                          flex: 2,
                          child: SizedBox(width: defaultPadding),
                        ),
                    ],
                  ),

                  // image preview section

                  Row(
                    children: [
                      Expanded(
                        child: uploadedDoc == null
                            ? Icon(Icons.photo, size: 12)
                            : Image.memory(
                                imagePri,
                                height: 80,
                                width: 100,
                              ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    themeButton3(context, () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          pro_name = CategoryController.text;
                          slug__url = SlugUrlController.text;
                          addList();
                          clearText();
                        });
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
        ]));
  }
//////////////  End Prodct Add form +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//// Widget for   Product List ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Widget listList(BuildContext context, tab) {
//    print("$StoreDocs");
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Text(
            "Product List",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "S.No.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text("Logo",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text("Product Name",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text("Category Name",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text("Status",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text("Date",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text("Actions",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    thickness: 1.5,
                  ),
                  for (var index = 0; index < StoreDocs.length; index++)
                    recentFileDataRow(
                        context,
                        "$index",
                        "${StoreDocs[index]["image"]}",
                        "${StoreDocs[index]["name"]}",
                        "${StoreDocs[index]["parent_cate"]}",
                        "${StoreDocs[index]["status"]}",
                        "${StoreDocs[index]["date_at"]}",
                        "${StoreDocs[index]["id"]}"),
                ],
              )),
        ],
      ),
    );
  }

  Widget recentFileDataRow(
      BuildContext context, sno, Iimage, name, pName, status, date, iid) {
    var bytes = base64.decode(Iimage);
    return Container(
      // margin: EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: Text("$sno")),
              Expanded(
                  child: (Iimage != null && Iimage.isNotEmpty)
                      ? Image.memory(
                          bytes,
                          height: 50,
                          width: 80,
                          fit: BoxFit.contain,
                        )
                      : SizedBox()),
              Expanded(child: Text("$name")),
              Expanded(child: Text("$pName")),
              Expanded(child: Text("$status")),
              Expanded(child: Text("$date")),
              Expanded(
                  child: Row(
                children: [
                  Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateProduct(id: iid)));
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          )) ////
                      ),
                  SizedBox(width: 10),
                  Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: IconButton(
                          onPressed: () {
                            deleteUser(iid);
                          },
                          icon: Icon(
                            Icons.delete_outline_outlined,
                            color: Colors.red,
                          ))),
                ],
              ))
            ],
          ),
          Divider(
            thickness: 1.5,
          )
        ],
      ),
    );
  }

///////++++++++++++++++++++++End Product List+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

/////////
  ///
  void _LogoutAlert(BuildContext context) {
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
                      All_media(context, setStatee)
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Widget All_media(BuildContext context, setStatee) {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < 4; i++)
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ0JhaimSD1ayvA9vffVRcueFMd8MqD5cJH9A&usqp=CAU'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  alignment: Alignment.topLeft,
                  child: Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.green,
                    side: BorderSide(width: 2, color: Colors.white),
                    value: this.Tranding,
                    onChanged: (value) {
                      setStatee(() {
                        this.Tranding = value!;
                      });
                    },
                  ),
                ),
              ),
          ],
        )
      ],
    ));
  }

  ///
  ///
  ///

  Widget Text_field(BuildContext context, ctr_name, lebel, hint) {
    return Container(
        height: 50,
        margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
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
}

/// Class CLose
