import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/* 
 * 画面のサイズ・セーフエリアの取得クラス
 */
class SizeConfig {
  static late MediaQueryData _mediaQueryData; // デバイスのメディア制御
  static late double screenWidth; // 画面横ピクセル
  static late double screenHeight; // 画面縦ピクセル
  static late double blockSizeHorizontal; // 横ピクセルの百分率ブロック
  static late double blockSizeVertical; // 縦ピクセルの百分率ブロック

  static late double _safeAreaHorizontal; // 画面セーフエリア横ピクセル
  static late double _safeAreaVertical; // 画面セーフエリア縦ピクセル
  static late double safeBlockHorizontal; // セーフエリア横ピクセルの百分率ブロック
  static late double safeBlockVertical; // セーフエリア縦ピクセルの百分率ブロック

  // 各サイズの取得
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
}
