/*
 * 面接のお題モデル
 */
class Question {
  int _number;
  String _subject; // お題
  List<dynamic> _points;
  List<dynamic> _genres;

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
  List<dynamic> get getPoints => _points;
  List<dynamic> get getGenres => _genres;

  // setter
}
