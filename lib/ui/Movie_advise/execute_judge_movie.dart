import 'dart:io';
import 'dart:convert';
import 'dart:developer';

import 'package:ainavi/config/constants.dart';
import 'package:ainavi/widget/ainavi_app_bar.dart';
import 'package:ainavi/widget/functional_description_bar.dart';
import 'package:ainavi/ui/Movie_advise/result_judge_movie.dart';
import 'package:ainavi/widget/loading.dart';
import 'package:ainavi/config/size_config.dart';
import 'package:ainavi/model/tables/question.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

/* 
 * ESアドバイス機能結果画面を生成するクラス
 */
class ExecuteJudgeMoviePage extends StatefulWidget {
  const ExecuteJudgeMoviePage({
    super.key,
    required this.themeColor,
    required this.question,
  });
  final Color themeColor;
  final Question question;
  @override
  State<ExecuteJudgeMoviePage> createState() => ResultJudgeMovieState();
}

/*
 * ESアドバイス機能結果画面ウィジェットのクラス
 */
class ResultJudgeMovieState extends State<ExecuteJudgeMoviePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int recordingState = 0; // 0=未スタート, 1=ナレーション中, 2=録音中, 3=録音終了
  late CameraController _controller; // カメラコントローラ
  bool initialized = false; // カメラ初期化フラグ
  final record = AudioRecorder(); // マイクコントローラ
  final audioPlayer = AudioPlayer(); // 音声再生コントローラ
  String path = ""; // 音声保存パス
  Map<String, dynamic> resultJudgeMovie = <String, dynamic>{}; // 動画分析結果map

  // 初期化
  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  // カメラ初期化
  Future<void> _initCamera() async {
    _controller = CameraController(AppConfig.firstCamera, ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        initialized = true;
      });
    });
  }

  // 画面終了時処理
  @override
  void dispose() {
    _controller.dispose(); // カメラ破棄
    audioPlayer.dispose(); // 録音破棄
    _stopRecording(); // 録音停止
    record.dispose(); // 録音破棄
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    audioPlayer.setReleaseMode(ReleaseMode.release);

    // setState() の度に実行される
    return Scaffold(
      key: _scaffoldKey,

      // 画面上部のバー
      appBar: ainaviAppBar('movie'),

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // 機能説明バー
                    functionalDescriptionBar(recordingState == 0
                        ? "準備ができたら開始ボタンで撮影を始めよう！"
                        : recordingState == 1
                            ? "お題再生中"
                            : recordingState == 2
                                ? "撮影中"
                                : "撮影終了！"),
                    // between「機能説明バー」and「カメラプレビュー欄」
                    SizedBox(height: SizeConfig.safeBlockVertical * 3.5),

                    // カメラプレビュー欄
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 75,
                      height: SizeConfig.safeBlockHorizontal * 100,
                      child: _cameraPreview(),
                    ),
                    // between「カメラプレビュー欄」and「お題」
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 4,
                    ),

                    // お題
                    Container(
                      alignment: Alignment.center,
                      width: SizeConfig.safeBlockHorizontal * 82,
                      height: SizeConfig.safeBlockVertical * 6,
                      child: Text(
                        "お題：${widget.question.getSubject}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // between「お題」and「ポイント」
                    SizedBox(height: SizeConfig.safeBlockVertical * 2),

                    // ポイント
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 82,
                      height: SizeConfig.safeBlockVertical * 6,
                      child: Text(
                        "ポイント：${widget.question.getPoints[0]}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // between「ポイント」and「撮影開始ボタン」
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 5,
                    ),

                    // 撮影開始ボタン
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal * 82,
                      height: SizeConfig.safeBlockVertical * 6,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            recordingState == 1
                                ? Colors.black12
                                : const Color.fromARGB(255, 100, 211, 239),
                          ),
                        ),
                        onPressed: () {
                          if (recordingState == 0) {
                            // ダイアログ表示
                            _showPrepareDialog();
                          } else if (recordingState == 2) {
                            _stopRecording();
                            _showResultDialog();
                            setState(() {
                              recordingState = 3;
                            });
                          }
                        },
                        child: Center(
                          child: Text(
                            recordingState == 0
                                ? "撮影を開始する"
                                : recordingState == 1
                                    ? "お題再生中"
                                    : "ストップ",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // between「撮影開始ボタン」and「under bar」
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

  // 準備確認ダイアログ生成
  _showPrepareDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.85),
          title: const Text("準備はOK？"),
          content: const Text(
              "確認しよう！\n・背景は無地ですか？\n・騒がしい場所ではありませんか？\n・事前に話す内容を考えましたか？"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                // 再生開始
                String recordPath = "records/${widget.question.getNumber}.wav";
                audioPlayer.play(AssetSource(recordPath));
                setState(() {
                  recordingState = 1;
                });
                // 再生終了時の処理
                audioPlayer.onPlayerComplete.listen((event) {
                  _startRecording();
                  setState(() {
                    recordingState = 2;
                  });
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // 結果確認ダイアログ生成
  _showResultDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.85),
          title: const Text("今の回答を解析する？"),
          actions: [
            // トップ画面まで戻る
            TextButton(
              child: const Text("やめる"),
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
            ),
            // 画面の再生成
            TextButton(
              child: const Text("撮り直す"),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  recordingState = 0;
                });
              },
            ),
            // 解析実行
            TextButton(
              child: const Text("解析する"),
              onPressed: () async {
                // debug: 結果画面強制表示
                List<String> sentenceStructure = [
                  "僕が御社を志望した理由は、御社の経営理念である「人に優しく、いい世界を」に深く共感したからです",
                  "御社の社長さんがお見えになられたとき、僕はとても緊張していました",
                  "しかし、僕のその姿を見て優しく声をかけてくれました",
                  "そのおかげで、いまも緊張せずに面接を受けることができています",
                  "僕も、御社の社長さんのように人に優しくし、いい世界にしていきたいと考えています",
                  "これが、僕が御社を志望した理由です",
                ];
                List<String> resultNgword = [];
                List<String> resultRefrainword = ["僕", "社長さん", "思います"];
                List<String> resultDoubleHonorificSentenceList = [
                  "お見えになられ",
                ];
                List<String> includeDoubleHonorificSentenceList = [
                  "僕が御社を志望した理由は、御社の経営理念である「人に優しく、いい世界を」に深く共感したからです",
                  "御社の社長さんがお見えになられたとき、僕はとても緊張していました",
                  "しかし、僕のその姿を見て優しく声をかけてくれました",
                  "そのおかげで、いまも緊張せずに面接を受けることができています",
                  "僕も、御社の社長さんのように人に優しくし、いい世界にしていきたいと考えています",
                  "これが、僕が御社を志望した理由です",
                ];

                resultJudgeMovie = {
                  "sentence_structure": sentenceStructure,
                  "result_ngword": resultNgword,
                  "result_refrainword": resultRefrainword,
                  "result_double_honorific_sentence_list":
                      resultDoubleHonorificSentenceList,
                  "include_double_honorific_sentence_list":
                      includeDoubleHonorificSentenceList
                };

                // 秒数指定ローディング画面
                await showLoadingDialog(context: context);
                int _counter = 0;
                while (_counter < 30) {
                  await Future.delayed(const Duration(seconds: 1));
                  _counter++;
                }
                Navigator.pop(context);

                // 画面遷移
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultJudgeMoviePage(
                      map: resultJudgeMovie,
                      movie: File(path),
                    ),
                  ),
                );

                // File voice_data = File(path);
                // resultJudgeMovie =
                //     await startJudge(context, voice_data);

                // // 分析成功かつ顔認識成功なら結果画面へ、失敗ならダイアログ表示
                // if (resultJudgeMovie['statusCode'] == 1) {
                //   // 結果画面へ遷移
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => ResultJudgeMoviePage(
                //         title: widget.title,
                //         themeColor: widget.themeColor,
                //         map: resultJudgeMovie,
                //         movie: voice_data,
                //       ),
                //     ),
                //   );
                // } else {
                //   // 失敗ダイアログ表示
                //   showDialog(
                //     context: context,
                //     builder: (context) {
                //       return CupertinoAlertDialog(
                //         title: Text(resultJudgeMovie['errorMessage']),
                //         content: Text(resultJudgeMovie['detailErrorMessage']),
                //         actions: [
                //           CupertinoDialogAction(
                //             child: Text('OK'),
                //             onPressed: () => Navigator.pop(context),
                //           ),
                //         ],
                //       );
                //     },
                //   );
                // }
              },
            ),
          ],
        );
      },
    );
  }

  // 分析開始
  Future<Map<String, dynamic>> startJudge(
      BuildContext context, File _voice) async {
    Map<String, dynamic> resultJudgeImage = <String, dynamic>{};
    try {
      // ローディング画面表示
      await showLoadingDialog(context: context);

      // debug: 5秒待つ
      // await stopFiveSeconds();

      // aws 接続
      resultJudgeImage = await ConnectAWS.uploadImage(_voice);

      Navigator.pop(context);
    } catch (e) {
      //ダイアログを閉じる（追加）
      resultJudgeImage['statusCode'] = 99;
      resultJudgeImage['errorMessage'] = "ネットワークエラー";
      resultJudgeImage['detailErrorMessage'] = "インターネットへの接続をご確認ください。";
      print(e);
      Navigator.pop(context);
    }

    return resultJudgeImage;
  }

  // 録音開始
  void _startRecording() async {
    // 権限確認
    if (await record.hasPermission()) {
      // 録音ファイルを指定
      final directory = await getApplicationDocumentsDirectory();
      String pathToWrite = directory.path;
      final path = '$pathToWrite/interview.wav';

      // 録音開始
      await record.start(const RecordConfig(), path: path);
    }
  }

  // 録音停止
  Future _stopRecording() async {
    final _path = await record.stop();
    record.dispose();
    path = _path!;
  }

  // カメラのプレビュー画面生成
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

