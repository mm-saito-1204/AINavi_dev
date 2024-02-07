import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ainavi/config/constants.dart';
import 'package:ainavi/config/size_config.dart';
import 'package:ainavi/ui/top_page.dart';

import 'package:dart_openai/dart_openai.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/* 
 * エントリーポイント
 */
Future<void> main() async {
  // main 関数内で非同期処理を呼び出すための設定
  WidgetsFlutterBinding.ensureInitialized();

  // 日本語対応メソッド
  await initializeDateFormatting('ja_JP');

  //OpenAPIにAPIキーの設定
  await dotenv.load(fileName: 'assets/.env');
  OpenAI.apiKey = dotenv.env['OPENAI_APIKEY']!;

  // アプリ生成
  SystemChrome.setPreferredOrientations([
    // 縦向きの強制
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const AINaviApp());
  });
}

/* 
 * アプリ生成クラス
 */
class AINaviApp extends StatelessWidget {
  const AINaviApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ステータスバー・ナビゲーションバーの表示
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // 画面サイズの取得
    SizeConfig().init(context);

    // アプリの生成
    return MaterialApp(
      title: AppConfig.title,
      theme: ThemeData(
        primarySwatch: AppConfig.themeColor,
      ),
      home: const TopPage(),
    );
  }
}
