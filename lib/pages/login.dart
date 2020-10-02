import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool is_Loading = false;
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
          child: Container(
            //color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  child: Image.asset("images/fm_logo_png.png"),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: "User Name/email",
                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Password",
                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                ),
                space10(),
                RaisedButton(
                    child: Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        is_Loading = true;
                      });
                      signIn(emailController.text, passwordController.text);
                    }),
                RaisedButton(
                    child: Text(
                      "CREATE NEW USER",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                    onPressed: () => {})
              ],
            ),
          ),
        ));
  }

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  signIn(String email, String password) async {
    Map data = {'email': email, 'password': password};
    var response = await http.post('http://www.google.com', body: data);
  }
  // void addProduct() {
  //   const url = "https://waaneizadb.firebaseio.com/products.json";
  //   http.post(
  //     url,
  //     body: json.encode({
  //       'title': 'Jarrow',
  //       'description': 'Good for ur  blood nutri',
  //       'price': '3000',
  //       'image': 'http://www.waaneiza.com/image.png',
  //     }),
  //   );
  //   print('poset');
  // }
}
