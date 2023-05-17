// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_this, non_constant_identifier_names, unnecessary_cast, avoid_print, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, prefer_final_fields, override_on_non_overriding_member, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_null_comparison, unnecessary_brace_in_string_interps, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable, sort_child_properties_last, depend_on_referenced_packages, avoid_types_as_parameter_names, unused_field

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firedart/generated/google/firestore/v1/document.pb.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:slug_it/slug_it.dart';
import 'package:intl/intl.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({super.key});
  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {

  ////// rate_cate
  final mrpController = TextEditingController();
  final offerController = TextEditingController();
  final DiscountController = TextEditingController();
  final SellingPriController = TextEditingController();
  final NoitemController = TextEditingController();
  final ShippingController = TextEditingController();
  ///////
  final _formKey = GlobalKey<FormState>();
  
  final SlugUrlController = TextEditingController();
  final NameController = TextEditingController();
  String? _PerentCate;
  String? _StatusValue;
  String? _sizeValue;
  String? _brandValue;
  String Date_at = DateFormat('dd-MM-yyyy').format(DateTime.now());
  @override
  clearText() {
    NameController.clear();
    SlugUrlController.clear();
    mrpController.clear();
    offerController.clear();
    DiscountController.clear();
    NoitemController.clear();
    _PerentCate;
    _StatusValue;
    _sizeValue;
    _brandValue;
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
  var db = FirebaseFirestore.instance;
  CollectionReference _product =
      FirebaseFirestore.instance.collection('product');
  ////////////+++++
  List StoreDocs = [];
  Pro_Data() async {
    StoreDocs = [];
    var collection = _product;
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map data = queryDocumentSnapshot.data() as Map<String, dynamic>;
      StoreDocs.add(data);
      data["id"] = queryDocumentSnapshot.id;
    }
   setState(() {
     listExample();
     _CateData();
     _AttributeData();
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
          'parent_cate': "$_PerentCate",
          'status': "$_StatusValue",
          'size': "$_sizeValue",
          'brand': "$_brandValue",
          'image': "$url_img",
          "date_at": "$Date_at"
        })
        .then((value) {

          setState(() {
            themeAlert(context, "Successfully Submit");
            Pro_Data();
          });
        } )
        .catchError(
            (error) => themeAlert(context, 'Failed to Submit', type: "error"));
  }

  ///
  ///delete
  Future<void> deleteUser(id) {
    return _product
        .doc(id)
        .delete()
        .then((value) {
          setState(() {
            themeAlert(context, "Deleted Successfully ");
             Pro_Data();
          });
        } )
        .catchError(
            (error) => themeAlert(context, 'Not find Data', type: "error"));
  }

  ///
/////// Update

/////////

  var Name ;
  var Noitem ;
  var slugUrl ;
  var Discount ;
  var Offer ;
  var Mrp ;
  var image ;
  var _Status ;
  var _Size;
  var _Brand ;
  var _PerentC ;
//////
  Map<String, dynamic>? data;
 Future Update_initial(id)
    async{
    DocumentSnapshot pathData = await FirebaseFirestore.instance
       .collection('product')
       .doc(id)
       .get();
      if (pathData.exists) {
       data = pathData.data() as Map<String, dynamic>?;
       setState(() {                   
        Name = data!['name'];
        Noitem = data!['No_Of_Item'];
        slugUrl = data!['slug_url'];
        Discount = data!['discount'];
        Offer = data!['Offer'];
        Mrp = data!['mrp'];
        image = data!["image"];
        _Status = data!['status'];
        _Size = data!['size'];
        _Brand = data!['brand'];
        _PerentC = data!['parent_cate'];
       });
     }
}
///

//////// Update Product Function +++++++++++++++++++++++++++++

  Future<void> updatelist(
    id, Name, Noitem, slugUrl, _Status,
     _Category, Mrp, Discount, Offer, _Size, 
     _Brand, image
     ) 
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
             Pro_Data();
          });
        } )
        .catchError(
            (error) => themeAlert(context, 'Failed to update', type: "error"));
  }


/////


///////////  Calling Category data +++++++++++++++++++++++++++
    List <String> Cate_Name_list = ["Select"];
   _CateData() async {
    var collection = FirebaseFirestore.instance.collection('category');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map data = queryDocumentSnapshot.data() as Map<String, dynamic>;
      Cate_Name_list.add(data["category_name"]);
    }
  }

///////////    Creating SLug Url Function +++++++++++++++++++++++++++++++++++++++
    Slug_gen(String text){
    var slus_string;
    String slug = SlugIT().makeSlug(text);
    setState(() {
    slus_string = slug;
    SlugUrlController.text = slus_string;
    });
    }
