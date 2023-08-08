// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_this, non_constant_identifier_names, unnecessary_cast, avoid_print, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, prefer_final_fields, override_on_non_overriding_member, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_null_comparison, unnecessary_brace_in_string_interps, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable, sort_child_properties_last, depend_on_referenced_packages, avoid_types_as_parameter_names, unused_field, curly_braces_in_flow_control_structures, prefer_is_empty, unnecessary_new, prefer_collection_literals, unused_local_variable, deprecated_member_use

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

import '../../themes/function.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/firebase_Storage.dart';
import '../../themes/firebase_functions.dart';
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
  var db = FirebaseFirestore.instance;
  var myAttr;
  final _formKey = GlobalKey<FormState>();
  String _PerentCate = '';
  int _StatusValue = 1;
////////  Map advance product Controller++++++++++++++++
  Map<String, TextEditingController> _controllers = new Map();
  // Map<String, TextEditingController> _controllers2 = new Map();
  Map<String, TextEditingController> _controllers_Address = new Map();

  // Map<String, TextEditingController> ctr_mrp = new Map();
  // Map<String, TextEditingController> ctr_sell_p = new Map();
  // Map<String, TextEditingController> ctr_dicount = new Map();
  // Map<String, TextEditingController> ctr_shipping = new Map();
  // Map<String, TextEditingController> ctr_notem = new Map();

  /// imple text controller
  final SlugUrlController = TextEditingController();
  final NameController = TextEditingController();
  final imageController = TextEditingController();
  final DiscountController = TextEditingController();
  int itemNo_i = 0;
  bool editAction = false;
  String Date_at = DateFormat('dd-MM-yyyy').format(DateTime.now());
  Map<dynamic, dynamic> _itemCtr = {};

/////================================================
  @override
  clearText() {
    setState(() {
      NameController.clear();
      SlugUrlController.clear();
      DiscountController.clear();
      _PerentCate;
      _StatusValue;
      clear_imageData();
      _controllers = new Map();
      _itemCtr = {};
    });
  }

  ///// File Picker +++++++++++++++++++++++++++++++++++++++++
  void clear_imageData() {
    fileName = null;
    url_img = null;
  }

  var url_img;
  String? fileName;
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
          print("image selected");
        });
        setState(() async {
          downloadURL = await FirebaseStorage.instance
              .ref()
              .child('media/$fileName')
              .getDownloadURL();
          url_img = downloadURL.toString();
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
          url_img = downloadURL.toString();
        });
      } else {
        themeAlert(context, 'Not find selected', type: "error");
        return null;
      }
    }
  }

  ///////////  firebase property
  final Stream<QuerySnapshot> _crmStream =
      FirebaseFirestore.instance.collection('product').snapshots();
  // var db = FirebaseFirestore.instance;
  CollectionReference _product =
      FirebaseFirestore.instance.collection('product');

  ////////////  Product data fetch  ++++++++++++++++++++++++++++++++++++++++++++
  List StoreDocs = [];
  //var temp ;
  var temp;
  List basic_list = [];
  List productList = [];
  List Featured_list = [];
  Pro_Data() async {
    var temp2 = [];
    productList = [];
    Map<dynamic, dynamic> w = {
      'table': "product",
      //'status': "$_StatusValue",
    };
    var temp = await dbFindDynamic(db, w);
    setState(() {
      temp.forEach((k, v) {
        productList.add(v);
      });
      for (var i = 0; i < productList.length; i++) {
        temp2.add(productList[i]["name"]);
      }
      // print("${temp2}  ++++++++++++++");
    });

    Image_data();
    _CateData();
    _AttributeData();
  }
/////////////=====================================================================

///////////  Calling Category data +++++++++++++++++++++++++++
  Map<int, String> v_status = {1: 'Active', 2: 'Inactive'};
  Map<String, String> Cate_Name_list = {'Select': ''};
  _CateData() async {
    Map<dynamic, dynamic> w = {
      'table': 'category',
      //'status':'1',
    };
    var dbData = await dbFindDynamic(db, w);
    dbData.forEach((k, v) {
      Cate_Name_list[v['category_name']] = v['id'];
    });
  }
  ///////============================================================

///////////  firebase  Attribute data access  ++++++++++++++++
  List Attri_data = [];
  _AttributeData() async {
    Attri_data = [];
    var collection = FirebaseFirestore.instance.collection('attribute');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map data = queryDocumentSnapshot.data() as Map<String, dynamic>;
      Attri_data.add(data);
      data["id"] = queryDocumentSnapshot.id;
    }
  }

/////////////==================================================================

