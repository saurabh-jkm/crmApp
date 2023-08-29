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
import 'product_widgets.dart';

class editStockScreen extends StatefulWidget {
  final data;
  const editStockScreen({super.key, this.data});

  @override
  State<editStockScreen> createState() => _editStockScreenState();
}

class _editStockScreenState extends State<editStockScreen> {
  var documentId;
  // function get all list & name
  initList() async {
    await controller.init_functions();

    // update all controllers
    documentId = widget.data['id'];
    controller.nameController.text = widget.data['name'];
    controller.categoryController.text = widget.data['category'];
    controller.quantityController.text = widget.data['quantity'];
    controller.priceController.text = widget.data['price'];

    controller.dynamicControllers.forEach((k, v) {
      if (widget.data[k] != null) {
        controller.dynamicControllers[k]?.text = widget.data[k];
      }
    });

    var i = 1;
    widget.data['item_location'].forEach((k, v) {
      controller.totalLocation = i;
      if (i == 1) {
        controller.locationControllers['${i}']!.text = k;
        controller.locationQuntControllers['${i}']!.text = v;
      } else {
        controller.locationControllers['${i}'] = TextEditingController();
        controller.locationQuntControllers['${i}'] = TextEditingController();

        controller.locationControllers['${i}']!.text = k;
        controller.locationQuntControllers['${i}']!.text = v;
      }

      i++;
    });

    setState(() {});
  }

  @override
  void initState() {
    print(widget.data);
    // TODO: implement initState
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (this.mounted) {
    //     initList();
    //   }
    // });

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
                          Row(children: [
                            themeHeading2("Attributes"),
                            SizedBox(width: 10.0),
                            IconButton(
                                onPressed: () {
                                  addNewAttrbute(
                                      context,
                                      controller.newAttributeController,
                                      addNewAttFn);
                                },
                                tooltip: "Add New Attribute",
                                icon: Icon(
                                  Icons.add,
                                  color: themeBG,
                                  size: 20.0,
                                )),
                          ]),
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
                                  onPressed: () {
                                    addNewLocation(context);
                                  },
                                  tooltip: "Add Location",
                                  icon: Icon(
                                    Icons.add,
                                    color: themeBG,
                                    size: 20.0,
                                  )),
                              SizedBox(width: 10.0),
                              (controller.totalLocation > 1)
                                  ? IconButton(
                                      onPressed: () {
                                        removeLocation(context);
                                      },
                                      tooltip: "Remove Location",
                                      icon: Icon(
                                        Icons.remove,
                                        color: Colors.red,
                                        size: 20.0,
                                      ))
                                  : SizedBox(),
                            ],
                          ),
                          themeSpaceVertical(4.0),
                          Row(
                            children: [
                              for (var i = 1;
                                  i <= controller.totalLocation;
                                  i++)
                                Container(
                                  color: Color.fromARGB(106, 211, 234, 255),
                                  margin: EdgeInsets.only(right: 8.0),
                                  width: MediaQuery.of(context).size.width /
                                          controller.totalLocation -
                                      30,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: formInput(
                                            context,
                                            "Location",
                                            controller
                                                .locationControllers['$i'],
                                            padding: 8.0),
                                      ),
                                      Container(
                                        width: 120.0,
                                        child: formInput(
                                            context,
                                            "Quantity",
                                            controller
                                                .locationQuntControllers['$i'],
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
                              controller.insertProduct(context,
                                  docId: documentId);
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

  addNewAttFn(context) async {
    // add new Attribute
    await controller.fnAddAttribute(context);
    setState(() {});
  }

  // add new location
  addNewLocation(context) {
    setState(() {
      if (controller.totalLocation < 4) {
        controller.totalLocation++;
        controller.locationControllers['${controller.totalLocation}'] =
            TextEditingController();
        controller.locationQuntControllers['${controller.totalLocation}'] =
            TextEditingController();
      }
    });
  }

  // remove new location
  removeLocation(context) {
    setState(() {
      if (controller.totalLocation > 1) {
        controller.locationControllers.remove('${controller.totalLocation}');
        controller.locationQuntControllers
            .remove('${controller.totalLocation}');
        controller.totalLocation--;
      }
    });
  }
}

/// Class CLose
