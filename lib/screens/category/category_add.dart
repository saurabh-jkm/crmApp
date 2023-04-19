// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, avoid_print, non_constant_identifier_names, prefer_typing_uninitialized_variables, unnecessary_string_interpolations, no_leading_underscores_for_local_identifiers, deprecated_member_use, unnecessary_brace_in_string_interps, sized_box_for_whitespace, unnecessary_new, unused_shown_name, prefer_final_fields, depend_on_referenced_packages, unused_local_variable, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slugify/slugify.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/firebase_functions.dart';
import '../../themes/function.dart';
import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';
import '../dashboard/components/header.dart';
import '../dashboard/components/my_fields.dart';
import '../dashboard/components/recent_files.dart';
import '../dashboard/components/storage_details.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:intl/intl.dart';

import '../product/update_pro.dart';
import 'update_cate.dart';

class CategoryAdd extends StatefulWidget {
  const CategoryAdd({super.key});
  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final _formKey = GlobalKey<FormState>();
  var cate_name = "";
  var slug__url = slugify('', delimiter: '_', lowercase: false);
  var image_logo = "";
  String _dropDownValue = "Select";
  String _StatusValue = "Select";
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
  }
//////

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
                  onPressed: () =>  deleteUser(iid_delete),
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




 ///// File Picker ==========================================================

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
               imagePri = base64.decode(uploadedDoc);
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
      // final ImagePicker _picker = ImagePicker();
      // XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      // if (image != null) {
      //   var f = await image.readAsBytes();
      //   setState(() {
      //     var webImage = f;
      //     uploadedDoc = base64.encode(webImage);
      //     imagePri = base64.decode(uploadedDoc);
      //   });
      // }

   final results = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['png','jpg'],
               );
          if(results != null){
             Uint8List? UploadImage =  results.files.single.bytes;
             String fileName = results.files.single.name;
            setState(() {
            uploadedDoc = base64.encode(UploadImage!);
            imagePri = base64.decode(uploadedDoc);
            themeAlert(context, "Upload Successfully ");
          });
          }
          else{
                themeAlert(context, 'Not find selected', type: "error");
            return null;

          }    


    }
  }



 /////////

///////////  firebase property Database access  +++++++++++++++++++++++++++
///
    final Stream<QuerySnapshot> _crmStream =
      FirebaseFirestore.instance.collection('category').snapshots();
      CollectionReference _category = FirebaseFirestore.instance.collection('category');
////////

/////////////  Category data fetch From Firebase   +++++++++++++++++++++++++++++++++++++++++++++

   final List StoreDocs = [];
   _CateData() async {

           var collection = FirebaseFirestore.instance.collection('category');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      // ignore: unnecessary_cast
      Map data = queryDocumentSnapshot.data() as Map<String, dynamic>;
      StoreDocs.add(data);
      data["id"] = queryDocumentSnapshot.id;

    }
    // setState(() {
    //   print("$StoreDocs++++++");
    // });
  }

/////////////

/////// add Category Data  =+++++++++++++++++++
 
 Future<void> addList() {
    return _category
        .add({
          'category_name': "$cate_name",
          'slug_url': "$slug__url",
          'parent_cate': "$_dropDownValue",
          'status': "$_StatusValue",
          'image': "$uploadedDoc",
          "date_at": "$Date_at"
        })
        .then((value) => themeAlert(context, "Successfully Submit"))
        .catchError(
        (error) => themeAlert(context, 'Failed to Submit', type: "error"));
  }

//////////


////////// delete Category Data ++++++++++++++++++++++++++++++++++++++

  Future<void> deleteUser(id) {
    return _category
        .doc(id)
        .delete()
        .then((value) => themeAlert(context, "Deleted Successfully "))
        .catchError(
            (error) => themeAlert(context, 'Not find Data', type: "error"));
  }

  ////////////
  @override
  void initState() {
    _CateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
    StreamBuilder<QuerySnapshot>(
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
                  title: "Category",
                ),
                SizedBox(height: defaultPadding),
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
              ],
            ),
          ));
        });
  }

//// Widget for Start_up

  Widget listCon(BuildContext context, tab) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(children: [
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
                                      color: Color.fromARGB(255, 228, 225, 225),
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
                                                  color: Color.fromARGB(
                                                      255, 1, 0, 0)),
                                            ),
                                      isExpanded: true,
                                      underline: Container(),
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Color.fromARGB(255, 63, 59, 59),
                                      ),
                                      iconSize: 35,
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 1, 7, 7)),
                                      items: ['Inactive', 'Active'].map(
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
                                        style: TextStyle(color: Colors.blue),
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
                            Text("Icon Image",
                                style: themeTextStyle(
                                    size: 15, fw: FontWeight.bold)),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
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
                          cate_name = CategoryController.text;
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

/////////

//// Widget for Start_up

  Widget listList(BuildContext context, tab) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: ListView(
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
                        Text("Category Details",
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],),
                    )

               : 
              //  SizedBox(width: defaultPadding),
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
                        child: Text("Category Name",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text("Parent Category",
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
                   (Responsive.isMobile(context)) 
                   ?
                   recentFileDataRow_Mobile(
                        context,
                        "$index",
                        "${StoreDocs[index]["image"]}",
                        "${StoreDocs[index]["category_name"]}",
                        "${StoreDocs[index]["parent_cate"]}",
                        "${StoreDocs[index]["status"]}",
                        "${StoreDocs[index]["date_at"]}",
                        "${StoreDocs[index]["id"]}")
                   :
                    recentFileDataRow(
                        context,
                        "$index",
                        "${StoreDocs[index]["image"]}",
                        "${StoreDocs[index]["category_name"]}",
                        "${StoreDocs[index]["parent_cate"]}",
                        "${StoreDocs[index]["status"]}",
                        "${StoreDocs[index]["date_at"]}",
                        "${StoreDocs[index]["id"]}"),
                ],
              )
              
              ),
        ],
      ),
    );
  }


