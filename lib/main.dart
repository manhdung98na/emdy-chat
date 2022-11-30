import 'package:emdy_chat/configure/app_manager.dart';
import 'package:emdy_chat/configure/route.dart';
import 'package:emdy_chat/configure/theme.dart';
import 'package:emdy_chat/controller/locale_controller.dart';
import 'package:emdy_chat/controller/theme_controller.dart';
import 'package:emdy_chat/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //set up fullscreen
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );

  runApp(const EmdyChatApp());
}

class EmdyChatApp extends StatelessWidget {
  const EmdyChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppManager.unfocus(context),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeController()),
          ChangeNotifierProvider(create: (context) => LocaleController()),
        ],
        builder: (context, child) => child!,
        child: Builder(
          builder: (context) => MaterialApp(
            title: 'EmdyChat',
            routes: RouteConfig.routes,
            onGenerateInitialRoutes: RouteConfig.onGenerateInitialRoutes,
            debugShowCheckedModeBanner: false,
            themeMode: Provider.of<ThemeController>(context).themeMode,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            locale: Provider.of<LocaleController>(context).locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      ),
    );
  }
}
