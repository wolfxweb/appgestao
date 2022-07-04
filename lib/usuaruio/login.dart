
import 'package:appgestao/classes/firebase/verificastatus.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/btnCadastrese.dart';
import 'package:appgestao/componete/btnDarkLight.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/esquceusenha.dart';
import 'package:appgestao/componete/logo.dart';
import 'package:appgestao/pages/home.dart';
import 'package:appgestao/pages/homeinativo.dart';
import 'package:appgestao/usuaruio/cadastro.dart';
import 'package:appgestao/usuaruio/recuperarsenha.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:form_validator/form_validator.dart';

import '../main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);


  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void initState(){

  }
  var irPagina = PushPage();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool status = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: Text("oapap"),
      ),*/
      body: Center(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: SingleChildScrollView(
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
                  TextFormField(
                    validator: ValidationBuilder().minLength(6).maxLength(50).required().build(),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    controller: _senhaController,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.orange, width: 1.0),
                      ),
                      border: UnderlineInputBorder(),
                      prefixIcon: Icon(Icons.password, color: Colors.orange),
                      //    suffixIcon: Icon(Icons.remove_red_eye,color: Colors.orange),
                      hintText: 'Digite sua senha',
                    ),
                  ),
                  const Espacamento(),

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton (
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      child: Text('Entrar',style: TextStyle(color: Colors.white)),
                      onPressed:_buildOnPressed,

                    ),
                  ),
                  const Espacamento(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      BtnCadastreSe(),
                      EsqueceuSenha(),
                    ],
                  ),
                  const Espacamento(),
                  BtnDarkLight(),
                ],
              ),
            ),
          ),
        ),
    ),
    );
  }

  _buildOnPressed()async{

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      ).then((value){
        print(value.user!.email);
         var user = VerificaStatusFairebase();
         user.statusUsuario(value.user!.email, context);
      });
   //   print(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