class ConnectAWS {
  static uploadImage(File _voice) async {
    // 認証なしアクセス
    http.Response response;
    try {
      String endpoint = AWSConfig.judgeMovieURL;
      Uri url = Uri.parse(endpoint);
      Map<String, String> headers = {'content-type': 'application/json'};

      final directory = await getApplicationDocumentsDirectory();
      String pathToWrite = directory.path;
      final localFile = '$pathToWrite/interview.wav';
      String movie_base64 = encodeWavToBase64(localFile);
      await writeToFile(movie_base64);
      response = await http.post(
        url,
        headers: headers,
        body: json.encode(
          {'sound': movie_base64, 'key': "1"},
        ),
      );
      // .timeout(const Duration(seconds: 30));
    } catch (e) {
      Map<String, dynamic> resultJudgeImage = <String, dynamic>{};
      resultJudgeImage['statusCode'] = 99;
      resultJudgeImage['errorMessage'] = "サーバ接続に失敗しました";
      resultJudgeImage['detailErrorMessage'] = "管理者へお問い合わせください";
      return "$e";
    }

    int statusCode = response.statusCode;
    Map<String, dynamic> resultJudgeImage =
        jsonDecode(utf8.decode(response.bodyBytes));

    // true response
    if (200 <= statusCode && statusCode <= 299) {
      resultJudgeImage['statusCode'] = 1;
      resultJudgeImage['errorMessage'] = "";
      resultJudgeImage['detailErrorMessage'] = "";

      // client error
    } else if (400 <= statusCode && statusCode <= 499) {
      resultJudgeImage['statusCode'] = 2;
      resultJudgeImage['errorMessage'] = "分析に失敗しました";
      resultJudgeImage['detailErrorMessage'] = "管理者へお問い合わせください";

      // network error
    } else if (500 <= statusCode && statusCode <= 599) {
      resultJudgeImage['statusCode'] = 3;
      resultJudgeImage['errorMessage'] = "ネットワークエラー";
      resultJudgeImage['detailErrorMessage'] =
          "ネットワーク接続が正しいか確認してください。[${response.body}]";

      // timeout or server error
    } else {
      resultJudgeImage['statusCode'] = 4;
      resultJudgeImage['errorMessage'] = "サーバエラー";
      resultJudgeImage['detailErrorMessage'] = "しばらく経ってからやり直してください";
    }

    return resultJudgeImage;
  }
}

