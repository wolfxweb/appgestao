import 'package:appgestao/blocs/usuario_bloc.dart';
import 'package:appgestao/classes/firebase/verificastatus.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/btnDarkLight.dart';
import 'package:appgestao/componete/logo.dart';
import 'package:appgestao/pages/analiseviabilidade.dart';
import 'package:appgestao/pages/calculadora.dart';
import 'package:appgestao/pages/clientes.dart';
import 'package:appgestao/pages/clientesSearch.dart';
import 'package:appgestao/pages/dadosbasicos.dart';
import 'package:appgestao/pages/diagnostico.dart';
import 'package:appgestao/pages/homeadmin.dart';
import 'package:appgestao/pages/importanciameses.dart';
import 'package:appgestao/pages/simulador.dart';
import 'package:appgestao/pages/simulador_new.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late UsuarioBloc _ususarioBloc;

  //final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('usuario').snapshots();

  @override
  void initState() {
    _ususarioBloc = UsuarioBloc();
    super.initState();
  }
  var userstatus = new VerificaStatusFairebase();

  var fb = VerificaStatusFairebase();
  var route = PushPage();

  var nivelAcesso = true;



  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        children: [
          const Logo(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              route.pushPage(context, const HomeAdmin());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text("Importância dos meses"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              route.pushPage(context, const InportanciaMeses());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text("Dados Básicos"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              route.pushPage(context, DadosBasicos());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text("Diagnóstico"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              route.pushPage(context, const Diagnostico());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.data_exploration),
            title: const Text("Simulador"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              route.pushPage(context, const Simulador());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text("Calculadora de preços"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              route.pushPage(context, const Calculadora());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.insights),
            title: const Text("Análise de viabilidade"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              route.pushPage(context, const AnaliseViabilidade());
              //  Navigator.pop(context);
            },
          ),
          if (nivelAcesso)
          StreamBuilder(
            stream: _ususarioBloc.outIsAdminUsuario,
            builder: (context, snapshot) {
            //  print("btn admin");
          //    print(snapshot.data.toString());
              if(snapshot.data.toString() =='admin'){
                return ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text("Clientes"),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    route.pushPage(context, const clientesSearch());
                  },
                );
              }else{
                return const SizedBox(height: 0.0);
              }
            }
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Sair"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              fb.logoutUsuario(context);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("new"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              route.pushPage(context, const simulador_new());
            },
          ),
          const BtnDarkLight(),
        ],
      ),
    );
  }
}
