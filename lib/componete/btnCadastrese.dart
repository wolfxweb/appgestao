

import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/usuaruio/cadastro.dart';
import 'package:flutter/material.dart';

class BtnCadastreSe extends StatelessWidget {
  const BtnCadastreSe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var irPagina = PushPage();
    return  OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: Colors.orange, // background
      ),
      child: const Text('Cadastre-se '),
      onPressed:(){
        irPagina.pushPage(context, const CadastroUsuario());
      },
    );
  }
}
