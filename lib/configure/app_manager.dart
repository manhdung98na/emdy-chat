import 'package:flutter/cupertino.dart';

class AppManager {
  static unfocus(BuildContext context) =>
      FocusScope.of(context).focusedChild?.unfocus();
}
