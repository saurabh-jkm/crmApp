// import 'package:chatapp_firebase/helper/helper_function.dart';
// import 'package:chatapp_firebase/service/database_service.dart';
// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';

import '../helper/helper_function.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  /////// login
  
  
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

////////// register
 //fname,lname, email, Mobile, password,_StatusValue,Date_at
  Future registerUserWithEmailandPassword(String fname, String lname, String email,String mobile, String password, String _Status, String date_at) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user data.
        await DatabaseService(uid: user.uid).savingUserData(fname,lname, email,mobile, password, _Status,date_at);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

 ////// signout
 
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
