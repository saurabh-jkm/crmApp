// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show Uint8List, debugPrint, kIsWeb;
  final firebase_storage.FirebaseStorage storage = 
   firebase_storage.FirebaseStorage.instance;

Future<void> UploadFile(
  String filepath,
  String fileName,
) 
async {
File file = File(filepath);

try{
  await storage.ref('media/$fileName').putFile(file);
} 
on firebase_core.FirebaseException 
catch (e) {
print("$e");
}
}

Future<firebase_storage.ListResult> listFiles()
async {
 firebase_storage.ListResult results = await storage.ref('media').listAll();
 results.items.forEach((firebase_storage.Reference ref) {
   print("Found file: $ref");
  });
  return results;
}

Future<String> downloadURL(String imageName) async {
String downloadURL = await storage.ref('media/$imageName').getDownloadURL();
return downloadURL;
}

class FireStoreDatabase{
  String?  downloadURL;
  Future getData() async{
  try
   {
    await downloadURLExample();
    return downloadURL;
  }
  catch (e){
     debugPrint("Error - $e");
     return null;
  }
  }

Future<void> downloadURLExample() async{
downloadURL = await FirebaseStorage.instance
.ref()
.child("media/Guddusingh.jpeg")
.getDownloadURL();
debugPrint(downloadURL.toString());
}



}