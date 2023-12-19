// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_this, non_constant_identifier_names, unnecessary_cast, avoid_print, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, prefer_final_fields, override_on_non_overriding_member, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_null_comparison, unnecessary_brace_in_string_interps, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable, sort_child_properties_last, depend_on_referenced_packages, avoid_types_as_parameter_names, unused_field, curly_braces_in_flow_control_structures, prefer_is_empty, unnecessary_new, prefer_collection_literals, unused_local_variable, deprecated_member_use, unused_element, camel_case_types, await_only_futures, deprecated_colon_for_default_value, prefer_if_null_operators

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:crm_demo/screens/Balance/balance_list.dart';
import 'package:crm_demo/screens/Profile/profile_details.dart';
import 'package:crm_demo/screens/Selsman/Track_History/track_list.dart';
import 'package:crm_demo/screens/category/category_add.dart';
import 'package:crm_demo/screens/dashboard/dashboard_screen.dart';
import 'package:crm_demo/themes/style.dart';
import 'package:crm_demo/themes/theme_footer.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import '../Selsman/WorkAlot/salesman_list.dart';

class More_screen extends StatefulWidget {
  const More_screen({super.key});

  @override
  State<More_screen> createState() => _More_screenState();
}

class _More_screenState extends State<More_screen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: theme_appbar(context, title: "Settings"),
      bottomNavigationBar: theme_footer_android(context, 3),
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          children: [
            // menut_list(context,
            //     title: "Category", icon: Icons.category_outlined, route: () {
            //   Navigator.push(
            //       context, MaterialPageRoute(builder: (_) => CategoryAdd()));
            // }),
            menut_list(context,
                title: "All Outstanding",
                icon: Icons.account_balance_wallet_outlined, route: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => BalanceList()));
            }),
            menut_list(context,
                title: "Salesman Routs",
                icon: Icons.pin_drop_outlined, route: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => TrackHistory()));
            }),
            menut_list(context,
                title: "Salesman Meeting", icon: Icons.meeting_room, route: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SalemanList()));
            }),
            menut_list(context,
                title: "My Profile",
                icon: Icons.supervised_user_circle_sharp, route: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ProfileDetails()));
            }),
          ],
        ),
      ),
    );
  }

  // ===============================================
  Widget menut_list(context, {title, icon, route}) {
    return InkWell(
      onTap: route,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
          children: [
            Icon(icon, color: themeBG3),
            SizedBox(width: 10.0),
            Text("$title", style: themeTextStyle(color: themeBG3))
          ],
        ),
      ),
    );
  }
}
/// Class CLose
