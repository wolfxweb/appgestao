// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

var lightThemeData = ThemeData(
    primaryColor:  Colors.orange,
    textTheme: const TextTheme(button: TextStyle(color: Colors.white70)),
    buttonColor: Colors.orange,
    //iconTheme: new IconTheme(data:  , child: Widget);
  //  elevatedButtonTheme:  new ElevatedButtonTheme(data: {}, child: child),
    brightness: Brightness.light,
    accentColor: Colors.orange
);

var darkThemeData = ThemeData(
    primaryColor: Colors.orange,

    textTheme: const TextTheme(
        button: TextStyle(color: Colors.white),
          headline1: TextStyle(color: Colors.grey),
          headline2: TextStyle(color: Colors.grey),
          bodyText2: TextStyle(color: Colors.grey),
          subtitle1: TextStyle(color: Colors.grey),

    ),
    brightness: Brightness.dark,
    accentColor: Colors.orange
);

/*
  //  elevatedButtonTheme:  new ElevatedButtonTheme(data: {}, child: child),

 */