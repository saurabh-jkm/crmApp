// ignore_for_file: non_constant_identifier_names

import 'package:charts_flutter/flutter.dart' as charts;

class BarChartModel {
  String year;
  int Sale;
  int Expenses;
  int Profit;
  final charts.Color color;
  final charts.Color color1;
  final charts.Color color2;

  BarChartModel({
    required this.year,
    required this.Sale,
    required this.Expenses,
    required this.Profit,
    required this.color,
    required this.color1,
    required this.color2,
  });
}
