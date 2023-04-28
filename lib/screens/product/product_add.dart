// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_this, non_constant_identifier_names, unnecessary_cast, avoid_print, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, prefer_final_fields, override_on_non_overriding_member, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_null_comparison, unnecessary_brace_in_string_interps, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable

import 'dart:convert';
import 'dart:io';
import 'package:crm_demo/screens/product/update_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/firebase_Storage.dart';
import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';
import '../dashboard/components/header.dart';
import '../dashboard/components/my_fields.dart';
import '../dashboard/components/recent_files.dart';
import '../dashboard/components/storage_details.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:intl/intl.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({super.key});
  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  final _formKey = GlobalKey<FormState>();
  final offerController = TextEditingController();
  final mrpController = TextEditingController();
  final NoitemController = TextEditingController();
  final SlugUrlController = TextEditingController();
  final DiscountController = TextEditingController();
  final NameController = TextEditingController();
  String _dropDownValue = "Select";
  String _StatusValue = "Select";
  String _sizeValue = "Select";
  String _brandValue = "Select";
  String Date_at = DateFormat('dd-MM-yyyy').format(DateTime.now());
  @override
  clearText() {
    NameController.clear();
    SlugUrlController.clear();
    mrpController.clear();
    offerController.clear();
    DiscountController.clear();
    NoitemController.clear();
    _dropDownValue = "Select";
    _StatusValue = "Select";
    _sizeValue = "Select";
    _brandValue = "Select";
    clear_imageData();
  }

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
          allowedExtensions: ['png','jpg'],
          allowMultiple: false,
          );
        if (results != null) {
          final path = results.files.single.path;
          final fileName = results.files.single.name;
           UploadFile(path!,fileName).then((value) 
           {
            print("image selected");
           });
            setState(() async{
              downloadURL = await FirebaseStorage.instance.ref().child('media/$fileName').getDownloadURL();
              url_img = downloadURL.toString();
            });

        }
        else {
            themeAlert(context, 'Not find selected', type: "error");
      }
    } 
    else if (kIsWeb) {
      final results = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['png','jpg'],
          );
          if(results != null){
             Uint8List? UploadImage =  results.files.single.bytes;
             fileName = results.files.single.name;
             Reference reference = FirebaseStorage.instance.ref('media/$fileName');
             final UploadTask uploadTask = reference.putData(UploadImage!);
             uploadTask.whenComplete(() => print("selected image"));
              setState(() async{
              downloadURL = await FirebaseStorage.instance.ref().child('media/$fileName').getDownloadURL();
              url_img = downloadURL.toString(); 
              // print("$url_img  +++++++88888888+++++++++");
            });
          }
          else{
                themeAlert(context, 'Not find selected', type: "error");
            return null;
          }    
       }
  }

/////////// firebase Storage +++++++++++++++++++
///
String?  downloadURL;
List<String> myList = [];
Future listExample() async {
    firebase_storage.ListResult result =
        await firebase_storage.FirebaseStorage.instance.ref('media').listAll();
        result.items.forEach((firebase_storage.Reference ref)
        async {
        var uri = await downloadURLExample("${ref.fullPath}");
        myList.add(uri);
    });
    return myList;
}

Future downloadURLExample(image_path) async{
downloadURL = await FirebaseStorage.instance
.ref()
.child(image_path)
.getDownloadURL();
return downloadURL.toString();
}