/////////// firebase Storage Image data calll   +++++++++++++++++++
  String? downloadURL;
  List<String> myList = [];
  Future Image_data() async {
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

////  +===============================================================================

////////////////////  add list   ++++++++++++++++++++++++++++++++++++++++++++++

  addList() async {
    //var arrData = new Map();
    var alert = '';

    Map<dynamic, dynamic> itemField = {};
    Map<dynamic, dynamic> location_pro = {};
    int totalItem = 0;
    var featureImg = '';

/////  Loop For Address Store ++++++++++++++++++++++++++++
    _controllers_Address.forEach((k, val) {
      var tempVar = _controllers_Address['$k']?.text;
      var temp = k.split("___");
      var key = temp[0];
      var field = temp[1];
      var tempData = (location_pro[key] == null) ? {} : location_pro[key];

      alert = (tempVar == null)
          ? 'Please Enter valid ${field.toUpperCase()}'
          : alert;
      tempData[field] = tempVar;

      if (tempVar != '') {
        location_pro[key] = tempData;
      }
    });

////////  Loop For Product Detais Hold

    _controllers.forEach((k, val) {
      var tempVar = _controllers['$k']?.text;
      var temp = k.split("___");
      var key = temp[0];
      var field = temp[1];
      var tempData = (itemField[key] == null) ? {} : itemField[key];

      totalItem = (field == 'no_item' &&
              tempVar != '' &&
              Submit_subProductBox.contains(key))
          ? totalItem + int.parse(tempVar.toString())
          : totalItem;

      alert = (tempVar!.length < 1)
          ? 'Please Enter valid ${field.toUpperCase()}'
          : alert;
      // check image
      if (_itemCtr[key] == null) {
        alert = "${key.toUpperCase()} Product Image Required";
      } else {
        List<dynamic> tempImgs = [];
        _itemCtr[key]['img'].forEach((k, v) {
          featureImg = (featureImg == '') ? k : featureImg;
          tempImgs.add(k);
        });
        tempData['img'] = tempImgs;
      }

      tempData[field] = tempVar;
      if (basic_Product == false && Submit_subProductBox.contains(key)) {
        itemField[key] = tempData;
      } else {
        itemField[key] = tempData;
      }

      // print("&&&&& ${tempData}");
    });

    if (alert != '') {
      themeAlert(context, alert, type: 'error');
      return false;
    }

    // print("---->${itemField}");

    // if (basic_Product == true) {
    //   var temp = itemField['basic'];
    //   itemField = {};
    //   itemField['basic'] = temp;
    //   // _controllers.forEach((key, value) {
    //   //   print("'$key : $value'  +++gggg++");
    //   // });
    // } else {
    //   itemField.remove('basic');
    // }

    // print("---->>><${itemField}");

    Map<String, dynamic> w = {};
    w = (basic_Product == true)
        ? {
            'table': "product",
            'name': "${NameController.text}",
            'slug_url': "${SlugUrlController.text}",
            "location_of_product": location_pro,
            'product_type': "basic",
            "price_details": itemField,
            "no_item": "${itemField["basic"]["no_item"]}",
            "img": featureImg,
            'category': "$_PerentCate",
            'status': "$_StatusValue",
            "date_at": "$Date_at",
          }
        : {
            'table': "product",
            'name': "${NameController.text}",
            'slug_url': "${SlugUrlController.text}",
            "location_of_product": location_pro,
            'product_type': "featured",
            "price_details": itemField,
            "no_item": totalItem,
            "img": featureImg,
            'category': "$_PerentCate",
            'status': "$_StatusValue",
            "date_at": "$Date_at",
            'attribute': selectedCheck,
            'attributeInner': Submit_subProductBox,
          };
    if (edit) {
      w['id'] = update_id;
      await dbUpdate(db, w);
      themeAlert(context, "Successfully Updated");
    } else {
      // print("$location_pro  +++++++++++++++");
      await dbSave(db, w);
      themeAlert(context, "Successfully Uploaded");
    }

    clearText();
    setState(() {
      edit = false;
      update_id = '';
      Add_product = false;
      Pro_Data();
    });
  }
///////////===================================================================

////////  delete  Product ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Future<void> deleteUser(id) {
    return _product.doc(id).delete().then((value) {
      setState(() {
        themeAlert(context, "Deleted Successfully ");
        Pro_Data();
      });
    }).catchError(
        (error) => themeAlert(context, 'Not find Data', type: "error"));
  }

////////  =================================================================================

// function select image =================================================================
//_fnSelectImg(0,myList[index],value);
  _fnSelectImg(itemNo, imgUrl, isSelected) {
    var temp = (_itemCtr[itemNo] == null) ? {} : _itemCtr[itemNo];
    var tempImg = (temp != null && temp['img'] != null) ? temp['img'] : {};
    if (isSelected) {
      tempImg[imgUrl] = true;
    } else {
      tempImg.remove(imgUrl);
    }
    temp['img'] = tempImg;
    setState(() {
      _itemCtr[itemNo] = temp;
    });
  }

// get attribute list+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  _fnGetAttr() async {
    Map<String, dynamic> where = {'table': "attribute", 'status': '1'};
    myAttr = await dbFindDynamic(db, where);
  }

  Map<String, bool> selectedCheck = {};
  Map<String, dynamic> subProduDetailList = {};
  List<dynamic> subProductBox = [];
  List<dynamic> Submit_subProductBox = [];
/////////  change check box value  +++++++++++++++++++++++++++++++++++++++++++++++

  _fnChangeCheckVal(key, Value, checkType) {
    if (this.mounted)
      setState(() {
        if (!edit) {
          _controllers = new Map();
        }
        itemNo_i = 0;
        subProductBox = [];
        Submit_subProductBox = [];
        selectedCheck[key.toLowerCase()] = Value;
        if (checkType == 'main') {
          if (subProduDetailList[key] != null) {
            subProduDetailList[key].forEach((k, v) {
              if (selectedCheck[k] != null) {
                selectedCheck.remove(k.toLowerCase());
              }
            });
            subProduDetailList.remove(key);
          }
        } else {
          var temp = (subProduDetailList[checkType] == null)
              ? {}
              : subProduDetailList[checkType];
          if (Value == true) {
            temp[key.toLowerCase()] = Value;
          } else {
            temp.remove(key.toLowerCase());
          }
          subProduDetailList[checkType] = temp;
        }

        if (subProduDetailList.length == 1) {
          subProduDetailList.forEach((key, value) {
            value.forEach((k, v) {
              subProductBox.add(k);
              Submit_subProductBox.add("$k");
            });
          });
        } else if (subProduDetailList.length > 1) {
          var i = 1;
          var tempList = [];
          subProduDetailList.forEach((key, value) {
            var tempKey;
            var tempList2 = [];
            value.forEach((k, v) {
              tempKey = (tempKey == null) ? k : '$tempKey + $k';
              if (i == 1) {
                tempList.add(k);
              } else {
                tempList.forEach((val) {
                  tempList2.add('$val + $k');
                });
              }
            });
            tempList = (tempList2.isEmpty) ? tempList : tempList2;
            i++;
          });
          tempList.forEach((val) {
            subProductBox.add(val);
            Submit_subProductBox.add("$val");
          });
        }
      });
  }

/////// ================================================================================

