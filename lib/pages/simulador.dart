

import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:flutter/material.dart';

class Simulador extends StatefulWidget {
  const Simulador({Key? key}) : super(key: key);

  @override
  State<Simulador> createState() => _SimuladorState();
}

class _SimuladorState extends State<Simulador> {
  var header = new HeaderAppBar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:header.getAppBar('Simulador'),
      drawer: Menu(),
      body: const SingleChildScrollView(
        child:  Center(
          child:  Text("Simulador"),
        ),
      ),
    );
  }
}
