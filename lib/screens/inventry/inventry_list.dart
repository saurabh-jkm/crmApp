// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, deprecated_member_use, sort_child_properties_last, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, unnecessary_string_interpolations, unused_field, prefer_final_fields, unnecessary_cast, unnecessary_new

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/screens/inventry/qr_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';
import '../dashboard/components/header.dart';
import '../dashboard/components/my_fields.dart';
import '../dashboard/components/recent_files.dart';
import '../dashboard/components/storage_details.dart';
import 'package:file_picker/file_picker.dart';

class InventryList extends StatefulWidget {
  const InventryList({super.key});
  @override
  State<InventryList> createState() => _InventryListState();
}

class _InventryListState extends State<InventryList> {

////// Firebase fn   +++
  var db = FirebaseFirestore.instance;
    final Stream<QuerySnapshot> _crmStream =
      FirebaseFirestore.instance.collection('product').snapshots();
  CollectionReference _product =
      FirebaseFirestore.instance.collection('product');
  ////////////+++++++++++++++++++++++++++++++++++++++++++++++++
     List StoreDocs = [];
  Inventory_list() async {
     StoreDocs = [];
    var collection = FirebaseFirestore.instance.collection('product');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map data = queryDocumentSnapshot.data() as Map<String, dynamic>;
      StoreDocs.add(data);
      data["id"] = queryDocumentSnapshot.id;
    }
  }
///

  @override
    void initState() {
    Inventory_list();
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
             themeAlert(context, "Something went wrong");
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
            title: "Inventory",
          ),
          SizedBox(height: defaultPadding),
           listList(context),
              ],
            ),
        ));
         });
  }


