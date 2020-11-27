import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_listview_json/pages/authServices.dart';

import 'package:firebase_auth/firebase_auth.dart' as auth;

class SignUpScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _email, _password;
  String error = '';
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Future<void> signUp() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();

      try {
        await auth.FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return AuthService().handleAuth();
        }));
      } on auth.FirebaseAuthException catch (e) {
        print(e.code);
        setState(() {
          if (e.code == 'invalid-email') {
            error = "Please type the correct email";
          } else if (e.code == 'email-already-in-use') {
            error = "The account already exists for that email";
          } else if (e.code == 'weak-password') {
            error = "The password provided is too weak";
          } else {
            error = "";
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(
          child: Text(
            "Waaneiza Holistic Health",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Container(
              //color: Colors.white,

              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      width: 250,
                      height: 250,
                      child: Image.asset("images/fm_logo_png.png"),
                    ),

                    Text(
                      error,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Please type username';
                        }
                      },
                      onSaved: (input) => _email = input,
                      decoration: InputDecoration(
                          labelText: "User Name/email",
                          contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                    ),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Please type password';
                        }
                      },
                      onSaved: (input) => _password = input,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Password",
                          contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      color: Colors.green,
                      onPressed: () => signUp(),
                    ),

                    // RaisedButton(
                    //   child: Text(
                    //     "CREATE NEW USER",
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    //   color: Colors.green,
                    //   onPressed: () {
                    //     print(emailController.text);
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
