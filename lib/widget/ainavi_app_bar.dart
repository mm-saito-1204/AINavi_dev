import 'package:flutter/material.dart';
import 'package:AINavi/config/constants.dart';

ainaviAppBar([String? functionTitle]) {
  // 機能名がなければ「アプリ名」
  if (functionTitle == null) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Color.fromARGB(255, 112, 112, 112)),
      centerTitle: true,
      title: const Text(
        AppConfig.title,
        style: TextStyle(
          fontSize: 30,
          color: AppConfig.themeColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    // 機能名があれば「アプリ名：機能名」
  } else {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Color.fromARGB(255, 112, 112, 112)),
      centerTitle: true,
      title: Text(
        "${AppConfig.title}:$functionTitle",
        style: const TextStyle(
          fontSize: 24,
          color: AppConfig.themeColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
