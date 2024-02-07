import 'dart:io';
import 'dart:convert';

import 'package:AINavi/config/size_config.dart';
import 'package:AINavi/main.dart';
import 'package:AINavi/widget/loading.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';

/* 
 * ESアドバイス写真選択画面を生成するクラス
 */
class TabPageAIChat extends StatefulWidget {
  final String title;

  const TabPageAIChat({
    Key? key,
    required this.title,
  }) : super(key: key);
  @override
  _TabPageAIChatState createState() => _TabPageAIChatState();
}

/* 
 * ESアドバイス写真選択画面ウィジェットのクラス
 */
class _TabPageAIChatState extends State<TabPageAIChat>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // 画像
  File? _image;
  final picker = ImagePicker();

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
    Map<String, dynamic> resultAIChat = <String, dynamic>{};

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
                        "AIに質問してアドバイスをもらおう！",
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
                          "質問",
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
                          "添削",
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
    BuildContext context, File? _image) async {
  Map<String, dynamic> resultAIChat = <String, dynamic>{};
  try {
    // ローディング画面表示
    await showLoadingDialog(context: context);

    // debug: 5秒待つ
    // await stopFiveSeconds();

    // aws 接続
    resultAIChat = await ConnectAWS.uploadImage(_image);

    Navigator.pop(context);
  } catch (e) {
    //ダイアログを閉じる（追加）
    resultAIChat['statusCode'] = 99;
    resultAIChat['errorMessage'] = "ネットワークエラー";
    resultAIChat['detailErrorMessage'] = "インターネットへの接続をご確認ください。";
    print(e);
    Navigator.pop(context);
  }

  return resultAIChat;
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
  static uploadImage(File? _image) async {
    // 認証なしアクセス
    http.Response response;
    try {
      String endpoint = '';
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
      Map<String, dynamic> resultAIChat = <String, dynamic>{};
      resultAIChat['statusCode'] = 99;
      resultAIChat['errorMessage'] = "サーバ接続に失敗しました";
      resultAIChat['detailErrorMessage'] = "管理者へお問い合わせください";
      return "$e";
    }

    int statusCode = response.statusCode;
    Map<String, dynamic> resultAIChat =
        jsonDecode(utf8.decode(response.bodyBytes));

    // true response
    if (200 <= statusCode && statusCode <= 299) {
      resultAIChat['statusCode'] = 1;
      if (resultAIChat['message'] != 1) {
        resultAIChat['errorMessage'] = "顔を認識できませんでした";
        resultAIChat['detailErrorMessage'] = "もう一度やり直してください";
      } else {
        resultAIChat['errorMessage'] = "";
        resultAIChat['detailErrorMessage'] = "";
      }

      // client error
    } else if (400 <= statusCode && statusCode <= 499) {
      resultAIChat['statusCode'] = 2;
      resultAIChat['errorMessage'] = "分析に失敗しました";
      resultAIChat['detailErrorMessage'] = "管理者へお問い合わせください";

      // network error
    } else if (500 <= statusCode && statusCode <= 599) {
      resultAIChat['statusCode'] = 3;
      resultAIChat['errorMessage'] = "ネットワークエラー";
      resultAIChat['detailErrorMessage'] =
          "ネットワーク接続が正しいか確認してください。[${response.body}]";

      // timeout or server error
    } else {
      resultAIChat['statusCode'] = 4;
      resultAIChat['errorMessage'] = "サーバエラー";
      resultAIChat['detailErrorMessage'] = "しばらく経ってからやり直してください";
    }

    return resultAIChat;
  }
}
