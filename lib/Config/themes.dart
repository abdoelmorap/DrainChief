// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:lms_flutter_app/utils/styles.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    primaryColor: AppStyles.appThemeColor,
    scaffoldBackgroundColor: Colors.white,
    unselectedWidgetColor: Colors.black,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(AppStyles.appThemeColor),
        backgroundColor: MaterialStateProperty.all<Color>(AppStyles.appThemeColor),
      ),
    ),
    tabBarTheme: TabBarTheme(
      indicator: BoxDecoration(
        color: AppStyles.appThemeColor,
      ),
    ),
    iconTheme: IconThemeData(
      color: Color(0xff6A779A),
    ),
    shadowColor: Colors.grey.withOpacity(0.3),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
    ),
    cardTheme: CardTheme(color: Colors.white),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 18.0,
        fontFamily: 'AvenirNext',
      ),
      displayLarge: TextStyle(
        fontSize: 72.0,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 36.0,
        fontStyle: FontStyle.italic,
      ),
      bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'AvenirNext'),
      titleSmall: TextStyle(
        fontSize: 14.0,
        fontFamily: 'AvenirNext',
        color: Colors.black,
      ),
      titleMedium: TextStyle(
        fontSize: 16.0,
        fontFamily: 'AvenirNext',
        color: Colors.black,
      ),
      labelLarge: TextStyle(
        fontSize: 14.0,
        fontFamily: 'AvenirNext',
        color: Colors.black,
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  static final dark = ThemeData.dark().copyWith(
    primaryColor: AppStyles.appThemeColorDark,
    unselectedWidgetColor: Colors.black87,
    scaffoldBackgroundColor: Colors.black54,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(AppStyles.appThemeColorDark),
        backgroundColor: MaterialStateProperty.all<Color>(AppStyles.appThemeColorDark),
      ),
    ),
    shadowColor: Colors.transparent,
    cardTheme: CardTheme(color: Colors.black45),
    tabBarTheme: TabBarTheme(
      indicator: BoxDecoration(
        color: AppStyles.appThemeColorDark,
      ),
    ),
    iconTheme: IconThemeData(
      color: Color(0xff8E99B7),
    ),
    textTheme: TextTheme(
      titleSmall: TextStyle(
        fontSize: 14.0,
        fontFamily: 'AvenirNext',
      ),
      titleMedium: TextStyle(
        fontSize: 16.0,
        fontFamily: 'AvenirNext',
        color: Colors.white,
      ),
      labelLarge: TextStyle(
        fontSize: 14.0,
        fontFamily: 'AvenirNext',
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 18.0,
        fontFamily: 'AvenirNext',
        color: Colors.white,
      ),
      displayLarge: TextStyle(
        fontSize: 72.0,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 36.0,
        fontStyle: FontStyle.italic,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        fontFamily: 'AvenirNext',
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
