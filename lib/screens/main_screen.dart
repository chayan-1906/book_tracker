import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/models/user.dart';
import 'package:book_tracker/screens/login_screen.dart';
import 'package:book_tracker/widgets/input_decoration.dart';
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