// debug: バイナリのクリップボードセット
Future<void> writeToFile(String text) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/example.txt');
  log('${directory.path}/example.txt', name: 'n-saito');

  final data = ClipboardData(text: text);
  await Clipboard.setData(data);
  // Write to the file
  await file.writeAsString(text);
}

// wavヘッダーの長さ取得
int getWavHeaderLength(List<int> wavBytes) {
  // RIFFチャンクが終わる位置を検索
  for (int i = 0; i < wavBytes.length - 3; i++) {
    if (String.fromCharCodes(wavBytes.sublist(i, i + 4)) == 'RIFF') {
      return i + 4;
    }
  }
  return 0;
}

// wav to base64
String encodeWavToBase64(String filePath) {
  // WAVファイルをバイナリデータとして読み込む
  List<int> wavBytes = File(filePath).readAsBytesSync();

  // WAVファイルのヘッダーとデータを取得
  Uint8List headerBytes = getWavHeaderBytes(wavBytes);
  Uint8List dataBytes = getWavDataBytes(wavBytes);

  // ヘッダーとデータをBase64にエンコード
  String base64EncodedHeader = base64Encode(headerBytes);
  String base64EncodedData = base64Encode(dataBytes);

  // ヘッダーとデータを連結して返す
  return base64EncodedHeader + base64EncodedData;
}

// wavヘッダーのbytesを取得
Uint8List getWavHeaderBytes(List<int> wavBytes) {
  // RIFFチャンクが終わる位置を検索
  int headerLength = 0;
  for (int i = 0; i < wavBytes.length - 3; i++) {
    if (String.fromCharCodes(wavBytes.sublist(i, i + 4)) == 'RIFF') {
      headerLength = i + 4;
      break;
    }
  }
  return Uint8List.fromList(wavBytes.sublist(0, headerLength));
}

// wabデータのbytesを取得
Uint8List getWavDataBytes(List<int> wavBytes) {
  // RIFFチャンクが終わる位置を検索
  int headerLength = 0;
  for (int i = 0; i < wavBytes.length - 3; i++) {
    if (String.fromCharCodes(wavBytes.sublist(i, i + 4)) == 'RIFF') {
      headerLength = i + 4;
      break;
    }
  }
  return Uint8List.fromList(wavBytes.sublist(headerLength));
}
