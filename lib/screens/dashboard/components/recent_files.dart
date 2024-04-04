// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_const_literals_to_create_immutables, use_super_parameters

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../../constants.dart';
import '../../../models/bar_charts.dart';

class RecentFiles extends StatelessWidget {
  RecentFiles({
    Key? key,
  }) : super(key: key);

  final List<BarChartModel> data = [
    BarChartModel(
      year: "2014",
      Sale: 200,
      Expenses: 100,
      Profit: 50,
      color: charts.ColorUtil.fromDartColor(Colors.green),
      color1: charts.ColorUtil.fromDartColor(Colors.red),
      color2: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
    BarChartModel(
      year: "2015",
      Sale: 350,
      Expenses: 200,
      Profit: 100,
      color: charts.ColorUtil.fromDartColor(Colors.green),
      color1: charts.ColorUtil.fromDartColor(Colors.red),
      color2: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
    BarChartModel(
      year: "2016",
      Sale: 450,
      Expenses: 200,
      Profit: 250,
      color: charts.ColorUtil.fromDartColor(Colors.green),
      color1: charts.ColorUtil.fromDartColor(Colors.red),
      color2: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
    BarChartModel(
      year: "2017",
      Sale: 300,
      Expenses: 200,
      Profit: 100,
      color: charts.ColorUtil.fromDartColor(Colors.green),
      color1: charts.ColorUtil.fromDartColor(Colors.red),
      color2: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
  ];

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
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: charts.BarChart(
        series,
        animate: true,
      ),
    );
  }
}
