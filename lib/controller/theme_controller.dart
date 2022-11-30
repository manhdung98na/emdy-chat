import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeController extends ChangeNotifier {
  ThemeController() {
    _theme = ThemeMode.system;
    isDarkTheme =
        SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
  }

  /// Chủ đề hiện tại
  late ThemeMode _theme;

  /// Kiểm tra xem [themeMode] có đang ở chế độ DarkTheme hay không.
  late bool isDarkTheme;

  ThemeMode get themeMode => _theme;

  String getThemeName(BuildContext context) {
    return isDarkTheme
        ? AppLocalizations.of(context)!.dark
        : AppLocalizations.of(context)!.light;
  }

  void toggleTheme() {
    _theme = isDarkTheme ? ThemeMode.light : ThemeMode.dark;
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}
