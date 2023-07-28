// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, prefer_final_fields, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_null_comparison, sort_child_properties_last, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, depend_on_referenced_packages, avoid_print, unnecessary_new

import 'package:crm_demo/themes/theme_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

import '../../themes/style.dart';
import '../dashboard/components/header.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});
  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  void initState() {
    super.initState();
  }

  bool updateWidget = false;
  var update_id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: ListView(
        children: [
          Header(
            title: "About Us",
          ),
          listCon(context, "Edit About Us")
        ],
      ),
    ));
  }

//// Widget for Start_up
  Widget listCon(BuildContext context, sub_text) {
    return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius:
          //     const BorderRadius.all(Radius.circular(10)),
        ),
        child: ListView(children: [
          Container(
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      // Add_Category = false;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.info_outlined, color: Colors.blue, size: 25),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'About Us',
                        style: themeTextStyle(
                            size: 18.0,
                            ftFamily: 'ms',
                            fw: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '$sub_text',
                        style: themeTextStyle(
                            size: 12.0,
                            ftFamily: 'ms',
                            fw: FontWeight.normal,
                            color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.all(defaultPadding),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text("About Us",
                          style: GoogleFonts.alike(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15))
                    ],
                  ),
                  Container(
                      alignment: Alignment.bottomLeft,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 1.5)),
                      child: Text(
                          """Geetanjali Electromart is engaged in the business of manufacturing and selling wires and cables and fast moving electrical goods ‘FMEG’ under the ‘Geetanjali Electromart’ brand. Apart from wires and cables, we manufacture and sell FMEG products such as electric fans, LED lighting and luminaires, switches and switchgear, solar products and conduits & accessories.
                  
                  We manufacture and sell a diverse range of wires and cables and our key products in the wires and cables segment are power cables, control cables, instrumentation cables, solar cables, building wires, flexible cables, flexible/single multi core cables, communication cables and others including welding cables, submersible flat and round cables, rubber cables, overhead conductors, railway signaling cables, specialty cables and green wires. we diversified into the engineering, procurement and construction ‘EPC’ business, which includes the design, engineering, supply, execution and commissioning of power distribution and rural electrification projects. we diversified into the FMEG segment and our key FMEG products are switches and switchgear and conduits & accessories.
                  
                  Our Telecom Division is engaged in manufacturing OFCs, FRP/ARP Rods, IGFR Yarns and a whole range of end-to-end passive networking solutions and providing EPC-services to transform people’s lives, in terms of digital infrastructure and accessibility.""",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.alike(
                              color: Colors.black54,
                              fontWeight: FontWeight.normal,
                              fontSize: 13))),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      themeButton3(context, () {}, label: 'Update')
                    ],
                  )
                ],
              )),
        ]));
  }
}
