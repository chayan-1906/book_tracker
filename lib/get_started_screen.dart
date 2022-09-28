import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

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
            Spacer(),
            Text('Book Tracker', style: Theme.of(context).textTheme.headline3),
            const Text(
              '"Read. Change. Yourself"',
              style: TextStyle(
                color: Colors.black26,
                fontSize: 29.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 50.0),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.login_rounded),
              label: Text('Sign in to get started'),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
