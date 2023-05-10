
// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, prefer_final_fields, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_null_comparison, sort_child_properties_last

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

class AttributeAdd extends StatefulWidget {
  const AttributeAdd({super.key});
  @override
  State<AttributeAdd> createState() => _AttributeAddState();
}

class _AttributeAddState extends State<AttributeAdd> {
  final _formKey = GlobalKey<FormState>();

  var cate_name = "";
  var slug__url = "";
  var image_logo = "";

  String? _dropDownValue;
  String? _StatusValue ;
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
    _StatusValue =null;
  }


///////////  firebase property Database access  +++++++++++++++++++++++++++
    final Stream<QuerySnapshot> _crmStream =
      FirebaseFirestore.instance.collection('category').snapshots();
      CollectionReference _category = FirebaseFirestore.instance.collection('category');
////////

/////////////  Category data fetch From Firebase   +++++++++++++++++++++++++++++++++++++++++++++

    List StoreDocs = [];
   _CateData() async {
    var collection = FirebaseFirestore.instance.collection('category');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      // ignore: unnecessary_cast
      Map data = queryDocumentSnapshot.data() as Map<String, dynamic>;
      StoreDocs.add(data);
      data["id"] = queryDocumentSnapshot.id;
    }
     setState(() {
         //listExample();
       });   
  }

/////////////

  var Perent_cat ;
  var slugUrl ;
  var image ;
  var _Status ;
  var Catename ;
//////
  Map<String, dynamic>? data;
 Future Update_initial(id)async{
    DocumentSnapshot pathData = await FirebaseFirestore.instance
       .collection('category')
       .doc(id)
       .get();
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
    return
     _category
        .add({
          'category_name': "$cate_name",
          'slug_url': "$slug__url",
          'parent_cate': "$_dropDownValue",
          'status': "$_StatusValue",
       
          "date_at": "$Date_at"
        })
        .then((value) => themeAlert(context, "Successfully Submit"))
        .catchError(
        (error) => themeAlert(context, 'Failed to Submit', type: "error"));
  }

//////////


////////// delete Category Data ++++++++++++++++++

  Future<void> deleteUser(id) {
    return _category
        .doc(id)
        .delete()
        .then((value){
          setState(() {
             themeAlert(context, "Deleted Successfully ");         
          });
        }
        )
        .catchError((error) => themeAlert(context, 'Not find Data', type: "error"));
  }

  ////////////
  ///
/////// Update

  Future<void> updatelist(id, Catename,slugUrl, _Status,_perentCate, image) 
    {
    return 
        _category
        .doc(id)
        .update({
          'category_name': "$Catename",
          "parent_cate":"$_perentCate",
          'slug_url': "$slugUrl",
          'status': "$_Status",
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
    _CateData();
    super.initState();
  }


  bool updateWidget = false;
  var update_id ;
  @override
  Widget build(BuildContext context) {
    return
    StreamBuilder<QuerySnapshot>(
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
                  title: "Attibute",
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
                                Tab(text: "Add New"),
                                Tab(text: "List All"),
                              ],
                            ),
                          ),
                          Expanded(
                              child: TabBarView(
                            children: [
                              listCon(context, 'tab1'),
                              listList(context, 'tab2')
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
                                  Text("Category Name*",
                                      style: themeTextStyle(
                                          color: Colors.black,
                                          size: 15,
                                          fw: FontWeight.bold)),
                                  Text_field(context, CategoryController,"Category Name", "Enter Category Name"),
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
                                            Text_field(context, SlugUrlController,"Slug Url", "Enter Slug Url"),
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
                                        Text_field(context, SlugUrlController,"Slug Url", "Enter Slug Url"),
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
                                      dropdownColor:
                                          Colors.white,
                                      hint: _StatusValue == null
                                          ? Text('Select',style: TextStyle(color:Colors.black),)
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
                                      items: ['Select','Inactive', 'Active'].map(
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
                                        dropdownColor:
                                            Colors.white,
                                        hint: _dropDownValue == null
                                            ?Text('Select',style: TextStyle(color:Colors.black),)
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
                                        style: TextStyle(color: Colors.blue),
                                        items: ['Select', 'Two', 'Three']
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
                                      dropdownColor:
                                          Colors.white,
                                      hint: _dropDownValue == null
                                          ?
                                          Text('Select',style: TextStyle(color:Colors.black),)
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
                                          ['Select','One', 'Two', 'Three'].map(
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
        
                
                  SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    themeButton3(context, () {
                   
                        
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
          SizedBox(height: 100,)      
        ]));
  }

////////////////////////////// List ++++++++++++++++++++++++++++++++++++++++++++

  Widget listList(BuildContext context, tab) {
      return
      Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5.0),
      //padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: ListView(
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
                                    child: Text("Category Details",
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
                                      "Category Name",
                                       style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Text(
                                      "Parent Category",
                                       style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child:Text("Status",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
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
                                 "${StoreDocs[index]["category_name"]}",
                                 "${StoreDocs[index]["parent_cate"]}",
                                 "${StoreDocs[index]["status"]}",
                                 "${StoreDocs[index]["date_at"]}",
                                 "${StoreDocs[index]["id"]}"
                                 )
                             :
                              tableRowWidget( 
                            "${index + 1}",
                            "${StoreDocs[index]["image"]}",
                            "${StoreDocs[index]["category_name"]}",
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
          padding: const EdgeInsets.all(5.0),
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

/////////




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
                  onChanged: 
           (ctr_name == CategoryController)
           ?
           (value){
            Slug_gen("${value}");
           }
           :
           (value){}, 
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