///// ++++++++++++++++++++++++++++++++++++++

  @override
  void initState() {
      Pro_Data();
    super.initState();
  }

  ///////   LOcal widget change variable
  bool updateWidget = false;
  var update_id ;
  var basic_Product = true;
  var fectured_Product;
  ////////// colors ++++++++++++
  bool Product_colors = false;
  bool colors_red = false;
  bool colors_blue  = false;
  ////// Size ++++++++++++++++++
  bool Product_Size = false;
  bool size_s = false;
  bool size_m =  false;
  bool size_l = false;
  ////// next >>>
  bool text_fields = false;
  ///
///////////  firebase property Database access  +++++++++++++++++++++++++++

  CollectionReference _attribute =
      FirebaseFirestore.instance.collection('attribute');

  List Attri_data =  [];
  _AttributeData() async {
    Attri_data = [];
    // var collection = FirebaseFirestore.instance.collection('category');
    var querySnapshot = await _attribute.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map data = queryDocumentSnapshot.data() as Map<String, dynamic>;
      Attri_data.add(data);
      data["id"] = queryDocumentSnapshot.id;
    }
    setState(() {
      
    });
  }

  var Attribute_name;
  Map value_color = {};
  List Color_list = [];
  
  var Size_value = [];
  var Color_value = [];
//////
  Map<String, dynamic>? dbData;
  Future Sub_attribute(id) async {
     Color_list = [];
    DocumentSnapshot pathData =
        await FirebaseFirestore.instance.collection('attribute').doc(id).get();
    if (pathData.exists) {
      dbData = pathData.data() as Map<String, dynamic>?;
      setState(() {
        _Status = dbData!['status'];
        Attribute_name = dbData!['attribute_name'];
        value_color = dbData!["value"];
        value_color.forEach((k, v) => Color_list.add(v));
      
      
       //print("$Color_list  ++++++");
      });
    }
  }

  ///

