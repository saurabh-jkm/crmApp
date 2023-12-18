// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:crm_demo/screens/Invoice/Buy_list.dart';
import 'package:crm_demo/screens/Invoice/sell_list.dart';
import 'package:crm_demo/screens/dashboard/dashboard_screen.dart';
import 'package:crm_demo/screens/more/more.dart';
import 'package:crm_demo/themes/style.dart';
import 'package:flutter/material.dart';

Widget theme_footer_android(context, selectedPage) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.081,
    decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: Color.fromARGB(255, 211, 217, 219), width: 2))),
    child: BottomNavigationBar(
      iconSize: 25,
      selectedLabelStyle: TextStyle(fontSize: 11.0, color: Colors.blue),
      unselectedLabelStyle: TextStyle(fontSize: 11.0, color: Colors.blue),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_rounded),
          label: 'Buy',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.sell_rounded),
        //   label: 'Buy/Sell',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.turn_sharp_right_sharp),
          label: 'Sale',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.format_list_bulleted_rounded),
          label: 'More',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      selectedItemColor: themeBG6,
      elevation: 14.0,
      unselectedItemColor: const Color.fromARGB(255, 131, 131, 131),
      currentIndex: selectedPage,
      // backgroundColor: Colors.white30,
      unselectedFontSize: 12.0,
      selectedFontSize: 15.0,
      onTap: (index) {
        if (index == 0) {
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (context) => new DashboardScreen()));
        } else if (index == 1 && selectedPage != index) {
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) => new Buy_List()));
        } else if (index == 2 && selectedPage != index) {
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) => new Sell_list()));
        } else if (index == 3 && selectedPage != index) {
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) => new More_screen()));
        }
      },
    ),
  );
}
