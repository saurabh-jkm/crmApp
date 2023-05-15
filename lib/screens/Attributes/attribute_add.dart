
// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, prefer_final_fields, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_null_comparison, sort_child_properties_last, unused_import, body_might_complete_normally_nullable, no_leading_underscores_for_local_identifiers, unused_field, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slug_it/slug_it.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';
import '../dashboard/components/header.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:intl/intl.dart';


class AttributeAdd extends StatefulWidget {
  const AttributeAdd({super.key});
  @override
  State<AttributeAdd> createState() => _AttributeAddState();
}

class _AttributeAddState extends State<AttributeAdd> {
  final _formKey = GlobalKey<FormState>();
//////
  final AttributeController = TextEditingController();
   final Sub_AttributeController = TextEditingController();
  String? _StatusValue ;
  String Date_at = DateFormat('dd-MM-yyyy').format(DateTime.now());
/////

  clearText() {
     AttributeController.clear();
    _StatusValue = null;
  }


///////////  firebase property Database access  +++++++++++++++++++++++++++
    final Stream<QuerySnapshot> _crmStream =
    FirebaseFirestore.instance.collection('attribute').snapshots();
    CollectionReference _attribute = FirebaseFirestore.instance.collection('attribute');

    List StoreDocs = [];
   _AttributeData() async {
    // var collection = FirebaseFirestore.instance.collection('category');
    var querySnapshot = await _attribute.get();
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

  var _Status ;
  var Attribute_name ;
//////
  Map<String, dynamic>? data;
 Future Update_initial(id)async{
        DocumentSnapshot pathData = await FirebaseFirestore.instance
       .collection('attribute')
       .doc(id)
       .get();
      if (pathData.exists) {
       data = pathData.data() as Map<String, dynamic>?;
       setState(() {                   
        _Status = data!['status'];
        Attribute_name = data!['attribute_name'];
       });
     }

}
///



/////// add Category Data  =+++++++++++++++++++
 
 Future<void> addList() {
    return
     _attribute
        .add({
          'attribute_name': "${AttributeController.text}",
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
    return _attribute
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


/////// Update
  Future<void> updatelist(id, Catename,_Status) 
    {
    return 
        _attribute
        .doc(id)
        .update({
          'attribute_name': "$Catename",
          'status': "$_Status",
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
  ///
  
/////// Update
  Future<void> AddNew_subAttribute(id, SubAttribute_name,_Status) 
  
    {
  
    return 
        _attribute
        .doc(id)
        .update({
         // 'value': "$SubAttribute_name",
       "value": {
       "$SubAttribute_name": {
        "name" : "$SubAttribute_name",
        "status" : "$_Status",
       "date_at": "$Date_at" ,
    }
            } 
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
  ///
  


  @override
  void initState() {
    _AttributeData();
    super.initState();
  }


  bool updateWidget = false;
  bool update_subAttribute = false;
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
                              (updateWidget == false)
                              ? 
                              (update_subAttribute == true && updateWidget == false)
                              ?
                              Update_Sub_Attribute(context,update_id)
                              :
                              listList(context, 'tab2')
                              :
                              Update_Attribute(context,update_id)
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
                    child: 
                      


                              Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Attribute Name*",
                                      style: themeTextStyle(
                                          color: Colors.black,
                                          size: 15,
                                          fw: FontWeight.bold)),
                                  Text_field(context, AttributeController,"Attribute Name", "Enter Category Name"),
                                ],
                              ))),
                  

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




                      
              
                
                  SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    themeButton3(context, () {
                          addList();
                          clearText();
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
      child: 
      ListView(
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
                                    child: Text(
                                      "Name",
                                       style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
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
                                 "${StoreDocs[index]["attribute_name"]}",
                                 "${StoreDocs[index]["status"]}",
                                 "${StoreDocs[index]["date_at"]}",
                                 "${StoreDocs[index]["id"]}"
                                 )
                             :
                              tableRowWidget( 
                            "${index + 1}",
                            "${StoreDocs[index]["attribute_name"]}",
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

  TableRow tableRowWidget( sno, name, status, date, iid) {
    return TableRow(children: [
       TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text("$sno",style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text("$name",style: TextStyle(fontWeight: FontWeight.bold)),
        ),
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
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: IconButton(
                                      onPressed: () {
                                           setState(() {
                                                update_subAttribute = true;
                                                update_id = iid;
                                                Update_initial(iid);
                                                  });
                                      },
                                      icon:
                                       Icon(
                                        Icons.more_horiz_outlined,
                                        color: Colors.green,
                                      )) ////
                                  ),
              
                ],
              )
      ),
     
    ]);
  }


 TableRow tableRowWidget_mobile(name,status, date, iid) {
    return TableRow(
      children: [
       TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child:  
                    Row(
                      children: [
                       
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              themeListRow(context, "Name", "$name"),
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
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: IconButton(
                                      onPressed: () {
                                           setState(() {
                                                update_subAttribute = true;
                                                update_id = iid;
                                                Update_initial(iid);
                                                  });
                                      },
                                      icon:
                                       Icon(
                                        Icons.more_horiz_outlined,
                                        color: Colors.green,
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
Widget Update_Attribute(BuildContext context,id) {
  return 
          Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: ListView(children: [

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
                          Text("Update Attribute",
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
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
      

                              Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Attribute Name*",
                                      style: themeTextStyle(
                                          color: Colors.black,
                                          size: 15,
                                          fw: FontWeight.bold)),
                                       
                                  
                                    Container(
                                                   height: 40,
                                                    margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: TextFormField(
                                                              initialValue: Attribute_name,
                                                              autofocus: false,
                                                              onChanged: (value) => Attribute_name = value,
                                                            // controller: ctr_name,
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return "Enter Attribute Name";
                                                                }
                                                                return null;
                                                              },
                                                              style: TextStyle(color: Colors.black),
                                                              decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                                                hintText: "Attibute Name ",
                                                                hintStyle: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            )),

                                ],
                              )),
                  

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
                                                        hint: _StatusValue ==
                                                                null
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
                                                      ),
                                                    ),
                
                       SizedBox(
                        height: 20,
                        ),
                       Row(mainAxisAlignment: MainAxisAlignment.center, 
                       children: [
                       themeButton3(context, () {
                            if(Attribute_name.isNotEmpty && (Attribute_name != null && _StatusValue !=null)){
                               setState(() {
                                        updatelist(id, Attribute_name,_StatusValue);  
                                         _Status = null;
                                         _StatusValue = null;
                                         Attribute_name = null;
                                        });
                               }
                               else{
                                 themeAlert(context, 'Please Enter Required value!', type: "error");
                               }
                               
                         }, buttonColor: Colors.green, label: "Update"),
                       SizedBox(
                      width: 10,
                       ),
                      themeButton3(context, () {
                      setState(() {
                        clearText();
                                         _Status = null;
                                         _StatusValue = null;
                                         Attribute_name = null;
                      });
                    }, label: "Reset", buttonColor: Colors.black),
                    SizedBox(width: 20.0),
                  ])
                ],
              )),
            SizedBox(height: 100,)      
        ]));            
}
///////////////////////////



/////////////  Update widget for product Update+++++++++++++++++++++++++
Widget Update_Sub_Attribute(BuildContext context,id) {
  return 
          Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: ListView(children: [

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
                     update_subAttribute = false;
                      });
                        }, icon:  Icon(Icons.arrow_back,color: Colors.black)),
 
                          SizedBox(width: 10,),
                          Text("Colours attribute  $id",
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
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                              Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Add New",
                                      style: themeTextStyle(
                                          color: Colors.black,
                                          size: 15,
                                          fw: FontWeight.bold)),
                                          Text_field( context, Sub_AttributeController, "Enter Sub Attribute Name", "Sub Attibute Name ")      
                                ],
                              )),

                       SizedBox(
                        height: 20,
                        ),
                       Row(mainAxisAlignment: MainAxisAlignment.center, 
                       children: [
                       themeButton3(context, () {
                            if(Sub_AttributeController.text.isNotEmpty){
                               setState(() {
                                        AddNew_subAttribute(id, Sub_AttributeController.text,_StatusValue);  
                                         _Status = null;
                                         _StatusValue = null;
                                         Sub_AttributeController.text = "";
                                        });
                               }
                               else{
                                 themeAlert(context, 'Please Enter Required value!', type: "error");
                               }
                               
                         }, buttonColor: Colors.green, label: "Add New"),
                       SizedBox(
                      width: 10,
                       ),
              
                    SizedBox(width: 20.0),
                  ])
                ],
              )),
            SizedBox(height: 100,)      
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
