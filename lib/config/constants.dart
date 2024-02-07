import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

// アプリ全体設定 定数
class AppConfig {
  static const title = 'AINavi'; // アプリ名
  static const themeColor = Colors.blue; // アプリ全体のテーマカラー
  static final firstCamera =
      _getCameras(); // 利用可能なカメラのリストからインカメラを取得(androidは未対応)
}

// aws 定数
class AWSConfig {
  static const String ipAddress = '18.181.119.224'; // awsのIPアドレス
  static const String judgeImageURL =
      'http://${AWSConfig.ipAddress}:8000/judge_photo'; // 画像解析機能のURL
  static const String judgeMovieURL =
      'http://${AWSConfig.ipAddress}:8000/judge_movie'; // 動画解析機能のURL
}

// OpenAI 定数
class OpenAIConfig {
  static const String apiKey =
      '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';
}

// デバイスで使用可能なインカメラ取得
_getCameras() async {
  final cameras = await availableCameras();
  return cameras[1];
}
