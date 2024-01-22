import 'package:ainavi/ui/top_tabs/tab_judge_movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ainavi/config/size_config.dart';
import 'package:ainavi/ui/top_tabs/tab_judge_image.dart';

// トップ画面生成クラス
class TopPage extends StatefulWidget {
  const TopPage(
      {super.key,
      required this.title,
      required this.themeColor,
      required this.camera});
  final String title;
  final Color themeColor;
  final CameraDescription camera;

  @override
  State<TopPage> createState() => _TopPageState();
}

// トップ画面クラス
class _TopPageState extends State<TopPage> {
  // タブページ
  final _tab = <Tab>[
    Tab(
      icon: Icon(
        Icons.image,
        size: SizeConfig.blockSizeHorizontal * 7,
      ),
      text: "ES画像解析",
    ),
    Tab(
      icon: Icon(
        Icons.video_camera_front_outlined,
        size: SizeConfig.blockSizeHorizontal * 7,
      ),
      text: "面接動画解析",
    ),
  ];

  // 日本語対応
  void initializeLocaleData() async {
    await initializeDateFormatting('ja_JP'); // 利用したいロケールに合わせて変更
  }

  // 画面に対してなにか一時的な付加要素を与える時に使用するキー
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // 画面生成
  @override
  Widget build(BuildContext context) {
    initializeLocaleData();

    // タブを扱う画面の生成
    return DefaultTabController(
      length: _tab.length,
      child: Scaffold(
        key: _scaffoldKey,

        // 画面上部バー
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            widget.title,
            style: TextStyle(
              fontSize: 30,
              color: widget.themeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // タブバーを押下した際のページ生成処理
        body: TabBarView(children: <Widget>[
          // 画像解析画面の呼び出し
          TabPageJudgeImage(
            title: 'ES画像解析',
            themeColor: widget.themeColor,
          ),
          // 動画解析画面の呼び出し
          TabPageJudgeMovie(
            title: '面接動画解析',
            themeColor: widget.themeColor,
            camera: widget.camera,
          ),
        ]),

        // 画面下部のナビゲーションバー
        bottomNavigationBar: Container(
          color: widget.themeColor,
          child: SafeArea(
            child: TabBar(
              tabs: _tab,
              labelColor: Colors.white,
            ),
          ),
        ),

        // 画面全体の背景色
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}
