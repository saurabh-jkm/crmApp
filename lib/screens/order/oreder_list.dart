// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

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
class OrderList extends StatefulWidget {
  const OrderList({super.key});
  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  Map<String, TextEditingController> _controllers = new Map();
   String _dropDownValue = "Select";
   String _StatusValue = "Select";
  
 // File Picker ==========================================================
         // Codec<String, String> stringToBase64 = utf8.fuse(base64);
  var uploadedDoc;
// result;
  String? fileName;
  PlatformFile? pickedfile;
  bool isLoading = false;
  File? fileToDisplay;

  void clear_upload() {
    fileName = null;
  }

  pickFile() async {
    //print("yes");
    try {
      setState(() {
        isLoading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpeg', 'jpg', 'pdf'],
        allowMultiple: false,
      );

      if (result != null) {
        fileName = result.files.first.name;
        pickedfile = result.files.first;
        fileToDisplay = File(pickedfile!.path.toString());
        setState(() {
          List<int> imageBytes = fileToDisplay!.readAsBytesSync();
          uploadedDoc = base64Encode(imageBytes);
          _controllers['doc'] = uploadedDoc;
        });
      print('File name $uploadedDoc');
      }
      setState(() {
        isLoading = false;
        
      });
    } catch (e) {
      print(e);
    }
  }

/// 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
    ListView(
                        children: [
                          Header(title: "Order",),
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
            "Order List",
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
                  Expanded(child: Text("Order Id",style: TextStyle(fontWeight: FontWeight.bold)),),
                  Expanded(child: Text("Price",style: TextStyle(fontWeight: FontWeight.bold)),),
                   Expanded(child: Text("Payment Status",style: TextStyle(fontWeight: FontWeight.bold)),),
                    Expanded(child: Text("Delivery Status",style: TextStyle(fontWeight: FontWeight.bold)),),
                     Expanded(child: Text("Payment Date",style: TextStyle(fontWeight: FontWeight.bold)),)
                      ,Expanded(child: Text("Invoice",style: TextStyle(fontWeight: FontWeight.bold)),)
                      ,
                       Expanded(child: Text("Refund Status",style: TextStyle(fontWeight: FontWeight.bold)),),
                      Expanded(child: Text("Actions",style: TextStyle(fontWeight: FontWeight.bold)),)
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
         Expanded(child: Text("Nik_200")),
         Expanded(child: Text("200rs")),
         Expanded(child:
         Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child:  Text("Success",style:themeTextStyle(color: Colors.green))
              ),
         
          ),

        Expanded(child: 
        Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                 child: DropdownButton(
                                     hint: _StatusValue == null
                                         ? Text('Dropdown')
                                         : Text(
                                             _StatusValue,
                                             style: TextStyle(color: Colors.blue),
                                           ),
                                     isExpanded: true,
                                     iconSize: 30.0,
                                     style: TextStyle(color: Colors.white),
                                     items: ['Pending','Processing', 
                                     'Confirm','Cancelled',
                                     'Out of Delivery','Delivered',"Return"].map(
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
        )  ,
         Expanded(child: Text("20/12/2022")),
         Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child:  Icon(Icons.download,color: Colors.green,)
              ),
          Expanded(child: Text("200rs")),
          Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child:  Icon(Icons.delete_outline_outlined,color: Colors.red,)
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
