

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
        style: colorButtonStyle() ,
        child: const Text('Cadastre-se '),
        onPressed:(){
          irPagina.pushPage(context, const CadastroUsuario());
        },
      ),
    );
  }
  ButtonStyle colorButtonStyle() {
    return ButtonStyle(
      // primary: color, // Cor de fundo do botão
      backgroundColor:MaterialStateProperty.all<Color>(const Color.fromRGBO(1, 57, 44, 1)),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    );
  }
}
