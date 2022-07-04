


import 'package:appgestao/classes/firebase/verificastatus.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/btnCadastrese.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/logo.dart';
import 'package:appgestao/usuaruio/login.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:form_validator/form_validator.dart';

import 'cadastro.dart';

class RecuperarSenha extends StatefulWidget {
  const RecuperarSenha({Key? key}) : super(key: key);

  @override
  State<RecuperarSenha> createState() => _RecuperarSenhaState();
}

class _RecuperarSenhaState extends State<RecuperarSenha> {

  var irPagina = PushPage();

  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Esqueceu a senha"),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Logo(),
                  TextFormField(
                    validator: ValidationBuilder().email().maxLength(50).required().build(),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.orange, width: 1.0),
                      ),
                      prefixIcon: Icon(Icons.email, color: Colors.orange),
                      hintText: 'Digite o seu email',
                    ),
                  ),
                  const Espacamento(),
                  ElevatedButton (
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    child: Text('Enviar',style: TextStyle(color: Colors.white)),
                    onPressed:_buildOnPressed,
                  ),
                  const Espacamento(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    BtnCadastreSe(),
                    TextButton(
                        style: OutlinedButton.styleFrom(
                          primary: Colors.orange, // background
                        ),
                        child: const Text('Login'),
                        onPressed:(){
                          irPagina.pushPage(context, const Login());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  _buildOnPressed()async{
    final isValid = _formKey.currentState!.validate();
    if(!isValid){
      return;
    }
    print(_emailController.text);
    try {
      final credential = await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text).then((value){
        print('ok');
      });


    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
