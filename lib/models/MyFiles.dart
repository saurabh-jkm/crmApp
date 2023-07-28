// ignore_for_file: prefer_const_constructors, file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

import '../constants.dart';

class CloudStorageInfo {
  final String? title, totalStorage;
  final IconData? svgSrc;
  final int numOfFiles, percentage, PageNo;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    required this.numOfFiles,
    required this.percentage,
    required this.PageNo,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "Total Order",
    numOfFiles: 13,
    svgSrc: Icons.shopping_cart,
    // svgSrc: "assets/icons/shoping.svg",
    color: primaryColor,
    percentage: 20,
    PageNo: 6,
  ),
  CloudStorageInfo(
    title: "Total Product",
    numOfFiles: 28,
    svgSrc: Icons.wallet_giftcard,
    // svgSrc: "assets/icons/google_drive.svg",
    color: Color(0xFFFFA113),
    percentage: 30,
    PageNo: 4,
  ),
  CloudStorageInfo(
    title: "Total User",
    numOfFiles: 32,
    svgSrc: Icons.person,
    // svgSrc: "assets/icons/one_drive.svg",
    color: Color(0xFFA4CDFF),
    percentage: 40,
    PageNo: 10,
  ),
  CloudStorageInfo(
    title: "Inventry Management",
    numOfFiles: 53,
    svgSrc: Icons.inventory_rounded,
    // svgSrc: "assets/icons/drop_box.svg",
    color: Colors.green,
    percentage: 33,
    PageNo: 7,
  ),
  CloudStorageInfo(
    title: "Out of stock",
    numOfFiles: 34,
    svgSrc: Icons.production_quantity_limits_outlined,
    // svgSrc: "assets/icons/drop_box.svg",
    color: Colors.yellow,
    percentage: 33,
    PageNo: 4,
  ),
];
