// ignore_for_file: prefer_const_constructors, prefer_final_fields, avoid_print, non_constant_identifier_names, unnecessary_string_interpolations, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, sized_box_for_whitespace, library_private_types_in_public_api

import 'dart:io';

import 'package:jkm_crm_admin/constants.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../themes/function.dart';
import '../../themes/style.dart';
import '../../themes/theme_widgets.dart';
import 'product/detail_product_screen.dart';
import 'test2.dart';

// ignore: use_key_in_widget_constructors
class PaginationScreen extends StatefulWidget {
  @override
  _PaginationScreenState createState() => _PaginationScreenState();
}

class _PaginationScreenState extends State<PaginationScreen> {
  final int _perPage = 3;
  int currentPage = 1;
  // Items per page
  List<DocumentSnapshot> _data = [];
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;
  final _controllers = TextEditingController();

  // Firebase query to retrieve data
  Future<void> _getData() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    QuerySnapshot querySnapshot;

    if (_lastDocument == null) {
      querySnapshot = await FirebaseFirestore.instance
          .collection('product') // Replace with your collection name
          // .orderBy('your_order_field') // Replace with your ordering field
          .limit(_perPage)
          .get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('product') // Replace with your collection name
          // .orderBy('your_order_field') // Replace with your ordering field
          .startAfterDocument(_lastDocument!)
          .limit(_perPage)
          .get();
    }

    if (querySnapshot.docs.isNotEmpty) {
      _data.addAll(querySnapshot.docs);
      _lastDocument = querySnapshot.docs.last;
    } else {
      _hasMore = false;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Stocks'),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  nextScreen(context, SearchScreen());
                },
                child: Text("Search")),
            Container(
              color: secondaryColor,
              height: 100,
              child: searchBar(context),
            ),
            HeadRow(context),
            Container(
              height: 320,
              child: ListView.builder(
                itemCount: _data.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _data.length) {
                    return _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox(); // Display an empty container or loading indicator at the end
                  }

                  final item = _data[index];

                  // Build UI using item data

                  return Rowlist(context, _data[index].data(), index, item.id);
                },
                // Pagination logic: Load more data when reaching the end of the list
                controller: ScrollController()
                  ..addListener(() {
                    if (!_isLoading &&
                        _hasMore &&
                        (context.size?.height ?? 0) - 1000 <=
                            (context.findRenderObject() as RenderBox)
                                .localToGlobal(Offset.zero)
                                .dy) {
                      _getData();
                    }
                  }),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                (currentPage > 1)
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentPage--;
                            // _getData();
                            // print("$currentPage");
                          });
                        },
                        child: Text('<<back'),
                      )
                    : Text('<<back',
                        style: TextStyle(color: Colors.black26, fontSize: 14)),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "$currentPage ",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                (currentPage < _data.length / 2)
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentPage++;
                            // print("$currentPage");
                            _getData();
                          });
                        },
                        child: Text('Next >>'),
                      )
                    : Text('Next >>',
                        style: TextStyle(color: Colors.black26, fontSize: 14)),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget HeadRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Colors.purple,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: 30,
              child: GoogleText(
                  text: "#",
                  fsize: 15,
                  fweight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(
              width: 150,
              child: GoogleText(
                  text: "Name",
                  fsize: 10,
                  fweight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(
              width: 90,
              child: GoogleText(
                  text: "Brand",
                  fsize: 10,
                  fweight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(
              width: 60,
              child: GoogleText(
                  text: "Category",
                  fsize: 10,
                  fweight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(
              width: 50,
              child: GoogleText(
                  text: "Qnt.",
                  fsize: 10,
                  fweight: FontWeight.bold,
                  color: Colors.white)),
          Expanded(
              child: GoogleText(
                  text: "Location",
                  fsize: 10,
                  fweight: FontWeight.bold,
                  color: Colors.white)),
          Expanded(
              child: GoogleText(
                  text: "Price⟨₹⟩",
                  fsize: 10,
                  fweight: FontWeight.bold,
                  color: Colors.white)),
          Expanded(
              child: GoogleText(
                  text: "Status",
                  fsize: 10,
                  fweight: FontWeight.bold,
                  color: Colors.white)),
          Expanded(
              child: GoogleText(
                  text: "Date",
                  fsize: 10,
                  fweight: FontWeight.bold,
                  color: Colors.white)),
          Container(
              padding: EdgeInsets.only(right: 20.0),
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: GoogleText(
                  text: "Action",
                  fsize: 10,
                  fweight: FontWeight.bold,
                  color: Colors.white))
        ],
      ),
    );
  }

  var selected_pro = {};
  Widget Rowlist(BuildContext context, item, index, id) {
    // print("$item    ++++++++++++++++++++++");
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Color.fromARGB(146, 163, 62, 180),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: 30,
              child: Text(
                  "${index + 1}" // Replace with the field you want to display
                  )),
          SizedBox(
              width: 150,
              child: Row(
                children: [
                  Container(
                    width: 30.0,
                    child: CheckboxListTile(
                      checkColor: Colors.white,
                      activeColor: Colors.red,
                      side: BorderSide(
                          width: 2, color: Color.fromARGB(255, 74, 83, 75)),
                      value: (selected_pro[id] == null) ? false : true,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selected_pro[id] = true;
                          } else {
                            selected_pro.remove(id);
                          }

                          // print("$selected_pro    +++++++");
                        });
                      },
                    ),
                  ),
                  GoogleText(
                      text: "${item['name']}",
                      maxline: 2,
                      fsize: 10,
                      color: Colors.white)
                ],
              )),
          SizedBox(
              width: 90,
              child: GoogleText(
                  text: "${item['brand']}",
                  maxline: 1,
                  fsize: 10,
                  color: Colors.white)),
          SizedBox(
              width: 60,
              child: GoogleText(
                  text: "${item['category']}",
                  maxline: 1,
                  fsize: 10,
                  color: Colors.white)),
          SizedBox(
              width: 50,
              child: GoogleText(
                  text: "${item['quantity']}",
                  maxline: 1,
                  fsize: 10,
                  color: Colors.white)),
          Expanded(
              child: Text(
                  "${item['location']}" // Replace with the field you want to display
                  )),
          Expanded(
              child: Text(
                  "${item['price']}" // Replace with the field you want to display
                  )),
          Expanded(
              child: Text(
            "${statusOF(item['status'])}",
            style: TextStyle(
                color: ("${statusOF(item['status'])}" == "Active")
                    ? Colors.green
                    : Colors.red),
            // Replace with the field you want to display
          )),
          Expanded(
              child: Text(
                  "${formatDate(item['date_at'], formate: 'dd/MM/yyyy')}" // Replace with the field you want to display
                  )),
          Container(
            padding: EdgeInsets.only(right: 10.0),
            margin: EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 10, 103, 139),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Details_product(
                                        header_name: "View details of product",
                                        MapData: item,
                                      )));
                        },
                        icon: Icon(
                          Icons.remove_red_eye_outlined,
                          size: 15,
                          color: Colors.green,
                        ))),
                // SizedBox(width: 10),
                // Container(
                //     height: 30,
                //     width: 30,
                //     alignment: Alignment.center,
                //     decoration: BoxDecoration(
                //       color: Color.fromARGB(255, 10, 103, 139),
                //       borderRadius:
                //           const BorderRadius.all(Radius.circular(10)),
                //     ),
                //     child: IconButton(
                //         onPressed: () async {
                //           final temp = await Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (_) => editStockScreen(
                //                         data: data,
                //                         header_name: "Edit product details",
                //                       )));
                //           if (temp == 'updated') {
                //             Pro_Data_list(_number_select);
                //           }
                //         },
                //         icon: Icon(
                //           Icons.edit,
                //           size: 15,
                //           color: Colors.blue,
                //         )) ////
                //     ),
                SizedBox(width: 10),
                Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 10, 103, 139),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: IconButton(
                        onPressed: () {
                          showExitPopup(id);
                        },
                        icon: Icon(
                          Icons.delete_outline_outlined,
                          size: 15,
                          color: const Color.fromARGB(255, 255, 117, 107),
                        ))),
              ],
            ),
          )
        ],
      ),
    );
  }

