// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_this, non_constant_identifier_names, unnecessary_cast, avoid_print, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, prefer_final_fields, override_on_non_overriding_member, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_null_comparison, unnecessary_brace_in_string_interps, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable, sort_child_properties_last, depend_on_referenced_packages, avoid_types_as_parameter_names, unused_field, curly_braces_in_flow_control_structures, prefer_is_empty, unnecessary_new, prefer_collection_literals, unused_local_variable, deprecated_member_use, camel_case_types

import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/screens/Invoice/invoice_widgets.dart';
import 'package:crm_demo/screens/product/product/product_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/generated/google/firestore/v1/document.pb.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../themes/function.dart';
import '../../../../constants.dart';
import '../../../../responsive.dart';
import '../../../../themes/firebase_Storage.dart';
import '../../../../themes/firebase_functions.dart';
import '../../../../themes/style.dart';
import '../../../../themes/theme_widgets.dart';
import '../dashboard/components/header.dart';
import '../product/product/product_widgets.dart';
import './../dashboard/components/my_fields.dart';
import './../dashboard/components/recent_files.dart';
import './../dashboard/components/storage_details.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:slug_it/slug_it.dart';
import 'package:intl/intl.dart';

import 'invoice_controller.dart';

class editInvoice extends StatefulWidget {
  final data;
  const editInvoice({super.key, this.data, required this.header_name});
  final String header_name;

  @override
  State<editInvoice> createState() => _editInvoiceState();
}

class _editInvoiceState extends State<editInvoice> {
  var documentId;
  bool isWait = true;
  // function get all list & name
  initList() async {
    await controller.init_functions(dbData: widget.data);

    setState(() {
      documentId = widget.data['id'];
      isWait = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (this.mounted) {
        initList();
      }
    });

    // key listner
    window.onKeyData = (final keyData) {
      if (keyData.character == 'D') {
        addNewProduct(context);
      }
      return false;
    };

    super.initState();
  }

