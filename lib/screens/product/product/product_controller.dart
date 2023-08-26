import 'package:crm_demo/themes/firebase_functions.dart';
import 'package:crm_demo/themes/style.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firedart/firestore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

class ProductController {
  //var db = FirebaseFirestore.instance;
  var db = Firestore.instance;

  // var db = (!kIsWeb && Platform.isWindows)
  //     ? Firestore.instance
  //     : FirebaseFirestore.instance;

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final brandController = TextEditingController();

  // reset controller
  resetController() {
    nameController.text = '';
    categoryController.text = '';
    quantityController.text = '';
    priceController.text = '';
    brandController.text = '';
  }

// insert product
  insertProduct(context) async {
    var alert = '';
    if (nameController.text.length < 5) {
      alert = "Please Enter Valid Product Name";
    } else if (quantityController.text == '') {
      alert = "Quntity Required";
    }

    var dbCollection = await db.collection('product');
    return dbCollection.add({
      "name": nameController.text,
      "category": categoryController.text,
      "quantity": quantityController.text,
      "price": priceController.text,
      "brand": brandController.text,
      "date_at": DateTime.now(),
      "status": true
    }).then((value) {
      themeAlert(context, "Submitted Successfully ");
      resetController();
    }).catchError(
        (error) => themeAlert(context, 'Failed to Submit', type: "error"));
  }
}
