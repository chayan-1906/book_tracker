import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'login_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CircleAvatar(
        backgroundColor: HexColor('F5F6F8'),
        child: Column(
          children: [
            const Spacer(),
            Text('Book Tracker', style: Theme.of(context).textTheme.headline3),
            const Text(
              '"Read. Change. Yourself"',
              style: TextStyle(
                color: Colors.black26,
                fontSize: 29.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50.0),
            TextButton.icon(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: HexColor('#69639F'),
                textStyle: const TextStyle(fontSize: 18.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const LoginScreen();
                  }),
                );
              },
              icon: const Icon(Icons.login_rounded),
              label: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Sign in to get started'),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
