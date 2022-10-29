import 'package:book_tracker/constants/constants.dart';
import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/models/user.dart';
import 'package:book_tracker/screens/login_screen.dart';
import 'package:book_tracker/utils/format_date.dart';
import 'package:book_tracker/widgets/reading_list_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../widgets/create_profile_dialog.dart';
import 'book_details_dialog.dart';
import 'book_search_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference usersCollection;
  CollectionReference booksCollection;
  List<Book> userBooksReadList = [];
  int booksRead = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usersCollection = firebaseFirestore.collection('users');
    booksCollection = firebaseFirestore.collection('books');
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
                return user.uid == firebaseAuth.currentUser.uid;
              }).toList();
              print(userListStream);
              MUser currentUser = userListStream[0];
              return Column(
                children: [
                  const SizedBox(height: 2.0),
                  SizedBox(
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
                                child: SingleChildScrollView(
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
                                        'Books Read (${userBooksReadList.length})',
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
                                                    bookList: userBooksReadList,
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
                                        child: Container(
                                          color: Colors.redAccent,
                                        ),
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
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.50,
                                        height: 200.0,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: userBooksReadList.length,
                                          itemBuilder: (context, index) {
                                            Book book =
                                                userBooksReadList[index];
                                            return Card(
                                              elevation: 2.0,
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    title:
                                                        Text('${book.title}'),
                                                    leading: CircleAvatar(
                                                      radius: 35.0,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              book.photoUrl),
                                                    ),
                                                    subtitle:
                                                        Text('${book.author}'),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                        'Finished on: ${formatDate(timestamp: book.finishedReading)}'),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                  top: 12.0,
                  left: 12.0,
                  bottom: 10.0,
                ),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.headline5,
                    children: const [
                      TextSpan(text: 'Your reading\n activity '),
                      TextSpan(
                        text: 'right now...',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              firebaseAuth.currentUser != null
                  ? StreamBuilder<QuerySnapshot>(
                      stream: booksCollection.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          /*return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          );*/
                        }
                        List<Book> userBookFilteredReadListStream =
                            snapshot.data.docs.map((book) {
                          return Book.fromDocument(book);
                        }).where((book) {
                          return book.userId == firebaseAuth.currentUser.uid &&
                              book.startedReading != null &&
                              book.finishedReading == null;
                        }).toList();

                        userBooksReadList = snapshot.data.docs.map((book) {
                          return Book.fromDocument(book);
                        }).where((book) {
                          return book.userId == firebaseAuth.currentUser.uid &&
                              book.startedReading != null &&
                              book.finishedReading != null;
                        }).toList();
                        booksRead = userBooksReadList.length;

                        return Expanded(
                          flex: 1,
                          child: userBookFilteredReadListStream.isNotEmpty
                              ? ListView.builder(
                                  itemCount:
                                      userBookFilteredReadListStream.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, int index) {
                                    Book book =
                                        userBookFilteredReadListStream[index];
                                    return InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return BookDetailsDialog(
                                                book: book);
                                          },
                                        );
                                      },
                                      child: ReadingListCard(
                                        book: book,
                                        buttonText: 'Reading',
                                        pressRead: () {},
                                        rating: double.parse(book.rating),
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text(
                                    'You haven\'t started reading. \n Start adding by a book',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        );
                      },
                    )
                  : Container(),
              const SizedBox(height: 10.0),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Reading List',
                              style: TextStyle(
                                fontSize: 24.0,
                                color: kBlackColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              firebaseAuth.currentUser != null
                  ? StreamBuilder<QuerySnapshot>(
                      stream: booksCollection.snapshots(),
                      builder: (context, snapshot) {
                        print(snapshot.connectionState);
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          /*return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          );*/
                        }
                        List<Book> readingListBook =
                            snapshot.data.docs.map((book) {
                          return Book.fromDocument(book);
                        }).where((book) {
                          return book.userId == firebaseAuth.currentUser.uid &&
                              book.startedReading == null &&
                              book.finishedReading == null;
                        }).toList();
                        return Expanded(
                          child: readingListBook.isNotEmpty
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: readingListBook.length,
                                  itemBuilder: (context, int index) {
                                    Book book = readingListBook[index];
                                    return InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return BookDetailsDialog(
                                                book: book);
                                          },
                                        );
                                      },
                                      child: ReadingListCard(
                                        book: book,
                                        buttonText: 'Not Started',
                                        rating: double.parse(book.rating),
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text(
                                    'No books found. Add a book :)',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        );
                      },
                    )
                  : Container(),
            ],
          ),
        ),
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
