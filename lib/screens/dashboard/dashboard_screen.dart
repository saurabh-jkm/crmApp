
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_returning_null_for_void, no_leading_underscores_for_local_identifiers, avoid_print, non_constant_identifier_names, unnecessary_string_interpolations, sized_box_for_whitespace, unused_import


import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/header.dart';
import 'components/my_fields.dart';
import 'components/recent_files.dart';


class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //////Crosss file picker
  final GlobalKey exportKey = GlobalKey();

@override
void initState() {
    super.initState();
  }


  /////
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      body: 
      Container(
        padding: EdgeInsets.all(defaultPadding),
        child: ListView(
          children: [
            Header(title: "Dashboard",),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      MyFiles(),
                      SizedBox(height: defaultPadding),
                     // RecentFiles(),
                      // if (Responsive.isMobile(context))
                      //   SizedBox(height: defaultPadding),
                      // if (Responsive.isMobile(context)) 
                      // StarageDetails(),
                    ],
                  ),
                ),
                // if (!Responsive.isMobile(context))
                //   SizedBox(width: defaultPadding),
                // // On Mobile means if the screen is less than 850 we dont want to show it
                // if (!Responsive.isMobile(context))
                //   Expanded(
                //     flex: 2,
                //     child: 
                //     StarageDetails(),
                //   ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
 