


import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:flutter/material.dart';

class DadosBasicos extends StatefulWidget {
  const DadosBasicos({Key? key}) : super(key: key);

  @override
  State<DadosBasicos> createState() => _DadosBasicosState();
}

class _DadosBasicosState extends State<DadosBasicos> {
  var header = new HeaderAppBar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:header.getAppBar('Dados básicos'),
      drawer: Menu(),
      body: const SingleChildScrollView(
        child:  Center(
          child:  Text("Dados básicos"),
        ),
      ),
    );
  }
}
