import 'dart:convert';

import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../widgets/search_book_detail_dialog.dart';

class BookSearchPage extends StatefulWidget {
  const BookSearchPage({Key key}) : super(key: key);

  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  TextEditingController _searchTextController = TextEditingController();
  List<Book> listOfBooks = [];
  final CollectionReference bookCollectionReference =
      FirebaseFirestore.instance.collection('books');

  Future<void> _search() async {
    fetchBooks(searchText: _searchTextController.text).then((value) {
      setState(() {
        listOfBooks = value;
      });
    }, onError: (error) {
      throw Exception('Failed to load books ${error.toString()}');
    });
  }

  Future<List<Book>> fetchBooks({@required String searchText}) async {
    List<Book> books = [];
    http.Response response = await http.get(
        Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$searchText'));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      final Iterable list = body['items'];
      for (var item in list) {
        String title = item['volumeInfo']['title'];
        String author = item['volumeInfo']['authors'] == null
            ? 'N/A'
            : item['volumeInfo']['authors'][0];
        String thumbNail = (item['volumeInfo']['imageLinks'] == null)
            ? ''
            : item['volumeInfo']['imageLinks']['thumbnail'];
        String publishedDate = item['volumeInfo']['publishedDate'] ?? 'N/A';
        String description = item['volumeInfo']['description'] ?? 'N/A';
        int pageCount = item['volumeInfo']['pageCount'] ?? 0;
        String rating = item['volumeInfo']['averageRating'] == null
            ? '0'
            : item['volumeInfo']['averageRating'].toString();
        String categories = item['volumeInfo']['categories'] == null
            ? 'N/A'
            : item['volumeInfo']['categories'][0];
        Book searchedBook = Book(
          title: title,
          author: author,
          photoUrl: thumbNail,
          description: description,
          publishedDate: publishedDate,
          pageCount: pageCount,
          rating: rating,
          categories: categories,
        );
        books.add(searchedBook);
      }
      return books;
    } else {
      throw ('error ${response.reasonPhrase}');
    }
  }

  List<Widget> createBookCards({BuildContext context, List<Book> books}) {
    List<Widget> children = [];
    for (Book book in books) {
      children.add(
        Container(
          width: 160.0,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Card(
            elevation: 5.0,
            color: HexColor('#F6F4FF'),
            child: Wrap(
              children: [
                Image.network(
                  book.photoUrl == null || book.photoUrl.isEmpty
                      ? 'https://media.istockphoto.com/photos/audiobook-or-elearning-concept-open-book-on-digital-tablet-with-picture-id1305993250?b=1&k=20&m=1305993250&s=170667a&w=0&h=gmXFNAWFYelVQHxVlUPGWxKptMmVJV0FpSeKS24ud5c='
                      : book.photoUrl,
                  height: 100.0,
                  width: 160.0,
                  fit: BoxFit.cover,
                ),
                ListTile(
                  title: Text(
                    book.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: HexColor('#5D48B6')),
                  ),
                  subtitle: Text(book.author),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SearchBookDetailDialog(
                          book: book,
                          bookCollectionReference: bookCollectionReference,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
    return children;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchTextController = TextEditingController();
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
                        context: context,
                        labelText: 'Search',
                        hintText: 'Flutter Development',
                      ),
                      onSubmitted: (String value) {
                        _search();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                listOfBooks != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: 300.0,
                              height: 200.0,
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: createBookCards(
                                  context: context,
                                  books: listOfBooks,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Text(''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
