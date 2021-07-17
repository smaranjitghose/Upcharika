import 'package:flutter/material.dart';

class MyThemes {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        primarySwatch: Colors.blue,
        cardColor: Colors.blue[100],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
        brightness: Brightness.dark,
        cardColor: Colors.grey,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      );
}