/////////////


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
          return 
          Scaffold(
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
                                Tab(text: "Add New Product"),
                                Tab(text: "All Products List"),
                              ],
                            ),
                          ),
                          Expanded(
                              child: TabBarView(
                            children: [
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
List<String> _selectOption_attri = [];
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
                    child:
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
                                  Text("Name*",style: themeTextStyle(
                                          color: Colors.black,
                                          size: 15,
                                          fw: FontWeight.bold)),
                                  Text_field(context, NameController, "Name","Enter Name"),
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
                                Text(
                                  "No Item",
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
                                        Text_field(context, SlugUrlController,"Slug Url", "Enter Slug Url")  
                                  ],
                                )),
                      SizedBox(height: defaultPadding),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: 
                            Container(
                              child:
                               Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child:
                                       Text("Status",
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold))),
                                  Container(
                                    height: 40,
                                    margin: EdgeInsets.only(
                                        top: 10, bottom: 10,),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: DropdownButton(
                                      dropdownColor:
                                          Colors.white,
                                      hint: _StatusValue == null
                                          ? Text('Select',style: TextStyle(color:Colors.black))
                                          : Text(
                                              _StatusValue!,
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
                                          ['Select','Inactive', 'Active'].map(
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
                       
                      ),
                      SizedBox(width: defaultPadding),
                        Expanded(
                            flex: 2,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Text("Category Name",
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
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: DropdownButton(
                                      dropdownColor:
                                          Colors.white,
                                      hint: _PerentCate == null
                                          ?Text('Select',style: TextStyle(color:Colors.black),)
                                          : Text(
                                              _PerentCate!,
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
                                      items: 
                                      Cate_Name_list.map(
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
                                            _PerentCate = val!;
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
                
                    // Size option

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: 
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
                                        top: 10, bottom: 20, ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: DropdownButton(
                                      dropdownColor:
                                          Colors.white,
                                      hint: _sizeValue == null
                                          ? Text('Select',style: TextStyle(color:Colors.black),)
                                          : Text(
                                              _sizeValue!,
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
                            )
                      ),
                      SizedBox(width: defaultPadding),
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
                                        top: 10, bottom: 20,),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: DropdownButton(
                                      dropdownColor:
                                         Colors.white,
                                      hint: _brandValue == null
                                          ? Text('Select',style: TextStyle(color:Colors.black),)
                                          : Text(
                                              _brandValue!,
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
                                          ['Select','Apple', 'Dell', 'HP'].map(
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
          children:[
         GestureDetector(
          onTap: (){
               setState(() {
                basic_Product = true;
            });
          },
              child:
               Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 5),
             margin: EdgeInsets.symmetric(horizontal: 5,vertical: 20),
            height: 40,
               decoration: BoxDecoration(
            color:  ( basic_Product == true)? Colors.green :Colors.grey,
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(10)
          ),
            child: Text("Basic Product")),
         ),

         GestureDetector(
          onTap: ()
          {
            setState(() {
              basic_Product = false;
            });
           
          },
           child:
         Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 5),
          margin: EdgeInsets.symmetric(horizontal: 5,vertical: 20),
          height: 40,
          decoration: BoxDecoration(
            color: ( basic_Product == false)? Colors.green :Colors.grey,
            border: Border.all(color: Colors.black38),
             borderRadius: BorderRadius.circular(10)
          ),
          child: Text("Fetured Product")))
        ]),


    /////////  ROw For Rate MRP +++++++++++++++++++++++
        (basic_Product == true)
        ?                   
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: 
                                Container(
                                    child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    Text("MRP",
                                            style: themeTextStyle(
                                            color: Colors.black,
                                            size: 15,
                                            fw: FontWeight.bold)),
                                             Text_field(context, mrpController, "MRP", "Enter MRP"),
                                     ],
                                )),
                               
                          ),
                         SizedBox(width: defaultPadding),
                            Expanded(
                              flex: 2,
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Discount",
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
                  )
               :
               Column(
                 children: [
                   Container(
                    padding: EdgeInsets.all(5), 
                    decoration: BoxDecoration(color: Colors.blue.withOpacity(0.5),),
                     child: 
                     Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                       Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                                  Text("Attribute",
                                            style: themeTextStyle(
                                                color: Colors.black,
                                                size: 15,
                                                fw: FontWeight.bold)),
                                  SizedBox(height: 10,)   , 
                                  Row(
                                  children: [
                                     for (var index = 0; index < Attri_data.length; index++)

                                    // Text( "${Attri_data[index]["attribute_name"]}  ++++++++++++++  ${Attri_data[index]["id"]}"),
                                       
                                    Container(
                                      height: 25,
                                    margin: EdgeInsets.symmetric(horizontal:5),
                                     padding: EdgeInsets.symmetric(horizontal: 10),  
                                    decoration: BoxDecoration(color: Colors.white,
                                     borderRadius: BorderRadius.circular(10)
                                    ),
                                    child:
                                     Row(children: [
                        
                                      
                                      Checkbox(
                                      activeColor: Colors.green,
                                        side:
                                           BorderSide(width: 2, color: Colors.black),
                                         value:
                                         (Attri_data[index]["attribute_name"] == "Colors") ?
                                           Product_colors
                                           :
                                           Product_Size, // _selectOption_attri.contains(Attri_data[index]["id"]),   // 
                                         onChanged: (value) {
                                        
                                          setState(() {  
                                               if(Attri_data[index]["attribute_name"] == "Colors") {
                                               Product_colors = value!; 
                                                setState(() {
                                                   Color_value = Color_list;
                                                }); 
                                              
                                               }
                                               else{
                                                Product_Size = value!;  
                                                setState(() 
                                                {
                                                  Size_value = Color_list;
                                                });
                                               }
                                               Sub_attribute(Attri_data[index]["id"]);
                                              });  
                                              
                                           },
                                          ),
                                      Text("${Attri_data[index]["attribute_name"]}",style: TextStyle(color: Colors.black),)
                                    ],) ),


            //          setState(() {
            //          if (value != null && _selectOption_attri.isEmpty ) {
            //           setState(() {
            //            if(_selectOption_attri.length < Attri_data.length ){
            //               _selectOption_attri.add(Attri_data[index]["attribute_name"]);
            //            } 
            //          //   url_img = _selectOption_attri[0];
            //          print("${_selectOption_attri}  +++++++");
            //         });
            //        }
            //        else if(_selectOption_attri.isNotEmpty &&  _selectOption_attri[0] == Attri_data[index]["attribute_name"])
            //        {
            //          setState(() {
            //           _selectOption_attri[0] == null;
            //          } );
            //        }
            //     else if(_selectOption_attri != null && _selectOption_attri.length < Attri_data.length){
            //      setState(() {
            //       _selectOption_attri.add(Attri_data[index]["attribute_name"]);
            //        print("${_selectOption_attri}  +++++++");
                  
            //      });
            //   }  
            //   // else if (_selectOption_attri.length == Attri_data.length){
            //   //   print(" more than value +++++++++++++");

            //   // }
            
            // });


                                    // Container(
                                    //   height: 25,
                                    //   padding: EdgeInsets.symmetric(horizontal: 10),
                                    //   margin: EdgeInsets.symmetric(horizontal:5), 
                                    //   decoration: BoxDecoration(color: Colors.white,
                                    //    borderRadius: BorderRadius.circular(10)
                                    //   ),
                                    //   child: 
                                    //    Row(children: [
                                    //   Checkbox(
                                    //     activeColor: Colors.green,
                                    //     side:
                                    //        BorderSide(width: 2, color: Colors.black),
                                    //      value: Product_Size,
                                    //      onChanged: (value) {
                                    //       setState(() {  
                                    //            Product_Size = value!;  
                                    //           });  
                                    //        },
                                    //       ),
                                    //   Text("Size",style: TextStyle(color: Colors.black))
                                   
                                    // ],)
                                    // ),
                         
                                  ],)          
                         
                             ],
                           ),
                         
                       ],
                     ),
                   ),

            (Product_Size == true || Product_colors == true)
               ?
              Container(
                padding: EdgeInsets.all(5), 
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.4),),
                 child: 
                 Column(
                   children: [
                     Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      (Product_colors == true)
                       ?
                       Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             children: [
                               Icon(Icons.brightness_1_rounded ,size: 10,color:Colors.black),
                               SizedBox(width: 5,),
                               Text("Colour",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                             ],
                           ), 

                       for (var i = 0; i < Color_value.length; i++)             
                       Container(
                          child:
                          Row(
                          children: [
                                Checkbox(
                                          activeColor: Colors.green,
                                            side:
                                            BorderSide(width: 2, color: Colors.black),
                                             value: colors_red,
                                             onChanged: (value) {
                                                setState(() {  
                                                colors_red = value!;  
                                                  });  
                                               },
                                              ),
                                Text("${Color_value[i]["name"]}",style: TextStyle(color: Colors.black)),       
                          ],),),
                          
                         ],
                       )
                       :
                       SizedBox(),

                      SizedBox(width: 200),  
                      (Product_Size == true)
                       ?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           Row(
                             children: [
                               Icon(Icons.brightness_1_rounded ,size: 10,color:Colors.black),
                               SizedBox(width: 5,),
                               Text("Size",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                             ],
                           ),

                          for (var i = 0; i < Size_value.length; i++)     
                           Container(
                          child:
                         Row(
                          children: [
                                Checkbox(
                                          activeColor: Colors.green,
                                            side:BorderSide(width: 2, color: Colors.black),
                                             value: size_s,
                                             onChanged: (value) {
                                              setState(() {  
                                                   size_s = value!;  
                                                   text_fields = false;
                                                  });  
                                               },
                                              ),
                                  Text("${Size_value[i]["name"]}",style: TextStyle(color: Colors.black)),       
                          ],),),


                          ],
                        )
                       :
                       SizedBox(),
                     ],
                     ),
                     SizedBox(height: 10,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                              (
                                    colors_red == true
                                     || colors_blue == true
                                      || size_s == true 
                                       ||size_m == true
                                         ||size_l == true)
                               ?
                               ElevatedButton(
                                 style: ElevatedButton.styleFrom(
                                   backgroundColor: Colors.blue),
                                onPressed: (){
                                  if(
                                    colors_red == true
                                     || colors_blue == true
                                      || size_s == true 
                                       ||size_m == true
                                         ||size_l == true)
                                   {
                                    setState(() {
                                    text_fields = true;
                                    });
                               
                                   }
                                         
                                    }, 
                               child: Text("Next",style: TextStyle(color: Colors.white)))
                               :
                               SizedBox()
                             ],
                           )
                   ],
                 )     
               )
               :SizedBox(),

               SizedBox(height: 10,),
                  (text_fields == true)
                    ?
                     Column(
                       children: [                                               
                       (colors_red == true)?
                         Column(
                           children: [
                             Row(
                               children: [
                                (colors_red == true && text_fields == true)
                                ?
                                 Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                                  child: Text("Red",style: TextStyle(color: Colors.blue),))
                                  :
                                  SizedBox(),
                                  (size_s == true && text_fields == true)
                                  ?
                                  Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                                  child: Text("Small",style: TextStyle(color: Colors.blue),))
                                  :
                                  SizedBox()
                               ],
                             ),
                             Rate_category(context)
                            ],
                         )
                         :

                         (colors_red == false &&  size_s == true && colors_blue == false)
                              ?
                              Row(
                                children: [
                                  Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                                  child: Text("Small",style: TextStyle(color: Colors.blue),)),
                                ],
                              ) 
                              :
                              SizedBox(),

                          (colors_blue == true)
                          ?
                           Row(
                           children: [
                              (colors_blue == true && text_fields == true)?
                              Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                              child: Text("Blue",style: TextStyle(color: Colors.blue),)
                              )
                              :
                              SizedBox(),
                              (size_s == true && text_fields == true)
                              ?
                              Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                              child: Text("Small",style: TextStyle(color: Colors.blue),))
                             :
                              SizedBox(),
                           ],
                         )
                         :
                          SizedBox(),
                       ],
                     )    
                    :
                    SizedBox()  ,

                 SizedBox(height: 10,),
                   (text_fields == true)
                    ?
                     Column(
                       children: [
                           (colors_red == true )?
                         Row(
                           children: [
                            (colors_red == true && (text_fields == true && size_m == true))?
                             Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                              child: Text("Red",style: TextStyle(color: Colors.blue),))
                               :
                               SizedBox(),
                              (size_m == true && text_fields == true)
                              ?
                              Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                              child: Text("Medium",style: TextStyle(color: Colors.blue),))
                              :
                              SizedBox(),
                           ],
                         )
                          :
                            (colors_red == false && colors_blue == false &&  size_m == true)
                              ?
                              Row(
                                children: [
                                  Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                                  child: Text("Medium",style: TextStyle(color: Colors.blue),)),
                                ],
                              ) 
                              :
                              SizedBox(),
                         



                             (colors_blue == true)?
                           Row(
                           children: [
                            (colors_blue == true && (text_fields == true && size_m == true))?
                             Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                              child: Text("Blue",style: TextStyle(color: Colors.blue),))
                               :
                               SizedBox(),
                              (size_m == true && text_fields == true)
                              ?
                              Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                              child: Text("Medium",style: TextStyle(color: Colors.blue),))
                             :
                              SizedBox(),
                           ],
                         )
                         :
                          
                              SizedBox(),
                       ],
                     )    
                    :
                    SizedBox()  ,

                    SizedBox(height: 10,),
                    (text_fields == true)
                    ?
                     Column(
                       children: [
                        (colors_red == true)?
                         Row(
                           children: [
                            (colors_red == true && (text_fields == true && size_l == true))?
                             Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                              child: Text("Red",style: TextStyle(color: Colors.blue),))
                               :
                               SizedBox(),
                              (size_l == true && text_fields == true)
                              ?
                              Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                              child: Text("Large",style: TextStyle(color: Colors.blue),))
                             :
                              SizedBox(),
                           ],
                         )
                         :
                            (colors_red == false &&  colors_blue == false   &&  size_l == true)
                              ?
                              Row(
                                children: [
                                  Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                                  child: Text("Large",style: TextStyle(color: Colors.blue),)),
                                ],
                              ) 
                              :
                              SizedBox(),

                       (colors_blue == true)?
                           Row(
                           children: [
                            (colors_blue == true && (text_fields == true && size_l == true) )?
                             Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                              child: Text("Blue",style: TextStyle(color: Colors.blue),))
                               :
                               SizedBox(),
                              (size_l == true && text_fields == true)
                              ?
                              Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                              child: Text("Large",style: TextStyle(color: Colors.blue),))
                             :
                              SizedBox(),
                           ],
                         )
                        :
                              SizedBox(),

                       ],
                     )    
                    :
                    SizedBox()  

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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 45,
                              margin: EdgeInsets.only(
                                  top: 10, bottom: 10),
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _ImageSelect_Alert(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          color: Colors.grey),
                                      child: Text(
                                        "Choose File",
                                        style: TextStyle(fontWeight:FontWeight.bold,color:Colors.black),
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
                                      : 
                                      Row(
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


        //  Rate_category(context)      
        ]));
  }

