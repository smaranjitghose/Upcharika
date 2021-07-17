import 'package:flutter/material.dart';

class MyThemes {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        primarySwatch: Colors.blue,
        buttonColor: Colors.blue,
        cardColor: Colors.blue[100],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
        brightness: Brightness.dark,
        cardColor: Color(0xFF1D2740),
        canvasColor: Color(0xFF0B1328),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          color: Color(0xFF1D2740),
        ),
        buttonColor: Color(0xFF3172F5),
      );
}
