// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class base_controller {
  List<LogicalKeyboardKey> Keys = [];
  KeyPressFun(e, context, {backtype: 'popup'}) {
    final key = e.logicalKey;
    if (e is RawKeyDownEvent) {
      // scape button
      if (e.isKeyPressed(LogicalKeyboardKey.escape)) {
        if (backtype == 'dashboard') {
          Navigator.popAndPushNamed(context, '/dashboard');
        } else {
          Navigator.pop(context);
        }
      }
    } else {
      Keys.remove(key);
    }
  }
}// class close
