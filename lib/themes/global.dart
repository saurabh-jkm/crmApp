// ignore_for_file: non_constant_identifier_names

library my_prj.globals;

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';

var is_mobile = false;
var arr_webVersion = 23;
// android new versoin======
int androidRealeaseNo = 4;
bool arrIsLocationAllowed = false;

///
var db = (!kIsWeb && Platform.isWindows)
    ? Firestore.instance
    : FirebaseFirestore.instance;
// var dbd = Firestore.instance;    
///