import 'package:emdy_chat/configure/color.dart';
import 'package:flutter/material.dart';

class StyleConfig {
  StyleConfig._();

  static const String? fontFamily = null;

  static const TextStyle headerTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontFamily: StyleConfig.fontFamily,
  );

  static const TextStyle titleTextStyle = TextStyle(
    color: ColorConfig.titleTextColor,
    fontSize: 18,
    fontFamily: StyleConfig.fontFamily,
  );

  static const TextStyle contentTextStyle = TextStyle(
    color: ColorConfig.contentTextColor,
    fontSize: 14,
    fontFamily: StyleConfig.fontFamily,
  );

  static const TextStyle hintTextStyle = TextStyle(
    color: ColorConfig.hintTextColor,
    fontSize: 12,
    fontFamily: StyleConfig.fontFamily,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontFamily: StyleConfig.fontFamily,
  );
}
