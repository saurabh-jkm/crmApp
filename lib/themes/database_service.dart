// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

/////// reference for our collections  ++++++++++++++++++++++++++++++++++++

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

/////// saving the userdata   +++++++++++++++++++++++++++++++++++++++++++++

  Future savingUserData(String fName, String lName, String email, String Mobile,
      String pass, String status, String date) async {
    return await userCollection.doc(uid).set({
      "first_name": fName,
      "last_name": lName,
      "email": email,
      "mobile_no": Mobile,
      "password": pass,
      "status": status,
      "date_at": date,
      "uid": uid,
    });
  }

  /////// getting user data

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  ///// get user groups  ++++++++++++++++++++++++++++++++++

  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }
}
