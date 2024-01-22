import 'package:ainavi/config/size_config.dart';
import 'package:ainavi/ui/Movie_advise/prepare_judge_movie.dart';
import 'package:ainavi/model/tables/question.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:intl/date_symbol_data_local.dart';

void initializeLocaleData() async {
  await initializeDateFormatting('ja_JP'); // 利用したいロケールに合わせて変更
}

/* 
 * 面接解析お題選択画面を生成するクラス
 */
class TabPageJudgeMovie extends StatefulWidget {
  final String title;
  final Color themeColor;
  final CameraDescription camera;

  const TabPageJudgeMovie(
      {Key? key,
      required this.title,
      required this.themeColor,
      required this.camera})
      : super(key: key);

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
  String selectGenre = "";
  String selectTitle = "";

  // ジャンル一覧
  late final List<String> genreList;
  // お題一覧
  late final List<String> questionTitleList;
  // お題リスト
  final questions = [
    Question(
      1,
      "志望動機を教えてください",
      ["過去→現在→未来の流れを意識しよう", "できるだけ簡潔にまとめよう", "自分が聞いて納得できる回答か確認しよう"],
      ["志望理由"],
    ),
    Question(
      2,
      "学生時代に一番力を入れたことを教えてください",
      ["過去→現在→未来の流れを意識しよう", "できるだけ簡潔にまとめよう", "自分が聞いて納得できる回答か確認しよう"],
      ["ガクチカ"],
    ),
    Question(
      3,
      "競合他者ではなく、弊社を志望した理由を教えてください",
      ["過去→現在→未来の流れを意識しよう", "できるだけ簡潔にまとめよう", "自分が聞いて納得できる回答か確認しよう"],
      ["志望理由"],
    ),
    Question(
      4,
      "君の代わりなんていくらでもいるんだよ？君にしかできないこととかないの？",
      ["過去→現在→未来の流れを意識しよう", "できるだけ簡潔にまとめよう", "自分が聞いて納得できる回答か確認しよう"],
      ["圧迫面接"],
    ),
    Question(
      5,
      "君は朝助けてくれた青年だね、合格としよう",
      ["ポイント１：投げ飛ばせ"],
      ["栄養素"],
    ),
    Question(
      6,
      "タンパク質について、正しいものをひとつ選べ",
      ["a"],
      ["栄養素"],
    ),
    Question(
      7,
      "代謝機構について、正しいものをひとつ選べ",
      ["a"],
      ["身体構造"],
    ),
    Question(
      8,
      "体づくりに関係する栄養素の組み合わせとして、正しいものをひとつ選べ",
      ["a"],
      ["栄養素"],
    ),
    Question(
      9,
      "減量について、正しいものをひとつ選べ",
      ["a"],
      ["トレーニング"],
    ),
    Question(
      10,
      "筋肥大目的のトレーニング配列において、正しいものをひとつ選べ",
      ["a"],
      ["トレーニング"],
    ),
  ];

  @override
  void initState() {
    super.initState();

    // questionsのジャンルを取得し、重複排除した結果をgenreListとして保存
    List<String> tmpGenreList = [""];
    questions.forEach((question) {
      tmpGenreList += question.getGenres;
    });
    genreList = tmpGenreList.toSet().toList();

    // questionsのお題を取得し、重複排除した結果をquestionTitleListとして保存
    List<String> tmpQuestionTitleList = [""];
    tmpQuestionTitleList = questions
        .map((q) {
          return q.getSubject;
        })
        .toSet()
        .toList();
    questionTitleList = [""] + tmpQuestionTitleList;

    // debug
    // questionTitleList = ["", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    initializeLocaleData();

    // 画面メインコンテンツ
    return Center(
      child: Container(
        alignment: Alignment.topCenter,
        child: Scrollbar(
          thumbVisibility: true,
          radius: const Radius.circular(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // functional description field
                Container(
                  width: SizeConfig.safeBlockHorizontal * 100,
                  height: SizeConfig.safeBlockVertical * 7.5,
                  color: Colors.blue[100],
                  child: const Center(
                    child: Text(
                      "面接動画を撮影し、AIにアドバイスをもらおう！",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // between 「functional description field」and「search box」
                SizedBox(height: SizeConfig.blockSizeVertical * 1),

                // search box
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
                            "検索ボックス",
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
                            "ジャンル",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 1.7),
                          const Text(
                            "タイトル",
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
                            items: genreList
                                .map((String list) => DropdownMenuItem(
                                    value: list,
                                    child: Container(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 30,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        list,
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
                                .map((String list) => DropdownMenuItem(
                                    value: list,
                                    child: Container(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 30,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        list,
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
                        // 未読・未回答チェックボックス
                      ]),
                    ],
                  ),
                ),

                // between「search box」and「」
                SizedBox(height: SizeConfig.blockSizeVertical * 1),

                // question header field
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
                    "  お題一覧",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // questions field
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
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      if (((selectGenre == "") && (selectTitle == "")) ||
                          ((selectGenre == "") &&
                              (questions[index].getSubject == selectTitle)) ||
                          ((questions[index].getGenres[0] == selectGenre) &&
                              (selectTitle == ""))) {
                        return _listTileQuestion(
                            questions[index], context, widget.camera);
                      } else {
                        return null;
                      }
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
_listTileQuestion(
    Question question, BuildContext context, CameraDescription camera) {
  return Card(
    child: ListTile(
      leading: const Icon(
        Icons.play_arrow_outlined,
        color: Colors.blue,
        size: 30.0,
      ),
      title: Text(question.getNumber.toString() + ". " + question.getSubject),
      subtitle: Text("ジャンル：" + question.getGenres[0]),
      onTap: () {
        _tapTile(question, context, camera);
      },
    ),
  );
}

/* 
 * お題タイルタップ時のダイアログ表示関数
 */
_tapTile(Question question, BuildContext context, CameraDescription camera) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("このお題の動画を撮影・解析しますか？"),
        content:
            Text("お題：" + question.getSubject + "\n" + question.getPoints[0]),
        actions: <Widget>[
          GestureDetector(
            child: const Text('いいえ'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          GestureDetector(
            child: const Text('はい'),
            onTap: () {
              Navigator.pop(context);
              // 結果画面へ遷移
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrepareJudgeMoviePage(
                      title: "judge_movie",
                      themeColor: Colors.blue[100]!,
                      question: question,
                      camera: camera),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