///////     Update data collection ++++++++++++++++++++++++++++++++++++++++++++++++++++++

  var Name;
  var slugUrl;
  var _Status;
  var _PerentC;
  var product_type;
  var price_data;

  ///
  var mrp;
  var sell;
  var disc;
  var stock;
  var ship;
  var pro_img;

  // Edit  ================================================================
  // Edit  ================================================================
  // Edit  ================================================================
  Map<String, dynamic>? update_data;
  Future Update_initial(id) async {
    Map<dynamic, dynamic> w = {'table': "product", 'id': id};
    var dbData = await dbFind(w);

    if (dbData != null) {
      setState(() {
        edit = true;
        NameController.text = (dbData['name'] == null) ? '' : dbData['name'];
        SlugUrlController.text = (dbData['name'] == null) ? '' : dbData['name'];

        Name = dbData!['name'];
        slugUrl = dbData!['slug_url'];
        price_data = dbData!['price_details'];
        product_type = dbData!['product_type'];
        _Status = dbData!['status'];
        _PerentC = dbData!['parent_cate'];
        _PerentCate = dbData!['category'];
        SlugUrlController.text = slugUrl;
        _controllers = new Map();

        if (dbData['price_details'] != null) {
          dbData['price_details'].forEach((k, v) {
            v.forEach((ke, vl) {
              var key = "${k}___$ke";

              if (ke == 'img') {
                var tt = (_itemCtr[k] != null) ? _itemCtr[k] : {};
                var ttt = (tt['img'] != null) ? tt['img'] : {};
                vl.forEach((img) {
                  ttt[img] = true;
                });

                tt['img'] = ttt;
                _itemCtr[k] = tt;
              } else {
                _controllers[key] = TextEditingController();
                _controllers[key]?.text = vl;
              }
            });
          });
        }

        if (dbData['location_of_product'] != null) {
          dbData['location_of_product'].forEach((k, v) {
            v.forEach((ke, vl) {
              var key = "${k}___$ke";

              _controllers_Address[key] = TextEditingController();
              _controllers_Address[key]?.text = vl;
            });
          });
        }

        // Submit_subProductBox = ['attributeInner'];

        Add_product = true;
        basic_Product = (product_type == 'basic') ? true : false;
        editAction = true;
        selectedCheck = {};
        if (basic_Product) {
          // this is basic product
          Map<String, dynamic> myMap = jsonDecode(price_data);
          mrp = myMap["basic_product"]["mrp_price"];
          sell = myMap["basic_product"]["selling_price"];
          disc = myMap["basic_product"]["discount"];
          stock = myMap["basic_product"]["stock"];
          ship = myMap["basic_product"]["shiping_price"];
          pro_img = myMap["basic_product"]["product_images"];
          basic_Product = true;
          url_img = pro_img;
        } else {
          // featured
          var attr = dbData['attribute'];

          Attri_data.forEach((vl) {
            if (vl['value'] != null) {
              vl['value'].forEach((k, val) {
                if (attr[k.toLowerCase()] != null &&
                    attr[k.toLowerCase()] == true) {
                  selectedCheck[vl['attribute_name'].toLowerCase()] = true;
                  selectedCheck[k.toLowerCase()] = true;
                  _fnChangeCheckVal(
                      k.toLowerCase(), true, capitalize(vl['attribute_name']));
                }
              });
            }
          });
        }
      });
    }
  }

///////////////////       ======================================================
//////// Update Product Function +++++++++++++++++++++++++++++

  Future<void> updatelist(id, Name, slugUrl, _Status, _Category) {
    return _product.doc(id).update({
      'name': "$Name",
      'slug_url': "$slugUrl",
      'status': "$_Status",
      'parent_cate': "$_Category",
      'price_details': "",
      "product_type": "Basic Product",
      "date_at": "$Date_at"
    }).then((value) {
      themeAlert(context, "Successfully Update");
      setState(() {
        updateWidget = false;
        Pro_Data();
      });
    }).catchError(
        (error) => themeAlert(context, 'Failed to update', type: "error"));
  }

/////////// ===============================================================

///////////    Creating SLug Url Function +++++++++++++++++++++++++++++++++++++++
  Slug_gen(String text) {
    var listtt = [];
    var slus_string;
    String slug = SlugIT().makeSlug(text);
    setState(() {
      for (var index = 0; index < productList.length; index++) {
        listtt.add("${productList[index]['slug_url']}");
      }
      slus_string = slug;
      if (listtt.contains("$slus_string")) {
        SlugUrlController.text = "$slus_string${listtt.length}";
      } else {
        SlugUrlController.text = slus_string;
      }
    });
  }
/////

///// Initiate Calll +++++++++++++++

  @override
  void initState() {
    _fnGetAttr();
    Pro_Data();
    super.initState();
  }
