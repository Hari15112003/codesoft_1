// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/main.dart';

import '../model/model.dart';
import '../utils/utils.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
  });
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthProvider _authProvider = AuthProvider();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool _isRegistering = false;

  void _toggleAuthMode() {
    setState(() {
      _isRegistering = !_isRegistering;
    });
  }

  void _submitForm() async {
    if (_isRegistering) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final String firstName = _firstNameController.text.trim();
      final String lastName = _lastNameController.text.trim();

      Users? user = await _authProvider.registerWithEmailAndPassword(
          email, password, firstName, lastName);
      try {
        if (user != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TaskListScreen(
                        userId: user.uid,
                      )));
        }
      } on FirebaseAuthException catch (e) {
        showSnackBar(context, e.message.toString());
      }
    } else {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      Users? user =
          await _authProvider.signInWithEmailAndPassword(email, password);
      try {
        if (user != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TaskListScreen(
                        userId: user.uid,
                      )));
        }
      } on FirebaseAuthException catch (e) {
        showSnackBar(context, e.message.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Authentication')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isRegistering)
                TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(labelText: 'First Name')),
              TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email')),
              TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password')),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: Text(_isRegistering ? 'Register' : 'Sign In'),
              ),
              TextButton(
                onPressed: _toggleAuthMode,
                child: Text(_isRegistering
                    ? 'Already have an account? Sign In'
                    : 'Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
