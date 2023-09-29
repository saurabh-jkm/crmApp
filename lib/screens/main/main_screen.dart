// ignore_for_file: prefer_const_constructors, sort_child_properties_last, non_constant_identifier_names, use_key_in_widget_constructors, annotate_overrides, prefer_typing_uninitialized_variables, unused_element

import 'dart:convert';

import 'package:crm_demo/screens/customers/customers_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/MenuAppController.dart';
import '../../responsive.dart';
import '../About/about_us.dart';
import '../Attributes/attribute_add.dart';
import '../Invoice/invoice_list.dart';
import '../Profile/profile_details.dart';
import '../Sub Admin/Add_SubAdmin.dart';
import '../Track_History/track_list.dart';
import '../category/category_add.dart';
import '../dashboard/dashboard_screen.dart';
import '../inventry/inventry_list.dart';
import '../order/oreder_list.dart';
import '../product/product_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({required this.pageNo}) : super();
  final int pageNo;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var sidemenu;

  Map<dynamic, dynamic> user = new Map();
  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userData = (prefs.getString('user'));
    if (userData != null) {
      setState(() {
        user = jsonDecode(userData) as Map<dynamic, dynamic>;
        // print("$user  ++++tttt+++");
      });
    }
  }

  @override
  void initState() {
    setState(() {
      sidemenu = widget.pageNo;
      _getUser();
    });
    super.initState();
  }

  ////////
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: WdSideMenu(context),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                child: WdSideMenu(context),
              ),
            if (sidemenu == 1)
              Expanded(
                flex: 5,
                child: DashboardScreen(),
              )
            else if (sidemenu == 2)
              Expanded(
                flex: 5,
                child: CategoryAdd(),
              )
            else if (sidemenu == 3)
              Expanded(
                flex: 5,
                child: AttributeAdd(),
              )
            // else if (sidemenu == 4)
            //   Expanded(
            //     flex: 5,
            //     child: ProductAdd(),
            //   )
            else if (sidemenu == 4)
              Expanded(
                flex: 5,
                child: ProductAdd(),
              )
            else if (sidemenu == 5)
              Expanded(
                flex: 5,
                child: Invoice_List(),
              )
            else if (sidemenu == 6)
              Expanded(
                flex: 5,
                child: OrderList(),
              )
            else if (sidemenu == 7)
              Expanded(flex: 5, child: InventryList())
            else if (sidemenu == 8)
              Expanded(flex: 5, child: TrackHistory())
            else if (sidemenu == 9)
              Expanded(flex: 5, child: ProfileDetails())
            // else if (sidemenu == 9)
            //   Expanded(flex: 5, child: AboutUs()
            //       //LoginPage()

            //       ///SignupScreen()
            //       )
            else if (sidemenu == 10)
              Expanded(flex: 5, child: SubAdmin())
            // All customer list
            else if (sidemenu == 11)
              Expanded(flex: 5, child: CustomerList())
          ],
        ),
      ),
    );
  }

  Widget WdSideMenu(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo-2.png"),
            decoration: BoxDecoration(
                //  color: const Color.fromARGB(127, 33, 149, 243)
                ),
          ),
          ListTile(
            tileColor: (sidemenu == 1)
                ? const Color.fromARGB(127, 33, 149, 243)
                : const Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                sidemenu = 1;
                if (Responsive.isMobile(context)) {
                  Navigator.of(context).pop();
                }
              });
            },
            horizontalTitleGap: 0.0,
            leading: Icon(Icons.dashboard_outlined, color: Colors.white),
            title: Text(
              "Dashboard",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            tileColor: (sidemenu == 2)
                ? const Color.fromARGB(127, 33, 149, 243)
                : const Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                sidemenu = 2;
                if (Responsive.isMobile(context)) {
                  Navigator.of(context).pop();
                }
              });
            },
            horizontalTitleGap: 0.0,
            leading: Icon(Icons.category_outlined, color: Colors.white),
            title: Text(
              "Category",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            tileColor: (sidemenu == 3)
                ? const Color.fromARGB(127, 33, 149, 243)
                : const Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                sidemenu = 3;
                if (Responsive.isMobile(context)) {
                  Navigator.of(context).pop();
                }
              });
            },
            horizontalTitleGap: 0.0,
            leading: Icon(Icons.account_tree_outlined, color: Colors.white),
            title: Text(
              "Attribute",
              style: TextStyle(color: Colors.white),
            ),
          ),

          ListTile(
            tileColor: (sidemenu == 4)
                ? const Color.fromARGB(127, 33, 149, 243)
                : const Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                sidemenu = 4;
                if (Responsive.isMobile(context)) {
                  Navigator.of(context).pop();
                }
              });
            },
            horizontalTitleGap: 0.0,
            leading: Icon(Icons.production_quantity_limits_outlined,
                color: Colors.white),
            title: Text(
              "Stocks",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            tileColor: (sidemenu == 5)
                ? const Color.fromARGB(127, 33, 149, 243)
                : const Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                sidemenu = 5;
                if (Responsive.isMobile(context)) {
                  Navigator.of(context).pop();
                }
              });
            },
            horizontalTitleGap: 0.0,
            leading: Icon(Icons.bar_chart, color: Colors.white),
            title: Text(
              "Buy/Sales",
              style: TextStyle(color: Colors.white),
            ),
          ),

          // All Customers
          ListTile(
            tileColor: (sidemenu == 11)
                ? const Color.fromARGB(127, 33, 149, 243)
                : const Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                sidemenu = 11;
                if (Responsive.isMobile(context)) {
                  Navigator.of(context).pop();
                }
              });
            },
            horizontalTitleGap: 0.0,
            leading: Icon(Icons.supervised_user_circle_outlined,
                color: Colors.white),
            title: Text(
              "All Customers",
              style: TextStyle(color: Colors.white),
            ),
          ),

          ListTile(
            tileColor: (sidemenu == 8)
                ? const Color.fromARGB(127, 33, 149, 243)
                : const Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                sidemenu = 8;
                if (Responsive.isMobile(context)) {
                  Navigator.of(context).pop();
                }
              });
            },
            horizontalTitleGap: 0.0,
            leading: Icon(Icons.location_history, color: Colors.white),
            title: Text(
              "Track History",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            tileColor: (sidemenu == 9)
                ? const Color.fromARGB(127, 33, 149, 243)
                : const Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                sidemenu = 9;
                if (Responsive.isMobile(context)) {
                  Navigator.of(context).pop();
                }
              });
            },
            horizontalTitleGap: 0.0,
            leading: Icon(Icons.person, color: Colors.white),
            title: Text(
              "Profile",
              style: TextStyle(color: Colors.white),
            ),
          ),
          // ListTile(
          //   tileColor: (sidemenu == 9)
          //       ? const Color.fromARGB(127, 33, 149, 243)
          //       : const Color.fromARGB(0, 255, 255, 255),
          //   onTap: () {
          //     setState(() {
          //       sidemenu = 9;
          //       if (Responsive.isMobile(context)) {
          //         Navigator.of(context).pop();
          //       }
          //     });
          //   },
          //   horizontalTitleGap: 0.0,
          //   leading: Icon(Icons.description_sharp, color: Colors.white),
          //   title: Text(
          //     "About Us",
          //     style: TextStyle(color: Colors.white),
          //   ),
          // ),

          (user["user_type"] == "admin")
              ? ListTile(
                  tileColor: (sidemenu == 10)
                      ? const Color.fromARGB(127, 33, 149, 243)
                      : const Color.fromARGB(0, 255, 255, 255),
                  onTap: () {
                    setState(() {
                      sidemenu = 10;
                      if (Responsive.isMobile(context)) {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                  horizontalTitleGap: 0.0,
                  leading: Icon(Icons.admin_panel_settings_outlined,
                      color: Colors.white),
                  title: Text(
                    "Sub Admin",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
} ////close  class
