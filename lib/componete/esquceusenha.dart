


import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/usuaruio/recuperarsenha.dart';
import 'package:flutter/material.dart';

class EsqueceuSenha extends StatelessWidget {
  const EsqueceuSenha({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var irPagina = PushPage();
    return TextButton(
      style: OutlinedButton.styleFrom(
        primary: Colors.orange, // background
      ),
      child: const Text('Esqueceu a senha?'),
      onPressed:(){
        irPagina.pushPage(context, RecuperarSenha());
      },
    );
  }
}
