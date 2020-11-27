import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_listview_json/main.dart';
import 'package:flutter_listview_json/pages/login.dart';

import 'package:http/http.dart' as http;

class AuthService {
  FacebookLogin facebookLogin = FacebookLogin();
  String verificationid;
  String error = '';

  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        print(snapshot.hasData);
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return LoginScreen();
        }
      },
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  void signInWithFacebook() async {
    final result = await facebookLogin.logIn(['email']);
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');

    print(graphResponse.body);
    if (result.status == FacebookLoginStatus.loggedIn) {
      final credential = FacebookAuthProvider.credential(token);
      FirebaseAuth.instance.signInWithCredential(credential);
    }
  }

  Future<void> signInWithPh() async {
    // WidgetsFlutterBinding.ensureInitialized();

    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      // FirebaseAuth.instance.signInWithCredential(authResult);
      print('pass');
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print(authException.message);
      print('fail');
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationid = verId;
      print('sms sent');
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeOut = (String verId) {
      this.verificationid = verId;
      print('time out');
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+959797132365',
        verificationCompleted: verified,
        timeout: const Duration(seconds: 5),
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeOut);
  }
}
