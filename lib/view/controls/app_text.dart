import 'package:emdy_chat/configure/style.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText({
    super.key,
    required this.text,
    this.style = StyleConfig.contentTextStyle,
    this.maxLines = 1,
    this.textOverflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.left,
  });

  ///This string will be display on screen.
  ///
  ///Can not be null.
  final String text;

  ///Style of [text]. This can not be null
  ///
  ///Default is [StyleConfig.contentTextStyle]
  final TextStyle style;

  ///The maximum lines to display [text]. Default is 1
  final int? maxLines;

  /// Default is [TextOverflow.ellipsis]
  final TextOverflow textOverflow;

  ///How to align the [text]. Default is left
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign,
    );
  }
}
