




import 'package:appgestao/blocs/dados_basico_bloc.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/btnCadastrese.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/logo.dart';
import 'package:appgestao/usuaruio/login.dart';
import 'package:flutter/material.dart';

class HomeInativo extends StatefulWidget {
  const HomeInativo({Key? key}) : super(key: key);

  @override
  State<HomeInativo> createState() => _HomeInativoState();
}

class _HomeInativoState extends State<HomeInativo> {
  String userMsg = '';
  @override
  var header =  HeaderAppBar();
  var irPagina = PushPage();
  var mesBloc = DadosBasicosBloc();
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 50.0 ,horizontal: 16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                 children:  [
                   const  Espacamento(),
                   const Logo(),
                   const  Espacamento(),
                   Container(
                     alignment: Alignment.bottomLeft,
                     child: StreamBuilder(
                         stream: mesBloc.nomeOutUsuario,
                         builder: (context, snapshot) {
                           if(snapshot.hasData){
                             userMsg = snapshot.data.toString();
                           }
                           return Text(userMsg,
                             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                             textAlign: TextAlign.justify,
                             //  softWrap: true,
                           );
                         }
                     ),
                   ),
                   const Espacamento(),
                   const Text("Seu cadastro ainda não está ativo entre em contato com suporte para ativar sua conta.",
                     style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.justify,
                   ),
                   const Espacamento(),
                   const Text("Contato email: xx@gmail.com",
                     style: TextStyle(fontSize: 20),
                     textAlign: TextAlign.center,
                   ),
                   const Espacamento(),
                   OutlinedButton(
                     style: OutlinedButton.styleFrom(
                       primary: const Color.fromRGBO(159, 105, 56,1),
                     ),
                     child: const Text('Login'),
                     onPressed: () {
                       irPagina.pushPage(context, const Login());
                     },
                   ),
                 ],
               ),
          ),
        ),
      ),
    );
  }
}

