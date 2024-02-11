import 'package:ainavi/ui/AI_chat/execute_ai_chat.dart';
import 'package:flutter/material.dart';

import 'package:ainavi/config/size_config.dart';
import 'package:ainavi/widget/functional_description_bar.dart';

/* 
 * ESアドバイス写真選択画面を生成するクラス
 */
class TabPageAIChat extends StatefulWidget {
  const TabPageAIChat({
    Key? key,
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _controller = ScrollController();

    return Center(
      child: Container(
        alignment: Alignment.topCenter,
        child: Scrollbar(
          thumbVisibility: true,
          controller: _controller,
          radius: const Radius.circular(16),
          child: SingleChildScrollView(
            controller: _controller,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // 機能説明バー
                  functionalDescriptionBar('AIにどんなことを聞きたい？'),
                  // between「機能説明バー」and「質問ボタン」
                  SizedBox(height: SizeConfig.safeBlockVertical * 5.5),

                  // 質問ボタン
                  optionButtonCard(context, '質問'),
                  // between「質問ボタン」and「添削ボタン」
                  SizedBox(height: SizeConfig.safeBlockVertical * 7),

                  // 添削ボタン
                  optionButtonCard(context, '添削'),
                  // between「添削ボタン」and「under bar」
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

/*
 *質問選択ボタンカード - テンプレ
 */
optionButtonCard(BuildContext context, String title) {
  bool isQuestion = (title == '質問') ? true : false;
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExecuteAIChatPage(isQuestion: isQuestion),
        ),
      );
    },
    child: Container(
      width: SizeConfig.safeBlockHorizontal * 80,
      height: SizeConfig.safeBlockVertical * 30,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        // 影
        boxShadow: const [
          BoxShadow(
            color: Colors.grey, //色
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(10, 10),
          ),
        ],
        // 枠線
        border: Border.all(
            color: const Color.fromARGB(255, 215, 230, 255), width: 10),
        borderRadius: BorderRadius.circular(20),
        // 背景画像
        image: DecorationImage(
          image: AssetImage(isQuestion
              ? 'assets/images/chatQuestion.png'
              : 'assets/images/chatCorrection.png'),
          fit: BoxFit.cover,
        ),
        color: Colors.blue[50],
      ),

      // Cardと被ったWidgetをCardの形に保持する
      // clipBehavior: Clip.antiAliasWithSaveLayer,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: SizeConfig.blockSizeHorizontal * 80,
            height: SizeConfig.blockSizeVertical * 6,
            color: const Color.fromARGB(255, 215, 230, 255).withOpacity(0.95),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.transparent,
                  shadows: [
                    Shadow(offset: Offset(0, -2)),
                  ],
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
