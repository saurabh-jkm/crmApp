// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_this, non_constant_identifier_names, unnecessary_cast, avoid_print, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, prefer_final_fields, override_on_non_overriding_member, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_null_comparison, unnecessary_brace_in_string_interps, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable, sort_child_properties_last, depend_on_referenced_packages, avoid_types_as_parameter_names, unused_field, curly_braces_in_flow_control_structures, prefer_is_empty, unnecessary_new, prefer_collection_literals, unused_local_variable, deprecated_member_use

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/screens/product/product/product_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/generated/google/firestore/v1/document.pb.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../themes/function.dart';
import '../../../../constants.dart';
import '../../../../responsive.dart';
import '../../../../themes/firebase_Storage.dart';
import '../../../../themes/firebase_functions.dart';
import '../../../../themes/style.dart';
import '../../../../themes/theme_widgets.dart';
import '../../dashboard/components/header.dart';
import '../../dashboard/components/my_fields.dart';
import '../../dashboard/components/recent_files.dart';
import '../../dashboard/components/storage_details.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:slug_it/slug_it.dart';
import 'package:intl/intl.dart';
import 'stock_header.dart';

class addStockScreen extends StatefulWidget {
  const addStockScreen({super.key});

  @override
  State<addStockScreen> createState() => _addStockScreenState();
}

class _addStockScreenState extends State<addStockScreen> {
  // function get all list & name
  initList() async {
    await controller.init_functions();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    initList();
    super.initState();
  }

  var controller = new ProductController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            //header ======================
            themeHeader2(context, "Add New Stock"),
            // formField =======================
            Form(
              key: controller.formKey,
              child: Column(
                children: <Widget>[
                  // Add TextFormFields and ElevatedButton here.
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          themeSpaceVertical(10.0),
                          themeHeading2("Basic Details"),
                          themeSpaceVertical(15.0),
                          Row(
                            children: [
                              // fireld 1 ==========================
                              Expanded(
                                child: autoCompleteFormInput(
                                    controller.ListName,
                                    "Product Name",
                                    controller.nameController,
                                    padding: 8.0),
                              ),

                              // fireld 2 ==========================
                              Expanded(
                                child: autoCompleteFormInput(
                                    controller.ListCategory,
                                    "Category",
                                    controller.categoryController,
                                    padding: 8.0),
                              ),

                              // fireld 3 ==========================
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: formInput(context, "Quantity",
                                          controller.quantityController,
                                          padding: 8.0),
                                    ),
                                    Expanded(
                                      child: formInput(context, "Price",
                                          controller.priceController,
                                          padding: 8.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // 2nd row =============================================
                          themeSpaceVertical(18.0),
                          themeHeading2("Attributes"),
                          themeSpaceVertical(4.0),
                          Row(
                            children: [
                              for (String key
                                  in controller.dynamicControllers.keys)
                                Expanded(
                                  child: autoCompleteFormInput(
                                      controller
                                          .ListAttribute[key.toLowerCase()],
                                      "${capitalize(key)}",
                                      controller.dynamicControllers[key],
                                      padding: 8.0),
                                ),
                            ],
                          ),

                          // 3nd row =============================================
                          themeSpaceVertical(18.0),
                          Row(
                            children: [
                              themeHeading2("Product Location"),
                              SizedBox(width: 10.0),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.add,
                                    color: themeBG,
                                    size: 20.0,
                                  )),
                            ],
                          ),
                          themeSpaceVertical(4.0),
                          Row(
                            children: [
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 10,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: formInput(context, "Location",
                                          controller.locationControllers['1'],
                                          padding: 8.0),
                                    ),
                                    Expanded(
                                      child: formInput(
                                          context,
                                          "Quantity",
                                          controller
                                              .locationQuntControllers['1'],
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
                      child: themeButton3(context, controller.insertProduct,
                          arg: context,
                          label: 'Submit',
                          btnHeightSize: 45.0,
                          radius: 8.0),
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
}

/// Class CLose
