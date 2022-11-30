import 'package:emdy_chat/configure/color.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(),
    primarySwatch: Colors.deepPurple,
    focusColor: ColorConfig.purpleColorLogo,
    indicatorColor: const Color(0xFFD7DEDC),
    // primaryColor: Colors.black87,
    // dividerColor: Colors.white54,
    // hintColor: Colors.white54,
    // brightness: Brightness.dark,
    // textSelectionTheme: const TextSelectionThemeData(
    //   cursorColor: Colors.white70,
    //   selectionColor: ColorConfig.secondaryColor,
    // ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
        elevation: MaterialStateProperty.all(1),
        shadowColor: MaterialStateProperty.all(Colors.white38),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFFD7DEDC),
      actionTextColor: ColorConfig.purpleColorLogo,
      contentTextStyle: TextStyle(color: Colors.black, fontSize: 14),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 24,
    ),
    // listTileTheme: const ListTileThemeData(iconColor: Color(0xff16213E)),
    // textTheme: const TextTheme(
    //   headlineSmall: TextStyle(
    //     color: Colors.white,
    //     // fontSize: 24,
    //   ),
    //   bodySmall: TextStyle(
    //     color: Colors.white54,
    //     fontSize: 12,
    //   ),
    //   labelLarge: TextStyle(
    //     color: Colors.black,
    //     fontSize: 14,
    //   ),
    // ),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(),
    primarySwatch: Colors.deepPurple,
    primaryColor: Colors.white,
    dividerColor: Colors.black54,
    focusColor: ColorConfig.purpleColorLogo,
    indicatorColor: ColorConfig.navyColorLogo,
    hintColor: Colors.black54,
    brightness: Brightness.light,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: ColorConfig.navyColorLogo,
      selectionColor: ColorConfig.secondaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
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
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ColorConfig.navyColorLogo.withOpacity(0.95),
      actionTextColor: ColorConfig.brown,
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
      size: 24,
    ),
    listTileTheme: const ListTileThemeData(iconColor: Color(0xff16213E)),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        // fontSize: 24,
      ),
      titleLarge: TextStyle(
        color: Color(0xff16213E),
        fontWeight: FontWeight.w500,
        // fontSize: 18,
      ),
      bodyMedium: TextStyle(
        color: Color(0xff16213E),
        fontWeight: FontWeight.w400,
        // fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
      labelLarge: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
