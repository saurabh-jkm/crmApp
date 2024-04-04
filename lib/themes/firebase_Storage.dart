// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_print, unnecessary_string_interpolations, unused_import, unnecessary_null_comparison, file_names, prefer_const_declarations, unused_local_variable, unused_shown_name, depend_on_referenced_packages, duplicate_ignore, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:http/http.dart' as http;
import 'package:jkm_crm_admin/themes/style.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show Uint8List, debugPrint, kIsWeb;
import 'dart:convert';

import '../screens/order/invoice_service.dart';
import '../shared/constants.dart';
import 'firebase_functions.dart';

final firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;
var db = (!kIsWeb && Platform.isWindows)
    ? Firestore.instance
    : FirebaseFirestore.instance;
Future<void> UploadFile(
  String filepath,
  String fileName,
) async {
  File file = File(filepath);
  try {
    await storage.ref('media/$fileName').putFile(file);

    downloadURLExample('media/$fileName');
  } on firebase_core.FirebaseException catch (e) {
    print("$e");
  }
}

Future downloadURLExample(image_path) async {
  String? downloadURL;
  downloadURL =
      await FirebaseStorage.instance.ref().child(image_path).getDownloadURL();
  return downloadURL.toString();
}

class FireStoreDatabase {
  String? downloadURL;
  List myList = [];
  Future listExample() async {
    // ignore: unused_local_variable
    var MediaLink = [];
    firebase_storage.ListResult result =
        await firebase_storage.FirebaseStorage.instance.ref('media').listAll();
    result.items.forEach((firebase_storage.Reference ref) async {
      var uri = await downloadURLExample("${ref.fullPath}");
      myList.add(uri);
    });
    return myList;
  }

///////   Download URL function Storage image path convert to Image Url +++++++++++++

  Future downloadURLExample(image_path) async {
    downloadURL =
        await FirebaseStorage.instance.ref().child(image_path).getDownloadURL();
    return downloadURL.toString();
  }
}

////////////////////////////  Rest Api  ????????????????
//Future<void>
uploadFile(String filepath, String fileName, var db) async {
  var ulr;
  final storageBucket = Constants.storageBucket;
  final apiKey = Constants.apiKey;
  // final File file = await File(filepath);

  final fileBytes = await File(filepath).readAsBytes();
  // final fileBase64 = base64Encode(fileBytes);

  var url = Uri.parse(
      "https://firebasestorage.googleapis.com/v0/b/$storageBucket/o?uploadType=media&name=media/$fileName");
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',

      'Content-Type':
          'application/octet-stream', // Replace with your file's content type
    },
    body: fileBytes,
  );

  if (response.statusCode == 200) {
    var tempRetrunData = jsonDecode(response.body) as Map<dynamic, dynamic>;
    ulr =
        "https://firebasestorage.googleapis.com/v0/b/crmapp-aed0e.appspot.com/o/media%2F$fileName?alt=media&token=${tempRetrunData["downloadTokens"]}";
    await image_addList(ulr);

    return ulr;
  } else {
    print("Error uploading file: ${response.statusCode}");
  }
}

//////
/////// add Category Data  =+++++++++++++++++++

Future<void> image_addList(image_url) async {
  Map<String, dynamic> w = {
    'table': "window_image",
    'image_url': "$image_url",
    "date_at": "$Date_at"
  };

  if (!kIsWeb && Platform.isWindows) {
    await win_dbSave(db, w);
  } else {
    await dbSave(db, w);
  }
}

//////////






