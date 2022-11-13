import 'package:book_tracker/screens/get_started_screen.dart';
import 'package:book_tracker/screens/login_screen.dart';
import 'package:book_tracker/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/page_not_found.dart';

class RouteController extends StatelessWidget {
  final String settingName;

  const RouteController({Key key, this.settingName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userSignedIn = Provider.of<User>(context) != null;
    final signedInGotoMain = userSignedIn && settingName == '/main';
    final notSignedInGotoMain = !userSignedIn && settingName == '/main';

    if (settingName == '/') {
      return const GetStartedScreen();
    } else if (settingName == '/login' || notSignedInGotoMain) {
      return const LoginScreen();
    } else if (signedInGotoMain) {
      return const MainScreen();
    } else {
      return const PageNotFound();
    }
    return Container();
  }
}