/////

  ///////   LOcal widget change variable
  bool updateWidget = false;
  bool edit = false;
  var update_id;
  var basic_Product = true;
  /////

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
          return Scaffold(
              body: Container(
            child: ListView(
              children: [
                Header(
                  title: "Product",
                ),
                (Add_product != true)
                    ? listList(context, "Add / Edit")
                    //  : Update_product(context, update_id, "Edit")
                    : listCon(context, "Add New Product")
              ],
            ),
          ));
        });
  }

  ///////////   Widget for Product Add Form  ++++++++++++++++++++++++++++++++++++++++++
  ///
  List<String> _selectOption_attri = [];
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
                      Add_product = false;
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
                        'Product',
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
                                  Text("Name*",
                                      style: themeTextStyle(
                                          color: Colors.black,
                                          size: 15,
                                          fw: FontWeight.bold)),
                                  Text_field(context, NameController, "Name",
                                      "Enter Name"),
                                ],
                              )),
                            ],
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
                                    child: Text("Category",
                                        style: themeTextStyle(
                                            color: Colors.black,
                                            size: 15,
                                            fw: FontWeight.bold))),
                                Container(
                                  height: 40,
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: DropdownButton(
                                    dropdownColor: Colors.white,
                                    value: _PerentCate,
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
                                          in Cate_Name_list.entries)
                                        DropdownMenuItem(
                                          value: e.value,
                                          child: Text(e.key),
                                        ),
                                    ],
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: defaultPadding),

                  ///////////// status ++++++++++++++++++++++++++++++++
                  SizedBox(height: defaultPadding),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
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
                                  top: 10,
                                  bottom: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  value: _StatusValue,
                                  underline: Container(),
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  iconSize: 35,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 3, 5, 6)),
                                  items: [
                                    for (MapEntry<int, String> e
                                        in v_status.entries)
                                      DropdownMenuItem(
                                        value: e.key,
                                        child: Text(e.value),
                                      ),
                                  ],
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
                                    "Slug Url", "Enter Slug Url")
                              ],
                            ))),
                    ],
                  ),

                  ///

                  ////////  Slug +++++++++++++++ web & Mobile +++++++++++++++++++++++++++++++++++++++

                  if (Responsive.isMobile(context))
                    SizedBox(height: defaultPadding),
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
                        Text_field(context, SlugUrlController, "Slug Url",
                            "Enter Slug Url")
                      ],
                    )),
                  ////////
                  Divider(
                    thickness: 1.5,
                    color: Colors.black12,
                  ),

                  ///  Address Details Of Prod
                  Column(
                    children: [
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          Icon(
                            Icons.edit_location_alt,
                            size: 30,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Address Of Product",
                              style: GoogleFonts.alike(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ],
                      ),
                      // dropdown
                      SizedBox(height: 10.0),
                      wd_add_product(
                        context,
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),

                  ///
                  Divider(
                    thickness: 1.5,
                    color: Colors.black12,
                  ),
                  //////////  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                  Column(
                    children: [
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Icon(
                            Icons.production_quantity_limits_sharp,
                            size: 30,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Type Of Product",
                              style: GoogleFonts.alike(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ],
                      ),
                      Row(children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              basic_Product = true;
                              _controllers = new Map();
                            });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 20),
                              height: 40,
                              decoration: BoxDecoration(
                                  color: (basic_Product == true)
                                      ? Colors.green
                                      : Colors.grey,
                                  border: Border.all(color: Colors.black38),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text("Basic Product")),
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                basic_Product = false;
                                _controllers = new Map();
                              });
                            },
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 20),
                                height: 40,
                                decoration: BoxDecoration(
                                    color: (basic_Product == false)
                                        ? Colors.green
                                        : Colors.grey,
                                    border: Border.all(color: Colors.black38),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text("Fetured Product"))),
                      ]),
                    ],
                  ),

                  /////////  Basic Product Rate Deatils +++++++++++++++++++++++

                  (basic_Product == true)
                      ? wd_sub_product_details(context, 'Product Details')

                      // wd_sub_Basic_product_details(
                      //     context,
                      //   )
                      :
                      /////////  Featured Product Rate Deatils +++++++++++++++++++++++

                      Column(children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.5),
                            ),
                            child: Row(
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
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        for (var index = 0;
                                            index < myAttr.length;
                                            index++)
                                          Container(
                                              height: 25,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    activeColor: Colors.green,
                                                    side: BorderSide(
                                                        width: 2,
                                                        color: Colors.black),
                                                    value: (selectedCheck[Attri_data[
                                                                        index][
                                                                    "attribute_name"]
                                                                .toLowerCase()] ==
                                                            null)
                                                        ? false
                                                        : selectedCheck[Attri_data[
                                                                    index][
                                                                "attribute_name"]
                                                            .toLowerCase()],
                                                    onChanged: (Value) {
                                                      _fnChangeCheckVal(
                                                          Attri_data[index][
                                                              "attribute_name"],
                                                          Value,
                                                          'main');
                                                    },
                                                  ),
                                                  Text(
                                                    "${Attri_data[index]["attribute_name"]}",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                ],
                                              )),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // sub attribute ---------------------------------
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 113, 174, 234),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (var i = 0; i < myAttr.length; i++)
                                  wd_subAttr_Row(context, myAttr[i], i),
                              ],
                            ),
                          ),

                          //// sub product list =======================================================
                          for (var title in subProductBox)
                            wd_sub_product_details(context, title)

                          // sub attribute ---------------------------------
                        ]),

                  SizedBox(
                    height: 20,
                  ),

                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    themeButton3(context, () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          addList();
                        });
                      }
                    },
                        buttonColor: Colors.green,
                        label: (edit) ? "Update" : "Submit"),
                    SizedBox(
                      width: 10,
                    ),
                    (edit)
                        ? SizedBox()
                        : themeButton3(context, () {
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

////////             List        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Widget wd_subAttr_Row(context, data, i) {
    var innerArr = data['value'];
    if (selectedCheck[data['attribute_name'].toLowerCase()] == true) {
      return Container(
        width: 150.0,
        padding: EdgeInsets.only(left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${data['attribute_name']}'),
            for (String key in innerArr.keys)
              wd_subAttr_Column(context, key, data['attribute_name'])
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget wd_subAttr_Column(context, data, type) {
    return Container(
      child: Row(
        children: [
          Checkbox(
            activeColor: Colors.green,
            side: BorderSide(width: 2, color: Colors.black),
            value: (selectedCheck[data.toLowerCase()] == null)
                ? false
                : selectedCheck[data.toLowerCase()],
            onChanged: (Value) {
              _fnChangeCheckVal(data, Value, type);
            },
          ),
          // end check box
          Text('${data}'),
        ],
      ),
    );
  }

////////////////  Product List  +++++++++++++++++++++++++++++++++++++++++++++++++++
  bool Add_product = false;
  var _number_select = 10;

  Widget listList(BuildContext context, sub_text) {
    return (productList.isEmpty)
        ? Container(
            height: MediaQuery.of(context).size.height - 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                themeButton3(context, () {
                  setState(() {
                    Add_product = true;
                  });
                },
                    label: 'Add New Product',
                    buttonColor: themeBG3,
                    radius: 8.0,
                    btnHeightSize: 50.0)
              ],
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius:
              //     const BorderRadius.all(Radius.circular(10)),
            ),
            child: ListView(
              children: [
                HeadLine(context, Icons.production_quantity_limits, "Product",
                    "$sub_text", () {
                  setState(() {
                    Add_product = true;
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
                                    "Product List",
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
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        padding: EdgeInsets.all(2),
                                        height: 20,
                                        color: Colors.white,
                                        child: DropdownButton<int>(
                                          dropdownColor: Colors.white,
                                          iconEnabledColor: Colors.black,
                                          hint: Text(
                                            "$_number_select",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
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
                              Container(
                                  height: 40, width: 300, child: SearchField())
                            ],
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        border: TableBorder(
                          horizontalInside:
                              BorderSide(width: .5, color: Colors.grey),
                        ),
                        children: [
                          (Responsive.isMobile(context))
                              ? TableRow(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                  children: [
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Product Details",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ),
                                    ])
                              : TableRow(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
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
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            width: 40,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Product Name',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Text('Category Name',
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
                                        child: Text("In Stock",
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
                          //tableRows(context),

                          for (var index = 0;
                              index < productList.length;
                              index++)
                            (Responsive.isMobile(context))
                                ? tableRowWidget_mobile(
                                    productList[index]['img'],
                                    productList[index]['name'],
                                    productList[index]['category'],
                                    productList[index]['status'],
                                    productList[index]['date_at'],
                                    productList[index]['id'])
                                : tableRowWidget(
                                    index + 1,
                                    productList[index]['img'],
                                    productList[index]['name'],
                                    productList[index]['category'],
                                    productList[index]['no_item'],
                                    (productList[index]['status'] == "1")
                                        ? "Active"
                                        : (productList[index]['status'] == "2")
                                            ? "Inactive"
                                            : "",
                                    productList[index]['date_at'],
                                    productList[index]['id'])
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  TableRow tableRowWidget(sno, Iimage, name, pName, items, status, date, iid) {
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
            padding: EdgeInsets.all(5.0),
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
            style: GoogleFonts.alike(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: (status == "Active")
                    ? Colors.green
                    : (status == "Inactive")
                        ? Colors.red
                        : Colors.white)),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text("$items",
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
                                size: 15,
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

// /////////////  Update widget for product Update+++++++++++++++++++++++++
//   Widget Update_product(BuildContext context, id, sub_text) {
//     return Container(
//         height: MediaQuery.of(context).size.height,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           // borderRadius:
//           //     const BorderRadius.all(Radius.circular(10)),
//         ),
//         child: ListView(children: [
//           Container(
//             height: 100,
//             width: double.infinity,
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       updateWidget = false;
//                       update_data = {};
//                       Pro_Data();
//                     });
//                   },
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Icon(Icons.arrow_back, color: Colors.blue, size: 25),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Text(
//                         'Product',
//                         style: themeTextStyle(
//                             size: 18.0,
//                             ftFamily: 'ms',
//                             fw: FontWeight.bold,
//                             color: Colors.blue),
//                       ),
//                       SizedBox(
//                         width: 5,
//                       ),
//                       Text(
//                         '$sub_text',
//                         style: themeTextStyle(
//                             size: 12.0,
//                             ftFamily: 'ms',
//                             fw: FontWeight.normal,
//                             color: Colors.black45),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//               margin: EdgeInsets.symmetric(horizontal: 10.0),
//               padding: EdgeInsets.all(defaultPadding),
//               decoration: BoxDecoration(
//                 color: Colors.black12,
//                 borderRadius: const BorderRadius.all(Radius.circular(10)),
//               ),
//               child: (update_data == null)
//                   ? Center(child: CircularProgressIndicator())
//                   : Column(
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: Column(
//                                 children: [
//                                   Container(
//                                       child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text("Name*",
//                                           style: themeTextStyle(
//                                               color: Colors.black,
//                                               size: 15,
//                                               fw: FontWeight.bold)),
//                                       Container(
//                                           height: 40,
//                                           margin: EdgeInsets.only(
//                                             top: 10,
//                                             bottom: 10,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                           child: TextFormField(
//                                             initialValue: Name,
//                                             autofocus: false,
//                                             onChanged: (value) {
//                                               Name = value;
//                                               Slug_gen("$value");
//                                               print(
//                                                   "${SlugUrlController.text} +++====");
//                                             },
//                                             //  onChanged: (value) => Name = value,
//                                             // controller: ctr_name,
//                                             validator: (value) {
//                                               if (value == null ||
//                                                   value.isEmpty) {
//                                                 return 'Please Enter Name';
//                                               }
//                                               return null;
//                                             },
//                                             style:
//                                                 TextStyle(color: Colors.black),
//                                             decoration: InputDecoration(
//                                               border: InputBorder.none,
//                                               contentPadding:
//                                                   EdgeInsets.symmetric(
//                                                       horizontal: 20,
//                                                       vertical: 15),
//                                               hintText: 'Enter Name',
//                                               hintStyle: TextStyle(
//                                                 color: Colors.grey,
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                           ))
//                                     ],
//                                   )),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         ///////////////// Category for Mobile ++++++++++++++++++++++++++++++++++++

//                         SizedBox(height: defaultPadding),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             if (!Responsive.isMobile(context))
//                               SizedBox(width: defaultPadding),
//                             if (!Responsive.isMobile(context))
//                               Expanded(
//                                   flex: 2,
//                                   child: Container(
//                                       child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text("Slug Url",
//                                           style: themeTextStyle(
//                                               color: Colors.black,
//                                               size: 15,
//                                               fw: FontWeight.bold)),
//                                       Container(
//                                           height: 40,
//                                           margin: EdgeInsets.only(
//                                             top: 10,
//                                             bottom: 10,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                           child: TextFormField(
//                                             //initialValue: SlugUrlController.text,
//                                             autofocus: false,
//                                             //  onChanged: (value) => Name = value,
//                                             onChanged: (value) =>
//                                                 SlugUrlController.text =
//                                                     value.toString(),
//                                             controller: SlugUrlController,
//                                             validator: (value) {
//                                               if (value == null ||
//                                                   value.isEmpty) {
//                                                 return 'Please Enter Slug Url';
//                                               }
//                                               return null;
//                                             },
//                                             style:
//                                                 TextStyle(color: Colors.black),
//                                             decoration: InputDecoration(
//                                               border: InputBorder.none,
//                                               contentPadding:
//                                                   EdgeInsets.symmetric(
//                                                       horizontal: 20,
//                                                       vertical: 15),
//                                               hintText: 'Enter Slug Url',
//                                               hintStyle: TextStyle(
//                                                 color: Colors.grey,
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                           ))
//                                     ],
//                                   ))),
//                           ],
//                         ),

//                         ///

//                         ////////  Slug +++++++++++++++ web & Mobile +++++++++++++++++++++++++++++++++++++++

//                         if (Responsive.isMobile(context))
//                           SizedBox(height: defaultPadding),
//                         if (Responsive.isMobile(context))
//                           Container(
//                               child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Slug Url",
//                                   style: themeTextStyle(
//                                       color: Colors.black,
//                                       size: 15,
//                                       fw: FontWeight.bold)),
//                               Container(
//                                   height: 40,
//                                   margin: EdgeInsets.only(
//                                     top: 10,
//                                     bottom: 10,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: TextFormField(
//                                     // initialValue: SlugUrlController.text,
//                                     autofocus: false,
//                                     onChanged: (value) =>
//                                         SlugUrlController.text = value,
//                                     controller: SlugUrlController,
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please Enter Slug Url';
//                                       }
//                                       return null;
//                                     },
//                                     style: TextStyle(color: Colors.black),
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       contentPadding: EdgeInsets.symmetric(
//                                           horizontal: 20, vertical: 15),
//                                       hintText: 'Enter Slug Url',
//                                       hintStyle: TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                   ))
//                             ],
//                           )),

//                         //////////  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//                         Row(children: [
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 basic_Product = true;
//                               });
//                             },
//                             child: Container(
//                                 alignment: Alignment.center,
//                                 padding: EdgeInsets.symmetric(horizontal: 5),
//                                 margin: EdgeInsets.symmetric(
//                                     horizontal: 5, vertical: 20),
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                     color: (basic_Product == true)
//                                         ? Colors.green
//                                         : Colors.grey,
//                                     border: Border.all(color: Colors.black38),
//                                     borderRadius: BorderRadius.circular(10)),
//                                 child: Text("Basic Product")),
//                           ),
//                           GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   basic_Product = false;
//                                 });
//                               },
//                               child: Container(
//                                   alignment: Alignment.center,
//                                   padding: EdgeInsets.symmetric(horizontal: 5),
//                                   margin: EdgeInsets.symmetric(
//                                       horizontal: 5, vertical: 20),
//                                   height: 40,
//                                   decoration: BoxDecoration(
//                                       color: (basic_Product == false)
//                                           ? Colors.green
//                                           : Colors.grey,
//                                       border: Border.all(color: Colors.black38),
//                                       borderRadius: BorderRadius.circular(10)),
//                                   child: Text("Fetured Product")))
//                         ]),

//                         /////////  Basic Product Rate Deatils +++++++++++++++++++++++

//                         SizedBox(
//                           height: 10,
//                         ),

//                         SizedBox(
//                           height: 20,
//                         ),

//                         Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               themeButton3(context, () {
//                                 updatelist(
//                                     id, Name, slugUrl, _StatusValue, _PerentC
//                                     // (url_img == null || url_img.isEmpty)
//                                     //     ? image
//                                     //     : url_img
//                                     );
//                               },
//                                   buttonColor: Colors.blueAccent,
//                                   label: "Update"),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                             ])
//                       ],
//                     )),
//         ]));
//   }

///////////////////////////

// /////////// Discount  ++++++++
//   Mp_Discount_cal(mrp, sell) {
//     var mrpp = int.parse(mrp);
//     var sellpp = int.parse(sell);
//     setState(() {
//       var DiscountPP = (((mrpp - sellpp) / mrpp * 100));
//       DiscountController.text = DiscountPP.toStringAsFixed(2);
//       (basic_Product == true)
//           ? _controllers2["discount"] = DiscountController
//           : _controllers["discount"] = DiscountController;
//     });
//   }

///////////// this is for  Featured Product   +++++++++++++++++++++++++++++++++++++++
///////////// this is for  Featured Product   +++++++++++++++++++++++++++++++++++++++
///////////// this is for  Featured Product   +++++++++++++++++++++++++++++++++++++++
  Widget wd_sub_product_details(BuildContext context, title) {
    var itemNo = title;
    var tempType = (basic_Product) ? 'basic' : itemNo;
    var tempData = (_itemCtr[tempType] != null) ? _itemCtr[tempType] : {};
    var selectedImgs = (tempData['img'] != null) ? tempData['img'] : {};

    var imgList = [];
    selectedImgs.forEach((k, v) {
      imgList.add(k);
    });

    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 219, 219, 219),
          border: Border.all(width: 1.0, color: Colors.blue),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 6.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.blue),
            child: Text("$title"),
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("MRP (₹)",
                        style: themeTextStyle(
                            color: Colors.black,
                            size: 15,
                            fw: FontWeight.bold)),
                    //Text_field_rate(context, "1", "mrp_price", "MRP"),
                    wd_input_field(context, 'Enter MRP Price', 'mrp', itemNo),
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
                    Text("Selling Price (₹)",
                        style: themeTextStyle(
                            color: Colors.black,
                            size: 15,
                            fw: FontWeight.bold)),
                    //Text_rate(context, SellingPriController, "Selling Price")
                    // Text_field_rate(
                    //     context, "1", "selling_price", "Selling Price"),
                    wd_input_field(context, 'Sell Price', 'sell_price', itemNo),
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
                    wd_input_field(context, 'Dicount', 'discount', itemNo),
                    /*Container(
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        height: 40,
                        margin: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text("${DiscountController.text} %",
                            style: themeTextStyle(
                                color: Colors.black,
                                size: 15,
                                fw: FontWeight.bold)))*/
                  ],
                )),
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
                      Text("Shiping Price(₹)",
                          style: themeTextStyle(
                              color: Colors.black,
                              size: 15,
                              fw: FontWeight.bold)),
                      // Text_rate(context, ShippingController, "MRP")
                      // Text_field_rate(
                      //     context, "1", "shiping_price", "Shiping Price"),
                      wd_input_field(
                          context, 'Sell Price', 'shipping_price', itemNo),
                    ],
                  )),
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
                      Text("Stock (No. item)",
                          style: themeTextStyle(
                              color: Colors.black,
                              size: 15,
                              fw: FontWeight.bold)),
                      // Text_rate(context, NoitemController, "Selling Price")
                      // Text_field_rate(
                      //     context, "1", "stock_item", "Stock (No. item)"),
                      wd_input_field(
                          context, 'Stock (No. item)', 'no_item', itemNo),
                    ],
                  )),
                ),
            ],
          ),
          if (Responsive.isMobile(context)) SizedBox(height: defaultPadding),
          if (Responsive.isMobile(context))
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Shiping Price(₹)",
                          style: themeTextStyle(
                              color: Colors.black,
                              size: 15,
                              fw: FontWeight.bold)),
                      // Text_field_rate(
                      //     context, "1", "shiping_price", "Shiping Price"),
                      wd_input_field(
                          context, 'Shiping Price', 'shiping_price', itemNo),
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
                      Text("Stock (No. item)",
                          style: themeTextStyle(
                              color: Colors.black,
                              size: 15,
                              fw: FontWeight.bold)),
                      // Text_rate(context, NoitemController, "Selling Price")
                      // Text_field_rate(
                      //     context, "1", "stock_item", "Stock (No. item)"),
                      wd_input_field(
                          context, 'Stock (No. item)', 'no_item', itemNo),
                    ],
                  )),
                ),
              ],
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: 50,
                child: IconButton(
                    onPressed: () async {
                      itemNo = (basic_Product) ? "basic" : itemNo;
                      var Swidth = MediaQuery.of(context).size.width;
                      var tempData =
                          (_itemCtr[itemNo] != null) ? _itemCtr[itemNo] : {};
                      var selectedImgs =
                          (tempData['img'] != null) ? tempData['img'] : {};
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              content: StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.width - 600,
                                  width:
                                      MediaQuery.of(context).size.width - 400,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 6.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Media",
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.black),
                                          ),
                                          Row(
                                            children: [
                                              themeButton3(context, () {
                                                setState(() {
                                                  pickFile();
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                                  label: "Add New",
                                                  buttonColor: Colors.blue),
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
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                      color: Colors.black12,
                                    ),

                                    // media ===================================
                                    Container(
                                      height: (Swidth.toInt() > 1400)
                                          ? MediaQuery.of(context).size.height -
                                              200
                                          : 500,
                                      child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              (Swidth.toInt() > 1400) ? 8 : 4,
                                        ),
                                        itemCount: myList.length,
                                        itemBuilder: (_, index) => Container(
                                            margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    '${myList[index]}'),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            alignment: Alignment.topLeft,
                                            child: CheckboxListTile(
                                              checkColor: Colors.white,
                                              activeColor: Colors.green,
                                              side: BorderSide(
                                                  width: 2, color: Colors.red),
                                              value: (selectedImgs[
                                                          myList[index]] ==
                                                      null)
                                                  ? false
                                                  : true,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value == true) {
                                                    selectedImgs[
                                                        myList[index]] = true;
                                                  } else {
                                                    selectedImgs
                                                        .remove(myList[index]);
                                                  }
                                                  tempData['img'] =
                                                      selectedImgs;
                                                  _itemCtr[itemNo] = tempData;
                                                });
                                              },
                                            )),
                                      ),
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        themeButton3(context, () {
                                          Navigator.of(context).pop();
                                        },
                                            label: 'Update',
                                            buttonColor: themeBG3,
                                            radius: 6.0),
                                      ],
                                    )
                                    // End media ===================================
                                  ]),
                                );
                              }),
                            );
                          });

                      //this setState will refresh the main screen
                      //this setState will execute after dismissing Dailog
                      setState(() {});
                    },
                    icon: Icon(Icons.drive_folder_upload,
                        size: 50, color: Colors.blue)),
              ),
              SizedBox(
                width: 20,
              ),
              (selectedImgs.isEmpty)
                  ? SizedBox()
                  : Row(
                      children: [
                        for (var imgUrl in imgList)
                          wd_selectedImgCon(context, imgUrl, itemNo)
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }
  //////////////

  //////////////  show selected images =========================================
  Widget wd_selectedImgCon(BuildContext context, imgUrl, itemNo) {
    return Container(
        alignment: Alignment.topRight,
        margin: EdgeInsets.all(10),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey),
            image: DecorationImage(image: NetworkImage("$imgUrl"))),
        child: GestureDetector(
            onTap: () {
              setState(() {
                var tempData =
                    (_itemCtr[itemNo] != null) ? _itemCtr[itemNo] : {};
                var selectedImgs =
                    (tempData['img'] != null) ? tempData['img'] : {};
                selectedImgs.remove(imgUrl);
                tempData['img'] = selectedImgs;
                _itemCtr[itemNo] = tempData;
              });
            },
            child: Icon(Icons.cancel_outlined, color: Colors.red, size: 15)));
  }

