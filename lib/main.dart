import 'package:book_tracker/screens/get_started_screen.dart';
import 'package:book_tracker/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/* API Key: AIzaSyC4GiIbV1f0BoqmjBVv-S3epMaOpgKaRJE */

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCLS3Op30iHHddlxhgKW6SlrKduHVU6de4",
        appId: "1:917900094496:web:cb8664832de6ebdd1e2045",
        messagingSenderId: "917900094496",
        projectId: 'book-tracker-chayan1906',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User firebaseUser = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      title: 'Book Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home:
          firebaseUser != null ? const MainScreen() : const GetStartedScreen(),
    );
  }
}
