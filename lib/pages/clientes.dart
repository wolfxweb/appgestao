

import 'package:appgestao/componete/btnCadastrese.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:flutter/material.dart';

class Clientes extends StatefulWidget {
  const Clientes({Key? key}) : super(key: key);

  @override
  State<Clientes> createState() => _ClientesState();
}

class _ClientesState extends State<Clientes> {
  var header = new HeaderAppBar();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:header.getAppBar('Clientes'),
      drawer: Menu(),
      body: SingleChildScrollView(
        child: const Center(
          child:   BtnCadastreSe(),
        ),
      ),
    );
  }
}
