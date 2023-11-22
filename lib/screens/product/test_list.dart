// ignore_for_file: prefer_const_constructors, prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // Firebase query to retrieve data
  Future<void> _getData() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    QuerySnapshot querySnapshot;
    print("$_lastDocument  +++++++++++++++");
    if (_lastDocument == null) {
      querySnapshot = await FirebaseFirestore.instance
          .collection('product') // Replace with your collection name
          // .orderBy('your_order_field') // Replace with your ordering field
          //.limit(_perPage)
          .startAt([1]).endAt([3]).get();
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
      print(_lastDocument);
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
      appBar: AppBar(
        title: Text('Firestore Pagination'),
      ),
      body: Column(
        children: [
          Container(
            height: 400,
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

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 40,
                        child: Text(
                            "$index" // Replace with the field you want to display
                            )),
                    Expanded(
                        child: Text(item[
                                'name'] // Replace with the field you want to display
                            )),
                    Expanded(
                        child: Text(item[
                                'brand'] // Replace with the field you want to display
                            )),
                  ],
                );
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
            child: Row(children: [
              (currentPage > 1)
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentPage--;
                          print("$currentPage");
                        });
                      },
                      child: Text('<<back'),
                    )
                  : Text('<<back',
                      style: TextStyle(color: Colors.black26, fontSize: 14)),
              Container(
                margin: EdgeInsets.all(10),
                child: Text("$currentPage "),
              ),
              (currentPage < _data.length)
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentPage++;
                          print("$currentPage");
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
    );
  }
}
