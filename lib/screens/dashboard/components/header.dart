// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_typing_uninitialized_variables, unused_element, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, dead_code, use_super_parameters, unnecessary_new, prefer_collection_literals

import 'dart:convert';

import 'package:jkm_crm_admin/screens/Login_Reg/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jkm_crm_admin/themes/theme_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../responsive.dart';
import '../../../themes/style.dart';

class Header extends StatefulWidget {
  const Header({super.key, @required this.title});
  final title;

  @override
  State<Header> createState() => _HeaderState();
}

logout(context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
  await themeAlert(context, "Successfully Logout !!");
  await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Login_Copy() //Home()
          ));
}

bool _isShown = true;

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: context.read<MenuAppController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Row(
            children: [
              Icon(
                Icons.dashboard_outlined,
                color: Colors.blue,
              ),
              SizedBox(
                width: 10,
              ),
              GoogleText(
                text: "${widget.title}",
                color: Colors.white,
              ),
            ],
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        ProfileCard()
      ],
    );
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

//
void _LogoutAlert(BuildContext context, setstate) {
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Image.asset("assets/images/logo.png", height: 30),
              SizedBox(width: 10.0),
              Text(
                'Logging Out',
                style: GoogleFonts.alike(
                    color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text('Are you sure to Logout?',
              style: GoogleFonts.alike(
                  color: Colors.black54,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic)),
          actions: [
            // The "Yes" button///
            TextButton(
                onPressed: () {
                  // Remove the box
                  logout(context);

                  // logout(context);
                  // setstate;
                },
                child: Text(
                  'Yes',
                  style: themeTextStyle(
                      ftFamily: 'ms', fw: FontWeight.bold, color: Colors.green),
                )),
            TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: Text(
                  'No',
                  style: themeTextStyle(
                      ftFamily: 'ms', fw: FontWeight.bold, color: Colors.red),
                ))
          ],
        );
      });
}

class _ProfileCardState extends State<ProfileCard> {
  gggg() {
    setState(() {
      _isShown = false;
    });
  }

  /////// get user data  +++++++++++++++++++++++++++++++++++++++++++++++++++
  Map<dynamic, dynamic> user = new Map();
  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userData = (prefs.getString('user'));
    if (userData != null) {
      setState(() {
        user = jsonDecode(userData) as Map<dynamic, dynamic>;
      });
    }
  }

//////==================================================================
  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
              backgroundImage: (user.isNotEmpty && user["avatar"] != null)
                  ? NetworkImage("${user["avatar"]}")
                  : NetworkImage(
                      "https://img.freepik.com/premium-vector/account-icon-user-icon-vector-graphics_292645-552.jpg?w=2000")),
          if (!Responsive.isMobile(context))
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: (user.isNotEmpty && user["name"] != null)
                  ? Text("${user["name"]}")
                  : Text("User Name"),
            ),
          PopupMenuButton(
              color: Colors.white,
              itemBuilder: (context) => [
                    /*PopupMenuItem(
                        onTap: () {
                          //ProfileDetails();
                          MainScreen(pageNo: 9);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "Profile",
                              style: GoogleFonts.alike(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        )),*/
                    PopupMenuItem(
                        onTap: () {
                          //_LogoutAlert(context, gggg());
                          logout(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout_outlined,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "Log Out",
                              style: GoogleFonts.alike(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        )),
                  ])
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Color.fromARGB(255, 27, 27, 27)),
      decoration: InputDecoration(
        hintText: "Search",
        hintStyle: TextStyle(color: Colors.black),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
              padding: EdgeInsets.all(defaultPadding * 0.75),
              margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Icon(Icons.search_sharp)
              //SvgPicture.asset("assets/icons/Search.svg"),
              ),
        ),
      ),
    );
  }
}
