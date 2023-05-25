
// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../controllers/MenuAppController.dart';
import '../../responsive.dart';
import '../../themes/theme_widgets.dart';
import '../main/main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
final EmailController = TextEditingController();
final PassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:  Container(
          margin: EdgeInsets.symmetric(vertical: 50,horizontal:(!Responsive.isMobile(context)?100:20)),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
          borderRadius: BorderRadius.circular(20)
          ),
          child: ListView(
       children: [


         Expanded(
           child:
            Row(
              children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(20),
                child: Image(image: AssetImage("assets/images/loginn.png"))),
            ),


             if (!Responsive.isMobile(context))
             SizedBox(width: defaultPadding),
                      // On Mobile means if the screen is less than 850 we dont want to show it
            if (!Responsive.isMobile(context))
              Expanded(
                child: Container(
                margin: EdgeInsets.symmetric(vertical:20,horizontal:20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Sign In",style: GoogleFonts.akayaKanadaka(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.black),),
                    ],
                  ), 
                  SizedBox(height: 20,),
                  Text_field(context, EmailController,"Enter Your Email","Email",Icons.email_rounded,"1"),
                  Text_field(context, PassController,"Enter Password","Password",Icons.lock_person_rounded,"2"),
                     SizedBox(height: 20,),
                     Row(
                         mainAxisAlignment: MainAxisAlignment.start,  
                       children: [
                             themeButton3(context, () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                         MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => MenuAppController(),
                  ),
                ],
                child:   MainScreen() // MainScreen(),          
              ),
                                 
                                 ));
                               }, buttonColor: Colors.green, label: "Log In"),
                       ],
                     )   ,    
            SizedBox(height: 10,),           
            Row( 
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                TextButton(onPressed: (){}, child:                 Text(
                'Create an account',
                style: TextStyle(
                  fontSize: 12.5,
                  decoration: TextDecoration.underline,
                  color: Colors.blue
                ),
              ),) 
            ],
          ), 
                  ],
                ) 
                )
                ),
           ],),
         ),

         if (Responsive.isMobile(context))
             SizedBox(width: defaultPadding),
                      // On Mobile means if the screen is less than 850 we dont want to show it
          if (Responsive.isMobile(context))

      Expanded(
                child: Container(
                margin: EdgeInsets.symmetric(vertical:20,horizontal:20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Sign In",style: GoogleFonts.akayaKanadaka(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.black),),
                    ],
                  ), 
                  SizedBox(height: 20,),
                  Text_field(context, EmailController,"Enter Your Email","Email",Icons.email_rounded,"1"),
                  Text_field(context, PassController,"Enter Password","Password",Icons.lock_person_rounded,"2"),
                     SizedBox(height: 20,),
                     Row(
                         mainAxisAlignment: MainAxisAlignment.start,  
                       children: [
                             themeButton3(context, () {
                               MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => MenuAppController(),
                  ),
                ],
                child:   MainScreen() // MainScreen(),          
              );
                               }, buttonColor: Colors.green, label: "Log In"),
                       ],
                     )   , 
            SizedBox(height: 10,),           
            Row( 
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                TextButton(onPressed: (){}, child:                 Text(
                'Create an account',
                style: TextStyle(
                  fontSize: 12.5,
                  decoration: TextDecoration.underline,
                  color: Colors.blue
                ),
              ),) 
            ],
          ),
   
                  ],
                ) 
                )
                ),

       ],
     ),),

    );
  }

  bool passwordVisible=false;
///////  Text_field 22 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
///
  Widget Text_field(BuildContext context, ctr_name, lebel, hint ,icons,type) {
    return Container(
        height: 45,
         alignment: Alignment.center,
        margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: ctr_name,
          style: TextStyle(color: Colors.black),
           obscureText: passwordVisible,
          decoration: InputDecoration(
             prefixIcon:
                  IconButton(onPressed: () {}, icon: Icon(icons,color: Colors.black,)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            hintText: '$hint',
            
               suffixIcon:(type == "2")? IconButton(
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off   ,color: Colors.blue,size: 20,),
                      onPressed: () {
                        setState(
                          () {
                            passwordVisible = !passwordVisible;
                          },
                        );
                      },
                    )
                   : SizedBox(),
                    alignLabelWithHint: false,
                    filled: true,
                  
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),

          ),
        ));
  }
///////////

}///Class closs