////

  ///////////  firebase property
  final Stream<QuerySnapshot> _crmStream =
      FirebaseFirestore.instance.collection('product').snapshots();
  final List StoreDocs = [];
  var db = FirebaseFirestore.instance;
  CollectionReference _product =
      FirebaseFirestore.instance.collection('product');
  ////////////+++++++++++++++++++++++++++++++++++++++++++++++++
  Pro_Data() async {
    var collection = FirebaseFirestore.instance.collection('product');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map data = queryDocumentSnapshot.data() as Map<String, dynamic>;
      StoreDocs.add(data);
      data["id"] = queryDocumentSnapshot.id;
    }
   setState(() {
     listExample();
   });
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
          'slug_url': "${SlugUrlController.text}",
          'parent_cate': "$_dropDownValue",
          'status': "$_StatusValue",
          'size': "$_sizeValue",
          'brand': "$_brandValue",
          'image': "$url_img",
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
/////// Update

  Future<void> updatelist(id, Name, Noitem, slugUrl, _Status, _Category, Mrp, Discount, Offer, _Size, _Brand, image) 
    {
    return 
        _product
        .doc(id)
        .update({
          'name': "$Name",
          "No_Of_Item": "$Noitem",
          'slug_url': "$slugUrl",
          'status': "$_Status",
          'parent_cate': "$_Category",
          "mrp": "$Mrp",
          'discount': "$Discount",
          "Offer": "$Offer",
          'size': "$_Size",
          'brand': "$_Brand",
          "image":"$image",
          "date_at": "$Date_at"
        })
        .then((value) {
          themeAlert(context, "Successfully Update");
          setState(() {
            updateWidget = false;
          });
        } )
        .catchError(
            (error) => themeAlert(context, 'Failed to update', type: "error"));
  }



  ///

  @override
  void initState() {
      Pro_Data();
    super.initState();
  }

  ///
  bool updateWidget = false;
  var update_id ;
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

          // snapshot.data!.docs.map((DocumentSnapshot document) {
          //   Map Docs = document.data() as Map<String, dynamic>;
          //   //StoreDocs.add(Docs);
          //   // Docs["id"] = document.id;
          //   //print("$StoreDocs");
          // }).toList();
          // ////////

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
                                Tab(text: "Add New"),
                                Tab(text: "List All"),
                              ],
                            ),
                          ),
                          Expanded(
                              child: TabBarView(
                            children: [
                              //Start_up(context),
                              listCon(context, 'tab1'),
                              (updateWidget == false)
                              ?
                              listList(context, 'tab2')
                              :
                              Update_product(context,update_id)
                            ],
                          )),
                        ],
                      ),
                    )),
                /// Tabbar End Here ++++++
              ],
            ),
          ));
        });
  }

 ///////////   Widget for Product Add Form  ++++++++++++++++++++++++++++++++++++++++++

  Widget listCon(BuildContext context, tab) {
    return Container(
        // color: themeBG,
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: ListView(children: [
          Container(
              padding: EdgeInsets.all(defaultPadding),
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
                                      _ImageSelect_Alert(context);
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
                        child: url_img == null
                            ? Icon(Icons.photo, size: 12)
                            : Image.network(
                                url_img,
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
                    }, 
                    label: "Reset", buttonColor: Colors.black),
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
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5.0),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: 
              ListView(
        children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              width: double.infinity,
              child: Column(
                      children: [
                        (Responsive.isMobile(context)) 
                        ?
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Text("Product Details",
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],),
                          )
                     : 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                          thickness: 2.0,
                        ),
                        for (var index = 0; index < StoreDocs.length; index++)
                         (Responsive.isMobile(context)) 
                          ?
                  
                        recentFileDataRow_Mobile(
                          context,
                          "$index",
                              "${StoreDocs[index]["image"]}",
                              "${StoreDocs[index]["name"]}",
                              "${StoreDocs[index]["parent_cate"]}",
                              "${StoreDocs[index]["status"]}",
                              "${StoreDocs[index]["date_at"]}",
                              "${StoreDocs[index]["id"]}"
                        )
                        :
                          recentFileDataRow(
                              context,
                              "$index",
                              "${StoreDocs[index]["image"]}",
                              "${StoreDocs[index]["name"]}",
                              "${StoreDocs[index]["parent_cate"]}",
                              "${StoreDocs[index]["status"]}",
                              "${StoreDocs[index]["date_at"]}",
                              "${StoreDocs[index]["id"]}"),
                       SizedBox(height: 80,)       
                      ],
                    ),
                  ),
                ],
              )
    );
  }

  Widget recentFileDataRow(
      BuildContext context, sno, Iimage, name, pName, status, date, iid) {
  //  var bytes = base64.decode(Iimage);
    return
     Container(
      // margin: EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: Text("$sno")),
              Expanded(
                  child: (Iimage != null && Iimage.isNotEmpty)
                      ? Image.network(
                          Iimage,
                          height: 80,
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
                            setState(() {
                              updateWidget = true;
                              update_id = iid;
                            });
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             UpdateProduct(id: iid)));
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



////////// Row   mobile ++++++++++++++++

  Widget recentFileDataRow_Mobile(
      BuildContext context, sno, Iimage, name, pName, status, date, iid) {  
     // var bytes = base64.decode(Iimage);
      return
             Container(
                 decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                       
                        Container(
                          margin: EdgeInsets.all(5),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 214, 214, 214),
                              image: DecorationImage(
                                  image: 
                                      NetworkImage(
                                      Iimage,
                                    ),fit: BoxFit.contain
                                    
                                    )),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              themeListRow(context, "Product Name", "$name"),
                              themeListRow(context, "Category Name","$pName"),
                              themeListRow(context, "Satus","$status"),
                              themeListRow(context, "Date","$date"),
                        SizedBox(height: 10,),
                            Row(
                            children: [
                                SizedBox(
                             width:  100.0,
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
                                           setState(() {
                                             updateWidget = true;
                                              update_id = iid;
                                                  });
                                      },
                                      icon:
                                       Icon(
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
                          )
                           
                            ],
                          ),
                        ),
                       
                      ],
                    ),


                 Divider(thickness: 1.0,color: Colors.white12,)   
                  ],
                ),

    );
  }
