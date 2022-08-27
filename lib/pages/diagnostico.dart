import 'package:appgestao/blocs/diagnostico.dart';
import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:appgestao/componete/espasamento.dart';
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
  initState() {}

  Widget build(BuildContext context) {
    // final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: header.getAppBar('Diagnóstico'),
      drawer: Menu(),
      body: SingleChildScrollView(
          child: StreamBuilder(
              stream: dignosticoBloc.textDiagnosticoController,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var lista = snapshot.data;
                  if (lista == "prejuízo") {
                    return buildContainerPrejuiso();
                  } else if (lista == "Lucro") {
                    return buildContainerLucro();
                  } else {
                    return Text('AGUARDE...');
                  }
                } else {
                  return buildLoad();
                }
              })),
    );
  }

  Center buildLoad() {
    return const Center(
        child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
    ));
  }

  Container buildContainerLucro() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          buildStreamBuilderLucro(dignosticoBloc.textLucro_1_Controller),
          const Espacamento(),
          buildStreamBuilderLucro(dignosticoBloc.textLucro_2_Controller),
          const Espacamento(),
          buildStreamBuilderLucro(dignosticoBloc.textLucro_3_Controller),
        ],
      ),
    );
  }

  StreamBuilder<dynamic> buildStreamBuilderLucro(_bluilderLucro) {
    return StreamBuilder(
        stream: _bluilderLucro, // dignosticoBloc.textLucro_1_Controller,
        builder: (context, snapshot) {
          var data = snapshot.data;
          return buildText(data.toString());
        });
  }

  Container buildContainerPrejuiso() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          StreamBuilder(
            stream: dignosticoBloc.textPrejuisoController,
            builder: (context, snapshot) {
              var data = snapshot.data;
              if (!snapshot.hasData) {
                return buildLoad();
              } else {
                return Column(
                  children: [
                    //  Text(data.toString()),
                    buildText(data.toString()),
                    const Espacamento(),
                    buildText(
                        "1. Verifique se os DADOS BÁSICOS informados estão corretos"),
                    const Espacamento(),
                    buildText(
                        "2. Analise, no SIMULADOR, as providências prioritárias para sair do prejuízo."),
                    const Espacamento(),
                    buildText(
                        "3. Com a CALCULADORA DE PREÇOS verifique a margem de cada produto. Se você concluir que precisa vender mais, ou descontinuar algum produto, estude a VIABILIDADE DE PROMOÇÃO & PROPAGANDA"),
                    const Espacamento(),
                    buildText(
                        "4. Avalie como está sua disponibilidade de CAPITAL DE GIRO.  Se for o caso, consulte o CHECKLIST 'O que fazer para diminuir a necessidade de capital de giro!'"),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Text buildText(text) {
    return Text(
      text.toString(),
      style: const TextStyle(
        //  color: Colors.white,
        fontSize: 20,
        //  fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.justify,
    );
  }
}
