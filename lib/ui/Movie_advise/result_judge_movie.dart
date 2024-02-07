import 'dart:convert';
import 'dart:io';

import 'package:AINavi/config/size_config.dart';
import 'package:AINavi/widget/ainavi_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

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
  final audioPlayer = AudioPlayer();
  bool _playingStatus = false;

  // 画面終了時処理
  @override
  void dispose() {
    audioPlayer.dispose(); // 録音破棄
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _startPlaying();
    Map<String, dynamic> map = widget.map;

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
                    // functional description field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        boxShadow: const [
                          BoxShadow(
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(10, 10),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      width: SizeConfig.safeBlockHorizontal * 100,
                      height: SizeConfig.safeBlockVertical * 7.5,
                      child: const Center(
                        child: Text(
                          "結果は以下の通りです！",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // between「functional description field」and「rank display field」
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 2.5,
                    ),

                    // rank display field
                    contentCard(
                      SizeConfig.safeBlockVertical * 30.6,
                      Center(
                        child: Row(
                          children: [
                            // between movie and rank
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
                                        "文章",
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
                                      height: SizeConfig.blockSizeVertical * 20,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            map["sentence_structure"].length,
                                        itemBuilder: (context, index) {
                                          if (map["sentence_structure"]
                                                  [index] !=
                                              "") {
                                            return Text(
                                              "${map["sentence_structure"][index]}。",
                                              style: TextStyle(fontSize: 16),
                                            );
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

                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),

                    // 控えた方が良い言葉
                    contentCard(
                      SizeConfig.safeBlockVertical * 20,
                      Center(
                        child: Row(
                          children: [
                            // between movie and rank
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
                                              "・${map["result_refrainword"][index]}",
                                              style: TextStyle(fontSize: 24),
                                            );
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
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 2,
                    ),

                    // 二重敬語
                    // 控えた方が良い言葉
                    contentCard(
                      SizeConfig.safeBlockVertical * 20,
                      Center(
                        child: Row(
                          children: [
                            // between movie and rank
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
                                    Container(
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
                                              "・${map["result_double_honorific_sentence_list"][index]}",
                                              style: TextStyle(fontSize: 24),
                                            );
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

                    // between「graph field」and「under bar」
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 8,
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  // 再生開始
  void _startPlaying() async {
    // // 再生するファイルを指定
    // final directory = await getApplicationDocumentsDirectory();
    // String pathToWrite = directory.path;
    // final localFile = '$pathToWrite/interview.wav';

    // // 再生開始
    // await audioPlayer.play(DeviceFileSource(localFile));

    // // 再生終了後、ステータス変更
    // audioPlayer.onPlayerComplete.listen((event) {
    //   setState(() {
    //     _playingStatus = false;
    //   });
    // });

    // setState(
    //   () {
    //     _playingStatus = true;
    //   },
    // );
  }

  // 再生一時停止
  void _pausePlaying() async {
    await audioPlayer.pause();
  }
}

/* 
 * 形態による色分け
 */
rankGetColor(rank) {
  MaterialColor color;

  switch (rank) {
    case 'A':
      color = Colors.red;
      break;
    case 'B':
      color = Colors.blue;
      break;
    case 'C':
      color = Colors.green;
      break;
    case 'D':
      color = Colors.purple;
      break;
    case 'E':
      color = Colors.grey;
      break;
    default:
      // 到達不可
      color = Colors.yellow;
      break;
  }

  return color;
}

/* 
 * base64 to file
 */
base64toFile(String imgBase64) {
  Uint8List imgBytes = base64Decode(imgBase64);
  return Image.memory(imgBytes);
}

/*
 * 左にスペースを開ける用row
 */
leftSpaceText(double leftSpace, Text text) {
  return Row(
    children: [
      SizedBox(
        width: SizeConfig.blockSizeHorizontal * leftSpace,
      ),
      text,
    ],
  );
}

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
