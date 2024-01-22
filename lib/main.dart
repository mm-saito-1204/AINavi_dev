import 'package:ainavi/ui/top_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'config/size_config.dart';
import 'package:dart_openai/dart_openai.dart';

const THEME_COLOR = Colors.blue;

/* 
 * エントリーポイント
 */
Future<void> main() async {
  // main 関数内で非同期処理を呼び出すための設定
  WidgetsFlutterBinding.ensureInitialized();
  // デバイスで使用可能なカメラのリストを取得
  final cameras = await availableCameras();
  // 利用可能なカメラのリストからインカメラを取得
  final firstCamera = cameras[1];

  SystemChrome.setPreferredOrientations([
    // 縦向きを矯正
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(AINaviApp(camera: firstCamera));
  });
}

/* 
 * アプリ生成クラス
 */
class AINaviApp extends StatelessWidget {
  const AINaviApp({super.key, required this.camera});

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    // ステータスバー・ナビゲーションバーの表示
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // 画面サイズの取得
    SizeConfig().init(context);

    // アプリの生成
    return MaterialApp(
      title: 'AI Navi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // primaryIconTheme: const IconThemeData(color: Colors.black),
      ),
      home: TopPage(title: 'AINavi', themeColor: THEME_COLOR, camera: camera),
    );
  }
}
