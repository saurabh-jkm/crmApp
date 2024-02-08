// ignore_for_file: prefer_const_constructors, sort_child_properties_last, non_constant_identifier_names, unnecessary_new, avoid_unnecessary_containers, deprecated_colon_for_default_value

import 'package:jkm_crm_admin/themes/style.dart';
import 'package:flutter/material.dart';

Widget themeHeader_android(
  context, {
  user = '',
  title = '',
  isBack: false,
}) {
  return Container(
    child: Stack(
      children: <Widget>[
        Opacity(
          opacity: 1,
          child: ClipPath(
            clipper: TsClip1(),
            child: Container(
              color: Color.fromARGB(255, 163, 203, 255),
              height: 110.0,
            ),
          ),
        ),
        ClipPath(
          clipper: TsClip2(),
          child: Container(
            decoration: BoxDecoration(gradient: themeGradient2),
            //color: Color(0XFFe51273),
            //color: themeBG2,
            height: 110.0,
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 40.0, left: 10.0, right: 10.0),
              child: Container(
                child: Center(
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        //  width: MediaQuery.of(context).size.width * 0.5,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (isBack)
                                ? IconButton(
                                    onPressed: () {
                                      //backScreen(context);
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 30,
                                    ))
                                : GestureDetector(
                                    onTap: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, top: 6.0),
                                      child: Image.asset(
                                        'assets/images/logo.png',
                                        width: 30,
                                      ),
                                    ),
                                  ),
                            SizedBox(width: 8.0),
                            Text("$title",
                                style: themeTextStyle(
                                    size: 20.0, color: Colors.white)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        // width:
                        //     MediaQuery.of(context).size.width * 0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.40,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 13.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      (user != '')
                                          ? Text(
                                              "Hello, ${user['fname']}",
                                              textAlign: TextAlign.end,
                                              style: textStyle3,
                                            )
                                          : SizedBox(),
                                    ]),
                              ),
                            ),
                            SizedBox(width: 10.0),

                            PopupMenuButton(
                                child:
                                    (user == null || user == '' || user.isEmpty)
                                        ? SizedBox()
                                        : (user['avatar'] == '')
                                            ? CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'assets/images/avtar.png'),
                                                radius: 22.0,
                                                backgroundColor: Color.fromARGB(
                                                    255, 28, 62, 112),
                                              )
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    '${user['avatar']}'),
                                                radius: 22.0,
                                              ),
                                color: Colors.white,
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                          onTap: () {
                                            // nextScreenReplace(
                                            //     context, ProfileScreen());
                                          },
                                          child: Text(
                                            "Profile",
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                      PopupMenuItem(
                                          onTap: () {
                                            //logout(context);
                                          },
                                          child: Text(
                                            "Log Out",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ))
                                    ])

                            // Scaffold.of(context).openDrawer();
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class TsClip1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(
        0, size.height - 50); //start path with this if you are making at bottom
    var firstStart = Offset(size.width / 5, size.height);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 1.8, size.height - 40.0);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy - 10, firstEnd.dx, firstEnd.dy);
    var secondStart = Offset(size.width - (size.width / 4), size.height - 60);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, size.height - 40);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(
        size.width, 0); //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TsClip2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(
        0, size.height - 50); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 5, size.height);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 1.8, size.height - 40.0);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy - 10, firstEnd.dx, firstEnd.dy);
    var secondStart = Offset(size.width - (size.width / 4), size.height - 70);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, size.height - 55);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    path.lineTo(
        size.width, 0); //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
