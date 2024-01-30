import 'dart:io';
import 'dart:convert';

import 'package:ainavi/config/size_config.dart';
import 'package:ainavi/main.dart';
import 'package:ainavi/ui/loading/loading.dart';
import 'package:ainavi/ui/es_advise/result_judge_image.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';

/* 
 * ESアドバイス写真選択画面を生成するクラス
 */
class TabPageJudgeImage extends StatefulWidget {
  final String title;
  final Color themeColor;
  final String awsIp;

  const TabPageJudgeImage(
      {Key? key,
      required this.title,
      required this.themeColor,
      required this.awsIp})
      : super(key: key);
  @override
  _TabPageJudgeImageState createState() => _TabPageJudgeImageState();
}

/* 
 * ESアドバイス写真選択画面ウィジェットのクラス
 */
class _TabPageJudgeImageState extends State<TabPageJudgeImage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // 画像
  File? _image;
  final picker = ImagePicker();

  // 日本語対応メソッド
  void initializeLocaleData() async {
    await initializeDateFormatting('ja_JP');
  }

  // 画像取得メソッド(カメラ)
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  // 画像取得メソッド(ギャラリー)
  Future getImageFromGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    initializeLocaleData();
    Map<String, dynamic> resultJudgeImage = <String, dynamic>{};

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
                        "ES写真を撮影し、AIにアドバイスをもらおう！",
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
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 60,
                    height: SizeConfig.safeBlockHorizontal * 80,
                    decoration: _image == null ? _innerShadow() : null,
                    child: _image == null
                        ? Center(
                            child: Text(
                              "画像が選択されていません",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        : FittedBox(
                            child: Image.file(_image!),
                            fit: BoxFit.contain,
                          ),
                  ),

                  // between「image display field」and「take a picture button」
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 3.5,
                  ),

                  // take a picture button
                  SizedBox(
                    width: SizeConfig.safeBlockHorizontal * 58,
                    height: SizeConfig.safeBlockVertical * 6,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8) //こちらを適用
                            ),
                        backgroundColor:
                            const Color.fromARGB(255, 101, 116, 163),
                      ),
                      onPressed: () {
                        getImageFromCamera();
                      },
                      child: const Center(
                        child: Text(
                          "写真を撮影する",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // between「take a picture button」and「select a picture button」
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 3.5,
                  ),

                  // select a picture button
                  SizedBox(
                    width: SizeConfig.safeBlockHorizontal * 58,
                    height: SizeConfig.safeBlockVertical * 6,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8) //こちらを適用
                            ),
                        backgroundColor:
                            const Color.fromARGB(255, 101, 116, 163),
                      ),
                      onPressed: () {
                        getImageFromGallery();
                      },
                      child: const Center(
                        child: Text(
                          "写真を選択する",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // between「select a picture button」and「start analysis button」
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 4,
                  ),

                  // start analysis button
                  SizedBox(
                    width: SizeConfig.safeBlockHorizontal * 82,
                    height: SizeConfig.safeBlockVertical * 6,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        // 画像が未選択ならグレー、選択済みなら水色
                        backgroundColor: MaterialStateProperty.all(
                          _image == null
                              ? Colors.black12
                              : const Color.fromARGB(255, 100, 211, 239),
                        ),
                      ),
                      onPressed: () async => {
                        // アップロード処理
                        if (_image != null)
                          {
                            resultJudgeImage =
                                await startJudge(context, _image, awsIp),

                            // 分析成功かつ顔認識成功なら結果画面へ、失敗ならダイアログ表示
                            if (resultJudgeImage['statusCode'] == 1 &&
                                resultJudgeImage['message'] == 1)
                              {
                                // 結果画面へ遷移
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResultJudgeImagePage(
                                      title: widget.title,
                                      themeColor: widget.themeColor,
                                      map: resultJudgeImage,
                                      image: _image,
                                    ),
                                  ),
                                ),
                              }
                            else
                              {
                                // 失敗ダイアログ表示
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                          resultJudgeImage['errorMessage']),
                                      content: Text(resultJudgeImage[
                                          'detailErrorMessage']),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: Text('OK'),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              }
                          }
                      },
                      child: Center(
                        child: Text(
                          "分析を開始する",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _image == null
                                ? const Color.fromARGB(255, 215, 215, 215)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // between「start analysis button」and「under bar」
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 6,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

// 画像表示欄用ボックスデコレーション
_innerShadow() {
  return const BoxDecoration(
    boxShadow: [
      BoxShadow(color: Colors.grey),
      BoxShadow(
        color: Color.fromARGB(255, 227, 227, 227),
        spreadRadius: -5,
        blurRadius: 8,
      ),
    ],
  );
}

// 分析開始
Future<Map<String, dynamic>> startJudge(
    BuildContext context, File? _image, String awsIp) async {
  Map<String, dynamic> resultJudgeImage = <String, dynamic>{};
  try {
    // ローディング画面表示
    await showLoadingDialog(context: context);

    // debug: 5秒待つ
    // await stopFiveSeconds();

    // aws 接続
    resultJudgeImage = await ConnectAWS.uploadImage(_image, awsIp);

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

// debug: 5秒待つ(ロード画面表示用)
Future<void> stopFiveSeconds() async {
  int _counter = 0;

  while (_counter < 5) {
    await Future.delayed(Duration(seconds: 1));
    _counter++;
  }
}

class ConnectAWS {
  static uploadImage(File? _image, String awsIp) async {
    // 認証なしアクセス
    http.Response response;
    try {
      String endpoint = 'http://$awsIp:8000/judge_photo';
      Uri url = Uri.parse(endpoint);
      Map<String, String> headers = {'content-type': 'application/json'};
      String image_base64 = base64Encode(_image!.readAsBytesSync());
      response = await http.post(
        url,
        headers: headers,
        body: json.encode(
          {'image': image_base64},
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
      if (resultJudgeImage['message'] != 1) {
        resultJudgeImage['errorMessage'] = "顔を認識できませんでした";
        resultJudgeImage['detailErrorMessage'] = "もう一度やり直してください";
      } else {
        resultJudgeImage['errorMessage'] = "";
        resultJudgeImage['detailErrorMessage'] = "";
      }

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
