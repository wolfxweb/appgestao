



import 'package:appgestao/componete/headerAppBar.dart';
import 'package:flutter/material.dart';

import '../componete/menu.dart';

class InportanciaMeses extends StatefulWidget {
  const InportanciaMeses({Key? key}) : super(key: key);

  @override
  State<InportanciaMeses> createState() => _InportanciaMesesState();
}

class _InportanciaMesesState extends State<InportanciaMeses> {
  var header = new HeaderAppBar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:header.getAppBar('Importância dos meses'),
      drawer: Menu(),
      body: const SingleChildScrollView(
        child:  Center(
          child:  Text("Importância dos meses"),
        ),
      ),
    );
  }
}
