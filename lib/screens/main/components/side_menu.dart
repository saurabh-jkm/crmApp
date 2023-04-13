// // ignore_for_file: non_constant_identifier_names, prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import '../../category/category_add.dart';

// class SideMenu extends StatelessWidget {
//   const SideMenu({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children: [
//           DrawerHeader(
//             child: Image.asset("assets/images/logo.png"),
//           ),
//           Wd_ListTile( context,
//              "Dashboard",
//              "assets/icons/menu_dashbord.svg",
//              ""
             
//           ),
//           Wd_ListTile( context,
//              "Category",
//              "assets/icons/menu_tran.svg",""
             
//           ),
//           Wd_ListTile( context,
//              "Product / Items",
//              "assets/icons/menu_task.svg",
//              () {},
//           ),
//            Wd_ListTile( context,
//              "Stock List",
//              "assets/icons/menu_doc.svg",
//              () {},
//           ),
//               Wd_ListTile( context,
//              "Order List",
//              "assets/icons/menu_store.svg",
//              () {},
//           ),
//            Wd_ListTile( context,
//              "Inventry Managment",
//              "assets/icons/menu_doc.svg",
//              () {},
//           ),
//           Wd_ListTile( context,
//              "Profile",
//              "assets/icons/menu_profile.svg",
//              () {},
//           ),
//           Wd_ListTile(context,
//              "About Us",
//              "assets/icons/menu_setting.svg",
//              () {},
//           ),
//         ],
//       ),
//     );
//   }


// Widget Wd_ListTile(BuildContext context , title , svgSrc,press){
//   return 
//   ListTile(
//       onTap: ()
//       {
//         Navigator.push(context,
//               MaterialPageRoute(builder: (context) => press
//               )
//               );
//                  },
//       horizontalTitleGap: 0.0,
//       leading: SvgPicture.asset(
//         svgSrc,
//         color: Colors.white54,
//         height: 16,
//       ),
//       title: Text(
//         title,
//         style: TextStyle(color: Colors.white54),
//       ),
//     );
// }


// }

// // class DrawerListTile extends StatelessWidget {
// //   const DrawerListTile({
// //     Key? key,
// //     // For selecting those three line once press "Command+D"
// //     required this.title,
// //     required this.svgSrc,
// //     required this.press,
// //   }) : super(key: key);

// //   final String title, svgSrc;
// //   final VoidCallback press;

// //   @override
// //   Widget build(BuildContext context) {
// //     return ListTile(
// //       onTap: ()
// //       {
// //         Navigator.push(context,
// //               MaterialPageRoute(builder: (context) => press;
// //               )
// //               );
// //                  },
// //       horizontalTitleGap: 0.0,
// //       leading: SvgPicture.asset(
// //         svgSrc,
// //         color: Colors.white54,
// //         height: 16,
// //       ),
// //       title: Text(
// //         title,
// //         style: TextStyle(color: Colors.white54),
// //       ),
// //     );
// //   }
// // }
