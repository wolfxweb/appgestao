




import 'package:appgestao/componete/btnCadastrese.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:flutter/material.dart';

class HomeInativo extends StatefulWidget {
  const HomeInativo({Key? key}) : super(key: key);

  @override
  State<HomeInativo> createState() => _HomeInativoState();
}

class _HomeInativoState extends State<HomeInativo> {
  @override
  var header =  HeaderAppBar();
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header.getAppBar('Cadastro inativo'),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            Text("Seu cadastro ainda não está ativo entre em contato com suporte para ativar sua conta"),
            Text("Email xx@gmail.com"),
          ],
        ),
      )
    );
  }
}

