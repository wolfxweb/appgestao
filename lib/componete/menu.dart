import 'package:appgestao/blocs/usuario_bloc.dart';
import 'package:appgestao/classes/firebase/verificastatus.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/btnDarkLight.dart';
import 'package:appgestao/componete/espasamento.dart';
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
          const Espacamento(),
          const Espacamento(),
          SizedBox(
            width: 100,
            height: 80,
            child: Image.asset("assets/img/Logo.png"),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: buildText('Home'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              route.pushPage(context, const HomeAdmin());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: buildText("Importância dos meses"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              route.pushPage(context, const InportanciaMeses());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: buildText("Dados Básicos"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              route.pushPage(context, DadosBasicos());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: buildText("Diagnóstico"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              route.pushPage(context, const Diagnostico());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.data_exploration),
            title: buildText("Simulador"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              route.pushPage(context, const Simulador());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: buildText("Calculadora de preços"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              route.pushPage(context, const Calculadora());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.insights),
            title:  buildText("Análise de viabilidade"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              route.pushPage(context, const AnaliseViabilidade());
              //  Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.rocket_launch),
            title:   buildText("Para mais,acesse nosso site"),
            trailing: const Icon(
              Icons.arrow_forward,
            ),
            onTap: () {
              _ususarioBloc.openURL();
              //   route.pushPage(context, const AnaliseViabilidade());
              //  Navigator.pop(context);
            },
          ),
          if (nivelAcesso)
            StreamBuilder(
                stream: _ususarioBloc.outIsAdminUsuario,
                builder: (context, snapshot) {
                  //  print("btn admin");
                  //    print(snapshot.data.toString());
                  if (snapshot.data.toString() == 'admin') {
                    return ListTile(
                      leading: const Icon(Icons.people),
                      title:  buildText("Clientes"),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        route.pushPage(context, const clientesSearch());
                      },
                    );
                  } else {
                    return const SizedBox(height: 0.0);
                  }
                }),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Sair"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              fb.logoutUsuario(context);
              Navigator.pop(context);
            },
          ),
          //  const BtnDarkLight(),
        ],
      ),
    );
  }

  buildText(text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
       // color: Colors.white,
      ),
    );
  }
}
