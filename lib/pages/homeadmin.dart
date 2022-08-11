import 'package:appgestao/blocs/usuario_bloc.dart';
import 'package:appgestao/classes/msghome.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/logo.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:appgestao/pages/analiseviabilidade.dart';
import 'package:appgestao/pages/calculadora.dart';
import 'package:appgestao/pages/dadosbasicos.dart';
import 'package:appgestao/pages/diagnostico.dart';
import 'package:appgestao/pages/importanciameses.dart';
import 'package:appgestao/pages/simulador.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  var header = new HeaderAppBar();
  var route = PushPage();
  late UsuarioBloc _ususarioBloc;
  @override
  void initState() {
    _ususarioBloc = UsuarioBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header.getAppBar('Home'),
      drawer: Menu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Espacamento(),
            const Logo(),
            const Espacamento(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              child: Text(
                'Sempre com você... participando do seu sucesso!',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            const Espacamento(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  //   borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 4,
                      offset: Offset(1, 2), // Shadow position
                    ),
                  ],
                ),
                child: MsgDia(),
              ),
            ),
            const Espacamento(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildGestureDetector(
                  context,
                  "Importência dos meses",
                  InportanciaMeses(),
                  const Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  1.0,
                  100.0,
                ),
                buildGestureDetector(
                  context,
                  "Dados Básicos",
                  DadosBasicos(),
                  const Icon(
                    Icons.description,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  1.0,
                  100.0,
                ),
                buildGestureDetector(
                  context,
                  "Diaginostico",
                  Diagnostico(),
                  const Icon(
                    Icons.currency_exchange,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  1,
                  95.0,
                ),

              ],
            ),
            const Espacamento(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildGestureDetector(
                  context,
                  "Simulador",
                  Simulador(),
                  const Icon(
                    Icons.data_exploration,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  1.0,
                  95.0,
                ),
                buildGestureDetector(
                  context,
                  "Calculadora",
                  Calculadora(),
                  const Icon(
                    Icons.calculate,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  1.0,
                  95.0,
                ),
                buildGestureDetector(
                  context,
                  "Análise viabilidade",
                  AnaliseViabilidade(),
                  const Icon(
                    Icons.insights,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  1.0,
                  100.0,
                ),
              ],
            ),
            const Espacamento(),
            const Espacamento(),
          ],
        ),
      ),
    );
  }

  GestureDetector buildGestureDetector(
      BuildContext context, titulo, rota, icone, linhas, altura) {
    return GestureDetector(
      child: Container(
        width: 100,
        height:altura,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.orange,
          //borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 4,
              //   offset: Offset(4, 8), // Shadow position
            ),
          ],
        ),
        child: Column(
          children: [
            icone,
            Text(
              titulo,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              softWrap: true,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        route.pushPage(context, rota);
      },
    );
  }
}
