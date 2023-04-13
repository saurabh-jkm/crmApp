// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
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



