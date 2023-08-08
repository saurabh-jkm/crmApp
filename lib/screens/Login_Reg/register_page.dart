// ignore_for_file: use_build_context_synchronously, prefer_final_fields, non_constant_identifier_names, prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../themes/auth_service.dart';
import '../../themes/theme_widgets.dart';
import 'Login_user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
/////////////////////////////////////////////////////
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  String status = "Active";
  String Date_at = DateFormat('dd-MM-yyyy').format(DateTime.now());
  AuthService authService = AuthService();
////////////////////////////////////////////////////

//  register() async {
//     if (formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });
//       await authService
//           .registerUserWithEmailandPassword(fullName, email, password,status,Date_at)
//           .then((value) async {
//         if (value == true) {
//          // saving the shared preference state
//           await HelperFunctions.saveUserLoggedInStatus(true);
//           await HelperFunctions.saveUserEmailSF(email);
//           await HelperFunctions.saveUserNameSF(fullName);
//           nextScreenReplace(context,
//           MultiProvider(
//                 providers: [
//                   ChangeNotifierProvider(
//                     create: (context) => MenuAppController(),
//                   ),
//                 ],
//                 child:   MainScreen() // MainScreen(),
//               ),
//               );
//         } else {
//           showSnackbar(context, Colors.red, value);
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       });
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                  child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // const Text(
                          //   "Chat app",
                          //   style: TextStyle(
                          //       fontSize: 40, fontWeight: FontWeight.bold),
                          // ),
                          // const SizedBox(height: 10),
                          // const Text(
                          //     "Create your account now to chat and explore",
                          //     style: TextStyle(
                          //         fontSize: 15, fontWeight: FontWeight.w400)),
                          //          Image.network("https://images-platform.99static.com//yT4-uU8ZTohW9Mjum5r1GLTEO0k=/169x2087:1712x3630/fit-in/590x590/99designs-contests-attachments/103/103937/attachment_103937755",height: 300,),
                          const SizedBox(
                            height: 20,
                          ),

                          /////// Full Name   TextFormField++++++++++++++++

                          SizedBox(
                            height: 45,
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Full Name",
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              onChanged: (val) {
                                setState(() {
                                  fullName = val;
                                });
                              },
                              validator: (val) {
                                if (val!.isNotEmpty) {
                                  return null;
                                } else {
                                  return "Name cannot be empty";
                                }
                              },
                            ),
                          ),

                          ////////

                          const SizedBox(
                            height: 15,
                          ),

                          /////////   Email     TextFormField+++++++++++++++

                          SizedBox(
                            height: 45,
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Email",
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
                          /////

                          const SizedBox(height: 20),

                          //// Passwd TextFormField ++++++++++++++++++++++++
                          SizedBox(
                            height: 45,
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              obscureText: true,
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Password",
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Theme.of(context).primaryColor,
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
                          ////

                          const SizedBox(
                            height: 20,
                          ),

                          //////////  Registration buttton++++++++++++++

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () {
                                // register();
                              },
                            ),
                          ),

                          /////
                          const SizedBox(
                            height: 10,
                          ),

                          /////   Send to Login page

                          Text.rich(TextSpan(
                            text: "Already have an account? ",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Login now",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      nextScreen(context, const LoginPage());
                                    }),
                            ],
                          )),
                          ////
                        ],
                      )),
                ),
              ),
            ),
    );
  }
}
