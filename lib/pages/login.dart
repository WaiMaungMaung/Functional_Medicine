import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_listview_json/main.dart';
import 'package:flutter_listview_json/pages/bottom_nav.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool is_Loading = false;
  String _email, _password;
  String error = '';
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  space10() {
    return SizedBox(
      height: 10,
    );
  }

  space20() {
    return SizedBox(
      height: 20,
    );
  }

  Future<void> signIn() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();

      try {
        auth.UserCredential userCredential = await auth.FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        auth.User user = auth.FirebaseAuth.instance.currentUser;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomePage(user: user)));
      } catch (e) {
        print(e.code);

        setState(() {
          if (e.code == "user-not-found")
            error = "User not found";
          else if (e.code == "wrong-password") {
            error = "Incorrect Password";
          } else if (e.code == "invalid-email") {
            error = "Invaild Email";
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
                        color: Colors.white,
                        backgroundColor: Colors.red,
                      ),
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
                          "LOGIN",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      color: Colors.green,
                      onPressed: () => signIn(),
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
