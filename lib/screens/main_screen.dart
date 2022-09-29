import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference booksCollection;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    booksCollection = firebaseFirestore.collection('books');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        elevation: 0.0,
        centerTitle: true,
        title: Row(
          children: [
            Text(
              'A.Reader',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: booksCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                Map<String, dynamic> data = snapshot.data.docs.first.data();
                // print('data: $snapshot');
                return Text(
                  data['author'],
                  style: const TextStyle(color: Colors.black),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