/////////

/////////////  Update widget for product Update+++++++++++++++++++++++++
Widget Update_product(BuildContext context,id){
  return 
            Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child:  ListView(children: [
                  // Text("${id}",style: TextStyle(color: Colors.black),),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child:
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Container(
                      child:
                       Row(
                        children: [
                          Icon(Icons.edit_document,color: Colors.green,),
                          SizedBox(width: 10,),
                          Text("Update Product",
                          style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                          ),),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),

                    ElevatedButton(
                      style:ElevatedButton.styleFrom(
                             primary: Colors.redAccent, // Background color
                           ),
                      onPressed: (){
                      setState(() {
                      updateWidget = false;
                      });
                    }, 
                    child:  
                    Row(
                      children: [
                        Icon(Icons.arrow_back,color: Colors.white),
                        Text("Back",style: TextStyle(color: Colors.white),)
                      ],
                    )),
                
                    
                  ],)
                  ),
                  Container(
                      padding: EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child:
                       Form(
                          key: _formKey,
                          child: FutureBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                              future: FirebaseFirestore.instance
                                  .collection("product")
                                  .doc(id)
                                  .get(),
                              builder: (_, snapshot) {
                                //////
                                if (snapshot.hasError) {
                                  print("Something went wrong");
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                var data = snapshot.data!.data();
                                var Name = data!['name'];
                                var Noitem = data['No_Of_Item'];
                                var slugUrl = data['slug_url'];
                                var Discount = data['discount'];
                                var Offer = data['Offer'];
                                var Mrp = data['mrp'];
                                var image = data["image"];
                                var _Status = data['status'];
                                var _Size = data['size'];
                                var _Brand = data['brand'];
                                var _Category = data['parent_cate'];

                                return Column(
                                  children: [
                                    //first row
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  Text("Name*",
                                                      style: themeTextStyle(
                                                          color: Colors.black,
                                                          size: 15,
                                                          fw: FontWeight.bold)),
                                                //  Text_field_up(context, Name,"Name", "Enter Name"),


                                                    Container(
                                                      height: 40,
                                                      margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: TextFormField(
                                                        initialValue: Name,
                                                        autofocus: false,
                                                        onChanged: (value) => Name = value,
                                                      // controller: ctr_name,
                                                        validator: (value) {
                                                          if (value == null || value.isEmpty) {
                                                            return 'Please Enter Name';
                                                          }
                                                          return null;
                                                        },
                                                        style: TextStyle(color: Colors.black),
                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                                          hintText: 'Enter Name',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ))


                                          
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
                                                    Text("Slug Url",
                                                        style: themeTextStyle(
                                                            color: Colors.black,
                                                            size: 15,
                                                            fw: FontWeight
                                                                .bold)),
                                                    // Text_field_up(
                                                    //     context,
                                                    //     slugUrl,
                                                    //     "Slug Url",
                                                    //     "Enter Slug Url"),

                                                   Container(
                                                   height: 40,
                                                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: TextFormField(
                                                              initialValue: slugUrl,
                                                              autofocus: false,
                                                              onChanged: (value) => slugUrl = value,
                                                            // controller: ctr_name,
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return 'Please Enter Slug Url';
                                                                }
                                                                return null;
                                                              },
                                                              style: TextStyle(color: Colors.black),
                                                              decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                                                hintText: 'Enter Slug Url',
                                                                hintStyle: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ))

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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("No Item",
                                                    style: themeTextStyle(
                                                        color: Colors.black,
                                                        size: 15,
                                                        fw: FontWeight.bold)),
                                                // Text_field_up(
                                                //     context,
                                                //     Noitem,
                                                //     "No Item",
                                                //     "Enter No Item"),

                                                  Container(
                                                   height: 40,
                                                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: TextFormField(
                                                              initialValue: Noitem,
                                                              autofocus: false,
                                                              onChanged: (value) => Noitem = value,
                                                            // controller: ctr_name,
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return 'Please Enter No Item';
                                                                }
                                                                return null;
                                                              },
                                                              style: TextStyle(color: Colors.black),
                                                              decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                                                hintText: 'Enter No Item',
                                                                hintStyle: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ))

                                            
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("No Item",
                                                    style: themeTextStyle(
                                                        color: Colors.black,
                                                        size: 15,
                                                        fw: FontWeight.bold)),
                                                // Text_field_up(context, Noitem,
                                                //     "No Item", "Enter No Item"),
                                             
                                               Container(
                                                   height: 40,
                                                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: TextFormField(
                                                              initialValue: Noitem,
                                                              autofocus: false,
                                                              onChanged: (value) => Noitem = value,
                                                            // controller: ctr_name,
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return 'Please Enter No Item';
                                                                }
                                                                return null;
                                                              },
                                                              style: TextStyle(color: Colors.black),
                                                              decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                                                hintText: 'Enter No Item',
                                                                hintStyle: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ))

                                             
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Slug Url",
                                                    style: themeTextStyle(
                                                        color: Colors.black,
                                                        size: 15,
                                                        fw: FontWeight.bold)),
                                                // Text_field_up(
                                                //     context,
                                                //     slugUrl,
                                                //     "Slug Url",
                                                //     "Enter Slug Url"),
                                                 Container(
                                                   height: 40,
                                                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: TextFormField(
                                                              initialValue: slugUrl,
                                                              autofocus: false,
                                                              onChanged: (value) => slugUrl = value,
                                                            // controller: ctr_name,
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return "Please Enter Slug Url";
                                                                }
                                                                return null;
                                                              },
                                                              style: TextStyle(color: Colors.black),
                                                              decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                                                hintText: '"Enter Slug Url"',
                                                                hintStyle: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ))

                                          
                                              ],
                                            )),
                                          ),
                                      ],
                                    ),

                                    //status
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        child: Text("Status",
                                                            style: themeTextStyle(
                                                                color: Colors
                                                                    .black,
                                                                size: 15,
                                                                fw: FontWeight
                                                                    .bold))),
                                                    Container(
                                                      height: 40,
                                                      margin: EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          right: 10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: DropdownButton(
                                                        dropdownColor:
                                                            Color.fromARGB(255,
                                                                248, 247, 247),
                                                        hint: (_StatusValue == null)
                                                            ? 
                                                            Text('Dropdown')
                                                            :
                                                             Text(
                                                                _Status,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
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
                                                                Color.fromARGB(
                                                                    255,
                                                                    7,
                                                                    10,
                                                                    12)),
                                                        items: [
                                                          'Select',
                                                          'Inactive',
                                                          'Active'
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
                                                              _StatusValue =val!;
                                                              _Status = _StatusValue;
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          child: Text(
                                                              "Parent Category",
                                                              style: themeTextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  size: 15,
                                                                  fw: FontWeight
                                                                      .bold))),
                                                      Container(
                                                        height: 40,
                                                        margin: EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10,
                                                            right: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 10),
                                                        child: DropdownButton(
                                                          dropdownColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  248,
                                                                  247,
                                                                  247),
                                                          hint: (_dropDownValue == null)
                                                              ? Text('Dropdown')
                                                              : Text(
                                                                  _dropDownValue,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                          underline:
                                                              Container(),
                                                          isExpanded: true,
                                                          icon: Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color: Colors.black,
                                                          ),
                                                          iconSize: 35,
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(255,
                                                                      4, 6, 7)),
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
                                                                child:
                                                                    Text(val),
                                                              );
                                                            },
                                                          ).toList(),
                                                          onChanged: (val) {
                                                            setState(
                                                              () {
                                                                _dropDownValue =
                                                                    val!;
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
                                                        child: Text(
                                                            "Parent Category",
                                                            style: themeTextStyle(
                                                                color: Colors
                                                                    .black,
                                                                size: 15,
                                                                fw: FontWeight
                                                                    .bold))),
                                                    Container(
                                                      height: 40,
                                                      margin: EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          right: 10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: DropdownButton(
                                                        dropdownColor:
                                                            Color.fromARGB(255,
                                                                248, 247, 247),
                                                        hint: _Category == null
                                                            ? Text('Dropdown')
                                                            : Text(
                                                                _Category,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
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
                                                                Color.fromARGB(
                                                                    255,
                                                                    8,
                                                                    12,
                                                                    16)),
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
                                              )),
                                      ],
                                    ),

                                    ///mrp

                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  Text("MRP",
                                                      style: themeTextStyle(
                                                          color: Colors.black,
                                                          size: 15,
                                                          fw: FontWeight.bold)),
                                                  // Text_field_up(context, Mrp,
                                                  //     "MRP", "Enter MRP"),

                                                    Container(
                                                   height: 40,
                                                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: TextFormField(
                                                              initialValue: Mrp,
                                                              autofocus: false,
                                                              onChanged: (value) => Mrp = value,
                                                            // controller: ctr_name,
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return "Please Enter MRP";
                                                                }
                                                                return null;
                                                              },
                                                              style: TextStyle(color: Colors.black),
                                                              decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                                                hintText: '"Enter MRP"',
                                                                hintStyle: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ))

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
                                                    Text("Offer Price",
                                                        style: themeTextStyle(
                                                            color: Colors.black,
                                                            size: 15,
                                                            fw: FontWeight
                                                                .bold)),
                                                    // Text_field_up(
                                                    //     context,
                                                    //     Offer,
                                                    //     "Offer Price",
                                                    //     "Enter Offer Price"),
                                                      Container(
                                                   height: 40,
                                                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: TextFormField(
                                                              initialValue: Offer,
                                                              autofocus: false,
                                                              onChanged: (value) => Offer = value,
                                                            // controller: ctr_name,
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return "Please Enter Offer Price";
                                                                }
                                                                return null;
                                                              },
                                                              style: TextStyle(color: Colors.black),
                                                              decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                                                hintText: '"Enter Offer Price"',
                                                                hintStyle: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ))
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Discount",
                                                    style: themeTextStyle(
                                                        color: Colors.black,
                                                        size: 15,
                                                        fw: FontWeight.bold)),
                                                // Text_field_up(
                                                //     context,
                                                //     Discount,
                                                //     "Discount",
                                                //     "Enter Discount"),

                                                 Container(
                                                   height: 40,
                                                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: TextFormField(
                                                              initialValue: Discount,
                                                              autofocus: false,
                                                              onChanged: (value) => Discount = value,
                                                            // controller: ctr_name,
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return "Please Enter Discount";
                                                                }
                                                                return null;
                                                              },
                                                              style: TextStyle(color: Colors.black),
                                                              decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                                                hintText: '"Enter Discount"',
                                                                hintStyle: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ))
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Discount",
                                                    style: themeTextStyle(
                                                        color: Colors.black,
                                                        size: 15,
                                                        fw: FontWeight.bold)),
                                                // Text_field_up(
                                                //     context,
                                                //     Discount,
                                                //     "Discount",
                                                //     "Enter Discount"),
                                                 Container(
                                                   height: 40,
                                                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: TextFormField(
                                                              initialValue: Discount,
                                                              autofocus: false,
                                                              onChanged: (value) => Discount = value,
                                                            // controller: ctr_name,
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return "Please Enter Discount";
                                                                }
                                                                return null;
                                                              },
                                                              style: TextStyle(color: Colors.black),
                                                              decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                                                hintText: '"Enter Discount"',
                                                                hintStyle: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ))
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Offer Price",
                                                    style: themeTextStyle(
                                                        color: Colors.black,
                                                        size: 15,
                                                        fw: FontWeight.bold)),
                                                // Text_field_up(
                                                //     context,
                                                //     Offer,
                                                //     "Offer Price",
                                                //     "Enter Offer Price"),

                                                 Container(
                                                   height: 40,
                                                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: TextFormField(
                                                              initialValue: Offer,
                                                              autofocus: false,
                                                              onChanged: (value) => Offer = value,
                                                            // controller: ctr_name,
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return "Please Enter Offer";
                                                                }
                                                                return null;
                                                              },
                                                              style: TextStyle(color: Colors.black),
                                                              decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                                                hintText: '"Enter Offer"',
                                                                hintStyle: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ))
                                              ],
                                            )),
                                          ),
                                      ],
                                    ),

                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        child: 
                                                        Text("Size",
                                                            style: themeTextStyle(
                                                                color: Colors
                                                                    .black,
                                                                size: 15,
                                                                fw: FontWeight.bold))),
                                                    Container(
                                                      height: 40,
                                                      margin: EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          right: 10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: DropdownButton(
                                                        dropdownColor:
                                                            Color.fromARGB(255,
                                                                248, 247, 247),
                                                        hint: _Size == null
                                                            ? Text('Dropdown')
                                                            : Text(
                                                                _Size,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
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
                                                                Color.fromARGB(
                                                                    255,
                                                                    4,
                                                                    7,
                                                                    9)),
                                                        items: [
                                                          'Select',
                                                          'Inactive',
                                                          'Active'
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
                                                              _StatusValue =
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
                                              SizedBox(height: defaultPadding),
                                              if (Responsive.isMobile(context))
                                                SizedBox(width: defaultPadding),
                                              if (Responsive.isMobile(context))

                                                 // Text_field_up(context,slug_url,"Slug Url","Enter Slug Url"),

                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          child: Text(
                                                              "Select Brand",
                                                              style: themeTextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  size: 15,
                                                                  fw: FontWeight
                                                                      .bold))),
                                                      Container(
                                                        height: 40,
                                                        margin: EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10,
                                                            right: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 10),
                                                        child: DropdownButton(
                                                          dropdownColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  248,
                                                                  247,
                                                                  247),
                                                          hint: _Brand == null
                                                              ? Text('Dropdown')
                                                              : Text(
                                                                  _Brand,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                          underline:
                                                              Container(),
                                                          isExpanded: true,
                                                          icon: Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color: Colors.black,
                                                          ),
                                                          iconSize: 35,
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(255,
                                                                      5, 6, 7)),
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
                                                                child:
                                                                    Text(val),
                                                              );
                                                            },
                                                          ).toList(),
                                                          onChanged: (val) {
                                                            setState(
                                                              () {
                                                                _dropDownValue =
                                                                    val!;
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
                                                        child: Text(
                                                            "Select Brand",
                                                            style: themeTextStyle(
                                                                color: Colors
                                                                    .black,
                                                                size: 15,
                                                                fw: FontWeight
                                                                    .bold))),
                                                    Container(
                                                      height: 40,
                                                      margin: EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          right: 10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: DropdownButton(
                                                        dropdownColor:
                                                            Color.fromARGB(255,
                                                                248, 247, 247),
                                                        hint: _Brand == null
                                                            ? Text('Dropdown')
                                                            : Text(
                                                                _Brand,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
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
                                                                Color.fromARGB(
                                                                    255,
                                                                    3,
                                                                    7,
                                                                    11)),
                                                        items: [
                                                          'Select',
                                                          'Original',
                                                          'Local',
                                                          'International'
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
                                              )),
                                      ],
                                    ),
                               
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(horizontal:10),
                                              width: 100,
                                             
                                              child: 
                                              Column(children: [
                                                Image.network("$image", height: 100,fit: BoxFit.contain,),

                                                GestureDetector(
                                                  onTap:(){
                                                    print("Image Removed Successfully");
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(border:Border.all(color: Colors.black),color: Colors.red),
                                                    child: Text("Remove Image",style: TextStyle(color: Colors.white,fontSize:11),)),
                                                )
                                            ],)),
                                          ],
                                        ),
                                         SizedBox(height: 10,),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Upload Image Here",
                                                      style: themeTextStyle(
                                                          size: 15,
                                                          fw: FontWeight.bold)),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(10),
                                                    ),
                                                    height: 50,
                                                    margin: EdgeInsets.only(
                                                        top: 10,
                                                        bottom: 10,
                                                        right: 10),
                                                    padding: EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    child: Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                           _ImageSelect_Alert(context);
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(10),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            31,
                                                                            232,
                                                                            226,
                                                                            226)),
                                                                color:
                                                                    Color.fromARGB(
                                                                        255,
                                                                        237,
                                                                        235,
                                                                        235)),
                                                            child: Text(
                                                              "Choose File",
                                                              style: themeTextStyle(
                                                                  size: 15),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        (url_img == null ||
                                                                url_img.isEmpty)
                                                            ?
                                                             Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                      "No file choosen",
                                                                      style: themeTextStyle(
                                                                          size: 15,
                                                                          color: Colors
                                                                              .black38)),
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
                                                                        fw: FontWeight
                                                                            .w400,
                                                                        color:
                                                                            themeBG4),
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
                                                child:
                                                    SizedBox(width: defaultPadding),
                                              ),
                                          ],
                                        ),
                                  
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          themeButton3(context, () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                                  setState(() {
                                                  if(_formKey.currentState!.validate()){
                                                 updatelist(id, Name, Noitem, slugUrl,_Status,
                                                 _Category, Mrp, Discount,Offer,_Size,_Brand,url_img
                                                 );
                                                }
                                              });
                                            }
                                          },
                                              buttonColor: Colors.blueAccent,
                                              label: "Update"),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          // themeButton3(context, () {
                                          //   setState(() {
                                          //     //    clearText();
                                          //   });
                                          // },
                                          //     label: "Reset",
                                          //     buttonColor: Colors.black),
                                          // SizedBox(width: 20.0),
                                        ])
                                  ],
                                );
                              }))),
                ]
                )
                );
                
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

