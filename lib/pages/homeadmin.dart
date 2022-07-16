



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
      appBar:header.getAppBar('Home'),
      drawer: Menu(),
      body:  SingleChildScrollView(
       child: Column(
         children: [
           const Espacamento(),
           const Logo(),
           const Espacamento(),
           const Center(
             child: Padding(
               padding: EdgeInsets.all(16.0),
               child: Card(
                 child:  Padding(
                   padding:  EdgeInsets.all(16.0),
                   child: MsgDia(),
                 ),
               ),
             ),
           ),
           const Espacamento(),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               ElevatedButton.icon(
                 icon: const Icon(
                   Icons.calendar_month,
                   color: Colors.white,
                   size: 50.0,
                 ),
                 style: ElevatedButton.styleFrom(
                   primary: Colors.orange, // background
                   padding: const EdgeInsets.all(16),
                 ),
                 label: const Text(
                   "",
                   style:  TextStyle(
                       fontSize: 16,
                       color: Colors.white),
                 ),
                 onPressed: () {
                   route.pushPage(context, const InportanciaMeses());
                 },
               ),

               ElevatedButton.icon(
                 icon: const Icon(
                   Icons.description,
                   color: Colors.white,
                   size: 50.0,
                 ),
                 style: ElevatedButton.styleFrom(
                   primary: Colors.orange, // background
                   padding: const EdgeInsets.all(16),
                 ),
                 label: const Text(
                   "",
                   style:  TextStyle(
                       fontSize: 16,
                       color: Colors.white),
                 ),
                 onPressed: () {
                   route.pushPage(context,  DadosBasicos());
                 },
               ),
               ElevatedButton.icon(
                 icon: const Icon(
                   Icons.currency_exchange,
                   color: Colors.white,
                   size: 50.0,
                 ),
                 style: ElevatedButton.styleFrom(
                   primary: Colors.orange, // background
                   padding: const EdgeInsets.all(16),
                 ),
                 label: const Text(
                   "",
                   style:  TextStyle(
                       fontSize: 16,
                       color: Colors.white),
                 ),
                 onPressed: () {
                   route.pushPage(context, const Diagnostico());
                 },
               ),
             ],
           ),
           const Espacamento(),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               ElevatedButton.icon(
                 icon: const Icon(
                   Icons.data_exploration,
                   color: Colors.white,
                   size: 50.0,
                 ),
                 style: ElevatedButton.styleFrom(
                   primary: Colors.orange, // background
                   padding: const EdgeInsets.all(16),
                 ),
                 label: const Text(
                   "",
                   style:  TextStyle(
                       fontSize: 16,
                       color: Colors.white),
                 ),
                 onPressed: () {
                   route.pushPage(context, const Simulador());
                 },
               ),
               ElevatedButton.icon(
                 icon: const Icon(
                   Icons.calculate,
                   color: Colors.white,
                   size: 50.0,
                 ),
                 style: ElevatedButton.styleFrom(
                   primary: Colors.orange, // background
                   padding: const EdgeInsets.all(16),
                 ),
                 label: const Text(
                   "",
                   style:  TextStyle(
                       fontSize: 16,
                       color: Colors.white),
                 ),
                 onPressed: () {
                   route.pushPage(context, const Calculadora());
                 },
               ),
               ElevatedButton.icon(
                 icon: const Icon(
                   Icons.insights,
                   color: Colors.white,
                   size: 50.0,
                 ),
                 style: ElevatedButton.styleFrom(
                   primary: Colors.orange, // background
                   padding: const EdgeInsets.all(16),
                 ),
                 label: const Text(
                   "",
                   style:  TextStyle(
                       fontSize: 16,
                       color: Colors.white),
                 ),
                 onPressed: () {
                   route.pushPage(context, const AnaliseViabilidade());
                 },
               ),
             ],
           ),
           const Espacamento(),
         ],
       ) ,
      ),
    );
  }
}
