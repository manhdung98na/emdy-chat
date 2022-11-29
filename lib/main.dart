import 'package:emdy_chat/configure/app_manager.dart';
import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/route.dart';
import 'package:emdy_chat/configure/style.dart';
import 'package:emdy_chat/controller/locale_controller.dart';
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
      child: ChangeNotifierProvider(
        create: (context) => LocaleController(),
        builder: (context, child) {
          return MaterialApp(
            title: 'EmdyChat',
            routes: RouteConfig.routes,
            onGenerateInitialRoutes: RouteConfig.onGenerateInitialRoutes,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              primarySwatch: Colors.deepPurple,
              brightness: Brightness.light,
              textSelectionTheme: textSelectionTheme,
              elevatedButtonTheme: elevatedButtonThemeData,
              snackBarTheme: snackBarTheme,
              dialogTheme: dialogTheme,
              scaffoldBackgroundColor: ColorConfig.primaryColor,
              iconTheme: iconTheme,
              listTileTheme: listTitleTheme,
              // buttonTheme: ButtonThemeData(),
            ),
            locale: Provider.of<LocaleController>(context).locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }

  TextSelectionThemeData get textSelectionTheme => const TextSelectionThemeData(
        cursorColor: ColorConfig.navyColorLogo,
        selectionColor: ColorConfig.secondaryColor,
      );

  ElevatedButtonThemeData get elevatedButtonThemeData =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.white),
          backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
          elevation: MaterialStateProperty.all(8),
          shadowColor: MaterialStateProperty.all(Colors.black),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );

  SnackBarThemeData get snackBarTheme => SnackBarThemeData(
        backgroundColor: ColorConfig.navyColorLogo.withOpacity(0.95),
        actionTextColor: ColorConfig.brown,
        contentTextStyle:
            StyleConfig.hintTextStyle.copyWith(color: Colors.white),
      );

  DialogTheme get dialogTheme => DialogTheme(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      );

  IconThemeData get iconTheme => const IconThemeData(
        color: ColorConfig.primaryColor,
        size: 24,
      );
  ListTileThemeData get listTitleTheme =>
      const ListTileThemeData(iconColor: ColorConfig.contentTextColor);
}