// ///////////  Map text field   ++++++++++++++++++++++++++++
//   Widget Text_field_rate(
//       BuildContext context, ctr_type, controller_name, hint) {
//     if (ctr_type == '1') {
//       var tempStr = (_controllers["$controller_name"]?.text == null)
//           ? ''
//           : _controllers["$controller_name"]?.text;
//       _controllers["$controller_name"] = TextEditingController();
//       _controllers["$controller_name"]?.text = tempStr.toString();
//     } else {
//       var tempStr = (_controllers2["$controller_name"]?.text == null)
//           ? ''
//           : _controllers2["$controller_name"]?.text;
//       _controllers2["$controller_name"] = TextEditingController();
//       _controllers2["$controller_name"]?.text = tempStr.toString();
//     }
//     return Container(
//       height: 40,
//       margin: EdgeInsets.only(
//         top: 10,
//         bottom: 10,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: TextFormField(
//         obscureText: false,
//         controller: (ctr_type == '1')
//             ? _controllers["$controller_name"]
//             : _controllers2["$controller_name"],
//         onChanged: (value) async {
//           if (ctr_type == '1') {
//             if (_controllers["mrp_price"]!.text.isNotEmpty &&
//                 _controllers["$controller_name"]!.text ==
//                     _controllers["selling_price"]!.text) {
//               Mp_Discount_cal(_controllers["mrp_price"]!.text,
//                   _controllers["selling_price"]!.text);
//             }
//           }
//           if (ctr_type == '2') {
//             if (_controllers2["mrp_price"]!.text.isNotEmpty &&
//                 _controllers2["$controller_name"]!.text ==
//                     _controllers2["selling_price"]!.text) {
//               Mp_Discount_cal(_controllers2["mrp_price"]!.text,
//                   _controllers2["selling_price"]!.text);
//             }
//           }
//         },
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please Enter value';
//           }
//         },
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//           hintText: '$hint',
//           hintStyle: TextStyle(
//             color: Colors.grey,
//             fontSize: 16,
//           ),
//           suffixIcon: Container(
//             height: 10,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     if (ctr_type == '1') {
//                       var mrpIncre =
//                           int.parse(_controllers["$controller_name"]!.text);
//                       setState(() {
//                         mrpIncre++;
//                         _controllers["$controller_name"]!.text =
//                             mrpIncre.toString();
//                       });
//                     }
//                     if (ctr_type == '2') {
//                       var mrpIncre =
//                           int.parse(_controllers2["$controller_name"]!.text);
//                       setState(() {
//                         mrpIncre++;
//                         _controllers2["$controller_name"]!.text =
//                             mrpIncre.toString();
//                       });
//                     }
//                   },
//                   child: Icon(Icons.expand_less_rounded,
//                       size: 20, color: Colors.black),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     if (ctr_type == '1') {
//                       var mrpIncre =
//                           int.parse(_controllers["$controller_name"]!.text);
//                       setState(() {
//                         mrpIncre--;
//                         _controllers["$controller_name"]!.text =
//                             mrpIncre.toString();
//                       });
//                     }
//                     if (ctr_type == '2') {
//                       var mrpIncre =
//                           int.parse(_controllers2["$controller_name"]!.text);
//                       setState(() {
//                         mrpIncre--;
//                         _controllers2["$controller_name"]!.text =
//                             mrpIncre.toString();
//                       });
//                     }
//                   },
//                   child: Icon(Icons.expand_more_outlined,
//                       size: 20, color: Colors.black),
//                 )
//               ],
//             ),
//           ),
//         ),
//         style: TextStyle(color: Colors.black),
//         keyboardType: TextInputType.number,
//         inputFormatters: <TextInputFormatter>[
//           FilteringTextInputFormatter.digitsOnly
//         ], // Onl
//       ),
//     );
//   }
// ////////////==============================================

