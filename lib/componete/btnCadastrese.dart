

import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/usuaruio/cadastro.dart';
import 'package:flutter/material.dart';

class BtnCadastreSe extends StatelessWidget {
  const BtnCadastreSe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var irPagina = PushPage();
    return  SizedBox(
      width: MediaQuery.of(context).size.width*0.35,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          primary:  const Color.fromRGBO(1, 57, 44, 1),// background
        ),
        child: const Text('Cadastre-se '),
        onPressed:(){
          irPagina.pushPage(context, const CadastroUsuario());
        },
      ),
    );
  }
}
