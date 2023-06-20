


import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/usuaruio/recuperarsenha.dart';
import 'package:flutter/material.dart';

class EsqueceuSenha extends StatelessWidget {
  const EsqueceuSenha({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var irPagina = PushPage();
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.35,
      child: TextButton(
        style: OutlinedButton.styleFrom(
          primary: const Color.fromRGBO(1, 57, 44, 1), // background
        ),
        child: const Text('Esqueceu a senha?'),
        onPressed:(){
          irPagina.pushPage(context, RecuperarSenha());
        },
      ),
    );
  }
}
