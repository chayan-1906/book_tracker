import 'package:flutter/material.dart';

import 'input_decoration.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required TextEditingController emailController,
    @required TextEditingController passwordController,
  })  : _formKey = formKey,
        _emailController = emailController,
        _passwordController = passwordController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          /// email
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _emailController,
              decoration: buildInputDecoration(
                labelText: 'Enter email',
                hintText: 'john@me.com',
              ),
              validator: (value) {
                return value.isEmpty ? 'Please add an email' : null;
              },
            ),
          ),

          /// password
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: buildInputDecoration(
                labelText: 'Enter password',
                hintText: '********',
              ),
              validator: (value) {
                return value.isEmpty ? 'Enter password' : null;
              },
            ),
          ),

          const SizedBox(height: 20.0),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              padding: const EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              backgroundColor: Colors.amber,
              textStyle: const TextStyle(fontSize: 18.0),
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

              }
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
