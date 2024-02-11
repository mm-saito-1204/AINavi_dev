import 'package:flutter/material.dart';

// アプリ全体設定 定数
class AppConfig {
  static const title = 'AINavi'; // アプリ名
  static const themeColor = Colors.blue; // アプリ全体のテーマカラー
}

// aws 定数
class AWSConfig {
  static const String ipAddress = '13.230.221.120'; // awsのIPアドレス
  static const String judgeImageURL =
      'http://${AWSConfig.ipAddress}:8000/judge_photo'; // 画像解析機能のURL
  static const String judgeMovieURL =
      'http://${AWSConfig.ipAddress}:8000/judge_movie'; // 動画解析機能のURL
}
