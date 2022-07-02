// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

var lightThemeData = ThemeData(
    primaryColor:  Colors.amber,
    textTheme: new TextTheme(button: TextStyle(color: Colors.white70)),
    buttonColor: Colors.amber,
  //  elevatedButtonTheme:  new ElevatedButtonTheme(data: {}, child: child),
    brightness: Brightness.light,
    accentColor: Colors.amber
);

var darkThemeData = ThemeData(
    primaryColor: Colors.amber,
    textTheme: new TextTheme(button: TextStyle(color: Colors.black54)),
    brightness: Brightness.dark,
    accentColor: Colors.amber
);