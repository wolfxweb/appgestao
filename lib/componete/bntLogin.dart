


import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/usuaruio/login.dart';
import 'package:flutter/material.dart';

class BtnLogin extends StatelessWidget {
  const BtnLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var irPagina = PushPage();
    return  OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: Colors.orange, // background
      ),
      child: const Text('Login'),
      onPressed:(){
        irPagina.pushPage(context, const Login());
      },
    );
  }
}
