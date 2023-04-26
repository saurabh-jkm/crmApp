// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_print, unnecessary_string_interpolations, unused_import, unnecessary_null_comparison

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
  var url;
File file = File(filepath);
try{
     await storage.ref('media/$fileName').putFile(file);
       
    downloadURLExample('media/$fileName');
} 
on 
firebase_core.FirebaseException 
catch (e) {
print("$e");
}
}



Future downloadURLExample(image_path) async{
String?  downloadURL;
downloadURL = await FirebaseStorage.instance
.ref()
.child(image_path)
.getDownloadURL();
//debugPrint(downloadURL.toString());
 print("${downloadURL.toString()}  ++++++++++++++++++++");
return downloadURL.toString();
 //print("${downloadURL.toString()}  ++++++++++++++++++++");

}


class FireStoreDatabase{
  String?  downloadURL;

  // Future getData() async{
  // try
  //  {
  //   await downloadURLExample();
  //   return downloadURL;
  // }
  // catch (e){
  //    debugPrint("Error - $e");
  //    return null;
  // }
  // }

// Future<firebase_storage.ListResult> listFiles()
// async {
//  // var returnData = {};
//  firebase_storage.ListResult results = await storage.ref('media').listAll();
//  results.items.forEach((firebase_storage.Reference ref) {
//      //print("Found file: ${ref.fullPath}");
//     // returnData['u1rl'] =
//     downloadURLExample("${ref.fullPath}");
     
//   });
//   return results;
// }


List myList = [];
Future listExample() async {
    var MediaLink = [];
    firebase_storage.ListResult result =
        await firebase_storage.FirebaseStorage.instance.ref('media').listAll();
    result.items.forEach((firebase_storage.Reference ref) async {
     //   print('Found file: $ref++++++++++++++++++++++');
    //  print("Found file: ${ref.fullPath}");
      // myList.add("${downloadURLExample("${ref.fullPath}")}");
      print("++=======================");
      var uri = await downloadURLExample("${ref.fullPath}");
    //   print(uri);
       myList.add(uri);
      //myList.add("${ref.fullPath}");
   //   print("Found file: ${ref.fullPath}");
    //  MediaLink.add("${ref.fullPath}");
    });
     return myList;
     // print("$MediaLink  -----");
    // result.prefixes.forEach((firebase_storage.Reference ref) {
    //     print('Found directory: $ref ++++++++++++++++++++');
    // });
}

Future downloadURLExample(image_path) async{
downloadURL = await FirebaseStorage.instance
.ref()
.child(image_path)
.getDownloadURL();
//debugPrint(downloadURL.toString());
 print("${downloadURL.toString()}  ++++++++++++++++++++");
return downloadURL.toString();
 //print("${downloadURL.toString()}  ++++++++++++++++++++");

}



}