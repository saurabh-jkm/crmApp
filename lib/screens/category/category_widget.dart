// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, non_constant_identifier_names

import 'package:flutter/material.dart';

import '../../themes/style.dart';

///////  Text_field 22 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
///

Future<bool> showExitPopup(iid_delete, context) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Icon(
                Icons.delete_forever_outlined,
                color: Colors.red,
                size: 35,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                'CRM App says',
                style: themeTextStyle(
                    size: 20.0,
                    ftFamily: 'ms',
                    fw: FontWeight.bold,
                    color: themeBG2),
              ),
            ],
          ),
          content: Text(
            'Are you sure to delete this Categorys ?',
            style: themeTextStyle(
                size: 16.0,
                ftFamily: 'ms',
                fw: FontWeight.normal,
                color: Colors.black87),
          ),
          actions: [
            Container(
              height: 30,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: themeTextStyle(
                      size: 16.0,
                      ftFamily: 'ms',
                      fw: FontWeight.normal,
                      color: Colors.red),
                ),
              ),
            ),
            Container(
              height: 30,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: TextButton(
                onPressed: () {
                  // setState(() {
                  //   if (kIsWeb) {
                  //     deleteUser(iid_delete);
                  //   } else if (!kIsWeb) {
                  //     All_deleteUser(iid_delete);
                  //   }
                  //   Navigator.of(context).pop(false);
                  // });
                },
                child: Text(
                  'Yes',
                  style: themeTextStyle(
                      size: 16.0,
                      ftFamily: 'ms',
                      fw: FontWeight.normal,
                      color: themeBG4),
                ),
              ),
            ),
          ],
        ),
      ) ??
      false; //if showDialouge had returned null, then return false
}


///////////