////////  Data bases Image call  +++++++++++++++++++++++++++++++
 List<String> _selectedOptions = [];
  Widget All_media(BuildContext context, setStatee) {
    return 
    Container(
          height: 500,
        child:
         GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: myList.length,
          itemBuilder: (_, index) => 
         Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          '${myList[index]}'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  alignment: Alignment.topLeft,
                  child:
                   CheckboxListTile(
                    checkColor: Colors.white,
                    activeColor: Colors.green,
                    side:
                     BorderSide(width: 2, color: Colors.red),
                  value: _selectedOptions.contains(myList[index]),
                    onChanged: ( value) {
                  setState(() {
                   if (value != null && _selectedOptions.isEmpty) {
                    setState(() {
                       _selectedOptions.add(myList[index]);
                        url_img = _selectedOptions[0];
                       Navigator.pop(context);
                    });
              } 
              else if(_selectedOptions != null && _selectedOptions.isNotEmpty){
                 setState(() {
                   _selectedOptions[0] = "${myList[index]}";
                    url_img = _selectedOptions[0];
                   Navigator.pop(context);
                 });
              }  
              else {
                _selectedOptions.remove(myList[index]);
              }
            });
          },
        )            
      ),
    ),
  );
}
//////////

////////  Data bases Image call   MOBILE +++++++++++++++++++++++++++++++

