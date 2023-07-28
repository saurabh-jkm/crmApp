// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_returning_null_for_void, no_leading_underscores_for_local_identifiers, avoid_print, non_constant_identifier_names, unnecessary_string_interpolations, sized_box_for_whitespace, unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'components/header.dart';
import 'components/my_fields.dart';
import 'components/recent_files.dart';
import 'components/storage_details.dart';
import 'package:flutter_svg/svg.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../../../models/RecentFile.dart';
import '../../../models/bar_charts.dart';

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

  final List<BarChartModel> data = [
    BarChartModel(
      year: "Jan",
      Sale: 200,
      Expenses: 100,
      Profit: 50,
      color: charts.ColorUtil.fromDartColor(Colors.green),
      color1: charts.ColorUtil.fromDartColor(Colors.red),
      color2: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
    BarChartModel(
      year: "Feb",
      Sale: 350,
      Expenses: 200,
      Profit: 100,
      color: charts.ColorUtil.fromDartColor(Colors.green),
      color1: charts.ColorUtil.fromDartColor(Colors.red),
      color2: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
    BarChartModel(
      year: "March",
      Sale: 450,
      Expenses: 200,
      Profit: 250,
      color: charts.ColorUtil.fromDartColor(Colors.green),
      color1: charts.ColorUtil.fromDartColor(Colors.red),
      color2: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
    BarChartModel(
      year: "April",
      Sale: 300,
      Expenses: 200,
      Profit: 100,
      color: charts.ColorUtil.fromDartColor(Colors.green),
      color1: charts.ColorUtil.fromDartColor(Colors.red),
      color2: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
  ];
  /////
  @override
  Widget build(BuildContext context) {
    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
        id: "Sale",
        data: data,
        domainFn: (BarChartModel series, _) => series.year,
        measureFn: (BarChartModel series, _) => series.Sale,
        colorFn: (BarChartModel series, _) => series.color,
      ),
      charts.Series(
        id: "Expenses",
        data: data,
        domainFn: (BarChartModel series, _) => series.year,
        measureFn: (BarChartModel series, _) => series.Expenses,
        colorFn: (BarChartModel series, _) => series.color1,
      ),
      charts.Series(
        id: "Profit",
        data: data,
        domainFn: (BarChartModel series, _) => series.year,
        measureFn: (BarChartModel series, _) => series.Profit,
        colorFn: (BarChartModel series, _) => series.color2,
      ),
    ];
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(defaultPadding),
        child: ListView(
          children: [
            Header(
              title: "Dashboard",
            ),
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

                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(defaultPadding),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(children: [
                            SizedBox(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.business,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 10),
                                    Text("Company Performance",
                                        style: GoogleFonts.alike(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.currency_rupee_outlined,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                        "Sales , Expenses and Profit : 2017 - 2023",
                                        style: GoogleFonts.alike(
                                            fontSize: 13,
                                            color: Colors.black45,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        demo_color(
                                            context, Colors.green, "Sale"),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        demo_color(
                                            context, Colors.red, "Expenses"),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        demo_color(
                                            context, Colors.yellow, "Profit")
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            )),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              width: double.infinity,
                              height: 500,
                              child: charts.BarChart(
                                series,
                                animate: true,
                              ),
                            )
                          ]))

                      // ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Back")),
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

  Widget demo_color(BuildContext context, clr, name) {
    return Container(
      margin: EdgeInsets.only(right: 30),
      child: Row(children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: clr, borderRadius: BorderRadius.circular(2.5)),
          height: 15,
          width: 15,
        ),
        Text("$name",
            style: GoogleFonts.alike(
                fontSize: 13,
                color: Colors.black54,
                fontWeight: FontWeight.normal)),
      ]),
    );
  }
}
