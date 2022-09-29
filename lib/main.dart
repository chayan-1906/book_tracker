import 'package:book_tracker/screens/get_started_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCLS3Op30iHHddlxhgKW6SlrKduHVU6de4",
      appId: "1:917900094496:web:cb8664832de6ebdd1e2045",
      messagingSenderId: "917900094496",
      projectId: 'book-tracker-chayan1906',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GetStartedScreen(),
      // home: const HomePage(),
    );
  }
}
