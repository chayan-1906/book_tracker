import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/models/user.dart';
import 'package:book_tracker/screens/login_screen.dart';
import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:book_tracker/widgets/reading_list_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../widgets/create_profile_dialog.dart';
import 'book_search_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference usersCollection;
  CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');

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
        toolbarHeight: 77.0,
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
              final userListStream = snapshot.data.docs.map((user) {
                print(user.data());
                return MUser.fromDocument(user);
              }).where((user) {
                return user.uid == FirebaseAuth.instance.currentUser.uid;
              }).toList();
              print(userListStream);
              MUser currentUser = userListStream[0];
              return Column(
                children: [
                  const SizedBox(height: 2.0),
                  Flexible(
                    child: SizedBox(
                      height: 40.0,
                      width: 40.0,
                      child: InkWell(
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage(currentUser.avatarUrl ??
                              'https://raw.githubusercontent.com/Ashwinvalento/cartoon-avatar/master/lib/images/female/10.png'),
                          backgroundColor: Colors.white,
                          child: const Text(''),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 50.0,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: NetworkImage(
                                                currentUser.avatarUrl ??
                                                    'https://raw.githubusercontent.com/Ashwinvalento/cartoon-avatar/master/lib/images/female/10.png'),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Books Read',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(color: Colors.redAccent),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              currentUser.displayName
                                                  .toUpperCase(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                          ),
                                          TextButton.icon(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return createProfileDialog(
                                                    context: context,
                                                    currentUser: currentUser,
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.mode_edit_rounded,
                                              color: Colors.black12,
                                            ),
                                            label: const Text(''),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        currentUser.profession,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      SizedBox(
                                        width: 100.0,
                                        height: 2.0,
                                        child:
                                            Container(color: Colors.redAccent),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1.0,
                                            color: Colors.blueGrey.shade100,
                                          ),
                                          color: HexColor('#F1F3F6'),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              const Text(
                                                'Favorite Quote:',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 100.0,
                                                height: 2.0,
                                                child: Container(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Text(
                                                    currentUser.quote != null
                                                        ? '"${currentUser.quote}"'
                                                        : 'Favorite book quote: Life is great...',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Text(
                    currentUser.displayName.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              );
            },
          ),
          TextButton.icon(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                return Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const LoginScreen();
                  }),
                );
              });
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text(''),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 12.0, left: 12.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Your reading\n activity',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const TextSpan(
                    text: 'right now...',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          StreamBuilder<QuerySnapshot>(
            stream: booksCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              List<Book> userBookFilteredReadListStream =
                  snapshot.data.docs.map((book) {
                return Book.fromDocument(book);
              }).toList();
              return Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: userBookFilteredReadListStream.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, int index) {
                    Book book = userBookFilteredReadListStream[index];
                    return ReadingListCard(
                      book: book,
                      // image: book.photoUrl,
                      // title: book.title,
                      // author: book.author,
                      buttonText: 'Reading',
                      pressRead: () {},
                      rating: double.parse(book.rating),
                    );
                  },
                ),
              );
            },
          ),
          Container(
            width: double.infinity,
            child: Column(
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Reading List',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          StreamBuilder<QuerySnapshot>(
            stream: booksCollection.snapshots(),
            builder: (context, snapshot) {
              print(snapshot.connectionState);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                return Container();
              }
              List<Book> readingListBook = snapshot.data.docs.map((book) {
                return Book.fromDocument(book);
              }).toList();
              return Expanded(
                child: readingListBook.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: readingListBook.length,
                        itemBuilder: (context, int index) {
                          Book book = readingListBook[index];
                          return ReadingListCard(
                            book: book,
                            buttonText: 'Not Started',
                            rating: double.parse(book.rating),
                            // author: book.author,
                            // title: book.title,
                            // image: book.photoUrl,
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No books found. Add a book',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const BookSearchPage();
            }),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
