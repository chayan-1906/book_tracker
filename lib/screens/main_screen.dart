import 'package:book_tracker/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference usersCollection;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usersCollection = firebaseFirestore.collection('users');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        elevation: 0.0,
        // centerTitle: true,
        title: Text(
          'A.Reader',
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: usersCollection.snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data.docs.first.id);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error));
              }
              /*final bookListStream = snapshot.data.docs.map((book) {
                  return Book.fromDocument(book);
                }).toList();
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: bookListStream.length,
                  itemBuilder: (BuildContext context, int index) {
                    Book book = bookListStream[index];
                    return Text(book.notes);
                  },
                );*/
              return Column(
                children: const [
                  SizedBox(height: 2.0),
                  Flexible(
                    child: SizedBox(
                      height: 40.0,
                      width: 40.0,
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage(
                            'https://raw.githubusercontent.com/Ashwinvalento/cartoon-avatar/master/lib/images/female/10.png'),
                        backgroundColor: Colors.white,
                        child: Text(''),
                      ),
                    ),
                  ),
                  Text('UserName', style: TextStyle(color: Colors.black12)),
                ],
              );
            },
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout_rounded),
            label: const Text(''),
          ),
        ],
      ),
    );
  }
}
