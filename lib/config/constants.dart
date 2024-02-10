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
  static const String ipAddress = '13.230.221.120'; // awsのIPアドレス
  static const String judgeImageURL =
      'http://${AWSConfig.ipAddress}:8000/judge_photo'; // 画像解析機能のURL
  static const String judgeMovieURL =
      'http://${AWSConfig.ipAddress}:8000/judge_movie'; // 動画解析機能のURL
}

// デバイスで使用可能なインカメラ取得
_getCameras() async {
  final cameras = await availableCameras();
  return cameras[1];
}
