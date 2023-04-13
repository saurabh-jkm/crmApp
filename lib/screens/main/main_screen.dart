
// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../controllers/MenuAppController.dart';
import '../../responsive.dart';
import '../Profile/profile_details.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: 
       WdSideMenu(context),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child:
                 
          WdSideMenu(context),
              ),

          if(sidemenu == 1)
            Expanded(
              flex: 5,
              child:  
                 DashboardScreen(),
            )
          else if(sidemenu == 2)   
            Expanded(
               flex: 5,
              child:  
                 CategoryAdd(),
            )

          else if(sidemenu == 3)
           Expanded(
               flex: 5,
              child:  
                 ProductAdd(),
            )
            
          else if (sidemenu == 4)
           Expanded(
            flex: 5,
            child: 
             CategoryAdd(),
           ) 

           else if (sidemenu == 5)
           Expanded(
            flex: 5,
            child: 
            OrderList(),
           )  
            else if (sidemenu == 6)
           Expanded(
            flex: 5,
            child: 
            InventryList()
           ) 

           else if (sidemenu == 7)
            Expanded(
            flex: 5,
            child: 
            ProfileDetails()
           ) 


          ],
        ),
      ),
    );
  }


  Widget WdSideMenu(BuildContext context){
  return
  Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
           ListTile(
      onTap: ()
      {

        setState(() {
          sidemenu = 1;
        });
        // Navigator.push(context,
        //       MaterialPageRoute(builder: (context) => DashboardScreen()
        //       )
        //       );
                 },
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        "assets/icons/menu_dashbord.svg",
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        "Dashboard",
        style: TextStyle(color: Colors.white54),
      ),
    ),

    ListTile(
      onTap: ()
      {
        setState(() {
          
          sidemenu = 2;
        });
                 },
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        "assets/icons/menu_tran.svg",
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        "Category",
        style: TextStyle(color: Colors.white54),
      ),
    ),

     ListTile(
      onTap: ()
      {
        setState(() {
          sidemenu = 3;
        });
                 },
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        "assets/icons/menu_task.svg",
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        "Product / Items",
        style: TextStyle(color: Colors.white54),
      ),
    ),

         ListTile(
      onTap: ()
      {
            setState(() {
          sidemenu = 4;
        });
                 },
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        "assets/icons/menu_doc.svg",
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        "Stock List",
        style: TextStyle(color: Colors.white54),
      ),
    ),

      ListTile(
      onTap: ()
      {
             setState(() {
          sidemenu = 5;
        });
                 },
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        "assets/icons/menu_store.svg",
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        "Order List",
        style: TextStyle(color: Colors.white54),
      ),
    ),
     
      ListTile(
      onTap: ()
      {
             setState(() {
          sidemenu = 6;
        });
                 },
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        "assets/icons/menu_doc.svg",
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        "Inventry Managment",
        style: TextStyle(color: Colors.white54),
      ),
    ),

     ListTile(
      onTap: ()
      {
            setState(() {
          sidemenu = 7;
        });
                 },
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
         "assets/icons/menu_profile.svg",
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        "Profile",
        style: TextStyle(color: Colors.white54),
      ),
    ),

     ListTile(
      onTap: ()
      {
        setState(() {
        sidemenu = 8;
        });
                 },
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
         "assets/icons/menu_setting.svg",
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        "About Us",
        style: TextStyle(color: Colors.white54),
      ),
    ),

        ],
      ),
    );
}  




}////close  class





