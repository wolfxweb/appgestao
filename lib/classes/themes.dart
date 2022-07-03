// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

var lightThemeData = ThemeData(
    primaryColor:  Colors.orange,
    textTheme: new TextTheme(button: TextStyle(color: Colors.white70)),
    buttonColor: Colors.orange,
  //  elevatedButtonTheme:  new ElevatedButtonTheme(data: {}, child: child),
    brightness: Brightness.light,
    accentColor: Colors.orange
);

var darkThemeData = ThemeData(
    primaryColor: Colors.orange,
    textTheme: new TextTheme(button: TextStyle(color: Colors.black54)),
    brightness: Brightness.dark,
    accentColor: Colors.orange
);