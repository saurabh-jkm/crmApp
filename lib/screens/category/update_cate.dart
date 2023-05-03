
// import 'dart:convert';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../constants.dart';
// import '../../responsive.dart';
// import '../../themes/style.dart';
// import '../../themes/theme_widgets.dart';
// import 'package:intl/intl.dart';
// import '../dashboard/components/header.dart';

// class UpdateCategory extends StatefulWidget {
//   const UpdateCategory({
//     @required this.id,
//   }) : super();
//   final id;
//   @override
//   State<UpdateCategory> createState() => _UpdateCategoryState();
// }

// class _UpdateCategoryState extends State<UpdateCategory> {
//   bool Tranding = false;
//   final _formKey = GlobalKey<FormState>();
//   String _dropDownValue = "Select";
//   String _StatusValue = "Select";
//   String Date_at = DateFormat('dd-MM-yyyy').format(DateTime.now());

//   //////

//   // Map<String, TextEditingController> _controllers = new Map();

//   // File Picker ==========================================================
//   var uploadedDoc;
// // result;
//   String? fileName;
//   PlatformFile? pickedfile;
//   bool isLoading = false;
//   File? fileToDisplay;
//   void clear_upload() {
//     fileName = null;
//   }

//   pickFile() async {
//     if (!kIsWeb) {
//       try {
//         setState(() {
//           isLoading = true;
//         });
//         FilePickerResult? result = await FilePicker.platform.pickFiles(
//           type: FileType.custom,
//           allowedExtensions: ['png', 'jpeg', 'jpg'],
//           allowMultiple: false,
//         );
//         if (result != null) {
//           fileName = result.files.first.name;
//           pickedfile = result.files.first;
//           fileToDisplay = File(pickedfile!.path.toString());
//           setState(() {
//             List<int> imageBytes = fileToDisplay!.readAsBytesSync();
//             uploadedDoc = base64Encode(imageBytes);
//             // _controllers['doc'] = uploadedDoc;
//           });
//           print('File name $uploadedDoc');
//         }
//         setState(() {
//           isLoading = false;
//         });
//       } catch (e) {
//         print(e);
//       }
//     } else if (kIsWeb) {
//       final ImagePicker _picker = ImagePicker();
//       XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         var f = await image.readAsBytes();
//         setState(() {
//           var webImage = f;
//           uploadedDoc = base64.encode(webImage);
//         });
//       }
//     }
//   }

// ///////////  firebase property
//   final Stream<QuerySnapshot> _crmStream =
//       FirebaseFirestore.instance.collection('category').snapshots();
//   final List StoreDocs = [];
//   var db = FirebaseFirestore.instance;
//   CollectionReference _category =
//       FirebaseFirestore.instance.collection('category');

//   /// Update list
//   Future<void> updatelist(id, cate_name, slug__url, image_logo, _dropDownValue,
//       _StatusValue, Date_at) {
//     return _category
//         .doc(id)
//         .update({
//           'category_name': "$cate_name",
//           'slug_url': "$slug__url",
//           'parent_cate': "$_dropDownValue",
//           'status': "$_StatusValue",
//           'image': "$uploadedDoc",
//           "date_at": "$Date_at"
//         })
//         .then((value) => themeAlert(context, "Successfully Updated"))
//         .catchError(
//             (error) => themeAlert(context, 'Failed to update', type: "error"));
//   }

//   ///

// //  var cate_name = "";
// //   var slug__url = "";
// //   var image_logo = "";
// //   String _dropDownValue = "Select";
// //   String _StatusValue = "Select";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//             padding: EdgeInsets.all(defaultPadding),
//             child: DefaultTabController(
//                 length: 2,
//                 child: ListView(children: [
//                   Header(
//                     title: "Update Category",
//                   ),
//                   SizedBox(height: defaultPadding),
//                   Text("${widget.id}"),
//                   Container(
//                       padding: EdgeInsets.all(defaultPadding),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(10)),
//                       ),
//                       child: Form(
//                           key: _formKey,
//                           child: FutureBuilder<
//                                   DocumentSnapshot<Map<String, dynamic>>>(
//                               future: FirebaseFirestore.instance
//                                   .collection("category")
//                                   .doc(widget.id)
//                                   .get(),
//                               builder: (_, snapshot) {
//                                 //////
//                                 if (snapshot.hasError) {
//                                   print("Something went wrong");
//                                 }
//                                 if (snapshot.connectionState ==
//                                     ConnectionState.waiting) {
//                                   return Center(
//                                       child: CircularProgressIndicator());
//                                 }

//                                 var data = snapshot.data!.data();
//                                 var Catename = data!['category_name'];
//                                 // var statuss = data!['Status'];
//                                 // var P_cate = data!['parent_cate'];
//                                 var slugUrl = data['slug_url'];
//                                 // var imagee = data!['image'];

