import 'dart:convert';

import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookSearchPage extends StatefulWidget {
  const BookSearchPage({Key key}) : super(key: key);

  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  final TextEditingController _searchTextController = TextEditingController();

  Future<void> _search() async {
    await fetchBooks(searchText: _searchTextController.text);
  }

  Future<void> fetchBooks({@required String searchText}) async {
    //  https://www.googleapis.com/books/v1/volumes?q=flutter%20development
    http.Response response = await http.get(Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=javascript'));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      final Iterable list = body['items'];
      for (var item in list) {
        print(item['volumeInfo']['title']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Search'),
        backgroundColor: Colors.redAccent,
      ),
      body: Material(
        elevation: 0.0,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.90,
            height: MediaQuery.of(context).size.height * 0.90,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 8.0,
                  ),
                  child: Form(
                    child: TextField(
                      controller: _searchTextController,
                      decoration: buildInputDecoration(
                        labelText: 'Search',
                        hintText: 'Flutter Development',
                      ),
                      onSubmitted: (String value) {
                        _search();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
