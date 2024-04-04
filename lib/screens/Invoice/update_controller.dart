// ignore_for_file: camel_case_types, unused_shown_name

import 'dart:io';
import 'package:firedart/firestore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

class updateController {
  var db = (!kIsWeb && Platform.isWindows)
      ? Firestore.instance
      : FirebaseFirestore.instance;

  // // supplier stock & update check ================================
  // supplierStockEdit(products, oldData, inputDataDbData) async {
  //   var i = 1;
  //   for (var k in products.keys) {
  //     var product = products[k];

  //     // check if the product exist in stock
  //     if (product['id'] == null || product['id'] == '') {
  //       // call insert function new product ===============================
  //       var updateProduct = {k: product};
  //       await updateStock(updateProduct);
  //       // check if product is not in old data ============================
  //     } else if (oldData[product['id']] == null ||
  //         oldData[product['id']]['${product['list_item_id']}'] == null) {
  //       // new ORDER
  //     } else {
  //       var li = product['list_item_id'];
  //       // old order calculate quantity & units
  //       var dbProduct = await dbFind({'table': 'product', 'id': product['id']});
  //       var oldVar = oldData[product['id']]['${product['list_item_id']}'];

  //       var listProduct = dbProduct['item_list'];

  //       var subProduct = listProduct['$li'];

  //       var dbSubQnt = int.parse(subProduct['quantity'].toString());
  //       //var dbSubUnit = int.parse(subProduct['totalUnit'].toString());
  //       var dbMainQnt = int.parse(dbProduct['quantity'].toString());

  //       if (oldVar['quantity'] != product['quantity']) {
  //         if (int.parse(oldVar['quantity'].toString()) >
  //             int.parse(product['quantity'].toString())) {
  //           // remove some data
  //           var qnt = int.parse(oldVar['quantity'].toString()) -
  //               int.parse(product['quantity'].toString());
  //           dbSubQnt += qnt;
  //           dbMainQnt += qnt;
  //         } else {
  //           // increase some data
  //           var qnt = int.parse(product['quantity'].toString()) -
  //               int.parse(oldVar['quantity'].toString());
  //           dbSubQnt -= qnt;
  //           dbMainQnt -= qnt;
  //         }

  //         // update quantity
  //         subProduct['quantity'] = dbSubQnt;
  //         dbProduct['quantity'] = dbMainQnt;
  //         listProduct['$li'] = subProduct;
  //         dbProduct['item_list'] = listProduct;

  //         // update stock db
  //         dbProduct['table'] = 'product';
  //         dbProduct['id'] = product['id'];

  //         //await dbUpdate(db, dbProduct);
  //       }
  //     }

  //     i++;
  //   }
  // }
}
