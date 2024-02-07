import 'package:AINavi/config/constants.dart';
import 'package:AINavi/ui/AI_chat/tab_ai_chat.dart';
import 'package:AINavi/ui/Movie_advise/tab_judge_movie.dart';
import 'package:AINavi/config/size_config.dart';
import 'package:AINavi/ui/ES_advise/tab_judge_image.dart';
import 'package:AINavi/widget/ainavi_app_bar.dart';

import 'package:flutter/material.dart';

/* 
 * トップ画面生成クラス
 */
class TopPage extends StatefulWidget {
  const TopPage({super.key});
  @override
  State<TopPage> createState() => _TopPageState();
}

/* 
 * トップ画面クラス
 */
class _TopPageState extends State<TopPage> {
  // タブページ
  final _tab = <Tab>[
    // 写真解析
    Tab(
      icon: Icon(
        Icons.image,
        size: SizeConfig.blockSizeHorizontal * 7,
      ),
      text: "写真解析",
    ),
    // 面接解析
    Tab(
      icon: Icon(
        Icons.video_camera_front_outlined,
        size: SizeConfig.blockSizeHorizontal * 7,
      ),
      text: "面接解析",
    ),
    // AIチャット
    Tab(
      icon: Icon(
        Icons.manage_search_sharp,
        size: SizeConfig.blockSizeHorizontal * 7,
      ),
      text: "AIチャット",
    ),
  ];

  // 画面に対してなにか一時的な付加要素を与える時に使用するキー
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // 画面生成
  @override
  Widget build(BuildContext context) {
    // タブを扱う画面の生成
    return DefaultTabController(
      length: _tab.length,
      child: Scaffold(
        key: _scaffoldKey,

        // 画面上部バー
        appBar: ainaviAppBar(),

        // タブバーの押下時処理
        body: const TabBarView(children: <Widget>[
          TabPageJudgeImage(title: 'ES画像解析'), // 画像解析画面の生成
          TabPageJudgeMovie(title: '面接動画解析'), // 動画解析画面の生成
          TabPageAIChat(title: 'AIチャット'), // AIチャット画面の生成
        ]),

        // 画面下部のナビゲーションバー
        bottomNavigationBar: Container(
          color: AppConfig.themeColor,
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
