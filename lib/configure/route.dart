import 'package:emdy_chat/configure/app_manager.dart';
import 'package:emdy_chat/view/pages/home_page.dart';
import 'package:emdy_chat/view/pages/landing_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteConfig {
  RouteConfig._();

  static const String landing = '';
  static const String home = 'home';
  // static const String register = 'register';

  static Map<String, Widget Function(BuildContext context)> get routes => {
        landing: (BuildContext context) => const LandingPage(),
        home: (BuildContext context) => const HomePage(),
      };

  static List<Route<dynamic>> onGenerateInitialRoutes(String name) {
    return [
      MaterialPageRoute(builder: (context) => const LandingPage()),
    ];
  }

  static void pushWidget(BuildContext context, Widget widget) {
    AppManager.unfocus(context);
    Navigator.push(context, CupertinoPageRoute(builder: (context) => widget));
  }
}
