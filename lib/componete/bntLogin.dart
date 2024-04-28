


import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/usuaruio/login.dart';
import 'package:flutter/material.dart';

class BtnLogin extends StatelessWidget {
  const BtnLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var irPagina = PushPage();
    return  OutlinedButton(
      style: colorButtonStyle() ,
      child: const Text('Login'),
      onPressed:(){
        irPagina.pushPage(context, const Login());
      },
    );
  }
  ButtonStyle colorButtonStyle() {
    var corVerde  = const Color.fromRGBO(1, 57, 44, 1);
    var corBranco = Colors.white;
    return ButtonStyle(
      // primary: color, // Cor de fundo do botão
      backgroundColor:MaterialStateProperty.all<Color>(corVerde),
      foregroundColor: MaterialStateProperty.all<Color>(corVerde),
    );
  }
}