////////             List        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Widget listList(BuildContext context, tab) {
      return
       Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5.0),
      // padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child:  ListView(
        children: [
          ClipRRect(
                      borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      child:
                       Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        border: 
                        TableBorder(
                        horizontalInside: BorderSide(width: .5, color: Colors.grey),
                        ),
                        children: [
                           (Responsive.isMobile(context)) 
                            ?
                              TableRow(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).secondaryHeaderColor),
                              children: [
                                 TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Product Details",
                                    style: TextStyle(fontWeight: FontWeight.bold))
                                  ),
                                ),
                              
                              ]
                              )
                         : 
                          TableRow(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).secondaryHeaderColor),
                              children: [
                                 TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'S.No.',
                                       style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      child: Text(
                                      'Logo',
                                       style: TextStyle(fontWeight: FontWeight.bold)),
                                      width: 40,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Product Name',
                                       style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Text(
                                      'Category Name',
                                       style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child:Text("Status",style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: 
                                      Text("Date",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child:  Text("Actions",
                                             style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ]
                              ),
                             for (var index = 0; index < StoreDocs.length; index++)
                               (Responsive.isMobile(context)) 
                              ?
                                 tableRowWidget_mobile(
                                  "${StoreDocs[index]["image"]}",
                                 "${StoreDocs[index]["name"]}",
                                 "${StoreDocs[index]["parent_cate"]}",
                                 "${StoreDocs[index]["status"]}",
                                 "${StoreDocs[index]["date_at"]}",
                                 "${StoreDocs[index]["id"]}"
                                 )
                              :
                              tableRowWidget( 
                                   "${index + 1}",
                                  "${StoreDocs[index]["image"]}",
                                  "${StoreDocs[index]["name"]}",
                                  "${StoreDocs[index]["parent_cate"]}",
                                  "${StoreDocs[index]["status"]}",
                                  "${StoreDocs[index]["date_at"]}",
                                  "${StoreDocs[index]["id"]}"),
                            ],
                      ),
                    ),
        ],
      ),
              
            );
}

  TableRow tableRowWidget( sno, Iimage, name, pName, status, date, iid) {
    return TableRow(children: [
       TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$sno",style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
       // horizentalAlignment: TableCellVerticalAlignment.middle,
        child:  
        Padding(
          padding:  EdgeInsets.all(5.0),
          child: 
           Container(
            alignment: Alignment.topLeft,
                          height: 60,
                          width: 60,
                          child:
                           Image(
                            image:
                            (Iimage != "null" && Iimage.isNotEmpty)
                                      ?  
                                      NetworkImage(
                                      Iimage,
                                    )
                                    :
                                      NetworkImage(
                                      "https://shopnguyenlieumypham.com/wp-content/uploads/no-image/product-456x456.jpg",
                                    )
                                    ,fit: BoxFit.contain),
                        )
        ),
    ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$name",style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("$pName",style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("$status",style: TextStyle(fontWeight: FontWeight.bold)),
      ),
       TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child:Text("$date",style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child:  Row(
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
                              Update_initial(iid);
                            });
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
                            showExitPopup(iid);
                          },
                          icon: Icon(
                            Icons.delete_outline_outlined,
                            color: Colors.red,
                          ))),
                ],
              )
      ),
     
    ]);
  }


 TableRow tableRowWidget_mobile( Iimage, name, pName, status, date, iid) {
    return TableRow(
      children: [
       TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child:  
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
                                     (Iimage != "null" && Iimage.isNotEmpty)
                                      ?  
                                      NetworkImage(
                                      Iimage,
                                    )
                                    :
                                      NetworkImage(
                                      "https://shopnguyenlieumypham.com/wp-content/uploads/no-image/product-456x456.jpg",
                                    )
                                    ,fit: BoxFit.contain
                                    )
                                    ),
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
                                            Update_initial(iid);
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
                                      showExitPopup(iid);
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
             

    )
        
      ]);
  
  }


