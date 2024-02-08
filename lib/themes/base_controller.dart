// ignore_for_file: non_constant_identifier_names, deprecated_colon_for_default_value, camel_case_types

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
        } else if (backtype == 'seller') {
          Navigator.popAndPushNamed(context, '/seller');
        } else {
          Navigator.pop(context);
        }
      }
    } else {
      Keys.remove(key);
    }
  }
}// class close
