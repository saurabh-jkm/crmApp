
// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';
import '../../../models/RecentFile.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Files",
            style: Theme.of(context).textTheme.subtitle1,
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 20 ,horizontal: 5),
            width: double.infinity,
            child:
            Column(
              children: [
               Row(
                children: [
                  SizedBox(
                  width: 150,
                  child: Text("File Name",style: TextStyle(fontWeight: FontWeight.bold),),),
                  Expanded(child: Text("Date",style: TextStyle(fontWeight: FontWeight.bold)),),
                  Expanded(child: Text("Size",style: TextStyle(fontWeight: FontWeight.bold)),)
                ],
               ),
               SizedBox(height: 20,),
               Divider(thickness: 1.5,),

                for( var index = 0; index < demoRecentFiles.length; index ++) 
                recentFileDataRow(demoRecentFiles[index]),

              ],
            )
          ),
        ],
      ),
    );
  }


  Widget recentFileDataRow(fileInfo) {
  return 
  Container(
    margin: EdgeInsets.only(top: 5),
    child: Column(
      children: [

        Row(
          children: [
         
            
                 SizedBox(
                  width: 150,
                   child: Row(
                    children: [
                      SvgPicture.asset(
                        fileInfo.icon!,
                        height: 30,
                        width: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                        child: Text(fileInfo.title!),
                      ),
                    ],
                                 ),
                 ),
             
          
            Expanded(child: Text(fileInfo.date!)),
            Expanded(child: Text(fileInfo.size!))
          ],
        ),

      Divider(thickness: 1.5,)
      ],
    ),
  );
}
}


