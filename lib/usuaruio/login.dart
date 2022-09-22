import 'package:appgestao/classes/firebase/verificastatus.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
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
  void initState() {}
  var irPagina = PushPage();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Logo(),
                  const Espacamento(),
                  const Espacamento(),
                  const Espacamento(),
                  Container(
                    decoration: buildBoxDecoration(),
                    child: TextFormField(
                      validator: ValidationBuilder()
                          .email()
                          .maxLength(50)
                          .required()
                          .build(),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration:buildInputDecoration('Digite o seu email'),

                    ),
                  ),
                  const Espacamento(),
                  Container(
                    decoration: buildBoxDecoration(),
                    child: TextFormField(
                      validator: ValidationBuilder()
                          .minLength(6)
                          .maxLength(50)
                          .required()
                          .build(),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      controller: _senhaController,
                      decoration: buildInputDecoration('Digite sua senha'),
                    ),
                  ),
                  const Espacamento(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(159, 105, 56,1),
                         // background
                        onPrimary: Colors.white, // foreground
                      ),
                      child: Text('Entrar', style: TextStyle(color: Colors.white)),
                      onPressed: _buildOnPressed,
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
                 // const BtnDarkLight(),
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
            color:  Color.fromRGBO(159, 105, 56,0.5), width: 1.0, style: BorderStyle.none),
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

  _buildOnPressed() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    var alert = AlertSnackBar();
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      )
          .then((value) {
        print(value.user!.email);
        var user = VerificaStatusFairebase();
        user.statusUsuario(value.user!.email, context);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        alert.alertSnackBar(
            context, Colors.red, 'Nenhum usuário encontrado para esse e-mail.');
      } else if (e.code == 'wrong-password') {
        print('Senha incorreta fornecida para esse usuário.');
        alert.alertSnackBar(context, Colors.red,
            'Senha incorreta fornecida para esse usuário.');
      }
    }
  }
}
