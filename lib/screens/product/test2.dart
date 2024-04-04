// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../themes/function.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _searchResults = [];

  Future<void> _runSearch(String searchText) async {
    final QuerySnapshot query = await _firestore
        .collection('product')
        // .where(Filter.or(Filter('name', isGreaterThanOrEqualTo: searchText),
        //     Filter('name', isGreaterThanOrEqualTo: searchText.toUpperCase())))

        .where('name', isGreaterThanOrEqualTo: searchText)
        // or(where('name', isGreaterThanOrEqualTo: searchText.toLowerCase() + 'z'), )
        // .where('name', isGreaterThanOrEqualTo: searchText.toLowerCase() + 'z')

        .where('name', isLessThan: searchText + 'z')
        .get();

    setState(() {
      _searchResults = query.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: ((value) async {
                await _runSearch(value);
              }),
              decoration: InputDecoration(
                hintText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _runSearch(_searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchResults.isNotEmpty
                ? ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _searchResults[index]['name'],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${formatDate(_searchResults[index]['date_at'], formate: 'dd/MM/yyyy – kk:mm')}",
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text('No results found'),
                  ),
          ),
        ],
      ),
    );
  }
}