//                                 return 
                                
                                
//                                 Column(
//                                   children: [
//                                     Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                           flex: 2,
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text("Category Name*",
//                                                   style: themeTextStyle(
//                                                       color: Colors.black,
//                                                       size: 15,
//                                                       fw: FontWeight.bold)),
//                                               Text_field(
//                                                   context,
//                                                   Catename,
//                                                   "Category Name",
//                                                   "Enter Category Name"),
//                                               SizedBox(height: defaultPadding),
//                                               if (Responsive.isMobile(context))
//                                                 SizedBox(width: defaultPadding),
//                                               if (Responsive.isMobile(context))
//                                                 Text_field(
//                                                     context,
//                                                     slugUrl,
//                                                     "Slug Url",
//                                                     "Enter Slug Url"),
//                                             ],
//                                           ),
//                                         ),
//                                         if (!Responsive.isMobile(context))
//                                           SizedBox(width: defaultPadding),
//                                         if (!Responsive.isMobile(context))
//                                           Expanded(
//                                             flex: 2,
//                                             child: Container(
//                                                 child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text("Slug Url",
//                                                     style: themeTextStyle(
//                                                         color: Colors.black,
//                                                         size: 15,
//                                                         fw: FontWeight.bold)),
//                                                 Text_field(
//                                                     context,
//                                                     slugUrl,
//                                                     "Slug Url",
//                                                     "Enter Slug Url"),
//                                               ],
//                                             )),
//                                           ),
//                                       ],
//                                     ),
//                                     //status
//                                     Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                           flex: 2,
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Container(
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Container(
//                                                         child: Text("Status",
//                                                             style: themeTextStyle(
//                                                                 color: Colors
//                                                                     .black,
//                                                                 size: 15,
//                                                                 fw: FontWeight
//                                                                     .bold))),
//                                                     Container(
//                                                       height: 40,
//                                                       margin: EdgeInsets.only(
//                                                           top: 10,
//                                                           bottom: 10,
//                                                           right: 10),
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.grey[200],
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10),
//                                                       ),
//                                                       padding: EdgeInsets.only(
//                                                           left: 10, right: 10),
//                                                       child: DropdownButton(
//                                                         dropdownColor:
//                                                             Color.fromARGB(255,
//                                                                 248, 247, 247),
//                                                         hint: _StatusValue ==
//                                                                 null
//                                                             ? Text('Dropdown')
//                                                             : Text(
//                                                                 _StatusValue,
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .black),
//                                                               ),
//                                                         isExpanded: true,
//                                                         underline: Container(),
//                                                         icon: Icon(
//                                                           Icons.arrow_drop_down,
//                                                           color: Colors.black,
//                                                         ),
//                                                         iconSize: 35,
//                                                         style: TextStyle(
//                                                             color:
//                                                                 Color.fromARGB(
//                                                                     255,
//                                                                     0,
//                                                                     0,
//                                                                     0)),
//                                                         items: [
//                                                           'Select',
//                                                           'Inactive',
//                                                           'Active'
//                                                         ].map(
//                                                           (val) {
//                                                             return DropdownMenuItem<
//                                                                 String>(
//                                                               value: val,
//                                                               child: Text(val),
//                                                             );
//                                                           },
//                                                         ).toList(),
//                                                         onChanged: (val) {
//                                                           setState(
//                                                             () {
//                                                               _StatusValue =
//                                                                   val!;
//                                                             },
//                                                           );
//                                                         },
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),

//                                               // Text_field(context,"category_name","Category Name","Enter Category Name"),
//                                               SizedBox(height: defaultPadding),
//                                               if (Responsive.isMobile(context))
//                                                 SizedBox(width: defaultPadding),
//                                               if (Responsive.isMobile(context))

//                                                 //   Text_field(context,"slug_url","Slug Url","Enter Slug Url"),

