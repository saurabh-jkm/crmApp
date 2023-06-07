// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_final_fields, prefer_collection_literals, unused_field, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, deprecated_member_use, unnecessary_null_comparison, unnecessary_new, sort_child_properties_last, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:io';

import 'package:crm_demo/screens/order/product.dart';
import 'package:crm_demo/screens/order/syncPdf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';
import '../dashboard/components/header.dart';
import '../dashboard/components/my_fields.dart';
import '../dashboard/components/recent_files.dart';
import '../dashboard/components/storage_details.dart';
import 'package:file_picker/file_picker.dart';

import 'invoice_service.dart';
class OrderList extends StatefulWidget {
  const OrderList({super.key});
  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
   String _StatusValue = "Select";
 

 ///////////////////////////////////////////////////////////////////////////  
  final PdfInvoiceService service = PdfInvoiceService();
  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
  if (kIsWeb) {
     Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFview_Web_mobile(BytesCode: byteList),
                        ),
                      );              
    }
  else{
      final output = await getTemporaryDirectory();
       // print("$output   ++++++++");
         var filePath = "${output.path}/$fileName.pdf";
         final file = File(filePath);
        await   file.writeAsBytes(byteList);
      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFview_Web_mobile(BytesCode: byteList),
                        ),
                      );                 
  }      
  }
/// ===============================================================





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
           ListView(
                        children: [
                          Header(title: "Order",),
                          SizedBox(height: defaultPadding),
                          (_Details_wd == false)
                          ?
                          listList(context)
                          :
                           Details_view(context)
                        ],
                      )

    );
  }


////////   List       ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    var _number_select = 10;
    bool _Details_wd = false;
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
                    'Order List',
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
                            Text("Orders List",style: themeTextStyle(fw: FontWeight.bold,color: Colors.white,size: 15),),
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
                         //S.No.	OrderId	User	Product	Price	Payment Status	Delivery Status	Payment Date	Actions
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
                                        'OrderId',
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
                                        'User',
                                         style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: 
                                    Text(
                                        'Product',
                                         style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child:Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Price",style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child:Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Payment Status",style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: 
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text("Delivery Status",
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child:  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Payment Date",
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
                             for (var index = 0; index <= 5; index++)
                               (Responsive.isMobile(context)) 
                              ?
                              tableRowWidget_mobile(
                                "123",
                                "Saurabh Yadav",
                                "Nike Shoes",
                                "101 ₹",
                                "Payment Status",
                                "Delivery Status",
                                "12/08/2022",
                                
                              )
                             :
                              tableRowWidget(
                                "${index + 1}",
                                "123",
                                "Saurabh Yadav",
                                "Nike Shoes",
                                "101 ₹",
                                "Payment Status",
                                "Delivery Status",
                                "12/08/2022",
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

  TableRow tableRowWidget(String  index, odID , user ,_product,_price ,pro_status,del_status,pay_date ) {
    return
     TableRow(
      children: [

      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(index,style: TextStyle(fontWeight: FontWeight.normal)),
        ),
        
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: 
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text("$odID",style: TextStyle(fontWeight: FontWeight.normal)),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text('$user',style: TextStyle(fontWeight: FontWeight.normal)),
        ),
      ),
       TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child:
       Text("$_product",style: TextStyle(fontWeight: FontWeight.normal))
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child:Text("$_price",style: TextStyle(fontWeight: FontWeight.normal))
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child:Padding(
          padding: const EdgeInsets.all(10.0),
          child: 
               Container(
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child:  Text("Success",style:themeTextStyle(color: Colors.green))
              ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child:
       Padding(
         padding: const EdgeInsets.all(10.0),
         child: Container(
          height: 30,
                      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                     child: DropdownButton(
                                         hint: _StatusValue == null
                                             ? Text('Dropdown')
                                             : Text(
                                                 _StatusValue,
                                                 style: TextStyle(color: Colors.white),
                                               ),
                                         dropdownColor: Colors.white,      
                                         isExpanded: true,
                                         iconSize: 30.0,
                                         style: TextStyle(color: Colors.white),
                                         items: ['Pending','Processing', 
                                         'Confirm','Cancelled',
                                         'Out of Delivery','Delivered',"Return"].map(
                                           (val) {
                                             return DropdownMenuItem<String>(
                                               value: val,
                                               child: Text(val, style: TextStyle(color: Colors.black)),
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
       ),
        ),
      
        TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child:Text("$pay_date")
      ),

      
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: 

        RowFor_Mobile_web( 
        context,
               () {
                setState(() async{
                final data = await service.createInvoice();
                savePdfFile("invoice", data);
                });
              },
        (){
          setState(() {
            _Details_wd = true;
          });
        }
        ),
      ),
     
    ]);
  }


/////////////   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

 TableRow tableRowWidget_mobile(String  odID , user ,_product,_price ,pro_status,del_status,pay_date )
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
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // S.No.	OrderId	User	Product	Price	Payment Status	Delivery Status	Payment Date	Actions
                              themeListRow(context, "OrderId", odID),
                              themeListRow(context, "User Name","$user"),
                              themeListRow(context, "Product Name","$_product"),
                              themeListRow(context, "Price","$_price"),
                              themeListRow(context, "Payment Status","$pro_status"),
                              themeListRow(context, "Delivery Status","$del_status"),
                              themeListRow(context, "Payment Date","$pay_date"),
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
                          RowFor_Mobile_web( 
        context,
                () {
                setState(() async{
                final data = await service.createInvoice();
                savePdfFile("invoice", data);
                });
              },
        (){
          setState(() async{
            _Details_wd = true;
          });
        }
        ),
                                ],
                              ),
                            Divider(thickness:2 ,)
                            ],
                          ),
                        ),
                       
                      ],
                    ),
          ),
      ]);
  
  }
  /////////================================================================





