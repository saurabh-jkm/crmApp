// ignore_for_file: prefer_const_constructors, file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

import '../constants.dart';

class CloudStorageInfo {
  final String? title, totalStorage;
  final IconData? svgSrc;
  final int numOfFiles, PageNo;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    required this.numOfFiles,
    required this.PageNo,
    this.color,
  });
}
