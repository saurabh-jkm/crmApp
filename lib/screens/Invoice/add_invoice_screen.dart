// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_this, non_constant_identifier_names, unnecessary_cast, avoid_print, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, prefer_final_fields, override_on_non_overriding_member, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_null_comparison, unnecessary_brace_in_string_interps, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable, sort_child_properties_last, depend_on_referenced_packages, avoid_types_as_parameter_names, unused_field, curly_braces_in_flow_control_structures, prefer_is_empty, unnecessary_new, prefer_collection_literals, unused_local_variable, deprecated_member_use, camel_case_types

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
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

class addInvoiceScreen extends StatefulWidget {
  const addInvoiceScreen({super.key, required this.header_name});
  final String header_name;

  @override
  State<addInvoiceScreen> createState() => _addInvoiceScreenState();
}

class _addInvoiceScreenState extends State<addInvoiceScreen> {
  bool isWait = true;
  // function get all list & name
  initList() async {
    await Incontroller.init_functions();
    setState(() {
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

    super.initState();
  }

  var Incontroller = new invoiceController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            //header ======================
            themeHeader2(context, "${widget.header_name}"),
            // formField =======================
            (isWait)
                ? pleaseWait(context)
                : Form(
                    key: Incontroller.formKeyInvoice,
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
                                          child: formInput(
                                              context,
                                              "Customer Name",
                                              Incontroller
                                                  .Customer_nameController,
                                              padding: 8.0),
                                        ),
                                        Expanded(
                                          child: formInput(
                                              context,
                                              "Mobile No.",
                                              Incontroller
                                                  .Customer_MobileController,
                                              padding: 8.0),
                                        ),
                                        Expanded(
                                          child: formInput(
                                              context,
                                              "Email Id",
                                              Incontroller
                                                  .Customer_emailController,
                                              padding: 8.0),
                                        ),
                                        // fireld 2 ==========================
                                        // Expanded(
                                        //   child: autoCompleteFormInput(
                                        //       Incontroller.ListCategory,
                                        //       "Category",
                                        //       Incontroller.categoryController,
                                        //       padding: 8.0),
                                        // ),

                                        // // fireld 3 ==========================
                                        // Expanded(
                                        //   child: Row(
                                        //     children: [
                                        //       Expanded(
                                        //         child: formInput(context, "Quantity",
                                        //             Incontroller.quantityController,
                                        //             padding: 8.0),
                                        //       ),
                                        //       Expanded(
                                        //         child: formInput(context, "Price",
                                        //             Incontroller.priceController,
                                        //             padding: 8.0),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: formInput(
                                              context,
                                              "Address",
                                              Incontroller
                                                  .Customer_AddressController,
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
                                    // Row(children: [
                                    //   themeHeading2("Attributes"),
                                    //   SizedBox(width: 10.0),
                                    //   IconButton(
                                    //       onPressed: () {
                                    //         addNewAttrbute(
                                    //             context,
                                    //             Incontroller.newAttributeController,
                                    //             addNewAttFn);
                                    //       },
                                    //       tooltip: "Add New Attribute",
                                    //       icon: Icon(
                                    //         Icons.add,
                                    //         color: themeBG,
                                    //         size: 20.0,
                                    //       )),
                                    // ]),
                                    // themeSpaceVertical(4.0),
                                    // Row(
                                    //   children: [
                                    //     for (String key
                                    //         in Incontroller.dynamicControllers.keys)
                                    //       Expanded(
                                    //         child: autoCompleteFormInput(
                                    //             Incontroller
                                    //                 .ListAttribute[key.toLowerCase()],
                                    //             "${capitalize(key)}",
                                    //             Incontroller.dynamicControllers[key],
                                    //             padding: 8.0),
                                    //       ),
                                    //   ],
                                    // ),

                                    // 3nd row =============================================
                                    themeSpaceVertical(18.0),
                                    Row(
                                      children: [
                                        themeHeading2("Product Details"),
                                        SizedBox(width: 10.0),
                                        IconButton(
                                            onPressed: () {
                                              addNewLocation(context);
                                            },
                                            tooltip: "Add Product",
                                            icon: Icon(
                                              Icons.add,
                                              color: themeBG,
                                              size: 20.0,
                                            )),
                                        SizedBox(width: 10.0),
                                        (Incontroller.totalProduct > 1)
                                            ? IconButton(
                                                onPressed: () {
                                                  removeLocation(context);
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
                                    themeSpaceVertical(4.0),
                                    Column(
                                      children: [
                                        for (var i = 1;
                                            i <= Incontroller.totalProduct;
                                            i++)
                                          Container(
                                            color: Color.fromARGB(
                                                106, 211, 234, 255),
                                            margin: EdgeInsets.only(
                                                right: 8.0, bottom: 10.0),
                                            child: Row(
                                              children: [
                                                // product Name
                                                Expanded(
                                                  child: autoCompleteFormInput(
                                                      Incontroller.ListName,
                                                      "Products Name",
                                                      Incontroller
                                                          // .Customer_nameController,
                                                          .ProductNameControllers[i],
                                                      padding: 8.0),
                                                ),
                                                // Price
                                                Expanded(
                                                  child: autoCompleteFormInput(
                                                      Incontroller.ListName,
                                                      "Price",
                                                      Incontroller
                                                          // .Customer_nameController,
                                                          .ProductNameControllers[i],
                                                      padding: 8.0),
                                                ),

                                                // Quantity
                                                Expanded(
                                                  child: autoCompleteFormInput(
                                                      Incontroller.ListName,
                                                      "Quantity",
                                                      Incontroller
                                                          // .Customer_nameController,
                                                          .ProductNameControllers[i],
                                                      padding: 8.0),
                                                ),

                                                // GST
                                                Expanded(
                                                  child: autoCompleteFormInput(
                                                      Incontroller.ListName,
                                                      "GST",
                                                      Incontroller
                                                          // .Customer_nameController,
                                                          .ProductNameControllers[i],
                                                      padding: 8.0),
                                                ),

                                                // Discount
                                                Expanded(
                                                  child: autoCompleteFormInput(
                                                      Incontroller.ListName,
                                                      "Discount",
                                                      Incontroller
                                                          // .Customer_nameController,
                                                          .ProductNameControllers[i],
                                                      padding: 8.0),
                                                ),

                                                // Total
                                                Expanded(
                                                  child: autoCompleteFormInput(
                                                      Incontroller.ListName,
                                                      "Total",
                                                      Incontroller
                                                          // .Customer_nameController,
                                                          .ProductNameControllers[i],
                                                      padding: 8.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
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
                          child: Center(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    Incontroller.insertInvoiceDetails(context);
                                    //setState(() {});
                                  },
                                  child: Text('Submit'))),
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
  addNewLocation(context) {
    setState(() {
      if (Incontroller.totalProduct < 4) {
        Incontroller.totalProduct++;
        Incontroller.ProductNameControllers[Incontroller.totalProduct] =
            TextEditingController();
      }
    });
  }

  // remove new location
  removeLocation(context) {
    setState(() {
      if (Incontroller.totalProduct > 1) {
        Incontroller.ProductNameControllers.remove(Incontroller.totalProduct);
        Incontroller.totalProduct--;
      }
    });
  }
}

/// Class CLose
