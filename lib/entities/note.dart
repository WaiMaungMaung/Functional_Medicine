class Note {
  String title;
  String imageLink;
  String url;
  String summary;
  Note(this.title, this.imageLink, this.summary, this.url);

  Note.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    imageLink = json['image'];
    url = json['link'];
    summary = json['summary'];
  }
}
