// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables, use_build_context_synchronously, file_names, avoid_print, unnecessary_brace_in_string_interps, dead_code

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/screens/Login_Reg/register_page.dart';
import 'package:crm_demo/themes/firebase_functions.dart';
import 'package:crm_demo/themes/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../controllers/MenuAppController.dart';
import '../../helper/helper_function.dart';
import '../../responsive.dart';
import '../../themes/auth_service.dart';
import '../../themes/database_service.dart';
import '../../themes/theme_widgets.dart';
import '../main/main_screen.dart';

class Login_Copy extends StatefulWidget {
  const Login_Copy({super.key});

  @override
  State<Login_Copy> createState() => _Login_CopyState();
}

class _Login_CopyState extends State<Login_Copy> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  // ignore: unused_field
  bool _isLoading = false;
  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;

/////////  internet checker
  var ActiveConnection;
  String T = "";
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          //     T = "successfull";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        //  T = "No Internet Connection";
        //return "No Internet Connection";
        //  themeAlert(context, "$T",
        //     type: "error");
      });
    }
  }
/////////

///////// Login  Fuction +++++++++++++++++++++++

  Future<void> login() async {
    // CheckUserConnection();
    // (user_data.isEmpty)
    //               ? themeButton3(context, _fnCheckPhoneNumber, label: "Submit")
    //               : themeButton3(context, _fnLoginNow, label: "Login Now")
    // AuthService authService = AuthService();
    if (formKey.currentState!.validate() && user_data.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      for (var i = 0; i <= user_data.length; i++) {
        if (password == "${user_data[i]["password"]}" &&
            email == "${user_data[i]["email"]}") {
          var userData = {
            'type': user_data[i]["user_category"],
            'id': user_data[i]["user_category"],
            'name':
                "${user_data[i]["first_name"]} ${user_data[i]["last_name"]}",
            'fname': user_data[i]["first_name"],
            'lname': user_data[i]["last_name"],
            'phone': user_data[i]["mobile_no"],
            'email': user_data[i]["email"],
            'user_type': user_data[i]["user_type"],
            'profile_complete': user_data[i]["user_category"],
            'avatar': user_data[i]["avatar"],
          };
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user', jsonEncode(userData));
          // print("${userData}  ++++++tt+++++");
          themeAlert(context, "Successfully Sign In !!");
          await Future.delayed(const Duration(seconds: 3), () {
            nextScreenReplace(
              context,
              MultiProvider(providers: [
                ChangeNotifierProvider(
                  create: (context) => MenuAppController(),
                ),
              ], child: MainScreen(pageNo: 1) // MainScreen(),
                  ),
            );
          });
          break;
        } else {
          //   themeAlert(context, "Account dosen't exist !!", type: "error");
        }
      }
    } else {
      showSnackbar(context, Colors.red, "Invalid value !!");
      setState(() {
        _isLoading = false;
      });
    }
  }

  ///

  List user_data = [];

  ///
  User_Data() async {
    user_data = [];
    Map<dynamic, dynamic> w = {
      'table': "users",
      //'status': "$_StatusValue",
    };
    var temp = (!kIsWeb && Platform.isWindows)
        ? await All_dbFindDynamic(db, w)
        : await dbFindDynamic(db, w);

    setState(() {
      temp.forEach((k, v) {
        user_data.add(v);
      });

      // print("${user_data}  ++++++++++++++");
    });
  }

  ///
  @override
  void initState() {
    User_Data();
    // TODO: implement initState
    super.initState();
  }

  bool passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Image(image: AssetImage("assets/images/loginn.png")),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 60.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.0,
                            color: Color.fromARGB(255, 212, 212, 212))),
                    child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Sign In",
                                  style: GoogleFonts.akayaKanadaka(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),

                            SizedBox(
                              height: 45,
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Email",
                                    hoverColor: Colors.black,
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                  });
                                },

                                // check tha validation
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val!)
                                      ? null
                                      : "Please enter a valid email";
                                },
                              ),
                            ),

                            const SizedBox(height: 20),
                            SizedBox(
                              height: 45,
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                obscureText: passwordVisible,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Password",
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(
                                          () {
                                            passwordVisible = !passwordVisible;
                                          },
                                        );
                                      },
                                    )),
                                validator: (val) {
                                  if (val!.length < 6) {
                                    return "Password must be at least 6 characters";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                              ),
                            ),

                            // Text_field(context, EmailController,"Enter Your Email","Email",Icons.email_rounded,"1"),
                            // Text_field(context, PassController,"Enter Password","Password",Icons.lock_person_rounded,"2"),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                themeButton3(context, () {
                                  login();
                                  //                 nextScreenReplace(context,
                                  //         MultiProvider(
                                  //        providers: [
                                  //        ChangeNotifierProvider(
                                  //       create: (context) => MenuAppController(),
                                  //     ),
                                  //   ],
                                  //   child: MainScreen() // MainScreen(),
                                  // ),);
                                }, buttonColor: Colors.green, label: "Log In"),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    nextScreenReplace(
                                      context,
                                      MultiProvider(providers: [
                                        ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController(),
                                        ),
                                      ], child: RegisterPage() // MainScreen(),
                                          ),
                                    );
                                  },
                                  child: Text(
                                    'Create an account',
                                    style: TextStyle(
                                        fontSize: 12.5,
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            )));
  }

// ///////  Text_field 22 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ///
//   Widget Text_field(BuildContext context, ctr_name, lebel, hint ,icons,type) {
//     return Container(
//         height: 45,
//          alignment: Alignment.center,
//         margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black),
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: TextFormField(
//           controller: ctr_name,
//           style: TextStyle(color: Colors.black),
//            obscureText: passwordVisible,
//           decoration: InputDecoration(
//              prefixIcon:
//                   IconButton(onPressed: () {}, icon: Icon(icons,color: Colors.black,)),
//             border: InputBorder.none,
//             contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             hintText: '$hint',

//                suffixIcon:(type == "2")? IconButton(
//                       icon: Icon(passwordVisible
//                           ? Icons.visibility
//                           : Icons.visibility_off   ,color: Colors.blue,size: 20,),
//                       onPressed: () {
//                         setState(
//                           () {
//                             passwordVisible = !passwordVisible;
//                           },
//                         );
//                       },
//                     )
//                    : SizedBox(),
//                     alignLabelWithHint: false,
//                     filled: true,

//             hintStyle: TextStyle(
//               color: Colors.grey,
//               fontSize: 16,
//             ),

//           ),
//         ));
//   }
// ///////////
}

///Class closs
