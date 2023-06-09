// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, sort_child_properties_last, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../controllers/MenuAppController.dart';
import '../../responsive.dart';
import '../Attributes/attribute_add.dart';
import '../Login_Reg/Login_user.dart';
import '../Profile/profile_details.dart';
import '../Sub Admin/Add_SubAdmin.dart';
import '../category/category_add.dart';
import '../dashboard/dashboard_screen.dart';
import '../inventry/inventry_list.dart';
import '../order/oreder_list.dart';
import '../product/product_add.dart';

// ignore: use_key_in_widget_constructors
class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var sidemenu = 1;
  @override
  ////////
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
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
                child: CategoryAdd(),
              )
            else if (sidemenu == 6)
              Expanded(
                flex: 5,
                child: OrderList(),
              )
            else if (sidemenu == 7)
              Expanded(
                flex: 5,
                child: InventryList()
                )
            else if (sidemenu == 8)
              Expanded(
                flex: 5, 
                child: ProfileDetails()
                )
            else if (sidemenu == 9)
              Expanded(
                flex: 5, 
                child: LoginPage()      ///SignupScreen()
                )
            else if (sidemenu == 10)
              Expanded(
                flex: 5, 
                child: SubAdmin()      ///SignupScreen()
                )
          ],
        ),
      ),
    );
  }

  Widget WdSideMenu(BuildContext context) {
    return
     Drawer(
      child: 
      ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
             decoration: BoxDecoration(
           //  color: const Color.fromARGB(127, 33, 149, 243)
          ),
          ),
          ListTile(
            tileColor:(sidemenu == 1)?const Color.fromARGB(127, 33, 149, 243)  : const Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                sidemenu = 1;
                 if (Responsive.isMobile(context))
                     {
                      Navigator.of(context).pop();
                     }
              });
            },
            horizontalTitleGap: 0.0,
            leading: Icon(Icons.dashboard_outlined,color: Colors.white),
            title: Text(
              "Dashboard",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
             tileColor:(sidemenu == 2)? const Color.fromARGB(127, 33, 149, 243)  : const Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                sidemenu = 2;
                     if (Responsive.isMobile(context))
                     {
                      Navigator.of(context).pop();
                     }

              });
            },
            horizontalTitleGap: 0.0,
            leading: Icon(Icons.category_outlined,color: Colors.white),
            title: Text(
              "Category",
              style: TextStyle(color: Colors.white),
            ),
          ),
            ListTile(
            tileColor:(sidemenu == 3)? const Color.fromARGB(127, 33, 149, 243)  : const Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                sidemenu = 3;
                 if (Responsive.isMobile(context))
                     {
                      Navigator.of(context).pop();
                     }
              });
            },
            horizontalTitleGap: 0.0,
            leading: Icon(Icons.account_tree_outlined,color: Colors.white),
            title: Text(
              "Attribute",
              style: TextStyle(color: Colors.white),
            ),
          ),
          //  ListTile(
          //   onTap: () {
          //     setState(() {
          //       sidemenu = 4;
          //     });
          //   },
          //   horizontalTitleGap: 0.0,
          //   leading: SvgPicture.asset(
          //     "assets/icons/menu_task.svg",
          //     color: Colors.white54,
          //     height: 16,
          //   ),
          //   title: Text(
          //     "Brand",
          //     style: TextStyle(color: Colors.white54),
          //   ),
          // ),
          ListTile(
             tileColor:(sidemenu == 4)? const Color.fromARGB(127, 33, 149, 243)  : const Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                sidemenu = 4;
                 if (Responsive.isMobile(context))
                     {
                      Navigator.of(context).pop();
                     }
              });
            },
            horizontalTitleGap: 0.0,
            leading:  Icon(Icons.production_quantity_limits_outlined,color: Colors.white),
            //  SvgPicture.asset(
            //   "assets/icons/menu_task.svg",
            //   color: Colors.white54,
            //   height: 16,
            // ),
            title: Text(
              "Products",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            tileColor:(sidemenu == 5)? const Color.fromARGB(127, 33, 149, 243)  : const Color.fromARGB(0, 255, 255, 255), 
            onTap: () {
              setState(() {
                sidemenu = 5;
                 if (Responsive.isMobile(context))
                     {
                      Navigator.of(context).pop();
                     }
              });
            },
            horizontalTitleGap: 0.0,
            leading:   Icon(Icons.collections_bookmark_outlined,color: Colors.white), 

            title: Text(
              "Stock List",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
             tileColor:(sidemenu == 6)?const Color.fromARGB(127, 33, 149, 243)  : const Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                sidemenu = 6;
                 if (Responsive.isMobile(context))
                     {
                      Navigator.of(context).pop();
                     }
              });
            },
            horizontalTitleGap: 0.0,
            leading:  Icon(Icons.view_list_outlined,color: Colors.white),
            title: Text(
              "Order",
              style: TextStyle(color: Colors.white),
            ),
          ),
          
          ListTile(
             tileColor:(sidemenu == 7)? const Color.fromARGB(127, 33, 149, 243)  : const Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                sidemenu = 7;
                 if (Responsive.isMobile(context))
                     {
                      Navigator.of(context).pop();
                     }
              });
            },
            horizontalTitleGap: 0.0,
            leading: Icon(Icons.inventory_outlined,color: Colors.white), 
            title: Text(
              "Inventory Manage",
              style: TextStyle(color: Colors.white),
            ),
          ),

          ListTile(
            tileColor:(sidemenu == 8)? const Color.fromARGB(127, 33, 149, 243)  : const Color.fromARGB(0, 255, 255, 255), 
            onTap: () {
              setState(() {
                sidemenu = 8;
                 if (Responsive.isMobile(context))
                     {
                      Navigator.of(context).pop();
                     }
              });
            },
            horizontalTitleGap: 0.0,
            leading: Icon(Icons.person_pin_sharp,color: Colors.white), 
            title: Text(
              "Profile",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
             tileColor:(sidemenu == 9)? const Color.fromARGB(127, 33, 149, 243)  : const Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                sidemenu = 9;
                 if (Responsive.isMobile(context))
                     {
                      Navigator.of(context).pop();
                     }
              });
            },
            horizontalTitleGap: 0.0,
            leading: Icon(Icons.description_sharp,color: Colors.white), 
            title: Text(
              "About Us",
              style: TextStyle(color: Colors.white),
            ),
          ),

            ListTile(
             tileColor:(sidemenu == 10)? const Color.fromARGB(127, 33, 149, 243)  : const Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                sidemenu = 10;
                 if (Responsive.isMobile(context))
                     {
                      Navigator.of(context).pop();
                     }
              });
            },
            horizontalTitleGap: 0.0,
            leading: Icon(Icons.admin_panel_settings_outlined,color: Colors.white), 
            title: Text(
              "Sub Admin",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}////close  class





