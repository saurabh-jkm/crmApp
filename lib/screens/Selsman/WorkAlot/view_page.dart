// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_this, non_constant_identifier_names, unnecessary_cast, avoid_print, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, prefer_final_fields, override_on_non_overriding_member, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_null_comparison, unnecessary_brace_in_string_interps, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable, sort_child_properties_last, depend_on_referenced_packages, avoid_types_as_parameter_names, unused_field, curly_braces_in_flow_control_structures, prefer_is_empty, unnecessary_new, prefer_collection_literals, unused_local_variable, deprecated_member_use, camel_case_types

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../themes/function.dart';
import '../../../../themes/firebase_functions.dart';
import '../../../../themes/style.dart';
import '../../../../themes/theme_widgets.dart';

import 'package:intl/intl.dart';

import '../../product/product/product_widgets.dart';

class MeetingView extends StatefulWidget {
  const MeetingView({super.key, required this.MapData});

  final MapData;

  @override
  State<MeetingView> createState() => _MeetingViewState();
}

class _MeetingViewState extends State<MeetingView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_history_rounded,
                    color: Colors.green,
                    size: 30,
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    "Meeting Details",
                    style: GoogleFonts.alike(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            // formField =======================
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Colors.black,
                thickness: 1.5,
              ),
            ),
            Details_view(context, widget.MapData)
            // end form ====================================
          ],
        ),
      ),
    );
  }

  Widget Details_view(BuildContext context, priceData) {
    var date;
    var status;
    date = formatDate(priceData["date_at"]);
    status = statusOF(priceData["status"]);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.black12,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              image: DecorationImage(
                  image: (priceData["image"])
                      ? NetworkImage("${priceData["image"]}")
                      : NetworkImage(
                          "https://i.pinimg.com/736x/ec/14/7c/ec147c4c53abfe86df2bc7e70c0181ff.jpg"),
                  fit: BoxFit.cover)),
        ),
        productRow(context, "Meeting Id", "${priceData["id"]}"),
        productRow(context, "Customer Name", "${priceData["customer_name"]}"),
        productRow(context, "Mobile No.", "${priceData["mobile"]}"),
        productRow(context, "Email ID", "${priceData["email"]}"),
        productRow(context, "Address", "${priceData["address"]}"),
        productRow(context, "Status", status),
        productRow(context, "Date At", date),
        Divider(thickness: 1.5),
        productRow(
            context, "Meeting Comment", priceData["meeting_conversation"]),
        Divider(thickness: 1.5),
        productRow(context, "Next Follow Up", priceData["next_follow_up"]),
      ]),
    );
  }
}

/// Class CLose
