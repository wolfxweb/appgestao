




import 'package:appgestao/blocs/dados_basico_bloc.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/btnCadastrese.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/logo.dart';
import 'package:appgestao/usuaruio/login.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
                   const Espacamento(),
                   const Espacamento(),
                   const  Espacamento(),
      /*             Container(
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
                   ),*/
                   const Espacamento(),
                   const Text("Seu cadastro ainda não está ativo entre em contato com suporte para ativar sua conta.",
                     style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.justify,
                   ),
                  /* const Espacamento(),
                   const Text("Contato email: xx@gmail.com",
                     style: TextStyle(fontSize: 20),
                     textAlign: TextAlign.center,
                   ),*/
                   const Espacamento(),
                   const Espacamento(),
                   SizedBox(
                     width: MediaQuery.of(context).size.width * 0.70,
                     child: ElevatedButton(
                       style: ElevatedButton.styleFrom(
                         primary: const Color.fromRGBO(1, 57, 44, 1),
                         // background
                         onPrimary: Colors.white, // foreground
                       ),
                       onPressed: () {
                         _launchEmail(); // Função para abrir o link do WhatsApp
                       },
                       child: const Text('Contato por Email',
                           style: TextStyle(color: Colors.white)),
                     ),
                   ),
                   const Espacamento(),
                   SizedBox(
                     width: MediaQuery.of(context).size.width * 0.70,
                     child: ElevatedButton(
                       style: ElevatedButton.styleFrom(
                         primary: const Color.fromRGBO(1, 57, 44, 1),
                         // background
                         onPrimary: Colors.white, // foreground
                       ),
                       onPressed: () {
                         _launchWhatsApp(); // Função para abrir o link do WhatsApp
                       },
                       child: const Text('Contato pelo WhatsApp',
                           style: TextStyle(color: Colors.white)),
                     ),
                   ),
                   const Espacamento(),
                   SizedBox(
                     width: MediaQuery.of(context).size.width * 0.70,
                     child: ElevatedButton(
                       style: ElevatedButton.styleFrom(
                         primary: const Color.fromRGBO(1, 57, 44, 1),
                         // background
                         onPrimary: Colors.white, // foreground
                       ),
                       onPressed: () {
                         irPagina.pushPage(context, const Login());
                       },
                       child: const Text('Login',
                           style: TextStyle(color: Colors.white)),
                     ),
                   ),
                 ],
               ),
          ),
        ),
      ),
    );
  }
  _launchWhatsApp() async {
    final phone = '+55419993185577'; // Substitua pelo número de telefone desejado
    final message = ''; // Mensagem opcional

    final url = 'https://wa.me/$phone/?text=${Uri.encodeComponent(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o WhatsApp.';
    }
  }
  _launchEmail() async {
    final email = 'contato@getup.app.br'; // Substitua pelo endereço de e-mail desejado
    final subject = ''; // Assunto do e-mail (opcional)
    final body = ''; // Corpo do e-mail (opcional)

    final url = 'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o cliente de e-mail.';
    }
  }
}

