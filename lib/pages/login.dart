import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_listview_json/pages/authServices.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:flutter_listview_json/pages/signUp.dart';

import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password, verificationid;
  String error = '';
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();

      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
      } catch (e) {
        print(e.code);
        setState(() {
          if (e.code == "user-not-found")
            error = "User not found";
          else if (e.code == "wrong-password") {
            error = "Incorrect Password";
          } else if (e.code == "invalid-email") {
            error = "Invaild Email";
          } else if (e.code == "too-many-requests") {
            error = "You try too many times plz try again later";
          } else if (e.code == "user-disabled") {
            error = "Accound is disabled";
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0, top: 20.0),
            child: GestureDetector(
              child: Text(
                "Sign Up",
                // widget.user.email.split("@")[0],
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
            ),
          ),
        ],
        backgroundColor: Colors.green,
        title: Center(
          child: Text(
            "Waaneiza Holistic Health ",
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
                          "LOG IN",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      color: Colors.green,
                      onPressed: () => signIn(),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    // SignInButton(
                    //   Buttons.FacebookNew,
                    //   padding: EdgeInsets.all(20),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(15.0),
                    //   ),
                    //   text: "Sign Up with Facebook",
                    //   onPressed: () async {
                    //     AuthService().signInWithFacebook();
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // SignInButton(
                    //   Buttons.GitHub,
                    //   padding: EdgeInsets.all(20),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(15.0),
                    //   ),
                    //   text: "Sign Up with Phone",
                    //   onPressed: () {
                    //     AuthService().signInWithPh();
                    //   },
                    // )
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
