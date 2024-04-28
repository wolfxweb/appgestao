


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
        style: colorButtonStyle(),
        child: const Text('Esqueceu a senha?'),
        onPressed:(){
          irPagina.pushPage(context, RecuperarSenha());
        },
      ),
    );
  }
  ButtonStyle colorButtonStyle() {
    var corVerde  = const Color.fromRGBO(1, 57, 44, 1);
    var corBranco = Colors.white;
    return ButtonStyle(
      // primary: color, // Cor de fundo do botão
      backgroundColor:MaterialStateProperty.all<Color>(corBranco),
      foregroundColor: MaterialStateProperty.all<Color>(corVerde),
    );
  }
}