///////// Alart Popup  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Future<bool> showExitPopup(iid_delete) async {
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
              'Are you sure to delete this Product ?',
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
                  onPressed: () async {
                    await delete_Pro(iid_delete);
                    themeAlert(context, "Deleted Successfully ");
                    Navigator.of(context).pop(false);
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
/////////  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
///////  delete  Product ++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Future<void> delete_Pro(id) {
    // var db = FirebaseFirestore.instance;
    if (!kIsWeb && Platform.isWindows) {
      final _product = Firestore.instance.collection('product');
      return _product.document(id).delete().then((value) {
        setState(() {
          // _controllers.clear();
          // productList2 = [];
          // Pro_Data_list(_number_select);
        });
      }).catchError(
          (error) => themeAlert(context, 'Not find Data', type: "error"));
    } else {
      var _product = FirebaseFirestore.instance.collection('product');
      return _product.doc(id).delete().then((value) {
        setState(() {
          // _controllers.clear();
          // productList2 = [];
          // Pro_Data_list(_number_select);
        });
      }).catchError(
          (error) => themeAlert(context, 'Not find Data', type: "error"));
    }
  }

///////// search Bar For Product  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Widget searchBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: (selected_pro.isNotEmpty && selected_pro != {})
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ////  Delete Selected Product +++++++++++++++++++++++++++++++++++++++
          if (selected_pro.isNotEmpty && selected_pro != {})
            themeButton3(context, () {
              selected_pro.forEach(
                  (k, v) async => await delete_Pro(k) //   showExitPopup(k)
                  );
              themeAlert(context, "Deleted Successfully ");
              setState(() {
                selected_pro = {};
              });
            },
                label: "Delete selected items : ${selected_pro.length}",
                buttonColor: Colors.red,
                radius: 10.0),

          // date filter

          //////// Search ++++++++++
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.only(top: 20, right: 10, bottom: 10),
            padding: EdgeInsets.all(8.0),
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.25,
            child: TextField(
              controller: _controllers,
              onChanged: ((value) {
                // _filterItems(value);
              }),
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: 'Search Product ,Category, Brand & Colors ....',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  border: InputBorder.none,
                  suffixIcon: (_controllers.text.isEmpty)
                      ? Icon(Icons.search, size: 30, color: Colors.blue)
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _controllers.clear();
                              // productList2 = [];
                              // Pro_Data_list(_number_select);
                            });
                          },
                          child: Icon(Icons.search_off, color: Colors.red))),
            ),
          )
        ],
      ),
    );
  }
/////////////=====================================================================
  ///
}/// class close
