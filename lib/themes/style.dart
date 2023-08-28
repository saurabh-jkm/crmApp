//import 'dart:ffi';
//import 'package:intl/intl.dart';

// ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, avoid_unnecessary_containers, non_constant_identifier_names

import 'package:flutter/material.dart';

final Color themeBG = Color(0xFF2697FF);
final Color themeBG2 = Color(0xff1a243f);
final Color themeBG3 = Color.fromARGB(255, 44, 108, 161);
final Color themeBG4 = Color(0xffff03a857);
final Color buttonBG = Color(0xffff9100);

const themeSecondaryColor = Color(0xFF2A2D3E);
const themeBgColor = Color(0xFF212332);

final Color buttonBG1 = Color(0xFF2697FF);
final Color themeBlue = Color.fromARGB(255, 6, 45, 123);
final Color alertSuccess = Color.fromARGB(255, 72, 170, 137);
final Color alertError = Color.fromARGB(255, 214, 99, 12);
final TextStyle textStyle1 =
    TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: themeBlue);

final BoxDecoration loginBoxDeco = BoxDecoration(
  color: Color(0xFFffd83f),
);

final themeBox = [
  BoxShadow(
    color: Color.fromARGB(255, 212, 212, 212),
    offset: const Offset(
      1.0,
      3.0,
    ),
    blurRadius: 4.0,
    spreadRadius: 0.0,
  ), //BoxShadow
  BoxShadow(
    color: Colors.white,
    offset: const Offset(0.0, 0.0),
    blurRadius: 0.0,
    spreadRadius: 0.0,
  ), //BoxShadow
];

final themeGradient1 = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Colors.blue,
    Color.fromARGB(255, 3, 42, 73),
  ],
);

final themeChatConMe = BorderRadius.only(
    topLeft: Radius.circular(20.0),
    topRight: Radius.circular(20.0),
    bottomLeft: Radius.circular(20.0));
final themeChatConYou = BorderRadius.only(
    topLeft: Radius.circular(20.0),
    topRight: Radius.circular(20.0),
    bottomRight: Radius.circular(20.0));

final themeGradient2 = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Colors.red,
    Colors.indigo,
  ],
);

themeTextStyle(
    {size = 16.0,
    Color color = Colors.black,
    FontWeight fw = FontWeight.normal,
    ftFamily = 'Lora'}) {
  return TextStyle(
      fontSize: (size == null) ? 16.0 : size.toDouble(),
      fontWeight: (fw != null) ? fw : FontWeight.normal,
      color: (color == null) ? Colors.black : color,
      fontFamily: (ftFamily == 'Lora') ? "Lora" : "Montserrat-Regular");
}

// text field style
inputStyle(lable) {
  return InputDecoration(
    labelText: '$lable',
    fillColor: Colors.black,
    labelStyle: textStyle1,
    hintStyle: TextStyle(color: Colors.black),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Color.fromARGB(255, 133, 133, 133),
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: const Color.fromARGB(214, 33, 149, 243),
      ),
    ),
  );
}

Widget progress() {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: MyStyle.themeBG,
              backgroundColor: Color.fromARGB(255, 252, 243, 243),
            ),
          ],
        ),
      ],
    ),
  );
}

themeButton_sm(label, btnColor, icon, iconSize, w, h, fontsize) {
  final Container themeBtn = Container(
      width: (w == '') ? 130.0 : w,
      height: (h == '') ? 40.0 : h,
      decoration: BoxDecoration(
        color: (btnColor == '' || btnColor == null) ? themeBlue : btnColor,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: iconSize,
              ),
              SizedBox(width: 5.0),
              Text(
                "$label",
                style: TextStyle(color: Colors.white, fontSize: fontsize),
              ),
            ],
          ),
        ),
      ));

  return themeBtn;
}

themeAlert(context, msg, {type = 'success'}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("$msg", style: TextStyle(color: Colors.white)),
      backgroundColor: (type == 'success')
          ? Color.fromARGB(255, 72, 170, 137)
          : Color.fromARGB(255, 214, 99, 12),
    ),
  );
}

// get date

class MyStyle {
  MyStyle._();

  static Color themeBG = Color.fromARGB(255, 182, 123, 12);
}
