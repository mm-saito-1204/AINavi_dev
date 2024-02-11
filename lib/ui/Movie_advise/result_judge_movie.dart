import 'dart:io';
import 'package:flutter/material.dart';

import 'package:ainavi/config/size_config.dart';
import 'package:ainavi/widget/ainavi_app_bar.dart';
import 'package:ainavi/widget/functional_description_bar.dart';

import 'package:substring_highlight/substring_highlight.dart';

/* 
 * ESアドバイス機能結果画面を生成するクラス
 */
class ResultJudgeMoviePage extends StatefulWidget {
  const ResultJudgeMoviePage({
    super.key,
    required this.map,
    required this.movie,
  });
  final Map<String, dynamic> map;
  final File movie;
  @override
  State<ResultJudgeMoviePage> createState() => ResultJudgeMovieState();
}

/*
 * ESアドバイス機能結果画面ウィジェットのクラス
 */
class ResultJudgeMovieState extends State<ResultJudgeMoviePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final audioPlayer = AudioPlayer();
  // bool _playingStatus = false;

  // デフォルトのテキストスタイル
  final defaultStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16,
  );
  // 控えた方が良い言葉・二重敬語のテキストスタイル
  final beforeTextStyle = TextStyle(
    color: Colors.red,
    backgroundColor: Colors.yellow[100],
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  // 添削後のテキストスタイル
  final afterTextStyle = TextStyle(
    color: Colors.blue,
    backgroundColor: Colors.yellow[100],
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  // 画面終了時処理
  @override
  void dispose() {
    // audioPlayer.dispose(); // 録音破棄
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _startPlaying();
    Map<String, dynamic> map = widget.map;

    // 添削後の文章
    List<String> afterSentenceStructure = [];
    List<String> ngRefrainword = map['result_refrainword']
        .map((list) {
          return list[0].toString();
        })
        .toList()
        .cast<String>();
    List<String> ngDoubleHonorificword =
        map['result_double_honorific_sentence_list']
            .map((list) {
              return list[0].toString();
            })
            .toList()
            .cast<String>();
    for (String sentence in map['sentence_structure']) {
      // sentenceごとに添削する
      for (int i = 0; i < ngRefrainword.length; i++) {
        if (sentence.contains(ngRefrainword[i])) {
          // ここで添削する
          sentence = sentence.replaceAll(
              map['result_refrainword'][i][0], map['result_refrainword'][i][1]);
        }
      }
      for (int i = 0; i < ngDoubleHonorificword.length; i++) {
        if (sentence.contains(ngDoubleHonorificword[i])) {
          // ここで添削する
          sentence = sentence.replaceAll(
              map['result_double_honorific_sentence_list'][i][0],
              map['result_double_honorific_sentence_list'][i][1]);
        }
      }
      // 添削したsentenceをafterに追加する
      afterSentenceStructure.add(sentence);
    }

    // setState() の度に実行される
    return Scaffold(
      key: _scaffoldKey,

      // 画面上部のバー
      appBar: ainaviAppBar('movie'),

      // 画面のbody
      body: Center(
        child: Container(
          color: const Color.fromARGB(255, 229, 236, 242),
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
                    // 機能説明バー
                    functionalDescriptionBar('結果は以下の通りです！'),

                    // between「機能説明バー」and「あなたが話した文章」
                    SizedBox(height: SizeConfig.safeBlockVertical * 2.5),

                    // あなたが話した文章
                    sentenceContentCard('あなたが話した文章', map, defaultStyle,
                        beforeTextStyle, true, []),

                    // between「あなたが話した文章」and「添削後の文章」
                    SizedBox(height: SizeConfig.safeBlockVertical * 2.5),

                    // 添削後の文章
                    sentenceContentCard('添削後の文章', map, defaultStyle,
                        afterTextStyle, false, afterSentenceStructure),

                    // between「添削後の文章」and「控えた方がいい言葉」
                    SizedBox(height: SizeConfig.blockSizeVertical * 2),

                    // 控えた方がいい言葉
                    contentCard(
                      SizeConfig.safeBlockVertical * 20,
                      Center(
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: SizeConfig.blockSizeHorizontal * 4,
                                  height: SizeConfig.blockSizeVertical * 6,
                                  color: Colors.blue[100],
                                ),
                              ],
                            ),
                            Flexible(
                              child: SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: SizeConfig.blockSizeVertical * 2,
                                      color: Colors.blue[100],
                                    ),
                                    Container(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 100,
                                      height: SizeConfig.blockSizeVertical * 4,
                                      color: Colors.blue[100],
                                      child: const Text(
                                        "控えた方が良い言葉",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      height:
                                          SizeConfig.blockSizeVertical * 0.2,
                                    ),
                                    Container(
                                      height: SizeConfig.blockSizeVertical * 12,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            map["result_refrainword"].length,
                                        itemBuilder: (context, index) {
                                          if (map["result_refrainword"]
                                                  [index] !=
                                              "") {
                                            return Text(
                                              "・${map["result_refrainword"][index][0]} → ${map["result_refrainword"][index][1]}",
                                              style:
                                                  const TextStyle(fontSize: 24),
                                            );
                                          } else {
                                            // itemBuilderがnullを返さないため
                                            return const SizedBox(height: 0);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // between「控えた方が良い言葉」and「二重敬語」
                    SizedBox(height: SizeConfig.safeBlockVertical * 2),

                    // 二重敬語
                    contentCard(
                      SizeConfig.safeBlockVertical * 20,
                      Center(
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: SizeConfig.blockSizeHorizontal * 4,
                                  height: SizeConfig.blockSizeVertical * 6,
                                  color: Colors.blue[100],
                                ),
                              ],
                            ),

                            // rank
                            Flexible(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: SizeConfig.blockSizeVertical * 2,
                                      color: Colors.blue[100],
                                    ),
                                    Container(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 100,
                                      height: SizeConfig.blockSizeVertical * 4,
                                      color: Colors.blue[100],
                                      child: const Text(
                                        "二重敬語",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      height:
                                          SizeConfig.blockSizeVertical * 0.2,
                                    ),
                                    SizedBox(
                                      height: SizeConfig.blockSizeVertical * 12,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            map["result_double_honorific_sentence_list"]
                                                .length,
                                        itemBuilder: (context, index) {
                                          if (map["result_double_honorific_sentence_list"]
                                                  [index] !=
                                              "") {
                                            return Text(
                                              "・${map["result_double_honorific_sentence_list"][index][0]} → ${map["result_double_honorific_sentence_list"][index][1]}",
                                              style:
                                                  const TextStyle(fontSize: 24),
                                            );
                                          } else {
                                            // itemBuilderがnullを返さないため
                                            return const SizedBox(height: 0);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // between「二重敬語」and「under bar」
                    SizedBox(height: SizeConfig.safeBlockVertical * 8),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  // 再生開始
  // void _startPlaying() async {
  //   // 再生するファイルを指定
  //   final directory = await getApplicationDocumentsDirectory();
  //   String pathToWrite = directory.path;
  //   final localFile = '$pathToWrite/interview.wav';

  //   // 再生開始
  //   await audioPlayer.play(DeviceFileSource(localFile));

  //   // 再生終了後、ステータス変更
  //   audioPlayer.onPlayerComplete.listen((event) {
  //     setState(() {
  //       _playingStatus = false;
  //     });
  //   });

  //   setState(
  //     () {
  //       _playingStatus = true;
  //     },
  //   );
  // }

  // 再生一時停止
  // void _pausePlaying() async {
  //   await audioPlayer.pause();
  // }
}

// /*
//  * base64 to file
//  */
// base64toFile(String imgBase64) {
//   Uint8List imgBytes = base64Decode(imgBase64);
//   return Image.memory(imgBytes);
// }

/*
 * content card
 */
contentCard(height, content) {
  return Container(
    width: SizeConfig.safeBlockHorizontal * 92,
    height: height,
    clipBehavior: Clip.antiAlias,
    // 影
    decoration: BoxDecoration(
      boxShadow: const [
        BoxShadow(
          color: Colors.grey, //色
          spreadRadius: 0,
          blurRadius: 10,
          offset: Offset(10, 10),
        ),
      ],
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
    ),
    // Cardと被ったWidgetをCardの形に保持する
    // clipBehavior: Clip.antiAliasWithSaveLayer,
    child: content,
  );
}

/*
 * sentenceContentCard
 */
sentenceContentCard(
    String title,
    Map<String, dynamic> map,
    TextStyle defaultStyle,
    TextStyle highlightStyle,
    bool isBefore,
    List<String> afterSentenceStructure) {
  // 文字起こし文章
  return contentCard(
    SizeConfig.safeBlockVertical * 30.6,
    Center(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: SizeConfig.blockSizeHorizontal * 4,
                height: SizeConfig.blockSizeVertical * 6,
                color: Colors.blue[100],
              ),
            ],
          ),
          Flexible(
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: SizeConfig.blockSizeVertical * 2,
                    color: Colors.blue[100],
                  ),
                  Container(
                    width: SizeConfig.blockSizeHorizontal * 100,
                    height: SizeConfig.blockSizeVertical * 4,
                    color: Colors.blue[100],
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: SizeConfig.blockSizeVertical * 0.2,
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 20,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: map["sentence_structure"].length,
                      itemBuilder: (context, index) {
                        return SubstringHighlight(
                          text: isBefore
                              ? map["sentence_structure"][index]
                              : afterSentenceStructure[index],
                          terms: isBefore
                              ? map['result_refrainword']
                                      .map((list) {
                                        return list[0].toString();
                                      })
                                      .toList()
                                      .cast<String>() +
                                  map['result_double_honorific_sentence_list']
                                      .map((list) {
                                        return list[0].toString();
                                      })
                                      .toList()
                                      .cast<String>()
                              : map['result_refrainword']
                                      .map((list) {
                                        return list[1].toString();
                                      })
                                      .toList()
                                      .cast<String>() +
                                  map['result_double_honorific_sentence_list']
                                      .map((list) {
                                        return list[1].toString();
                                      })
                                      .toList()
                                      .cast<String>(),
                          textStyle: defaultStyle,
                          textStyleHighlight: highlightStyle,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
