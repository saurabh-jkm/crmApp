// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../models/MyFiles.dart';
import '../../../themes/theme_widgets.dart';
import '../../main/main_screen.dart';

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final CloudStorageInfo info;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 5),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: info.color),
                      child: Text("${info.numOfFiles}",
                          style: GoogleFonts.abel(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)

                          // Theme.of(context)
                          //     .textTheme
                          //     .caption!
                          //     .copyWith(color: Colors.white70),
                          ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Text(info.title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.abel(
                              fontSize: 15, fontWeight: FontWeight.w400)),
                    ),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(defaultPadding * 0.45),
                        // height: MediaQuery.of(context).size.height * 0.12,
                        // width: MediaQuery.of(context).size.width * 0.06,
                        decoration: BoxDecoration(
                          color: info.color!.withOpacity(0.1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Icon(
                          info.svgSrc,
                          color: info.color,
                          size: MediaQuery.of(context).size.height * 0.08,
                        )
                        //Icon(info.svgSrc,color: info.color)
                        //  SvgPicture.asset(
                        //   info.svgSrc!,
                        //   color: info.color,
                        // ),
                        ),
                  ],
                ),
                // ProgressLine(
                //   color: info.color,
                //   percentage: info.percentage,
                // ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              nextScreenReplace(
                context,
                MultiProvider(providers: [
                  ChangeNotifierProvider(
                    create: (context) => MenuAppController(),
                  ),
                ], child: MainScreen(pageNo: info.PageNo)
                    // MainScreen() // MainScreen(),
                    ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(61, 255, 255, 255),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("More Info",
                      style: GoogleFonts.abel(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: Colors.white)),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.arrow_circle_right_outlined,
                      size: 20, color: Colors.white)
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