// //////////// update text widget ++++++++++++++++
//   Widget Text_field_up(BuildContext context, ini_value, lebel, hint) {
//     return Container(
//         height: 40,
//         margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: TextFormField(
//           obscureText: false,
//           controller: ini_value,
//           onChanged: (value) async {
//             if (mrp.isNotEmpty && ini_value == sell) {
//               Mp_Discount_cal(mrp, sell);
//             }
//           },
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please Enter value';
//             }
//           },
//           decoration: InputDecoration(
//             border: InputBorder.none,
//             contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             hintText: '$hint',
//             hintStyle: TextStyle(
//               color: Colors.grey,
//               fontSize: 16,
//             ),
//             suffixIcon: Container(
//               height: 10,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       var mrpIncre = int.parse(ini_value!.text);
//                       setState(() {
//                         mrpIncre++;
//                         ini_value = mrpIncre.toString();
//                       });
//                     },
//                     child: Icon(Icons.expand_less_rounded,
//                         size: 20, color: Colors.black),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       var mrpIncre = int.parse(ini_value!.text);
//                       setState(() {
//                         mrpIncre--;
//                         ini_value = mrpIncre.toString();
//                       });
//                     },
//                     child: Icon(Icons.expand_more_outlined,
//                         size: 20, color: Colors.black),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           style: TextStyle(color: Colors.black),
//           keyboardType: TextInputType.number,
//           inputFormatters: <TextInputFormatter>[
//             FilteringTextInputFormatter.digitsOnly
//           ], // Onl
//         ));
//   }
// //////