////////// Row   ++++++++++++++++

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
                  child:
                (Iimage != null && Iimage.isNotEmpty)
                      ?
                       Container(
                        alignment: Alignment.bottomLeft,
                        child: Image.memory(
                            bytes,
                            height: 80,
                            width: 80,
                            fit: BoxFit.contain,
                          ),
                      )
              : 
              SizedBox()),
              Expanded(child: Text("$name")),
              Expanded(child: Text("$pName")),
              Expanded(child: Text("$status")),
              Expanded(child: Text("$date")),
              action_button(context, iid)
            ],
          ),
          Divider(
            thickness: 1.5,
          )
        ],
      ),
    );
  }
/////////

Widget action_button(BuildContext context, iid){
  return 
 Row(
  mainAxisAlignment: MainAxisAlignment.start,
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
                                        UpdateCategory(id: iid)));
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
                           // deleteUser(iid);
                            // print("$iid+++++++++++++");
                          },
                          icon: Icon(
                            Icons.delete_outline_outlined,
                            color: Colors.red,
                          ))),
                ],
              ) ;
}




////////// Row   mobile ++++++++++++++++

  Widget recentFileDataRow_Mobile(
      BuildContext context, sno, Iimage, name, pName, status, date, iid) {  
      var bytes = base64.decode(Iimage);
      return
    
    // Container(
    //   margin: EdgeInsets.symmetric(horizontal: 10),
    //   child: Row(
    //     children: [
    //        SizedBox(
    //                       width: 50,
    //                       child:  Text(
    //                         "$sno",
    //                         style: TextStyle(fontWeight: FontWeight.bold),
    //                       ),),
    //       Expanded(
    //         child:
             Container(
                // margin: EdgeInsets.symmetric( vertical: 10),
                // height: 140.0,
                // decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(10), boxShadow: themeBox),
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
                              //color: themeBG3,
                              // borderRadius: BorderRadius.only(
                              //     topLeft: Radius.circular(10.0),
                              //     bottomLeft: Radius.circular(10.0)),
                              // boxShadow: themeBox,
                              //gradient: themeGradient1,
                              color: Color.fromARGB(255, 214, 214, 214),
                              image: DecorationImage(
                                  image: 
                                      MemoryImage(
                                      bytes,
                                    ),fit: BoxFit.cover
                                    
                                    )),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              themeListRow(context, "Category Name", "$name"),
                              themeListRow(context, "Parent Category","$pName"),
                              themeListRow(context, "Satus","$status"),
                              themeListRow(context, "Date","$date"),
                        SizedBox(height: 10,),
                          //   Row(
                          //   children: [
                          //       SizedBox(
                          //    width:  100.0,
                          //    child: Text(
                          //    "Action",
                          //    style: themeTextStyle(
                          //    size: 12.0,
                          //    color: Colors.white,
                          //    ftFamily: 'ms',
                          //    fw: FontWeight.bold),
                          //  ),
                          //     ),
          
                          // Text(
                          //   ": ",
                          //   overflow: TextOverflow.ellipsis,
                          //   style: themeTextStyle(
                          //       size: 14,
                          //       color: Colors.white,
                          //       ftFamily: 'ms',
                          //       fw: FontWeight.normal),
                          // ),
                          //     Container(
                          //         height: 40,
                          //         width: 40,
                          //         alignment: Alignment.center,
                          //         decoration: BoxDecoration(
                          //           color: Colors.blue.withOpacity(0.1),
                          //           borderRadius:
                          //               const BorderRadius.all(Radius.circular(10)),
                          //         ),
                          //         child: IconButton(
                          //             onPressed: () {
                          //               Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) =>
                          //                           UpdateCategory(id: iid)
                          //                           )
                          //                           );
                          //             },
                          //             icon:
                          //              Icon(
                          //               Icons.edit,
                          //               color: Colors.blue,
                          //             )) ////
                          //         ),
                          //     SizedBox(width: 10),
                          //     Container(
                          //         height: 40,
                          //         width: 40,
                          //         alignment: Alignment.center,
                          //         decoration: BoxDecoration(
                          //           color: Colors.red.withOpacity(0.1),
                          //           borderRadius:
                          //               const BorderRadius.all(Radius.circular(10)),
                          //         ),
                          //         child: IconButton(
                          //             onPressed: () {
                          //               deleteUser(iid);
                          //             },
                          //             icon: Icon(
                          //               Icons.delete_outline_outlined,
                          //               color: Colors.red,
                          //             ))),
                          //   ],
                          // )
                           action_button(context ,iid)
                            ],
                          ),
                        ),
                       
                      ],
                    ),


                 Divider(thickness: 1.0,color: Colors.white12,)   
                  ],
                ),
      //         ),
      //     ),
      //   ],
      // ),
    );
  }
/////////



//////////////////
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
  ///
  ///
  Widget Text_field(BuildContext context, ctr_name, lebel, hint) {
    return Container(
        height: 40,
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