/////////////  Update widget for product Update+++++++++++++++++++++++++
Widget Update_product(BuildContext context,id) {
 
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
                      IconButton(onPressed: (){
                      setState(() {
                      updateWidget = false;
                      });
                        }, icon:  Icon(Icons.arrow_back,color: Colors.black)),
 
                          SizedBox(width: 10,),
                          Text("Update Product",
                          style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                          ),),
                        ],
                      ),
                    )
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
                            (data == null)
                              ?
                                Center(
                                child: CircularProgressIndicator())
                              :
                                Column(
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
                                              //   Text_field_up(context, Name,"Name", "Enter Name"),
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
                                    margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.only(left: 10, right: 10),
                                    child: DropdownButton(
                                                        dropdownColor:
                                                            Colors.white,
                                                        hint: _StatusValue == null
                                                            ? Text('$_Status',style: TextStyle(color:Colors.black),)
                                                            : Text(
                                                                _StatusValue!,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
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
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    0,
                                                                    0)),
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
                                                      )
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
                                                              "Category Name",
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
                                                              Colors.white,
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
                                                              Colors.white,
                                                          hint: (_PerentCate == null)
                                                              ? Text('$_PerentC',style: TextStyle(color:Colors.black),)
                                                              : Text(
                                                                  _PerentCate!,
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
                                                          items:
                                                          //  [
                                                          //   'Select',
                                                          //   'One',
                                                          //   'Two',
                                                          //   'Three'
                                                          // ]
                                                          Cate_Name_list.map(
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
                                                                _PerentCate =
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
                                                            "Category Name",
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
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: DropdownButton(
                                                          dropdownColor:
                                                              Colors.white,
                                                          hint: (_PerentCate == null)
                                                              ? Text('$_PerentC',style: TextStyle(color:Colors.black),)
                                                              : Text(
                                                                  _PerentCate!,
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
                                                           items: 
                                                          // [
                                                          //   'Select',
                                                          //   'One',
                                                          //   'Two',
                                                          //   'Three'
                                                          // ]
                                                          Cate_Name_list.map(
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
                                                                _PerentCate =
                                                                    val!;
                                                              },
                                                            );
                                                          },
                                                        )
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
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: DropdownButton(
                                                        dropdownColor:
                                                            Colors.white,
                                                        hint: _sizeValue  == null
                                                            ?
                                                             Text('$_Size',style: TextStyle(color:Colors.black),)
                                                            :
                                                             Text(
                                                               _sizeValue!,
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
                                                          'Small',
                                                          'Medium',
                                                          "Large"
                                                        ].map(
                                                          (val) {
                                                            return 
                                                            DropdownMenuItem<String>(
                                                              value: val,
                                                              child: Text(val),
                                                            );
                                                          },
                                                        ).toList(),
                                                        onChanged: (val) {
                                                            setState(
                                                              () {
                                                                _sizeValue =
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
                                                              Colors.white,
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
                                                              Colors.white,
                                                          hint: _brandValue == null
                                                              ?  Text('$_Brand',style: TextStyle(color:Colors.black),)
                                                              : Text(
                                                                  _brandValue!,
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
                                                                _brandValue =
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
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child:DropdownButton(
                                                          dropdownColor:
                                                              Colors.white,
                                                          hint: _brandValue == null
                                                              ?  Text('$_Brand',style: TextStyle(color:Colors.black),)
                                                              : Text(
                                                                  _brandValue!,
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
                                                                _brandValue =
                                                                    val!;
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
                                     (
                                    url_img == null && image == "null")
                                     ?
                                      SizedBox()
                                      :
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(horizontal:10),
                                              width: 100,
                                             
                                              child: 
                                              Column(children: [
                                              (url_img == null || url_img.isEmpty)
                                              ?
                                                (image != null )
                                                ?
                                                Image.network("$image", height: 100,fit: BoxFit.contain,)
                                                :
                                                Image.network(
                                                  "https://cdn.vectorstock.com/i/preview-1x/65/30/default-image-icon-missing-picture-page-vector-40546530.jpg", height: 100,fit: BoxFit.contain,)
                                              :
                                              Image.network(url_img, height: 100,fit: BoxFit.contain,),
                                                 
                                                GestureDetector(
                                                  onTap:(){
                                                   setState(() {
                                                     url_img = null;
                                                    image = null;
                                                   });
                                                    
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
                                                    height: 45,
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
                                                                EdgeInsets.all(2),
                                                            decoration: BoxDecoration(
                                                    
                                                                color:
                                                                    Colors.grey),
                                                            child: Text(
                                                              "Choose File",
                                                              style:TextStyle(color: Colors.black)
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
                                                 updatelist(id, Name, Noitem, slugUrl,_StatusValue,
                                                 _PerentC, Mrp, Discount,Offer,_Size,_Brand,
                                                 
                                                 (url_img == null || url_img.isEmpty)
                                                 ?
                                                 image
                                                 :
                                                 url_img
                                                 );
                                          },
                                              buttonColor: Colors.blueAccent,
                                              label: "Update"),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ])
                                  ],
                                )
                             // }
                             // )
                              //)
                              
                              ),
                ]
                )
                );
                
}
///////////////////////////
Discount_cal()
{
  if(SellingPriController.text.isNotEmpty && mrpController.text.isNotEmpty)
  {
    var mrpp = int.parse(mrpController.text);
    var sellpp = int.parse(SellingPriController.text);
   
   setState(() {
     var DiscountPP = (( (mrpp - sellpp) /mrpp*100 ));
     DiscountController.text = DiscountPP.toStringAsFixed(2);
   });
  }
}

Widget Rate_category(BuildContext context)
{
return
    Container(
      color: Colors.grey,
      child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: 
                                  Container(
                                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      Text("MRP (₹)",
                                              style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold)),
                                               //Text_field(context, mrpController, "MRP", "Enter MRP"),                                     
                                      Text_rate(context,mrpController,"MRP")
                                       ],
                                  )),
                                 
                            ),
                           SizedBox(width: defaultPadding),
                              Expanded(
                                flex: 2,
                                child: Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Selling Price (₹)",
                                        style: themeTextStyle(
                                            color: Colors.black,
                                            size: 15,
                                            fw: FontWeight.bold)),
                                        Text_rate(context,SellingPriController,"Selling Price")    
                                  ],
                                )),
                              ),
                          
                              SizedBox(width: defaultPadding),
                            // // On Mobile means if the screen is less than 850 we dont want to show it
                            // if (!Responsive.isMobile(context))
                              Expanded(
                                flex: 2,
                                child: Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Discount (%)",
                                        style: themeTextStyle(
                                            color: Colors.black,
                                            size: 15,
                                            fw: FontWeight.bold)),
                                 Container(
                                  alignment: Alignment.centerLeft,
                                 width: double.infinity,
                                 height: 40,
                                 margin: EdgeInsets.only(top: 10, bottom: 10,left:10),
                                 padding: EdgeInsets.only(left:10),
                                 decoration: BoxDecoration(
                                 color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                   ),
                                 child: Text("${DiscountController.text} %",style: themeTextStyle(
                                            color: Colors.black,
                                            size: 15,
                                            fw: FontWeight.bold)))
                                  ],
                                )),
                              ),
                          ],
                        ),

                 Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: 
                                  Container(
                                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      Text("Shiping Price(₹)",
                                              style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold)),                                  
                                      Text_rate(context,ShippingController,"MRP")
                                       ],
                                  )),
                                 
                            ),
                           SizedBox(width: defaultPadding),
                              Expanded(
                                flex: 2,
                                child: Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Stock (No. item)",
                                        style: themeTextStyle(
                                            color: Colors.black,
                                            size: 15,
                                            fw: FontWeight.bold)),
                                            Text_rate(context,NoitemController,"Selling Price")    
                                  ],
                                )),
                              ),
                          
                          
                          ],
                        ),
                      ],
                    ),
    );
}