/////////////////////////////////////  Row GOt Action Button  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
///

Widget RowFor_Mobile_web(BuildContext context,_invoice,_details_view){
  return
  Padding(
    padding: EdgeInsets.only(bottom: 4.0,),
    child:
       Row(
                children: [
                  Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: IconButton(onPressed: _invoice, icon:Icon(Icons.download,color: Colors.green,) ) 
              ),

              SizedBox(width: 10),
         
            Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: IconButton(
                  onPressed: _details_view,
                   icon:Icon(Icons.find_in_page_outlined,color: Colors.blue,) )  
              ),
                ],
              )
    
  );

}

/////////////////////////////////////////////=====================================================




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////   Detaials View ++++++++++++++++++++++++++++++++++++++++++++

    Widget Details_view(BuildContext context) {
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
           child: 
                 GestureDetector(
              onTap: (){
                setState(() {
                   _Details_wd = false;
                });

              },
              child:
           Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                  Icon(Icons.arrow_back,color: Colors.blue,size:25),
                  SizedBox(width: 10,),
                Text(
                    'Details',
                    style: themeTextStyle(
                    size: 18.0,
                    ftFamily: 'ms',
                    fw: FontWeight.bold,
                    color: Colors.blue),
                     ),
                  ],
                ),
                 )
         ),
         Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(thickness: 4,color: Colors.blue)),
          Container(
              padding: EdgeInsets.all(defaultPadding),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black12,
               // borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child:  Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("View Product" ,style: TextStyle(color: Colors.black),),
                    Divider(thickness: 2,color: Colors.black38)
                  ],
                ),
               Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Table(
                                border: TableBorder.all(
                                    color: Colors.black26, width: 1.5),
                                children: [
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Sr.",                   ///	Product	Order Id	Item	Price	Shipping
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Product",
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Order Id",
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold)),
                                    ),
                                     Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Item",
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold)),
                                    ),
                                     Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Price",
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold)),
                                    ),
                                     Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Shipping",
                                          style: themeTextStyle(
                                              color: Colors.black,
                                              size: 15,
                                              fw: FontWeight.bold)),
                                    ),
                                  ]),
                                  for (var i = 0; i < 1; i++)
                                    TableRow(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text("${i + 1}",
                                            style: themeTextStyle(
                                                color: Colors.black,
                                                size: 15,
                                                fw: FontWeight.normal)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                            "Nike Shoes"
                                                .toUpperCase(),
                                            style: themeTextStyle(
                                                color: Colors.black,
                                                size: 15,                                                     // Sizes   
                                            fw: FontWeight.normal)),
                                      ),
  

                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: 
                                        Text(
                                            "123",
                                                style: themeTextStyle(
                                                color: Colors.black,
                                                size: 15,
                                                fw: FontWeight.normal)),
                                      ),
                                        Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: 
                                        Text(
                                            "Red,Small",
                                                style: themeTextStyle(
                                                color: Colors.black,
                                                size: 15,
                                                fw: FontWeight.normal)),
                                      ),
                                        Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: 
                                        Text(
                                            "100",
                                                style: themeTextStyle(
                                                color: Colors.black,
                                                size: 15,
                                                fw: FontWeight.normal)),
                                      ),
                                         Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: 
                                        Text(
                                            "20",
                                                style: themeTextStyle(
                                                color: Colors.black,
                                                size: 15,
                                                fw: FontWeight.normal)),
                                      ),

                                    ]),
                                ],
                              ),
                             ),
                 SizedBox(height: 50),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 100),
                          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Text("Order Details",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black))
                            ],)
                          ],),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Text("Shipping Details",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black))
                          ],)
                        ],)
                      ],
                    ),
                  )
   

                        
              ],
            ),
          ),
        ],
      ),      
   );
}

}/// Class CLose
