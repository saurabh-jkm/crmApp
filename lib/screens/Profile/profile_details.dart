// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, deprecated_member_use, sized_box_for_whitespace, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';
import '../dashboard/components/header.dart';
import '../dashboard/components/my_fields.dart';
import '../dashboard/components/recent_files.dart';
import '../dashboard/components/storage_details.dart';
import 'package:file_picker/file_picker.dart';
class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});
  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {

  
/// 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      ListView(
              children: [
                      Header(title: "My Profile",),
                      SizedBox(height: defaultPadding),
                        build_top(context),
                        listList(context),
                        ],
                      )
    );
  }


//// Widget for Start_up

  Widget listList(BuildContext context) {
    return
    Container(
      // height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
             
          // Text(
          //   "Product Inventry List",
          //   style: Theme.of(context).textTheme.subtitle1,
          // ),

          // Container(
          //   margin: EdgeInsets.symmetric(vertical: 20 ,horizontal: 5),
          //   width: double.infinity,
          //   child:
          //   Column(
          //     children: [
          //      Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         Expanded(
          //         child: Text("S.No.",style: TextStyle(fontWeight: FontWeight.bold),),),
          //         Expanded(child: Text("Name",style: TextStyle(fontWeight: FontWeight.bold)),),
          //         Expanded(child: Text("Category Name",style: TextStyle(fontWeight: FontWeight.bold)),),
          //         Expanded(child: Text("Quantity Left",style: TextStyle(fontWeight: FontWeight.bold)),),
          //          Expanded(child: Text("Total Sell",style: TextStyle(fontWeight: FontWeight.bold)),),
          //           Expanded(child: Text("Status",style: TextStyle(fontWeight: FontWeight.bold)),),
                    
          //       ]
          //       ,    
          //      ),
          //      SizedBox(height: 20,),
          //      Divider(thickness: 1.5,),

          //       for( var index = 1; index < 10; index ++) 
          //       recentFileDataRow(context,"$index"),

          //     ],
          //   )
          // ),
        ],
      ),
    );
  }  

  final double coverHeight = 220;

  Widget build_top(BuildContext context) => 
       Container(
        height: coverHeight + 80,
      //  width: MediaQuery.of(context).size.width,
        // margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(defaultPadding),
        child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0, child: buildCover()),
              Positioned(
                  top: coverHeight / 1.9,
                  right: coverHeight*2,
                  child:
                   profile_image()
                   ),
              Positioned(
                  top: coverHeight + 27,
                  child: GestureDetector(
                    onTap: () {
                    //  _fnGoEditPage();
                    },
                    child: Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(width: 1.0, color: Colors.white),
                            color: Color.fromARGB(255, 23, 160, 126)),
                        child: Icon(
                          Icons.mode_edit_outlined,
                          color: Colors.white,
                        )),
                  ))
            ]),
      );

///////////////

  Widget buildCover() => Container(
       width: MediaQuery.of(context).size.width-200,
      // padding: EdgeInsets.all(defaultPadding),
        height: coverHeight - 20,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [themeBG2, themeBG3, themeBG],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // stops: [0.6,0.4,0.7],
              // tileMode: TileMode.repeated,
            ),
              image: DecorationImage(
                image: AssetImage("assets/images/baner1.jpg"),
                fit: BoxFit.fill)),
        //  child:
        //  Stack(
        //   children: [
        //        Positioned(
        //         top: coverHeight/1.15,
        //         right: coverHeight/3.2,
        //          child: Text("Saurabh Yadav",style: TextStyle(fontSize: 22.0,fontFamily: 'ms',fontWeight: FontWeight.bold,color: Colors.white,)
        //          ),
        //        ),
        //  ],),
      );

/////  Profile image +====

  Widget profile_image() => Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Container(
          //margin: EdgeInsets.all(10),
          height: coverHeight / 1.5,
          width: coverHeight / 1.5,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage("https://mir-s3-cdn-cf.behance.net/project_modules/fs/bd59d257035687.59c5f04c1361c.png"),
                  // AssetImage("assets/images/sl1.jpg"),
                  fit: BoxFit.fill)),
        ),
      );

}/// Class CLose
