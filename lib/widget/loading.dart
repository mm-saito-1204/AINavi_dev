import 'package:flutter/material.dart';

/* 
 * 非同期ローディング画面生成クラス
 */
Future<void> showLoadingDialog({
  required BuildContext context,
}) async {
  showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 250),
      barrierColor: Colors.black.withOpacity(0.5), // 画面マスクの透明度
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text(
                  "分析中",
                  style: TextStyle(
                    color: Color.fromARGB(255, 198, 198, 198),
                    fontSize: 24,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