////////  Data bases Image call  +++++++++++++++++++++++++++++++
  List<String> _selectedOptions = [];
  Widget All_media(BuildContext context, itemNo) {
    var Swidth = MediaQuery.of(context).size.width;
    var tempData = (_itemCtr[itemNo] != null) ? _itemCtr[itemNo] : {};
    var selectedImgs = (tempData['img'] != null) ? tempData['img'] : {};

    return Container(
      height: (Swidth.toInt() > 1400) ? 650 : 500,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (Swidth.toInt() > 1400) ? 8 : 4,
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
              value: (selectedImgs[myList[index]] == null) ? false : true,
              onChanged: (value) {
                setState(() {
                  _fnSelectImg(itemNo, myList[index], value);
                });
              },
            )),
      ),
    );
  }
//////////

////////  Data bases Image call   MOBILE +++++++++++++++++++++++++++++++

///////////// New Add text widget +++++++++++++++++++++
  Widget Text_field(BuildContext context, ctr_name, lebel, hint) {
    return Container(
        height: 40,
        margin: EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: ctr_name,
          onChanged: (ctr_name == NameController)
              ? (value) {
                  Slug_gen("$value");
                }
              : (value) {}, // => slus_string = value,
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

  // input fields
  Widget wd_input_field(BuildContext context, label, ctrName, conName) {
    conName = (basic_Product) ? "basic" : conName;
    var key =
        (basic_Product) ? "basic___${ctrName}" : "${conName}___${ctrName}";

    var tempStr =
        (_controllers[key]?.text != null) ? _controllers[key]?.text : '';

    _controllers[key] = TextEditingController();
    _controllers[key]?.text = tempStr.toString();

    // for cursor show in input field at last
    int stringLength = (tempStr == null) ? 0 : tempStr.length;
    _controllers[key]?.selection =
        TextSelection.collapsed(offset: stringLength);

    return Container(
      height: 40,
      margin: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        obscureText: false,
        controller: _controllers[key],
        readOnly: (ctrName == 'discount') ? true : false,
        onChanged: (value) async {
          if (ctrName == 'sell_price' || ctrName == 'mrp') {
            var tempMrp = _controllers['${conName}___mrp']?.text;
            var tempSellPrice = _controllers['${conName}___sell_price']?.text;

            if (tempSellPrice != '' && tempMrp != '') {
              var discount = (((int.parse(tempMrp.toString()) -
                              int.parse(tempSellPrice.toString())) *
                          100) /
                      int.parse(tempMrp.toString()))
                  .round();

              setState(() {
                _controllers['${conName}___discount'] = TextEditingController();
                _controllers['${conName}___discount']?.text =
                    (discount == null) ? '' : discount.toString();
              });
            } else {
              setState(() {
                _controllers['${conName}___discount'] = TextEditingController();
                _controllers['${conName}___discount']?.text = '';
              });
            }
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
          hintText: '$label',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          // suffixIcon: Container(
          //   height: 10,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       GestureDetector(
          //         onTap: () {},
          //         child: Icon(Icons.expand_less_rounded,
          //             size: 20, color: Colors.black),
          //       ),
          //       GestureDetector(
          //         onTap: () {},
          //         child: Icon(Icons.expand_more_outlined,
          //             size: 20, color: Colors.black),
          //       )
          //     ],
          //   ),
          // ),
        ),
        style: TextStyle(color: Colors.black),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ], // Onl
      ),
    );
  }

//  @3b Add   Address Of Product Cib ======================================================
  int Order_details = 1;
  Widget wd_add_product(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black45)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // wd_added_product_list(context),
          // SizedBox(height: 10.0),
          for (var i = 0; i < Order_details; i++)
            wd_Address_details(context, "Address No._${i + 1}"),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.amber // Background color
                          ),
                      onPressed: () {
                        setState(() {
                          Order_details++;
                        });
                      },
                      child: Text(
                        "+",
                        style: GoogleFonts.alike(fontSize: 30),
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                (Order_details != 1)
                    ? Container(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red, // Background color
                            ),
                            onPressed: () {
                              setState(() {
                                Order_details--;
                              });
                            },
                            child: Text("-",
                                style: GoogleFonts.alike(fontSize: 30))),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }

