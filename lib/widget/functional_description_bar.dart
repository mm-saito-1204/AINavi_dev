import 'package:flutter/material.dart';
import 'package:ainavi/config/size_config.dart';

// 機能説明バー
functionalDescriptionBar(String text) {
  return Container(
    width: SizeConfig.safeBlockHorizontal * 100,
    height: SizeConfig.safeBlockVertical * 7.5,
    decoration: BoxDecoration(
      color: Colors.blue[100],
      boxShadow: const [
        BoxShadow(
          spreadRadius: 0,
          blurRadius: 10,
          offset: Offset(0, 5),
          color: Colors.grey,
        ),
      ],
    ),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
