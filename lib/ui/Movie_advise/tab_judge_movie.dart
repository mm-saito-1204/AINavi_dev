import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ainavi/config/size_config.dart';
import 'package:ainavi/widget/functional_description_bar.dart';
import 'package:ainavi/ui/Movie_advise/execute_judge_movie.dart';
import 'package:ainavi/model/tables/question.dart';

/* 
 * 面接解析お題選択画面を生成するクラス
 */
class TabPageJudgeMovie extends StatefulWidget {
  const TabPageJudgeMovie({
    Key? key,
  }) : super(key: key);

  @override
  _TabPageJudgeMovieState createState() => _TabPageJudgeMovieState();
}

/* 
 * 面接解析お題選択画面ウィジェットのクラス
 */
class _TabPageJudgeMovieState extends State<TabPageJudgeMovie>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int questionTextFlg = 0; // 0 = question, 1 = Text
  String selectGenre = ''; // 検索プルダウンで選択したジャンル
  String selectTitle = ''; // 検索プルダウンで検索したタイトル
  List<Question> selectQuestions = []; // 検索結果

  List<dynamic> questionGenreList = []; // プルダウン表示用ジャンル一覧
  List<dynamic> questionTitleList = []; // プルダウン表示用お題名一覧
  List<Question> questions = []; // お題リスト

  // 問題用jsonロード
  String jsonData = '';
  Future<void> loadJsonAsset() async {
    jsonData = '';
    String loadData =
        await rootBundle.loadString('assets/files/questions.json');
    List<dynamic> jsonList = json.decode(loadData)['questions'];

    for (int i = 0; i < jsonList.length; i++) {
      String title = jsonList[i]['title']!;
      var points = jsonList[i]['points']!;
      var genres = jsonList[i]['genres']!;
      questions.add(Question(
        i + 1,
        title,
        points,
        genres,
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      // 問題取得：jsonからquestionのListを取得
      await loadJsonAsset();

      // 検索プルダウン用：questionsのジャンルを取得し、重複排除した結果をquestionGenreListとして保存
      List<dynamic> tmpquestionGenreList = [''];
      questions.forEach((question) {
        tmpquestionGenreList += question.getGenres;
      });
      questionGenreList = tmpquestionGenreList.toSet().toList();

      // 検索プルダウン用：questionsのお題を取得し、重複排除した結果をquestionTitleListとして保存
      List<String> tmpQuestionTitleList = [''];
      tmpQuestionTitleList = questions
          .map((q) {
            return q.getSubject;
          })
          .toSet()
          .toList();
      questionTitleList = [''] + tmpQuestionTitleList;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    //　事前の絞り込み
    selectQuestions = [];
    for (Question question in questions) {
      // ジャンル・タイトルが未選択の場合、挿入
      if (selectGenre == '' && selectTitle == '') {
        selectQuestions.add(question);
      }
      // ジャンルが一致していてタイトルが未選択の場合、挿入
      else if (question.getGenres.contains(selectGenre) && selectTitle == '') {
        selectQuestions.add(question);
      }
      // タイトルが一致していてジャンルが未選択の場合、挿入
      else if (question.getSubject == selectTitle && selectGenre == '') {
        selectQuestions.add(question);
      }
      // ジャンル・タイトルが一致している場合、挿入
      else if (question.getGenres.contains(selectGenre) &&
          question.getSubject == selectTitle) {
        selectQuestions.add(question);
      }
    }

    final _controller = ScrollController();

    // 画面メインコンテンツ
    return Center(
      child: Container(
        alignment: Alignment.topCenter,
        child: Scrollbar(
          thumbVisibility: true,
          controller: _controller,
          radius: const Radius.circular(16),
          child: SingleChildScrollView(
            controller: _controller,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // 機能説明欄
                functionalDescriptionBar('面接動画を撮影し、AIにアドバイスをもらおう！'),

                // between 「機能説明欄」and「検索ボックス」
                SizedBox(height: SizeConfig.blockSizeVertical * 1),

                // 検索ボックス
                Container(
                  height: SizeConfig.blockSizeVertical * 8,
                  width: SizeConfig.blockSizeHorizontal * 96,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: SizeConfig.blockSizeVertical * 0.7),
                          const Text(
                            '検索ボックス',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal * 15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'ジャンル',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 1.7),
                          const Text(
                            'タイトル',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(children: [
                        // ジャンル
                        Container(
                          alignment: Alignment.bottomRight,
                          height: SizeConfig.blockSizeVertical * 4,
                          width: SizeConfig.blockSizeHorizontal * 40,
                          child: DropdownButton<String>(
                            value: selectGenre,
                            items: questionGenreList
                                .map((dynamic list) => DropdownMenuItem(
                                    value: list.toString(),
                                    child: Container(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 30,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        list.toString(),
                                        softWrap: false,
                                      ),
                                    )))
                                .toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectGenre = value!;
                              });
                            },
                          ),
                        ),
                        // タイトル
                        Container(
                          alignment: Alignment.bottomRight,
                          height: SizeConfig.blockSizeVertical * 4,
                          width: SizeConfig.blockSizeHorizontal * 40,
                          child: DropdownButton<String>(
                            value: selectTitle,
                            items: questionTitleList
                                .map((dynamic list) => DropdownMenuItem(
                                    value: list.toString(),
                                    child: Container(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 30,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        list.toString(),
                                        softWrap: false,
                                      ),
                                    )))
                                .toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectTitle = value!;
                              });
                            },
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),

                // between「検索ボックス」and「お題一覧」
                SizedBox(height: SizeConfig.blockSizeVertical * 1),

                // お題一覧
                Container(
                  width: SizeConfig.blockSizeHorizontal * 96,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 208, 235, 247),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: const Text(
                    '  お題一覧',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // お題一覧
                Container(
                  height: SizeConfig.blockSizeVertical * 59,
                  width: SizeConfig.blockSizeHorizontal * 96,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: selectQuestions.length,
                    itemBuilder: (context, index) {
                      return _listTileQuestion(selectQuestions[index], context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* 
 * お題タイル生成関数
 */
_listTileQuestion(Question question, BuildContext context) {
  return Card(
    child: ListTile(
      leading: const Icon(
        Icons.play_arrow_outlined,
        color: Colors.blue,
        size: 30.0,
      ),
      title: Text('${question.getNumber.toString()}. ${question.getSubject}'),
      subtitle: Text('ジャンル： ${question.getGenres[0]}'),
      onTap: () {
        _tapTile(question, context);
      },
    ),
  );
}

/* 
 * お題タイルタップ時のダイアログ表示関数
 */
_tapTile(Question question, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('このお題の動画を撮影・解析しますか？'),
        content: Text('お題：${question.getSubject}\n${question.getPoints[0]}'),
        actions: <Widget>[
          TextButton(
            child: const Text('いいえ'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('はい'),
            onPressed: () {
              Navigator.pop(context);
              // 結果画面へ遷移
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExecuteJudgeMoviePage(
                    themeColor: Colors.blue,
                    question: question,
                  ),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
