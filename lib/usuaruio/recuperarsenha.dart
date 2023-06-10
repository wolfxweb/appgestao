


import 'package:appgestao/classes/firebase/verificastatus.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/alertamodal.dart';
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
  var alerta = AlertModal();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool btnEnviar = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

     /* appBar: AppBar(
        title: Text("Esqueceu a senha"),
      ),*/
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
                  const Espacamento(),
                  const Text(
                    'Recuperar senha',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: const Color.fromRGBO(159, 105, 56,1),
                    ),
                  ),
                  const Espacamento(),

                  Container(
                    decoration: buildBoxDecoration(),
                    child: TextFormField(
                      validator: ValidationBuilder().email().maxLength(50).required().build(),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: buildInputDecoration("Digite o seu email")
                    ),
                  ),
                  const Espacamento(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton (
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(159, 105, 56,1), // background
                        onPrimary: Colors.white, // foreground
                      ),
                      child: Text('Enviar',style: TextStyle(color: Colors.white)),
                      onPressed:btnEnviar?_buildOnPressed:null,
                    ),
                  ),
                  const Espacamento(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    BtnCadastreSe(),
                    TextButton(
                        style: OutlinedButton.styleFrom(
                          primary: const Color.fromRGBO(159, 105, 56,1), // background
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
  InputDecoration buildInputDecoration(text) {
    return  InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      //   suffixIcon: suffixIcon,
      fillColor: const Color.fromRGBO(159, 105, 56,0.5),
      filled: true,

      // disabledBorder: true,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
            color: const Color.fromRGBO(159, 105, 56,1), width: 1.0, style: BorderStyle.none),
      ),
      border: InputBorder.none,
      labelText: text,
      labelStyle: const TextStyle(
        color: Colors.black,
        //  backgroundColor: Colors.white,
      ),
    );
  }
  BoxDecoration buildBoxDecoration() {
    return const BoxDecoration(
      color: Colors.transparent,
      //borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 1,
          offset: Offset(1, 3), // Shadow position
        ),
      ],
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
        _emailController.text="";
        btnEnviar = false;
        alerta.openModal(context,'Foi enviado para o seu email o link para criação da nova senha, caso não estaja na caixa de entrada verifique o Span.');
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
