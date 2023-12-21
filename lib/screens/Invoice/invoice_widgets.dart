// ignore_for_file: prefer_const_constructors, deprecated_colon_for_default_value

import 'package:crm_demo/themes/style.dart';
import 'package:flutter/material.dart';

Widget totalWidgets(context, label, value) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    margin: EdgeInsets.symmetric(horizontal: 3.0),
    decoration: BoxDecoration(
        color: Color.fromARGB(255, 240, 243, 245),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        border: Border.all(width: 0.6, color: themeBG2)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "$label",
          style:
              themeTextStyle(size: 10.0, fw: FontWeight.bold, color: themeBG2),
        ),
        Text(
          "$value",
          style: themeTextStyle(size: 16.0),
        )
      ],
    ),
  );
}

// invoice item list ===========================================
Widget invoiceItemRow(context, key, productList,
    {isGstColum: false, isDiscountColum: false}) {
  var data = productList[key];
  int i = int.parse(key.toString()) + 1;
  return Container(
    decoration: BoxDecoration(border: Border.all(color: themeBG2, width: 0.5)),
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: 40,
            padding: EdgeInsets.all(2),
            alignment: Alignment.topCenter,
            child: Text("${"${i}"}",
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    color: themeBG2))),
        Container(
            padding: EdgeInsets.all(2),
            width: 100,
            alignment: Alignment.topLeft,
            child: Text("${data["name"]} ",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    color: themeBG2))),
        Expanded(
            child: Container(
                padding: EdgeInsets.all(2),
                alignment: Alignment.topCenter,
                child: Text("${data["price"]} ",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        color: themeBG2)))),
        Expanded(
            child: Container(
                padding: EdgeInsets.all(2),
                alignment: Alignment.topCenter,
                child: Text(
                    "${(data["unit"] != '0') ? '${data["unit"]} - unit' : data["quantity"]}",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        color: themeBG2))

                // for (var i = 1; i <= eedata.length; i++)
                )),
        Expanded(
            child: Container(
                padding: EdgeInsets.all(2),
                alignment: Alignment.topCenter,
                child: Text((data['unit'] != null) ? "${data['unit']}" : "-",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        color: themeBG2))

                // for (var i = 1; i <= eedata.length; i++)
                )),
        (isDiscountColum)
            ? Expanded(
                child: Container(
                    padding: EdgeInsets.all(2),
                    alignment: Alignment.topCenter,
                    child: Text("${data["discount"]} ",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: themeBG2))))
            : SizedBox(),
        Expanded(
            child: Container(
                padding: EdgeInsets.all(2),
                alignment: Alignment.topCenter,
                child: Text("${data["subtotal"]} ",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        color: themeBG2)))),
        (isGstColum)
            ? Expanded(
                child: Container(
                    padding: EdgeInsets.all(2),
                    alignment: Alignment.topCenter,
                    child: Text("${data["gst"]} (${data["gst_per"]}%)",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: themeBG2))))
            : SizedBox(),
        Expanded(
            child: Container(
                padding: EdgeInsets.all(2),
                alignment: Alignment.topCenter,
                child: Text("${data["total"]}",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        color: themeBG2))))
      ],
    ),
  );
}
