import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_listview_json/entities/note.dart';
import 'package:flutter_listview_json/pages/bottom_nav.dart';
import 'package:flutter_listview_json/pages/login.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Functional Medicine',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Splash2(),
    );
  }
}

class Splash2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 1,
      navigateAfterSeconds: new LoginScreen(),
      title: new Text(
        'Waaneiza Holistic Health\n ',
        textScaleFactor: 2,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
          color: Colors.green,
        ),
      ),
      loadingText: Text(""),
      image: new Image.asset('images/fm_logo_png.png'),
      backgroundColor: Colors.white,
      photoSize: 150.0,
      loaderColor: Colors.green,
    );
  }
}

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> _notes = List<Note>();
  List<Note> _notesForDisplay = List<Note>();

  Future<List<Note>> fetchNotes() async {
    var url =
        'https://next.json-generator.com/api/json/get/EJLFJ4NUt'; // (sway)
    //var url=http://www.json-generator.com/api/json/get/cgoJtSmLkO?indent=2//(Word)
    var response = await http.get(url);

    var notes = List<Note>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(Note.fromJson(noteJson));
      }
    }
    return notes;
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        _notes.addAll(value);
        _notesForDisplay = _notes;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Waaneiza FM Stores'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0, top: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BottomNav()));
              },
              child: Text(
                widget.user.email.split("@")[0],
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return index == 0 ? _searchBar() : _listItem(index - 1);
        },
        itemCount: _notesForDisplay.length + 1,
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Search...'),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            _notesForDisplay = _notes.where((note) {
              var noteTitle = note.title.toLowerCase();
              return noteTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    return Container(
      child: new InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WebViewLoadUI(_notesForDisplay[index].url)),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Text(
            //   _notesForDisplay[index].title,
            //   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            // ),
            Text(' \ '),
            Text(' \ '),

            // Image.asset(_notesForDisplay[index].text, height: 300, width: 350),
            Image(
              image: NetworkImage(_notesForDisplay[index].imageLink),
              height: 300,
              width: 350,
            ),
            RaisedButton(
              child: Text(
                'Product Summary',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            WebViewLoadUI(_notesForDisplay[index].summary)));
              },
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// navigateToAdrenalOptimizer(context) async {
//   Navigator.push(
//       context, MaterialPageRoute(builder: (context) => WebViewLoadUI()));
// }

class WebViewLoadUI extends StatelessWidget {
  final url;
  WebViewLoadUI(this.url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
