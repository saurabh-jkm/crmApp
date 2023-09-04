import 'package:crm_demo/screens/product/product/product_widgets.dart';
import 'package:crm_demo/themes/style.dart';
import 'package:flutter/material.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:intl/intl.dart';

class ProductController {
  //var db = FirebaseFirestore.instance;
  var db = Firestore.instance;

  //  var db = (!kIsWeb && Platform.isWindows)
  //     ? Firestore.instance
  //     : FirebaseFirestore.instance;

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final brandController = TextEditingController();

  // for new attribute
  final newAttributeController = TextEditingController();

  // temporary
  Map<String, TextEditingController> dynamicControllers = new Map();

  Map<String, TextEditingController> locationControllers = new Map();
  Map<String, TextEditingController> locationQuntControllers = new Map();

  // Suggation List =====================================
  List<String> ListName = [];
  List<String> ListCategory = [];
  Map<String, dynamic> ListAttribute = {};
  Map<String, dynamic> ListAttributeWithId = {};

  int totalLocation = 1;

  init_functions() async {
    await getProductNameList();
    await getCategoryList();
    await getAttributeList();

    locationControllers['1'] = TextEditingController();
    locationQuntControllers['1'] = TextEditingController();
  }

  // reset controller
  resetController() {
    nameController.text = '';
    categoryController.text = '';
    quantityController.text = '';
    priceController.text = '';
    brandController.text = '';
  }

  // get all product name List =============================
  getProductNameList() async {
    ListName = [];
    var dbData = await db.collection('product').get();

    dbData.forEach((doc) {
      ListName.add(doc.map['name']);
    });
  }

  // get all product Category List =============================
  getCategoryList() async {
    ListCategory = [];
    var dbData = await db.collection('category').get();
    dbData.forEach((doc) {
      ListCategory.add(doc.map['category_name']);
    });
  }

  // get all  Attribute List =============================
  getAttributeList() async {
    ListAttribute = {};
    var dbData = await db.collection('attribute').get();
    dbData.forEach((doc) {
      List<String> temp = [];
      if (doc.map['value'] != null) {
        doc.map['value'].forEach((k, v) {
          temp.add(k);
        });
      }
      ListAttribute[doc.map['attribute_name'].toLowerCase()] = temp;
      ListAttributeWithId[doc.map['attribute_name'].toLowerCase()] = {
        'id': doc.id,
        'data': doc.map
      };
      dynamicControllers[doc.map['attribute_name'].toLowerCase()] =
          TextEditingController();
    });
  }

  // Attribute Value List =============================
  fnUpdateAttrVal(key, value) async {
    var doc = ListAttributeWithId[key];
    var tempArr = doc['data']['value'];

    tempArr[value] = {"name": value, "status": "1"};
    var dbArr = doc['data'];
    dbArr['value'] = tempArr;
    await db.collection('attribute').document(doc['id']).set(dbArr);
  }

  // add new category
  fnAddNewCat(parentCat, context) async {
    // add new category
    var dbCollection = await db.collection('category');
    // default value
    var dbArr = {
      "category_name": categoryController.text,
      "img": '',
      "parent_cate": (parentCat == 'Primary') ? '' : parentCat,
      "date_at": DateFormat('dd-MM-yyyy').format(DateTime.now()),
      "status": "1",
      "slug_url": categoryController.text.replaceAll(" ", "-"),
    };

    return dbCollection.add(dbArr).then((value) async {
      Navigator.of(context).pop();
      await getCategoryList();
      await insertProduct(context);
    }).catchError((error) =>
        themeAlert(context, 'Failed to Update Category', type: "error"));
  }

  // add attribute Funciton
  fnAddAttribute(context) async {
    if (newAttributeController.text == '') {
      return false;
    }
    Navigator.of(context).pop();
    var dbCollection = await db.collection('attribute');
    if (ListAttribute.containsKey(newAttributeController.text.toLowerCase())) {
      themeAlert(context, "${newAttributeController.text} already added",
          type: 'error');
    }

    // default value
    var dbArr = {
      "attribute_name": newAttributeController.text,
      "img": '',
      "date_at": DateTime.now(),
      "status": "1",
      "value": {},
    };

    return await dbCollection.add(dbArr).then((value) async {
      await getAttributeList();
      newAttributeController.text = '';
    }).catchError((error) =>
        themeAlert(context, 'Failed to Update Category', type: "error"));
  }

// insert product ============================================
  insertProduct(context) async {
    var alert = '';
    if (nameController.text.length < 5) {
      alert = "Please Enter Valid Product Name";
    } else if (quantityController.text == '') {
      alert = "Quntity Required";
    } else if (categoryController.text == '') {
      alert = "Category Required";
    }

    if (alert != '') {
      themeAlert(context, "$alert", type: 'error');
      return false;
    }

    if (!ListCategory.contains(categoryController.text)) {
      addNewCategory(
          context, categoryController.text, ListCategory, fnAddNewCat,
          label: "Add New Category");
      return false;
    }

    var dbCollection = await db.collection('product');

    // default value
    var dbArr = {
      "name": nameController.text,
      "category": categoryController.text,
      "quantity": quantityController.text,
      "price": priceController.text,
      "date_at": DateTime.now(),
      "status": true
    };

    // for attribute
    dynamicControllers.forEach((key, value) async {
      if (value.text != '') {
        dbArr[key.toLowerCase()] = value.text;
        if (!ListAttribute[key.toLowerCase()].contains(value.text)) {
          await fnUpdateAttrVal(key, value.text);
        }
      }
    });

    // for address =================================
    var tempLocation = {};
    locationControllers.forEach((key, value) {
      tempLocation[key] = value.text;
    });

    // location quantity
    var location = {};
    locationQuntControllers.forEach((key, value) {
      if (tempLocation[key] != '') {
        location[tempLocation[key]] = value.text;
      }
    });

    dbArr['item_location'] = location;

    // return false;

    return dbCollection.add(dbArr).then((value) {
      themeAlert(context, "Submitted Successfully ");
      resetController();

      Navigator.popAndPushNamed(context, '/add_stock');

      //Navigator.pop(context, 'updated');
    }).catchError(
        (error) => themeAlert(context, 'Failed to Submit', type: "error"));
  }
}
