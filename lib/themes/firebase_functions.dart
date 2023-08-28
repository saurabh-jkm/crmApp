// ignore_for_file: unused_local_variable, dead_code, prefer_collection_literals, unnecessary_new, prefer_typing_uninitialized_variables, avoid_print, non_constant_identifier_names, avoid_single_cascade_in_expression_statements, unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/foundation.dart';

//exmaple calling DB  function
// Map<dynamic, dynamic> where = {
//   'table': "users",
//   'phone': '11199119911',
//   'gender': 'transgender',
//   'orderBy': 'phone',
//   'limit': 1,
// };
//dbSave(db, where);
//dbDelete(db, 'users', 'LQJbIfdB15SHDCf51p03');
//print(dbFindDynamic(db, where));

dbUpdate(db, where) {
  var returnData = '';
  if (where == null || where == '') {
    return "Map data is empty";
    return false;
  }

  if (where['table'] == null) {
    return "Table name required!!";
    return false;
  }
  var table = (where['table']);
  where.remove('table');

  if (where['id'] == null) {
    return "id required";
    return false;
  }
  var id = (where['id']);
  where.remove('id');

  // return false;

  db.collection(table).doc(id).update(where).then((value) {
    returnData = 'Updated';
  }).catchError((error) {
    returnData = "Updattion Failed: $error";
  });
  return returnData;
}

//////////// All dbUpdate
All_dbUpdate(
  db,
  where,
) {
  var returnData = '';
  if (where == null || where == '') {
    return "Map data is empty";
    return false;
  }

  if (where['table'] == null) {
    return "Table name required!!";
    return false;
  }
  var table = (where['table']);
  where.remove('table');

  if (where['id'] == null) {
    return "id required";
    return false;
  }
  var id = (where['id']);
  where.remove('id');

  // return false;
  db.collection(table).document(id).update(where).then((value) {
    returnData = 'Updated';
  }).catchError((error) {
    returnData = "Updattion Failed: $error";
  });
  return returnData;
}
//////

///////////////////////////    data Save    ++++++++++++++++

dbSave(db, where) async {
  var returnData = '';
  if (where == null || where == '') {
    return "Map data is empty";
  }

  if (where['table'] == null) {
    return "Table name required!";
  }
  var table = (where['table']);
  where.remove('table');

  final data =
      await db.collection(table).add(where).then((DocumentReference doc) {
    return doc.id;
  });

  return data;
}

win_dbSave(db, where) async {
  var returnData = '';
  if (where == null || where == '') {
    return "Map data is empty";
  }

  if (where['table'] == null) {
    return "Table name required!";
  }
  var table = (where['table']);
  where.remove('table');
  var tabledb = await db.collection(table);

  final data = await tabledb.add(where).then((doc) {
    return doc;
  });

  return data;
}

////////// ===================================================================
dbFind(where) async {
  if (where == null || where == '') {
    return {'error': 'Array Required'};
  }

  if (where['table'] == null) {
    return {'error': 'Table name required!!'};
  }
  var table = (where['table']);

  if (where['id'] == null) {
    return {'error': 'Document ID Required'};
  }
  var id = (where['id']);

  where.remove('id');

  final data = (!kIsWeb && Platform.isWindows)
      ? await Firestore.instance
          .collection(table)
          .document(id)
          .get()
          .then((documentSnapshot) {
          return documentSnapshot.map;
          // if (documentSnapshot.exists) {
          //   Map<int, dynamic> returnData2 = new Map();
          //   return documentSnapshot.data();
          // } else {
          //   return 'Document does not exist on the database';
          // }
        })
      : await FirebaseFirestore.instance
          .collection(table)
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            Map<int, dynamic> returnData2 = new Map();
            //print("${documentSnapshot.data()}  jjjj==");
            return documentSnapshot.data();
          } else {
            return 'Document does not exist on the database';
          }
        });

  return data;
}

dbFindDynamic(db, where) async {
  var returnData = '';
  if (where == null || where == '') {
    return {'error': 'Array Required'};
  }

  if (where['table'] == null) {
    return {'error': 'Table name required!!'};
  }
  var table = (where['table']);
  where.remove('table');

  var dbTable = db.collection(table);

  // Order by
  if (where['orderBy'] != null) {
    if (where['orderBy'].contains('-')) {
      //query = query.orderBy('dateAt', descending: true);
      dbTable = dbTable.orderBy(where['orderBy'].replaceAll("-", ""),
          descending: true);
    } else {
      //dbTable.orderBy(where['orderBy']);
    }
    where.remove('orderBy');
  }
  // Limit (limit must be integer formate)
  if (where['limit'] != null) {
    dbTable = dbTable.limit(where['limit']);

    where.remove('limit');
  }

  // Where Query
  var query;
  int i = 1;
  where.forEach((k, v) {
    //query.where('$k', isEqualTo: v);
    if (i == 1) {
      query = dbTable.where("$k", isEqualTo: "$v");
    } else {
      query = query.where("$k", isEqualTo: "$v");
    }
    i++;
  });

  query = (query == null || query == '') ? dbTable : query;

  final data = await query.get().then(
    (res) {
      Map<int, dynamic> returnData2 = new Map();

      int k = 0;

      for (var doc in res.docs) {
        //returnData2[doc.id] = doc.data();
        Map<String, dynamic> temp = doc.data();

        temp['id'] = doc.id;

        returnData2[k] = temp;

        k++;
      }
      // print("${returnData2} =====j2 ");
      return returnData2;
    },
    onError: (e) => print("Error completing: $e"),
  );

  return data;
}

//////////////////// Alll Windows ++++++++++++++++
All_dbFindDynamic(db, where) async {
  var returnData = '';
  if (where == null || where == '') {
    return {'error': 'Array Required'};
  }

  if (where['table'] == null) {
    return {'error': 'Table name required!!'};
  }
  var table = (where['table']);
  var dbTable = await db.collection(table);

  // final documents = await ref.get();
  int k = 0;
  final data = await dbTable.get().then(
    (res) {
      Map<int, dynamic> returnData2 = new Map();

      int k = 0;
      for (var doc in res) {
        //returnData2[doc.id] = doc.data();
        Map<String, dynamic> temp = doc.map;
        temp['id'] = doc.id;

        returnData2[k] = temp;

        k++;
      }
      // print("${returnData2} =====j2 ");
      return returnData2;
    },
    onError: (e) => print("Error completing: $e"),
  );
  return data;
}
////////////////////////////////////////================

// Delete function
dbDelete(db, where) {
  var returnData = '';
  if (where == null || where == '') {
    return "Map data is empty";
  }
  if (where['table'] == null) {
    return "Table name required!!";
  }

  db
      .collection(where['table'])
      .doc(where['id'])
      .delete()
      .then((value) {})
      .catchError((error) {
    returnData = "Updattion Failed: $error";
  });

  return returnData;
}

win_dbDelete(db, where) {
  var returnData = '';
  if (where == null || where == '') {
    return "Map data is empty";
  }
  if (where['table'] == null) {
    return "Table name required!!";
  }

  db
      .collection(where['table'])
      .document(where['id'])
      .delete()
      .then((value) {})
      .catchError((error) {
    returnData = "Updattion Failed: $error";
  });

  return returnData;
}

////////  =================================================================================