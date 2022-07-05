



import 'package:appgestao/classes/firebase/verificastatus.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/btnDarkLight.dart';
import 'package:appgestao/componete/logo.dart';
import 'package:appgestao/pages/analiseviabilidade.dart';
import 'package:appgestao/pages/calculadora.dart';
import 'package:appgestao/pages/clientes.dart';
import 'package:appgestao/pages/dadosbasicos.dart';
import 'package:appgestao/pages/diagnostico.dart';
import 'package:appgestao/pages/homeadmin.dart';
import 'package:appgestao/pages/importanciameses.dart';
import 'package:appgestao/pages/simulador.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  var fb = VerificaStatusFairebase();
  var route = PushPage();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const Logo(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            trailing:const Icon(Icons.arrow_forward),
            onTap: (){
              route.pushPage(context, const HomeAdmin());
            //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text("Importância dos meses"),
            trailing:const Icon(Icons.arrow_forward),
            onTap: (){
              route.pushPage(context, const InportanciaMeses());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text("Dados Básicos"),
            trailing:const Icon(Icons.arrow_forward),
            onTap: (){
              route.pushPage(context, const DadosBasicos());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text("Diagnóstico"),
            trailing:const Icon(Icons.arrow_forward),
            onTap: (){
              route.pushPage(context, const Diagnostico());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.data_exploration),
            title: const Text("Simulador"),
            trailing:const Icon(Icons.arrow_forward),
            onTap: (){
              route.pushPage(context, const Simulador());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text("Calculadora de preços"),
            trailing:const Icon(Icons.arrow_forward),
            onTap: (){
              route.pushPage(context, const Calculadora());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.insights),
            title: const Text("Análise de viabilidade"),
            trailing:const Icon(Icons.arrow_forward),
            onTap: (){
              route.pushPage(context, const AnaliseViabilidade());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Clientes"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: (){
              route.pushPage(context, const Clientes());
           //   Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Sair"),
            trailing:const Icon(Icons.arrow_forward),
            onTap: (){
              fb.logoutUsuario(context);
              Navigator.pop(context);
            },
          ),
         const BtnDarkLight(),
        ],
      ),

    );
  }
}