//                                                 Container(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Container(
//                                                           child: Text(
//                                                               "Parent Category",
//                                                               style: themeTextStyle(
//                                                                   color: Colors
//                                                                       .black,
//                                                                   size: 15,
//                                                                   fw: FontWeight
//                                                                       .bold))),
//                                                       Container(
//                                                         height: 40,
//                                                         margin: EdgeInsets.only(
//                                                             top: 10,
//                                                             bottom: 10,
//                                                             right: 10),
//                                                         decoration:
//                                                             BoxDecoration(
//                                                           color:
//                                                               Colors.grey[200],
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(10),
//                                                         ),
//                                                         padding:
//                                                             EdgeInsets.only(
//                                                                 left: 10,
//                                                                 right: 10),
//                                                         child: DropdownButton(
//                                                           dropdownColor:
//                                                               Color.fromARGB(
//                                                                   255,
//                                                                   248,
//                                                                   247,
//                                                                   247),
//                                                           hint: _dropDownValue ==
//                                                                   null
//                                                               ? Text('Dropdown')
//                                                               : Text(
//                                                                   _dropDownValue,
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .black),
//                                                                 ),
//                                                           underline:
//                                                               Container(),
//                                                           isExpanded: true,
//                                                           icon: Icon(
//                                                             Icons
//                                                                 .arrow_drop_down,
//                                                             color: Colors.black,
//                                                           ),
//                                                           iconSize: 35,
//                                                           style: TextStyle(
//                                                               color: Color
//                                                                   .fromARGB(255,
//                                                                       1, 1, 2)),
//                                                           items: [
//                                                             'Select',
//                                                             'One',
//                                                             'Two',
//                                                             'Three'
//                                                           ].map(
//                                                             (val) {
//                                                               return DropdownMenuItem<
//                                                                   String>(
//                                                                 value: val,
//                                                                 child:
//                                                                     Text(val),
//                                                               );
//                                                             },
//                                                           ).toList(),
//                                                           onChanged: (val) {
//                                                             setState(
//                                                               () {
//                                                                 _dropDownValue =
//                                                                     val!;
//                                                               },
//                                                             );
//                                                           },
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 )
//                                             ],
//                                           ),
//                                         ),
//                                         if (!Responsive.isMobile(context))
//                                           SizedBox(width: defaultPadding),
//                                         // On Mobile means if the screen is less than 850 we dont want to show it
//                                         if (!Responsive.isMobile(context))
//                                           Expanded(
//                                               flex: 2,
//                                               child: Container(
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Container(
//                                                         child: Text(
//                                                             "Parent Category",
//                                                             style: themeTextStyle(
//                                                                 color: Colors
//                                                                     .black,
//                                                                 size: 15,
//                                                                 fw: FontWeight
//                                                                     .bold))),
//                                                     Container(
//                                                       height: 40,
//                                                       margin: EdgeInsets.only(
//                                                           top: 10,
//                                                           bottom: 10,
//                                                           right: 10),
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.grey[200],
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10),
//                                                       ),
//                                                       padding: EdgeInsets.only(
//                                                           left: 10, right: 10),
//                                                       child: DropdownButton(
//                                                         dropdownColor:
//                                                             Color.fromARGB(255,
//                                                                 248, 247, 247),
//                                                         hint: _dropDownValue ==
//                                                                 null
//                                                             ? Text('Dropdown')
//                                                             : Text(
//                                                                 _dropDownValue,
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .black),
//                                                               ),
//                                                         isExpanded: true,
//                                                         underline: Container(),
//                                                         icon: Icon(
//                                                           Icons.arrow_drop_down,
//                                                           color: Colors.black,
//                                                         ),
//                                                         iconSize: 35,
//                                                         style: TextStyle(
//                                                             color:
//                                                                 Color.fromARGB(
//                                                                     255,
//                                                                     8,
//                                                                     14,
//                                                                     18)),
//                                                         items: [
//                                                           'Select',
//                                                           'One',
//                                                           'Two',
//                                                           'Three'
//                                                         ].map(
//                                                           (val) {
//                                                             return DropdownMenuItem<
//                                                                 String>(
//                                                               value: val,
//                                                               child: Text(val),
//                                                             );
//                                                           },
//                                                         ).toList(),
//                                                         onChanged: (val) {
//                                                           setState(
//                                                             () {
//                                                               _dropDownValue =
//                                                                   val!;
//                                                             },
//                                                           );
//                                                         },
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               )),
//                                       ],
//                                     ),

//                                     Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                           flex: 2,
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text("Icon Image",
//                                                   style: themeTextStyle(
//                                                       size: 15,
//                                                       fw: FontWeight.bold)),
//                                               Container(
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.grey[200],
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                 ),
//                                                 height: 55,
//                                                 margin: EdgeInsets.only(
//                                                     top: 10,
//                                                     bottom: 10,
//                                                     right: 10),
//                                                 padding: EdgeInsets.only(
//                                                     left: 10, right: 10),
//                                                 child: Row(
//                                                   children: [
//                                                     GestureDetector(
//                                                       onTap: () {
//                                                         _LogoutAlert(context);
//                                                       },
//                                                       child: Container(
//                                                         padding:
//                                                             EdgeInsets.all(10),
//                                                         decoration: BoxDecoration(
//                                                             border: Border.all(
//                                                                 color: Color
//                                                                     .fromARGB(
//                                                                         31,
//                                                                         232,
//                                                                         226,
//                                                                         226)),
//                                                             color:
//                                                                 Color.fromARGB(
//                                                                     255,
//                                                                     237,
//                                                                     235,
//                                                                     235)),
//                                                         child: Text(
//                                                           "Choose File",
//                                                           style: themeTextStyle(
//                                                               size: 15),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 10,
//                                                     ),
//                                                     (uploadedDoc == null ||
//                                                             uploadedDoc.isEmpty)
//                                                         ? Row(
//                                                             children: [
//                                                               SizedBox(
//                                                                 width: 10,
//                                                               ),
//                                                               Text(
//                                                                   "No file choosen",
//                                                                   style: themeTextStyle(
//                                                                       size: 15,
//                                                                       color: Colors
//                                                                           .black38)),
//                                                             ],
//                                                           )
//                                                         : Row(
//                                                             children: [
//                                                               SizedBox(
//                                                                 width: 10,
//                                                               ),
//                                                               Text(
//                                                                 "file selected",
//                                                                 style: themeTextStyle(
//                                                                     size: 12,
//                                                                     fw: FontWeight
//                                                                         .w400,
//                                                                     color:
//                                                                         themeBG4),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               ////
//                                               SizedBox(height: defaultPadding),
//                                             ],
//                                           ),
//                                         ),

