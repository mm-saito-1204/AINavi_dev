import 'dart:convert';
import 'dart:io';

import 'package:ainavi/config/size_config.dart';
import 'package:ainavi/widget/ainavi_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/* 
 * ESアドバイス機能結果画面を生成するクラス
 */
class ResultJudgeImagePage extends StatefulWidget {
  const ResultJudgeImagePage({
    super.key,
    required this.map,
    required this.image,
  });
  final Map<String, dynamic> map;
  final File? image;
  @override
  State<ResultJudgeImagePage> createState() => ResultJudgeImageState();
}

/*
 * ESアドバイス機能結果画面ウィジェットのクラス
 */
class ResultJudgeImageState extends State<ResultJudgeImagePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> map = widget.map;
    Map<String, dynamic> mapEmotions = widget.map["emotion"];
    final listEmotions = <Emotion>[];
    mapEmotions.forEach((k, v) => listEmotions.add(Emotion(k, v)));
    listEmotions.sort((a, b) => b._emotionValue.compareTo(a._emotionValue));

    // setState() の度に実行される
    return Scaffold(
      key: _scaffoldKey,

      // 画面上部のバー
      appBar: ainaviAppBar('画像解析'),

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
                            SizedBox(
                              width: SizeConfig.blockSizeHorizontal * 0,
                            ),

                            // picture
                            Container(
                              color: Colors.white,
                              width: SizeConfig.safeBlockHorizontal * 48,
                              height: SizeConfig.safeBlockHorizontal * 64,
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Image.file(widget.image!),
                                ),
                              ),
                            ),

                            // between picture and rank
                            SizedBox(
                              width: SizeConfig.blockSizeHorizontal * 5,
                            ),

                            // rank
                            Column(
                              children: [
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 3,
                                ),
                                const Text(
                                  "あなたの写真は...",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 2,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: SizeConfig.blockSizeHorizontal * 2,
                                    ),
                                    Text(
                                      map['rank'].toString(),
                                      style: TextStyle(
                                        color: rankGetColor(map['rank']),
                                        fontSize: 80,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.blockSizeHorizontal * 2,
                                    ),
                                    const Text(
                                      "ランク！",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // between「rank display field」and「advice field」
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 3,
                    ),

                    // advice field
                    contentCard(
                      SizeConfig.safeBlockVertical * 20,
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: SizeConfig.blockSizeVertical * 2),
                            leftSpaceText(
                              5,
                              const Text(
                                "総評",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            // 総評の回答
                            leftSpaceText(
                              10,
                              Text(
                                map["generalReview"],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            // もっとよくするには？
                            SizedBox(height: SizeConfig.blockSizeVertical * 2),
                            leftSpaceText(
                              5,
                              const Text(
                                "もっとよくするには？",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            // もっとよくするには？の回答
                            leftSpaceText(
                              10,
                              Text(
                                "${map["advice_message"]}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // between「advice field」and「graph field」
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 3,
                    ),

                    // graph field
                    contentCard(
                      SizeConfig.safeBlockVertical * 50,
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: SizeConfig.blockSizeVertical * 2),
                            leftSpaceText(
                              5.0,
                              const Text(
                                "あなたの表情から読み取れる感情",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical * 1),
                            // 円グラフ
                            Center(
                              child: Container(
                                // color: Colors.grey,
                                width: SizeConfig.safeBlockHorizontal * 80,
                                height: SizeConfig.safeBlockHorizontal * 60,
                                decoration:
                                    BoxDecoration(border: Border.all(width: 1)),
                                child: Center(
                                  child: base64toFile(map["img"]),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.blockSizeHorizontal * 8,
                            ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: map["emotion"].length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  String emotionName =
                                      listEmotions[index].getEmotionName;
                                  double emotionValue =
                                      listEmotions[index].getEmotionValue * 100;
                                  String emotionPercent =
                                      emotionValue.toInt().toString();
                                  return leftSpaceText(
                                    5,
                                    Text(
                                      "${index + 1}位　$emotionName ：$emotionPercent%",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                },
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
}

/*
 * emotionを扱うクラス
 */
class Emotion {
  final String _emotionName;
  final double _emotionValue;

  // constructor
  Emotion(
    this._emotionName,
    this._emotionValue,
  );

  // getter
  String get getEmotionName => _emotionName;
  double get getEmotionValue => _emotionValue;
}

/* 
 * ランクによる色分け
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