  var controller = new invoiceController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            //header ======================
            themeHeader2(context, "${widget.header_name}",
                widthBack: 'updated'),
            // formField =======================
            (isWait)
                ? pleaseWait(context)
                : Form(
                    key: controller.formKeyInvoice,
                    child: Column(
                      children: <Widget>[
                        // Add TextFormFields and ElevatedButton here.
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    themeSpaceVertical(10.0),
                                    themeHeading2("Customer Details"),
                                    themeSpaceVertical(15.0),
                                    Row(
                                      children: [
                                        // fireld 1 ==========================
                                        // Expanded(
                                        //   child: autoCompleteFormInput(
                                        //       controller.ListName,
                                        //       "Product Name",
                                        //       controller.nameController,
                                        //       padding: 8.0),
                                        // ),
                                        Expanded(
                                            child: autoCompleteFormInput(
                                                controller.ListCustomer,
                                                "Customer Name",
                                                controller
                                                    .Customer_nameController,
                                                method: fnFetchCutomerDetails)),

                                        Expanded(
                                          child: formInput(
                                            context,
                                            "Mobile No.",
                                            controller
                                                .Customer_MobileController,
                                            padding: 8.0,
                                            isNumber: true,
                                          ),
                                        ),
                                        Expanded(
                                          child: formInput(
                                              context,
                                              "Email Id",
                                              controller
                                                  .Customer_emailController,
                                              padding: 8.0),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: formInput(
                                              context,
                                              "Address",
                                              controller
                                                  .Customer_AddressController,
                                              padding: 8.0),
                                        ),
                                        Expanded(
                                          child: formInput(
                                              context,
                                              "Invoice Date",
                                              controller.invoiceDateController,
                                              padding: 8.0),
                                        ),
                                        Expanded(child: Text("")),
                                        Expanded(child: Text("")),
                                      ],
                                    ),
                                    // 2nd row =============================================
                                    themeSpaceVertical(18.0),
                                    Divider(
                                      thickness: 2.0,
                                      color: Colors.black12,
                                    ),

                                    // 3nd row =============================================
                                    themeSpaceVertical(18.0),
                                    Row(
                                      children: [
                                        themeHeading2("Product Details"),
                                        SizedBox(width: 10.0),
                                        IconButton(
                                            onPressed: () {
                                              addNewProduct(context);
                                            },
                                            tooltip: "Add Product",
                                            icon: Icon(
                                              Icons.add,
                                              color: themeBG,
                                              size: 20.0,
                                            )),
                                        SizedBox(width: 10.0),
                                        (controller.totalProduct > 1)
                                            ? IconButton(
                                                onPressed: () {
                                                  removeRow(context);
                                                },
                                                tooltip: "Remove Product",
                                                icon: Icon(
                                                  Icons.remove,
                                                  color: Colors.red,
                                                  size: 20.0,
                                                ))
                                            : SizedBox(),
                                      ],
                                    ),
                                    // Header End ============================
                                    themeSpaceVertical(4.0),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              420,
                                      child: ListView(
                                        children: [
                                          for (var i = 1;
                                              i <= controller.totalProduct;
                                              i++)
                                            Container(
                                              color: Color.fromARGB(
                                                  106, 211, 234, 255),
                                              margin: EdgeInsets.only(
                                                  right: 8.0, bottom: 10.0),
                                              child: Row(
                                                children: [
                                                  // product Name
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                3 -
                                                            10,
                                                    child: autoCompleteFormInput(
                                                        controller.ListName,
                                                        "Products Name",
                                                        controller
                                                            // .Customer_nameController,
                                                            .ProductNameControllers[i],
                                                        padding: 8.0,
                                                        method: fnCalcualtePrice,
                                                        methodArg: i,
                                                        strinFilter: '- Out Of Stock'),
                                                  ),
                                                  // Price
                                                  Expanded(
                                                    child: formInput(
                                                        context,
                                                        "Price",
                                                        controller
                                                            // .Customer_nameController,
                                                            .ProductPriceControllers[i],
                                                        padding: 8.0,
                                                        isNumber: true),
                                                  ),

                                                  // Quantity
                                                  Expanded(
                                                    child: formInput(
                                                        context,
                                                        "Quantity",
                                                        controller
                                                            .ProductQuntControllers[i],
                                                        padding: 8.0,
                                                        isNumber: true,
                                                        method: fnTotalPrice,
                                                        methodArg: i),
                                                  ),

                                                  // GST
                                                  Expanded(
                                                    child: formInput(
                                                        context,
                                                        "GST (%)",
                                                        controller
                                                            .ProductGstControllers[i],
                                                        padding: 8.0,
                                                        isNumber: true),
                                                  ),

                                                  // Discount
                                                  Expanded(
                                                    child: formInput(
                                                        context,
                                                        "Discount",
                                                        controller
                                                            .ProductDiscountControllers[i],
                                                        padding: 8.0,
                                                        isNumber: true),
                                                  ),

                                                  // Total
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            4,
                                                    child: Row(
                                                      children: [
                                                        // sub total
                                                        Expanded(
                                                            child: totalWidgets(
                                                                context,
                                                                'Sub Total',
                                                                "${(controller.productDBdata[i] != null && controller.productDBdata[i]['gst'] != null) ? int.parse(controller.ProductTotalControllers[i]!.text) - int.parse(controller.productDBdata[i]['gst']) : '0'}")),
                                                        //GST
                                                        Expanded(
                                                            child: totalWidgets(
                                                                context,
                                                                'GST',
                                                                "${(controller.productDBdata[i] != null && controller.productDBdata[i]['gst'] != null) ? controller.productDBdata[i]['gst'] : '0'}")),
                                                        // Total
                                                        Expanded(
                                                            child: totalWidgets(
                                                                context,
                                                                'Total',
                                                                "${(controller.productDBdata[i] != null) ? controller.ProductTotalControllers[i]!.text : '0'}")),
                                                        // Expanded(
                                                        //     child: formInput(
                                                        //         context,
                                                        //         "Total",
                                                        //         controller
                                                        //             .ProductTotalControllers[i],
                                                        //         padding: 8.0,
                                                        //         isNumber: true)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    //field
                                  ],
                                )),
                              ),
                              SizedBox(width: defaultPadding),
                            ]),
                        // auto complete =================================

                        // buttom submit
                        themeSpaceVertical(20.0),
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Center(
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          controller.insertInvoiceDetails(
                                              context,
                                              docId: widget.data['id']);
                                          //setState(() {});
                                        },
                                        child: Text('Update')),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(right: 30.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "SubTotal : ",
                                                style:
                                                    themeTextStyle(size: 12.0),
                                              ),
                                              Text(
                                                "₹${controller.totalPrice - controller.totalGst}",
                                                style:
                                                    themeTextStyle(size: 15.0),
                                              )
                                            ],
                                          ),
                                          // GST
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "GST : ",
                                                style:
                                                    themeTextStyle(size: 12.0),
                                              ),
                                              Text(
                                                "₹${controller.totalGst}",
                                                style:
                                                    themeTextStyle(size: 15.0),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 30.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Total:",
                                            style: themeTextStyle(
                                                size: 20.0,
                                                fw: FontWeight.bold),
                                          ),
                                          Text(
                                            "₹${controller.totalPrice}",
                                            style: themeTextStyle(size: 25.0),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )

            // end form ====================================
          ],
        ),
      ),
    );
  }

  // Functions for setstate =================================================
  // Functions for setstate =================================================
  // Functions for setstate =================================================
  // Functions for setstate =================================================

  // add new Product
  addNewProduct(context) {
    setState(() {
      if (controller.totalProduct < 4) {
        controller.totalProduct++;
        controller.ctrNewRow(controller.totalProduct);
      }
    });
  }

  // remove new location
  removeRow(context) {
    setState(() {
      if (controller.totalProduct > 1) {
        controller.ctrRemoveRow(controller.totalProduct);
        controller.totalProduct--;
      }
    });
  }

  // get price & calculate
  fnCalcualtePrice(controllerId) async {
    var productName = controller.ProductNameControllers[controllerId]!.text;
    if (productName != '') {
      var rData = await controller.getProductDetails(productName);
      controller.productDBdata[controllerId] = rData;

      if (rData.isNotEmpty) {
        setState(() {
          controller.ProductPriceControllers[controllerId]!.text =
              (rData != null && rData['price'] != null) ? rData['price'] : 0;
          controller.ProductGstControllers[controllerId]!.text =
              (controller.ProductGstControllers[controllerId]!.text == '')
                  ? '18'
                  : controller.ProductGstControllers[controllerId]!.text;

          controller.ProductQuntControllers[controllerId]!.text =
              (controller.ProductQuntControllers[controllerId]!.text == '' ||
                      controller.ProductQuntControllers[controllerId]!.text ==
                          '0')
                  ? '1'
                  : controller.ProductQuntControllers[controllerId]!.text;

          controller.ProductDiscountControllers[controllerId]!.text =
              (controller.ProductDiscountControllers[controllerId]!.text == '')
                  ? '0'
                  : controller.ProductDiscountControllers[controllerId]!.text;
        });
        fnTotalPrice(controllerId);
      }
    }
  }

  // Fetch all detials
  fnFetchCutomerDetails() {
    var tName = controller.Customer_nameController.text;
    var tempData = (tName != '' && controller.CustomerArr[tName] != null)
        ? controller.CustomerArr[tName]
        : {};
    if (tempData.isNotEmpty) {
      controller.Customer_MobileController.text = tempData['mobile'];
      controller.Customer_emailController.text = tempData['email'];
      controller.Customer_AddressController.text = tempData['address'];
    }
  }

  // Total Price
  fnTotalPrice(controllerId) async {
    await controller.ctrTotalCalculate(controllerId);
    setState(() {});
  }
}

/// Class CLose