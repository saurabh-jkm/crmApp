// ignore_for_file: deprecated_member_use, prefer_const_constructors, no_leading_underscores_for_local_identifiers, use_key_in_widget_constructors, non_constant_identifier_names, unused_import, use_super_parameters

import 'package:jkm_crm_admin/themes/global.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../../../constants.dart';
import '../../../responsive.dart';
import 'file_info_card.dart';

class MyFiles extends StatefulWidget {
  const MyFiles(
      {required this.quantity_no,
      required this.demoMyFiles,
      required this.value})
      : super();
  final int value;
  final int quantity_no;
  final List demoMyFiles;

  @override
  State<MyFiles> createState() => _MyFilesState();
}

class _MyFilesState extends State<MyFiles> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        is_mobile ? SizedBox() : SizedBox(height: defaultPadding + 50),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
            demoMyFiles: widget.demoMyFiles,
            valuee: widget.value,
          ),
          tablet: FileInfoCardGridView(
            demoMyFiles: widget.demoMyFiles,
            valuee: widget.value,
          ),
          desktop: FileInfoCardGridView(
            demoMyFiles: widget.demoMyFiles,
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
            valuee: widget.value,
          ),
        ),
      ],
    );
  }
}

// List demoMyFiles = [
//   CloudStorageInfo(
//     title: "Total Order",
//     numOfFiles: 13,
//     svgSrc: Icons.shopping_cart,
//     // svgSrc: "assets/icons/shoping.svg",
//     color: primaryColor,

//     PageNo: 6,
//   ),
//   CloudStorageInfo(
//     title: "Total Product",
//     numOfFiles: 28,
//     svgSrc: Icons.wallet_giftcard,
//     // svgSrc: "assets/icons/google_drive.svg",
//     color: Color(0xFFFFA113),

//     PageNo: 4,
//   ),
//   CloudStorageInfo(
//     title: "Total User",
//     numOfFiles: 32,
//     svgSrc: Icons.person,
//     // svgSrc: "assets/icons/one_drive.svg",
//     color: Color(0xFFA4CDFF),

//     PageNo: 10,
//   ),
//   CloudStorageInfo(
//     title: "Inventry Management",
//     numOfFiles: 53,
//     svgSrc: Icons.inventory_rounded,
//     // svgSrc: "assets/icons/drop_box.svg",
//     color: Colors.green,
//     PageNo: 7,
//   ),
//   CloudStorageInfo(
//     title: "Out of stock",
//     numOfFiles: 34,
//     svgSrc: Icons.production_quantity_limits_outlined,
//     // svgSrc: "assets/icons/drop_box.svg",
//     color: Colors.yellow,

//     PageNo: 4,
//   ),
// ];

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    required this.valuee,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.demoMyFiles,
  }) : super(key: key);
  final int valuee;
  final int crossAxisCount;
  final double childAspectRatio;
  final List demoMyFiles;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoMyFiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) =>
          FileInfoCard(info: demoMyFiles[index], value: valuee),
    );
  }
}
