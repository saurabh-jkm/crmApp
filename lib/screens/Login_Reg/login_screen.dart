// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables, use_build_context_synchronously, file_names, avoid_print, unnecessary_brace_in_string_interps, dead_code, camel_case_types, duplicate_ignore, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_demo/themes/firebase_functions.dart';
import 'package:crm_demo/themes/style.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/MenuAppController.dart';
import '../../themes/theme_widgets.dart';
import '../main/main_screen.dart';

// ignore: camel_case_types
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
  bool isWait = true;
  bool smallD = true;
  
  

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
    setState(() {
      _isLoading = true;
    });

    var dbData = await dbFindDynamic(
        db, {'table': 'users', 'email': email, 'password': password});

    if (dbData.isNotEmpty) {
      var userData = dbData[0];
      // print("$userData  +++++");
      var userDataArr = {
        'id': userData["id"],
        'name': "${userData["first_name"]} ${userData["last_name"]}",
        'fname': userData["first_name"],
        'lname': userData["last_name"],
        'phone': userData["mobile_no"],
        'email': userData["email"],
        'user_type': userData["user_type"],
        "status": userData["status"],
        "date_at": userData["date_at"],
        'avatar': userData["avatar"],
      };
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(userDataArr));
      // print("${userData}  ++++++tt+++++");
      themeAlert(context, "Successfully Sign In !!");
      // Navigator.of(context).pushReplacement(new MaterialPageRoute(
      //     builder: (context) => new MainScreen(pageNo: 1)));
      await Future.delayed(const Duration(seconds: 1), () {
        nextScreenReplace(
          context,
          MultiProvider(providers: [
            ChangeNotifierProvider(
              create: (context) => MenuAppController(),
            ),
          ], child: MainScreen(pageNo: 1, stockvalue: 0) // MainScreen(),
              ),
        );
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      themeAlert(context, "Email Or Password MistMatch!!", type: 'error');
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
    if(Platform.isAndroid || Platform.isIOS){
      smallD = true;
    }else{
      smallD = false;
    }
    User_Data();
    super.initState();
  }

  bool passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.white,
            child: (_isLoading)
                ? Container(
                    child: Center(
                      child: pleaseWait(context),
                    ),
                  )
                : Row(
                    children: [
                      (smallD)?SizedBox():Expanded(
                        child: Image(
                            image: AssetImage("assets/images/loginn.png")),
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
                                            color:
                                                Theme.of(context).primaryColor,
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
                                            color:
                                                Theme.of(context).primaryColor,
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
                                                  passwordVisible =
                                                      !passwordVisible;
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
                                      },
                                          buttonColor: Colors.green,
                                          label: "Log In"),
                                    ],
                                  ),
                                  /*SizedBox(
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
                            ),*/
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