Widget Text_rate(BuildContext context,ctro_name,_hint){
  return
     Container(
          height: 40,
          margin: EdgeInsets.only(top: 10, bottom: 10,),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child:                              
            TextFormField(
           controller: ctro_name, 
           onChanged: (value) async {
              if (SellingPriController.text.isNotEmpty) {
      
                 Discount_cal();
        
              } 
           },
            validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Enter value';
            }
          },
          
              decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            hintText: '$_hint',
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            
        suffixIcon:  Container(
          height: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap:(){
                     var mrpIncre = int.parse(ctro_name.text);
                     setState(() {
                        mrpIncre ++;
                        ctro_name.text = mrpIncre.toString();
                   });
                  },
                  child:  Icon(
                      Icons.expand_less_rounded ,size: 20,color:Colors.black),
                ),
                  GestureDetector(
                    onTap: (){
                       var mrpIncre = int.parse(ctro_name.text);
                     setState(() {
                        mrpIncre --;
                       ctro_name.text = mrpIncre.toString();
                   });
                    },
                    child: Icon(
                      Icons.expand_more_outlined,size: 20,color:Colors.black),
                  )
              ],
            ),
        ),
        
                ),
                style: 
               TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                inputFormatters: 
                  <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
              ),
          );

}


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
                    border: Border.all(color:Colors.grey),
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
                    border: Border.all(color:Colors.grey),
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

