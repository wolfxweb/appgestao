import 'package:flutter/material.dart';

class HeaderAppBar {
  getAppBar(String title) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold ),
      ),
      centerTitle: true,
      backgroundColor: Colors.orange,
      actionsIconTheme: const IconThemeData(color: Colors.white),
      //  elevation: 15,
      //  toolbarHeight: 100, // default is 56
      //  toolbarOpacity: 0.5,
    );
  }
}
