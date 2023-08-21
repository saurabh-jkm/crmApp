// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firestore/firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

/////// reference for our collections  ++++++++++++++++++++++++++++++++++++

/////// saving the userdata   +++++++++++++++++++++++++++++++++++++++++++++

  Future savingUserData(String fName, String lName, String email, String Mobile,
      String pass, String user_Cate, String status, String date) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection("users");
    return await userCollection.doc(uid).set({
      "first_name": fName,
      "last_name": lName,
      "email": email,
      "mobile_no": Mobile,
      "password": pass,
      "user_category": user_Cate,
      "status": status,
      "date_at": date,
      "uid": uid,
    });
  }

  Future win_savingUserData(
      String fName,
      String lName,
      String email,
      String Mobile,
      String pass,
      String user_Cate,
      String status,
      String date) async {
    final userCollection = Firestore.instance.collection("users");
    return await userCollection.document(uid!).set({
      "first_name": fName,
      "last_name": lName,
      "email": email,
      "mobile_no": Mobile,
      "password": pass,
      "user_category": user_Cate,
      "status": status,
      "date_at": date,
      "uid": uid,
    });
  }

  ////////////////////=========================================================
  /////// getting user data

  Future gettingUserData(String email) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection("users");
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  ///// get user groups  ++++++++++++++++++++++++++++++++++

  getUserGroups() async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection("users");
    return userCollection.doc(uid).snapshots();
  }
}
