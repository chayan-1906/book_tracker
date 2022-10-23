import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';

class SearchBookDetailDialog extends StatelessWidget {
  final Book book;
  final CollectionReference<Object> bookCollectionReference;

  const SearchBookDetailDialog({
    Key key,
    @required this.book,
    @required this.bookCollectionReference,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [
          Container(
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(book.photoUrl),
              radius: 50.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              book.title,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Text('Category: ${book.categories}'),
          Text('Page Count: ${book.pageCount}'),
          Text('Author: ${book.author}'),
          Text('Published: ${book.publishedDate}'),
          const SizedBox(height: 20.0),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueGrey.shade100,
                  width: 1.0,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    book.description,
                    style: const TextStyle(wordSpacing: 0.9),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            bookCollectionReference.add(
              Book(
                userId: FirebaseAuth.instance.currentUser.uid,
                title: book.title,
                author: book.author,
                photoUrl: book.photoUrl,
                publishedDate: book.publishedDate,
                description: book.description,
                pageCount: book.pageCount,
                categories: book.categories,
                rating: book.rating,
              ).toMap(),
            );
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
