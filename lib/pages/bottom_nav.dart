import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_listview_json/entities/note.dart';
import 'package:flutter_listview_json/main.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  List<Note> _notes = List<Note>();
  List<Note> _notesForDisplay = List<Note>();

  Future<List<Note>> fetchNotes() async {
    // var url =
    //     'http://www.json-generator.com/api/json/get/cfhBFKjFTS?indent=2'; // (sway)
    var url = 'https://next.json-generator.com/api/json/get/EJJfFgQSt'; //(Word)
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
      appBar: AppBar(
        title: Text('Waaneiza FM Stores'),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0, top: 20.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Text('Sway', style: TextStyle(fontSize: 20))))
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

            // Image.network("https://picsum.photos/250?image=9"),
            Image.asset(
              _notesForDisplay[index].text,
              height: 300,
              width: 350,
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
  String url;
  WebViewLoadUI(url) {
    this.url = url;
  }
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
