// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

var lightThemeData = ThemeData(
    primaryColor: const Color.fromRGBO(1, 57, 44, 1),
    textTheme: const TextTheme(button: TextStyle(color: Colors.white70)),
   // buttonColor:  const Color.fromRGBO(1, 57, 44, 1),
    fontFamily: 'Lato',

    //iconTheme: new IconTheme(data:  , child: Widget);
  //  elevatedButtonTheme:  new ElevatedButtonTheme(data: {}, child: child),
    brightness: Brightness.light,
 //   accentColor: const Color.fromRGBO(1, 57, 44, 1)
);

var darkThemeData = ThemeData(
    primaryColor: const Color.fromRGBO(1, 57, 44, 1),

    textTheme: const TextTheme(
        button: TextStyle(color: Colors.white),
          headline1: TextStyle(color: Colors.grey),
          headline2: TextStyle(color: Colors.grey),
          bodyText2: TextStyle(color: Colors.grey),
          subtitle1: TextStyle(color: Colors.grey),

    ),
    brightness: Brightness.dark,
  //  accentColor: const Color.fromRGBO(1, 57, 44, 1)
);

/*
  //  elevatedButtonTheme:  new ElevatedButtonTheme(data: {}, child: child),

 */