///////////// New Add text widget +++++++++++++++++++++
  Widget Text_field(BuildContext context, ctr_name, lebel, hint) {
    return Container(
          height: 40,
          margin: EdgeInsets.only(top: 10, bottom: 10,),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: 
        TextFormField(
          controller: ctr_name,
          onChanged: 
           (ctr_name == NameController)
           ?
           (value){
            Slug_gen("${value}");
           }
           :
           (value){},     // => slus_string = value,
            validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Enter value';
            }
          },
          style: 
          TextStyle(color: Colors.black),
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

////////////// update text widget ++++++++++++++++
//  Widget Text_field_up(BuildContext context, ini_value, lebel, hint) {
//     return
//      Container(
//         height: 40,
//         margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: TextFormField(
//           initialValue: ini_value,
//           autofocus: false,
//           onChanged: (value) => ini_value = value,
//         // controller: ctr_name,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please $hint';
//             }
//              return null;
//           },
//           style: TextStyle(color: Colors.black),
//           decoration: InputDecoration(
//             border: InputBorder.none,
//             contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             hintText: '$hint',
//             hintStyle: TextStyle(
//               color: Colors.grey,
//               fontSize: 16,
//             ),
//           ),
//         ));

  
//         }
// //////





 Future<bool> showExitPopup(iid_delete) async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  Icon(Icons.delete_forever_outlined,color: Colors.red,size: 35,),
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
                'Are you sure to delete this Product ?',
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child:  TextButton(
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child:  TextButton(
                  onPressed: () {
                   setState(() {
                     deleteUser(iid_delete);
                     Navigator.of(context).pop(false);
                   });
                  } ,
                  child: Text(
                    'Yes',
                    style: themeTextStyle(
                        size: 16.0,
                        ftFamily: 'ms',
                        fw: FontWeight.normal,
                        color: themeBG4),
                  ),),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }
}/// Class CLose
