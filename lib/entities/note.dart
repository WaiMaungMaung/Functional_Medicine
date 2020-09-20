class Note {
  String title;
  String text;
  String url;
  Note(this.title, this.text);

  Note.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
    url = json['link'];
  }
}