///////////// this is for  Featured Product   +++++++++++++++++++++++++++++++++++++++
  bool show_drop_list = false;
  Map<dynamic, dynamic> _itemdCtr = {};
  Widget wd_Address_details(BuildContext context, title) {
    var itemNo = title;
    // print("$itemNo   +++++++++++++++++++++++++++");
    var tempType = itemNo;
    var tempData = (_itemdCtr[tempType] != null) ? _itemdCtr[tempType] : {};
    print("$tempData   +++++++++++++++++++++++++++");
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 3.0),
        decoration: BoxDecoration(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: themeBG2),
            child: Text(
              "$title",
              style: GoogleFonts.alike(
                  fontWeight: FontWeight.normal, fontSize: 11),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            color: Color.fromARGB(228, 182, 222, 248),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Number Of Item",
                              style: GoogleFonts.alike(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          wd_Address_field(context, 'Enter Number Of Item',
                              'number_of_item', itemNo),
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
                          Text("Name Of Storage",
                              style: GoogleFonts.alike(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          wd_Address_field(context, 'Enter Name Of Storage',
                              'name_of_storage', itemNo),
                        ],
                      )),
                    ),
                  ],
                ),
              ],
            ),
          )
        ]));
  }

// input fields
  Widget wd_Address_field(BuildContext context, label, ctrName, conName) {
    // conName = conName;
    var key = "${conName}___${ctrName}";

    var tempStr = (_controllers_Address[key]?.text != null)
        ? _controllers_Address[key]?.text
        : '';

    _controllers_Address[key] = TextEditingController();
    _controllers_Address[key]?.text = tempStr.toString();

    // for cursor show in input field at last
    int stringLength = (tempStr == null) ? 0 : tempStr.length;
    _controllers_Address[key]?.selection =
        TextSelection.collapsed(offset: stringLength);

    return Container(
      height: 40,
      margin: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
          obscureText: false,
          controller: _controllers_Address[key],
          // onChanged: (value) async {
          //   // print("${_controllers_Address}   ++++++++++++++++++");
          // },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Enter value';
            }
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            hintText: '$label',
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            // suffixIcon: (ctrName == "number_of_item")
            //     ? Container(
            //         height: 10,
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.spaceAround,
            //           children: [
            //             GestureDetector(
            //               onTap: () {
            //                 setState(() {});
            //               },
            //               child: Icon(Icons.expand_less_rounded,
            //                   size: 20, color: Colors.black),
            //             ),
            //             GestureDetector(
            //               onTap: () {},
            //               child: Icon(Icons.expand_more_outlined,
            //                   size: 20, color: Colors.black),
            //             )
            //           ],
            //         ),
            //       )
            //     : SizedBox()
          ),
          style: TextStyle(color: Colors.black),
          keyboardType: (ctrName == "number_of_item")
              ? TextInputType.number
              : TextInputType.name,
          inputFormatters: (ctrName == "number_of_item")
              ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
              : <TextInputFormatter>[
                  FilteringTextInputFormatter.singleLineFormatter
                ]
          // Onl
          ),
    );
  }

  ////////////// Search drop down
}

/// Class CLose