Widget All_media_mobile(BuildContext context, setStatee) 
     {
    return 
    Container(
          height: 500,
        child:
         GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:    2,
          ),
          itemCount: myList.length, // <-- required
          itemBuilder: (_, index) => 
         Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          '${myList[index]}'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child:
                    CheckboxListTile(
                    checkColor: Colors.white,
                    activeColor: Colors.green,
                    side:
                     BorderSide(width: 2, color: Colors.red),
                  value: _selectedOptions.contains(myList[index]),
                    onChanged: ( value) {
                  setState(() {
                   if (value != null && _selectedOptions.isEmpty) {
                    setState(() {
                       _selectedOptions.add(myList[index]);
                        url_img = _selectedOptions[0];
                       Navigator.pop(context);
                    });
              } 
              else if(_selectedOptions != null && _selectedOptions.isNotEmpty){
                 setState(() {
                   _selectedOptions[0] = "${myList[index]}";
                    url_img = _selectedOptions[0];
                   Navigator.pop(context);
                 });
              }  
              else {
                _selectedOptions.remove(myList[index]);
              }
            });
          },
        )
                ),
        ),
    );
  }
////////////// update text widget ++++++++++++++++
 Widget Text_field_up(BuildContext context, ini_value, lebel, hint) {
    return

     Container(
        height: 40,
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          initialValue: ini_value,
          autofocus: false,
          onChanged: (value) => ini_value = value,
        // controller: ctr_name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please $hint';
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
//////

///////////// New Add text widget +++++++++++++++++++++
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
}

/// Class CLose