//                                         if (!Responsive.isMobile(context))
//                                           SizedBox(width: defaultPadding),
//                                         // On Mobile means if the screen is less than 850 we dont want to show it
//                                         if (!Responsive.isMobile(context))
//                                           Expanded(
//                                             flex: 2,
//                                             child:
//                                                 SizedBox(width: defaultPadding),
//                                           ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 20,
//                                     ),
//                                     Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           themeButton3(context, () {
//                                             if (_formKey.currentState!
//                                                 .validate()) {
//                                               setState(() {
//                                                 //  cate_name =  CategoryController.text;
//                                                 //  slug__url =   SlugUrlController.text;
//                                                 // addList();
//                                                 // clearText();
//                                               });
//                                             }
//                                           },
//                                               buttonColor: Colors.green,
//                                               label: "Submit"),
//                                           SizedBox(
//                                             width: 10,
//                                           ),
//                                           themeButton3(context, () {
//                                             setState(() {
//                                               //    clearText();
//                                             });
//                                           },
//                                               label: "Reset",
//                                               buttonColor: Colors.black),
//                                           SizedBox(width: 20.0),
//                                         ])
//                                   ],
//                                 );
//                               }))),
//                 ]))));
//   }

//   Widget Text_field(BuildContext context, ini_value, lebel, hint) {
//     return Container(
//         height: 40,
//         margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: TextFormField(
//           initialValue: ini_value,
//           // controller: ctr_name,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please Enter value';
//             }
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
//   }

//   void _LogoutAlert(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return StatefulBuilder(builder: (context, StateSetter setStatee) {
//             return AlertDialog(
//               backgroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(
//                     20.0,
//                   ),
//                 ),
//               ),
//               // contentPadding: EdgeInsets.only(
//               //   top: 10.0,
//               // ),
//               title: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Media",
//                         style: TextStyle(fontSize: 20.0, color: Colors.black),
//                       ),
//                       IconButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           icon: Icon(
//                             Icons.cancel,
//                             color: Colors.black38,
//                           ))
//                     ],
//                   ),
//                   Divider(
//                     thickness: 1,
//                     color: Colors.black12,
//                   )
//                 ],
//               ),
//               content: Container(
//                 height: 400,
//                 width: MediaQuery.of(context).size.width - 400,
//                 child: SingleChildScrollView(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             margin: EdgeInsets.all(10),
//                             child: Text(
//                               "All Media ",
//                               style: TextStyle(
//                                   fontSize: 15.0, color: Colors.black),
//                             ),
//                           ),
//                           themeButton3(context, () {
//                             setState(() {
//                               pickFile();
//                               Navigator.of(context).pop();
//                             });
//                           }, label: "Add New", buttonColor: Colors.blue),
//                         ],
//                       ),
//                       Divider(
//                         thickness: 1.5,
//                         color: Colors.black,
//                       ),
//                       All_media(context, setStatee)
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           });
//         });
//   }

//   Widget All_media(BuildContext context, setStatee) {
//     return Container(
//         child: Column(
//       children: [
//         Row(
//           children: [
//             for (var i = 0; i < 4; i++)
//               Expanded(
//                 child: Container(
//                   margin: EdgeInsets.symmetric(horizontal: 10),
//                   height: 100,
//                   width: 100,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(
//                           'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ0JhaimSD1ayvA9vffVRcueFMd8MqD5cJH9A&usqp=CAU'),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                   alignment: Alignment.topLeft,
//                   child: Checkbox(
//                     checkColor: Colors.white,
//                     activeColor: Colors.green,
//                     side: BorderSide(width: 2, color: Colors.white),
//                     value: this.Tranding,
//                     onChanged: (value) {
//                       setStatee(() {
//                         this.Tranding = value!;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//           ],
//         )
//       ],
//     ));
//   }
// }
