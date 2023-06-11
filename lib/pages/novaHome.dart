

import 'package:appgestao/componete/menu.dart';
import 'package:flutter/material.dart';
import 'package:appgestao/componete/headerAppBar.dart';

class novaHome extends StatefulWidget {
  const novaHome({Key? key}) : super(key: key);

  @override
  State<novaHome> createState() => _novaHomeState();
}

class _novaHomeState extends State<novaHome> {
  var header = new HeaderAppBar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header.getAppBar('Home'),
      drawer: Menu(),
      body: SingleChildScrollView(
        child: Text("home"),
      ),

    );
  }
}
