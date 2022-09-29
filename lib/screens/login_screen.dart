import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../widgets/create_account_form.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isCreateAccountClicked = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(color: HexColor('#B9C2D1')),
            ),
            Text('Sign In', style: Theme.of(context).textTheme.headline5),
            const SizedBox(height: 10.0),
            Column(
              children: [
                SizedBox(
                  width: 300.0,
                  height: 300.0,
                  child: !isCreateAccountClicked
                      ? LoginForm(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                        )
                      : CreateAccountForm(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                        ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      if (!isCreateAccountClicked) {
                        isCreateAccountClicked = true;
                      } else {
                        isCreateAccountClicked = false;
                      }
                    });
                  },
                  icon: const Icon(Icons.portrait_rounded),
                  style: TextButton.styleFrom(
                    primary: HexColor('#FD5B28'),
                    textStyle: const TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  label: Text(isCreateAccountClicked
                      ? 'Already have an account'
                      : 'Create Account'),
                ),
              ],
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: HexColor('#B9C2D1'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
