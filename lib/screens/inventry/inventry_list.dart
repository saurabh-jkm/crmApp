// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, deprecated_member_use

import 'dart:convert';
import 'dart:io';

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

  
/// 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
    ListView(
                        children: [
                          Header(title: "Inventry",),
                          SizedBox(height: defaultPadding),
                          
                       
                           listList(context),
                          
                         
                        ],
                      )
        
      

      
    );
  }






//// Widget for Start_up

  Widget listList(BuildContext context) {
    return
    
    Container(
      // height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Product Inventry List",
            style: Theme.of(context).textTheme.subtitle1,
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 20 ,horizontal: 5),
            width: double.infinity,
            child:
            Column(
              children: [
               Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                  child: Text("S.No.",style: TextStyle(fontWeight: FontWeight.bold),),),
                  Expanded(child: Text("Name",style: TextStyle(fontWeight: FontWeight.bold)),),
                  Expanded(child: Text("Category Name",style: TextStyle(fontWeight: FontWeight.bold)),),
                  Expanded(child: Text("Quantity Left",style: TextStyle(fontWeight: FontWeight.bold)),),
                   Expanded(child: Text("Total Sell",style: TextStyle(fontWeight: FontWeight.bold)),),
                    Expanded(child: Text("Status",style: TextStyle(fontWeight: FontWeight.bold)),),
                    
                ]
                ,    
               ),
               SizedBox(height: 20,),
               Divider(thickness: 1.5,),

                for( var index = 1; index < 10; index ++) 
                recentFileDataRow(context,"$index"),

              ],
            )
          ),
        ],
      ),
    );
  }  





  Widget recentFileDataRow(BuildContext context,sno) {
  return 
  Container(
    // margin: EdgeInsets.only(top: 5),
    child: Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
         Expanded(child: Text("$sno")),
         Expanded(child: Text("Nike tshirt")),
         Expanded(child: Text("cloth")),
         Expanded(child: Text("200")),
         Expanded(child: Text("10")),
         Expanded(child:
         Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child:  Text("Active",style:themeTextStyle(color: Colors.green))
              ),
         
          ),

          ],
        ),

      Divider(thickness: 1.5,)
      ],
    ),
  );
}
/////////

}/// Class CLose