////////   List       ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

 var _number_select = 10;
    Widget listList(BuildContext context) {
      return
       Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // borderRadius:
                        //     const BorderRadius.all(Radius.circular(10)),
                      ),
                      child:
                        ListView(
        children: [
         Container(
          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
           child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                 Icon(Icons.inventory_outlined,color: Colors.blue,size:25),
                  SizedBox(width: 10,),
                Text(
                    'Product Inventory',
                    style: themeTextStyle(
                    size: 18.0,
                    ftFamily: 'ms',
                    fw: FontWeight.bold,
                    color: Colors.black),
                     ),
                  ],
                ),
         ),
         
           Container(
            margin: EdgeInsets.all(10),
             decoration: BoxDecoration(
            color: secondaryColor,
            ),
            child: Column(
              children: [
                  Container(
                          padding: EdgeInsets.all(10),
                          color:Theme.of(context).secondaryHeaderColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Column(
                            crossAxisAlignment: CrossAxisAlignment.start, 
                            children: [
                            Text("Inventory List",style: themeTextStyle(fw: FontWeight.bold,color: Colors.white,size: 15),),
                            SizedBox(height: 20,),
                            Row(children: [
                              Text("Show",style: themeTextStyle(fw: FontWeight.normal,color: Colors.white,size: 15),),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    padding: EdgeInsets.all(2) ,
                                    height: 20,
                                    color: Colors.white,
                                    child: DropdownButton<int>(
                                       dropdownColor:Colors.white,
                                       iconEnabledColor: Colors.black,
                                       hint: Text("$_number_select",style: TextStyle(color:Colors.black,fontSize: 12),),
                                      value: _number_select,
                                      items: <int>[10,25, 50, 100].map((int value) {
                                      return new DropdownMenuItem<int>(
                                      value: value,
                                      child: new Text(value.toString(),style: TextStyle(color:Colors.black,fontSize: 12),),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                       setState(() {
                                      _number_select = newVal!;
                                         });
                                       }),
                                  ),
                            

                              Text("entries",style: themeTextStyle(fw: FontWeight.normal,color: Colors.white,size: 15),),
                            ],)
                            ],),
                           SizedBox(
                            height: 40,
                            width: 300,
                            child: SearchField())  
                            ],
                          )), 
                          
                          SizedBox(height: 5,),
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
                                    child: Text("Product Inventry List",
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
                                  child:
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: 
                                   Text(
                                      'S.No.',
                                       style: TextStyle(fontWeight: FontWeight.bold)),)                                 
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: SizedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                        'Name',
                                         style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      width: 40,
                                    ),
                                  
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                        'Category Name',
                                         style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: 
                                    Text(
                                        'Quantity Left',
                                         style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child:Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Total Sell",style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child:Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Total Buy",style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: 
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text("Status",
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child:  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Action",
                                               style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ]
                              ),
                             for (var index = 0; index < StoreDocs.length; index++)
                               (Responsive.isMobile(context)) 
                              ?
                              tableRowWidget_mobile(
                                "${StoreDocs[index]["name"]}",
                                "${StoreDocs[index]["parent_cate"]}",
                                "${StoreDocs[index]["status"]}",
                                 "${StoreDocs[index]["No_Of_Item"]}",
                                
                              )
                             :
                              tableRowWidget(
                                "${index + 1}",
                                "${StoreDocs[index]["name"]}",
                                "${StoreDocs[index]["parent_cate"]}",
                                "${StoreDocs[index]["status"]}",
                                "${StoreDocs[index]["No_Of_Item"]}",
                              )
                            ],
                      ),
              ],
            ),
          ),
        ],
      ),      
   );
}

  TableRow tableRowWidget(String  index, name , category ,_Status ,_Item ) {
    return
     TableRow(
      children: [

       TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child:Padding(
                padding: const EdgeInsets.all(5.0),
                child: 
                  Text(index,style: TextStyle(fontWeight: FontWeight.bold)),)
        
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
        child: 
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text("$category",style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text('$_Item',style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
       TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child:
       Text("100")
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child:Text("100")
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child:Padding(
          padding: const EdgeInsets.all(5.0),
          child: 
          
          Text("$_Status",style: 
          TextStyle(fontWeight: FontWeight.bold,
          color:
          (_Status == "Inactive" )
          ?
          Colors.red
          :
          (_Status == "Active" )
          ?
          Colors.green
          :
          Colors.white
          )
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child:
        RowFor_Mobile_web( context,"","Sell",Colors.green,"Buy",Colors.red),
        //  Padding(
        //   padding: const EdgeInsets.all(5.0),
        //   child: QRCode(qrSize: 80,qrData: '$name',),
        // ),
      ),
    
    ]);
  }


 TableRow tableRowWidget_mobile(String name,category , _Status ,_Item)
  {
    return 
    TableRow(
      children: [
       TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child:  
                    Row(
                      children: [
                           Container(
                            color: Colors.black,
                          margin: EdgeInsets.all(5),
                          height: 100,
                          width: 100,
                          child:QRCode(qrSize: 80,qrData: '$name'),
                        ),
          
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              themeListRow(context, "Name", "$name"),
                              themeListRow(context, "Category Name","$category"),
                              themeListRow(context, "Quantity Left","$_Item"),
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

                                   RowFor_Mobile_web( context,"","Sell",Colors.green,"Buy",Colors.red),
                                ],
                              ),
                              themeListRow(context, "Status","$_Status"),
                            ///  themeListRow(context, "Product QR","Product QR"),
                            Divider(thickness:2 ,)
                            ],
                          ),
                        ),
                       
                      ],
                    ),
          ),
      ]);
  
  }/////////




Widget RowFor_Mobile_web(BuildContext context,label,descSell,colorrSell, descBuy,colorrBuy){
  return
  Padding(
    padding: EdgeInsets.only(bottom: 4.0,),
    child:
       Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorrSell.withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                             _Action_Alert(context);
                            });
                          },
                          child: Text(
                            descSell,
                            style: TextStyle(color: colorrSell,),
                            
                          )) ////
                      ),
                  SizedBox(width: 10),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorrBuy.withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                             _Action_Alert(context);
                            });
                          },
                          child: Text(
                            descBuy,
                            style: TextStyle(color: colorrBuy,),
                            
                          )) ////
                      )
                ],
              )
    
  );

}








//////////////////   popup Box for Image selection ++++++++++++++++++++++++++++++++++++++ 

  void _Action_Alert(BuildContext context) {
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
                        "Totall Sell Product Info",
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
              content: SizedBox(
                height: 400,
                width: MediaQuery.of(context).size.width - 400,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                   
                      // if (!Responsive.isMobile(context))
                      // All_media(context, setStatee),
                      // if (Responsive.isMobile(context)) 
                      // All_media_mobile(context, setStatee)
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }



}/// Class CLose
