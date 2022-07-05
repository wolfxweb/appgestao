


import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:flutter/material.dart';

class AnaliseViabilidade extends StatefulWidget {
  const AnaliseViabilidade({Key? key}) : super(key: key);

  @override
  State<AnaliseViabilidade> createState() => _AnaliseViabilidadeState();
}

class _AnaliseViabilidadeState extends State<AnaliseViabilidade> {
  var header = new HeaderAppBar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:header.getAppBar('Análise viabilidade'),
      drawer: Menu(),
      body: const SingleChildScrollView(
        child:  Center(
          child:  Text("Análise viabilidade"),
        ),
      ),
    );
  }
}
