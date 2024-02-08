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
                  // 上部画面バー
                  functionalDescriptionBar('AIに質問してアドバイスをもらおう！'),

                  // between「上部説明バー」and「質問ボタン」
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 3.5,
                  ),

                  // 質問ボタン
                  optionButton(context, '質問', ''),

                  // between「質問ボタン」and「添削ボタン」
                  SizedBox(height: SizeConfig.safeBlockVertical * 3.5),

                  // 添削ボタン
                  optionButton(context, '添削', ''),

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

/*
 *質問選択ボタン - テンプレ
 */
optionButton(BuildContext context, String text, page) {
  return SizedBox(
    // size
    width: SizeConfig.safeBlockHorizontal * 58,
    height: SizeConfig.safeBlockVertical * 6,
    // button
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8) //こちらを適用
            ),
        backgroundColor: const Color.fromARGB(255, 101, 116, 163),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
