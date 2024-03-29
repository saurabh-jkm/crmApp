// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_this, non_constant_identifier_names, unnecessary_cast, avoid_print, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, prefer_final_fields, override_on_non_overriding_member, sized_box_for_whitespace, unnecessary_string_interpolations, unnecessary_null_comparison, unnecessary_brace_in_string_interps, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable, sort_child_properties_last, depend_on_referenced_packages, avoid_types_as_parameter_names, unused_field, curly_braces_in_flow_control_structures, prefer_is_empty, unnecessary_new, prefer_collection_literals, unused_local_variable, deprecated_member_use, unused_element, camel_case_types, await_only_futures, deprecated_colon_for_default_value, prefer_if_null_operators

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:jkm_crm_admin/screens/Balance/balance_list.dart';
import 'package:jkm_crm_admin/screens/Login_Reg/login_screen.dart';
import 'package:jkm_crm_admin/screens/Profile/profile_details.dart';
import 'package:jkm_crm_admin/screens/Selsman/Track_History/track_list.dart';
import 'package:jkm_crm_admin/screens/category/category_add.dart';
import 'package:jkm_crm_admin/screens/dashboard/dashboard_screen.dart';
import 'package:jkm_crm_admin/themes/style.dart';
import 'package:jkm_crm_admin/themes/theme_footer.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../themes/global.dart';
import '../../themes/theme_header.dart';
import '../../themes/theme_widgets.dart';
import '../Selsman/WorkAlot/salesman_list.dart';
import '../Sub Admin/Add_SubAdmin.dart';

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: clientAppBar(),
      ),
      bottomNavigationBar: theme_footer_android(context, 3),
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          children: [
            if (is_mobile) themeHeader_android(context, title: "More"),
            // SizedBox(height: 20.0),
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
                title: "Sub Admin",
                icon: Icons.admin_panel_settings_outlined, route: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SubAdmin()));
            }),
            menut_list(context,
                title: "My Profile",
                icon: Icons.supervised_user_circle_sharp, route: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ProfileDetails()));
            }),
            menut_list(context, title: "Log Out", icon: Icons.logout,
                route: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.clear();
              await themeAlert(context, "Successfully Logout !!");
              await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Login_Copy() //Home()
                      ));
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
            Icon(icon, color: themeBG4),
            SizedBox(width: 20.0),
            Text("$title",
                style: themeTextStyle(
                    size: 13.0, color: const Color.fromARGB(255, 73, 73, 73)))
          ],
        ),
      ),
    );
  }
}
/// Class CLose
