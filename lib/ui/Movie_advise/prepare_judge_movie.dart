import 'package:ainavi/config/size_config.dart';
import 'package:ainavi/model/tables/question.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:camera/camera.dart';

/* 
 * ESアドバイス機能結果画面を生成するクラス
 */
class PrepareJudgeMoviePage extends StatefulWidget {
  const PrepareJudgeMoviePage({
    super.key,
    required this.title,
    required this.themeColor,
    required this.question,
    required this.camera,
  });
  final String title;
  final Color themeColor;
  final Question question;
  final CameraDescription camera;
  @override
  State<PrepareJudgeMoviePage> createState() => ResultJudgeImageState();
}

/*
 * ESアドバイス機能結果画面ウィジェットのクラス
 */
class ResultJudgeImageState extends State<PrepareJudgeMoviePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late CameraController _controller;
  bool initialized = false;

  // 日本語対応メソッド
  void initializeLocaleData() async {
    await initializeDateFormatting('ja_JP');
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _controller = CameraController(widget.camera, ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        initialized = true;
      });
    });
  }

  @override
  void dispose() {
    // ウィジェットが破棄されたら、コントローラーを破棄
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeLocaleData();

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
          "AINavi:${widget.title}",
          style: TextStyle(
            fontSize: 24,
            color: widget.themeColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // 画面Mainコンテンツ
      body: Center(
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
                          "準備はいい？開始ボタンで撮影を始めよう！",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // between「functional description field」and「image display field」
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 3.5,
                    ),

                    // image display field
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 75,
                      height: SizeConfig.safeBlockHorizontal * 100,
                      child: _cameraPreview(),
                    ),

                    // between「image display field」and「sentence field」
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 4,
                    ),

                    // sentence field
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 82,
                      height: SizeConfig.safeBlockVertical * 6,
                      child: Text("お題：${widget.question.getSubject}"),
                    ),

                    // between「sentence field」and「points field」
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 4,
                    ),

                    // points field
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 82,
                      height: SizeConfig.safeBlockVertical * 6,
                      child: Text("ポイント１：${widget.question.getPoints[0]}"),
                    ),

                    // between「points field」and「start filming button」
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 4,
                    ),

                    // start filming button
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 82,
                      height: SizeConfig.safeBlockVertical * 6,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 100, 211, 239),
                          ),
                        ),
                        onPressed: () async => {},
                        child: const Center(
                          child: Text(
                            "撮影を開始する",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // between「start filming button」and「under bar」
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 6,
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  // カメラのプレビュー画面生成関数
  Widget _cameraPreview() {
    if (initialized) {
      return AspectRatio(
        aspectRatio: 9 / 16,
        child: ClipRect(
          child: Transform.scale(
            scale: _controller.value.aspectRatio,
            child: Center(
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: CameraPreview(_controller),
              ),
            ),
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
