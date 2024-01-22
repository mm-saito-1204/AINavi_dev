import 'package:ainavi/config/size_config.dart';
import 'package:flutter/material.dart';

/* 
 * ESアドバイス機能結果画面を生成するクラス
 */
class ResultJudgeImagePage extends StatefulWidget {
  const ResultJudgeImagePage({
    super.key,
    required this.title,
    required this.themeColor,
    required this.map,
  });
  final String title;
  final Color themeColor;
  final Map<String, dynamic> map;
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
    // setState() の度に実行される
    return Scaffold(
      key: _scaffoldKey,

      // 画面上部のバー
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 112, 112, 112)),
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 30,
            color: widget.themeColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

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
                      height: SizeConfig.safeBlockVertical * 3,
                    ),

                    // rank display field
                    Container(
                      width: SizeConfig.safeBlockHorizontal * 86,
                      height: SizeConfig.safeBlockVertical * 30,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(
                              width: SizeConfig.blockSizeHorizontal * 6,
                            ),

                            // picture
                            Container(
                              color: Colors.grey,
                              width: SizeConfig.safeBlockHorizontal * 28.5,
                              height: SizeConfig.safeBlockHorizontal * 38,
                              child: Center(
                                child: Text(
                                  // "画像",
                                  map['statusCode'].toString() +
                                      ":" +
                                      map['error_message'].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),

                            // picture and rank
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
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 5,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: SizeConfig.blockSizeHorizontal * 2,
                                    ),
                                    Text(
                                      map['rank'].toString(),
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 40,
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
                    Container(
                      width: SizeConfig.safeBlockHorizontal * 86,
                      height: SizeConfig.safeBlockVertical * 25,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: SizeConfig.blockSizeVertical * 2),
                            const Text(
                              "総評",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "　〜〜〜〜〜〜〜〜です",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical * 2),
                            const Text(
                              "もっとよくするには？",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "　${map["advice_message"].toString()}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // between「advice field」and「graph field」
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 3,
                    ),

                    // graph field
                    Container(
                      width: SizeConfig.safeBlockHorizontal * 86,
                      height: SizeConfig.safeBlockVertical * 25,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: SizeConfig.blockSizeVertical * 2),
                            const Text(
                              "　　あなたの表情から読み取れる感情",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical * 1),
                            Row(
                              children: [
                                SizedBox(
                                    width: SizeConfig.blockSizeHorizontal * 8),
                                // picture
                                Container(
                                  color: Colors.grey,
                                  width: SizeConfig.safeBlockHorizontal * 26,
                                  height: SizeConfig.safeBlockHorizontal * 26,
                                  child: Center(
                                    child: Text(
                                      "円グラフ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: SizeConfig.blockSizeHorizontal * 8),
                                const Column(
                                  children: [
                                    Text("１位：平常"),
                                    Text("２位：笑顔"),
                                    Text("３位：恐怖")
                                  ],
                                ),
                              ],
                            )
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
