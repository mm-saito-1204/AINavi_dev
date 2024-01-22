class Question {
  int _number;
  String _subject; // 問題文
  List<String> _points;
  List<String> _genres;

  // constructor
  Question(
    this._number,
    this._subject,
    this._points,
    this._genres,
  ) {}

  // getter
  int get getNumber => _number;
  String get getSubject => _subject;
  List<String> get getPoints => _points;
  List<String> get getGenres => _genres;

  // setter
}
