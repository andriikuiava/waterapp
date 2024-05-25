import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppColors {
  static const Color primary = Colors.blue;
  static Color primaryDark = Colors.blue.shade900;
  static const Color accent = Colors.red;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;

  static const Color success = Colors.green;
  static const Color successDark = Colors.greenAccent;
}

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.white,
    textTheme: TextTheme(
      bodyText1: TextStyle(color: AppColors.black),
      bodyText2: TextStyle(color: AppColors.black),
      headline1: TextStyle(color: AppColors.black, fontSize: 20),
      headline6: TextStyle(color: AppColors.black, fontSize: 16),
    ),
  );

  static final CupertinoThemeData cupertinoTheme = CupertinoThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.white,
    textTheme: CupertinoTextThemeData(
      navTitleTextStyle: TextStyle(color: AppColors.black, fontSize: 20),
      textStyle: TextStyle(color: AppColors.black, fontSize: 16),
    ),
  );
}
