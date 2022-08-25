import 'package:appgestao/blocs/diagnostico.dart';
import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:flutter/material.dart';

class Diagnostico extends StatefulWidget {
  const Diagnostico({Key? key}) : super(key: key);

  @override
  State<Diagnostico> createState() => _DiagnosticoState();
}

class _DiagnosticoState extends State<Diagnostico> {
  var header = new HeaderAppBar();
  var dignosticoBloc = DignosticoBloc();


  @override


  initState() {


  }

  Widget build(BuildContext context) {
   // final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: header.getAppBar('Diagnóstico'),
      drawer: Menu(),
      body: SingleChildScrollView(
          child: Container(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          children: [
               StreamBuilder(
                   stream: dignosticoBloc.textDiagnosticoController,
                   builder: (snapshot, context) {
                    // print(snapshot);
                     return Text("kldldl");
                   },
               ),
          ],
        ),
      )),
    );
  }
}
