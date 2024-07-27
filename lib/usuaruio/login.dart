import 'dart:async';

import 'package:appgestao/classes/firebase/verificastatus.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
import 'package:appgestao/componete/btnCadastrese.dart';
import 'package:appgestao/componete/btnDarkLight.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/esquceusenha.dart';
import 'package:appgestao/componete/logo.dart';

import 'package:appgestao/pages/homeinativo.dart';
import 'package:appgestao/usuaruio/cadastro.dart';
import 'package:appgestao/usuaruio/recuperarsenha.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:form_validator/form_validator.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:appgestao/componete/alertamodal.dart';
import '../main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var alerta = AlertModal();
  var irPagina = PushPage();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool status = true;
  StreamSubscription? subscription;
  final SimpleConnectionChecker _simpleConnectionChecker =  SimpleConnectionChecker()..setLookUpAddress('pub.dev');
  String _message = '';
  bool _conn = false;
  @override
  void initState() {
    super.initState();

    subscription =    _simpleConnectionChecker.onConnectionChange.listen((connected) {
      setState(() {
        _message = connected ? 'Connected' : 'Not connected';
      });
    });
    _getConection();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: Text("oapap"),
      ),*/
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
           //   crossAxisAlignment: CrossAxisAlignment.center,
             // mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const SizedBox(
                  height: 100.0,
                ),
               // const Logo(),
                const SizedBox(
                  height: 100.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTextoInput('Digite o seu email'),
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
                        decoration:buildInputDecoration(''),

                      ),
                    ),
                  ],
                ),
                const Espacamento(),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTextoInput('Digite sua senha'),
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
                        decoration: buildInputDecoration(''),
                      ),
                    ),
                  ],
                ),
                const Espacamento(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.10,
                          child: Container(),
                        ),
                        SizedBox(
                           width: MediaQuery.of(context).size.width*0.70,
                          child: ElevatedButton(
                            style: colorButtonStyle(),
                            child: Text('Entrar', style: TextStyle(color: Colors.white)),
                            onPressed: _buildOnPressed,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.10,
                          child: Container(),
                        ),
                      ],
                    ),
                    const Espacamento(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BtnCadastreSe(),
                        EsqueceuSenha(),
                      ],
                    ),
                  ],
                ),

                const Espacamento(),
               // const BtnDarkLight(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Text buildTextoInput(titulo) {
    return Text(
      titulo,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Color.fromRGBO(105, 105, 105, 1),
      ),
    );
  }
  InputDecoration buildInputDecoration(text) {
    return  InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      //   suffixIcon: suffixIcon,
      fillColor: const Color.fromRGBO(245, 245, 245, 1),
      filled: true,
      // disabledBorder: true,
    focusedBorder: const OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide:    BorderSide(color: Color.fromRGBO(1, 57, 44, 1), width: 1.0),
      ),
      border: const OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide:  BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
      ),

      labelText: text,
      labelStyle: const TextStyle(
        color: Colors.black,

        fontFamily: 'Lato',
        fontSize: 16,
        //  color: const Color.fromRGBO(159, 105, 56,1),
        backgroundColor: Colors.white,
      ),
    );
  }
  BoxDecoration buildBoxDecoration() {
    return const BoxDecoration(
      color: Colors.transparent,
      //borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.white,
        //  blurRadius: 1,
         // offset: Offset(1, 3), // Shadow position
        ),
      ],
    );
  }
  _getConection() async {
    bool _isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    setState(() {
      _conn = _isConnected;
    });
    if (!_isConnected) {
      alerta.openModal(context, 'Sem conexão com a internet');
    }
  }
  _buildOnPressed() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _getConection();
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
