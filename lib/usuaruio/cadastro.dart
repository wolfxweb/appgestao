import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/logo.dart';
import 'package:appgestao/usuaruio/login.dart';
import 'package:appgestao/usuaruio/recuperarsenha.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:form_validator/form_validator.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({Key? key}) : super(key: key);

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {


  var irPagina = PushPage();

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ValidationBuilder.setLocale('pt-br');
    return Scaffold(
/*
      appBar: AppBar(
        title: Text("Cadastre-se"),
      ),*/
      body: Center(
        child:Container(
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: SingleChildScrollView(
              reverse: true,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Logo(),
                    const Espacamento(),
                    const Text(
                      'Cadastre-se',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.orange,
                      ),
                    ),
                    const Espacamento(),

                    Container(
                      decoration: buildBoxDecoration(),
                      child: TextFormField(
                        validator: ValidationBuilder().email().maxLength(50).required().build(),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration:  buildInputDecoration("Digite seu email")
                      ),
                    ),
                    const Espacamento(),
                    Container(
                      decoration: buildBoxDecoration(),
                      child: TextFormField(
                        validator: ValidationBuilder().minLength(3).maxLength(50).required().build(),
                        keyboardType: TextInputType.text,
                        controller: _nomeController,
                        decoration: buildInputDecoration("Digite como gostaria de ser chamado")
                      ),
                    ),
                    const Espacamento(),
                    Container(
                      decoration: buildBoxDecoration(),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter(),
                        ],
                        keyboardType: TextInputType.number,
                        controller: _telefoneController,
                        decoration: buildInputDecoration("Digite seu telefone")
                      ),
                    ),
                    const Espacamento(),
                    Container(
                      decoration: buildBoxDecoration(),
                      child: TextFormField(
                        validator: ValidationBuilder().minLength(6).maxLength(50).required().build(),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: _senhaController,
                        decoration: buildInputDecoration("Digite sua senha")
                      ),
                    ),
                    const Espacamento(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: _buildOnPressed,
                        child: const Text('Cadastrar',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const Espacamento(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.orange, // background
                          ),
                          child: const Text('Login'),
                          onPressed: () {
                            irPagina.pushPage(context, const Login());
                          },
                        ),
                        TextButton(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.orange, // background
                          ),
                          child: const Text('Esqueceu a senha?'),
                          onPressed: () {
                            irPagina.pushPage(context, const RecuperarSenha());
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
      ),
    );
  }
  InputDecoration buildInputDecoration(text) {
    return  InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      //   suffixIcon: suffixIcon,
      fillColor: Colors.orangeAccent[100],
      filled: true,

      // disabledBorder: true,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.orange, width: 1.0, style: BorderStyle.none),
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
  _buildOnPressed()async {
    final isValid = _formKey.currentState!.validate();
    if(!isValid){
      return;
    }
    var alert = AlertSnackBar();
    var data ={
      'nome': _nomeController.text,
      'telefone':_telefoneController.text,
      'email':_emailController.text,
      'status':false,
      'admin':false,
    };
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      );
      if(credential.additionalUserInfo != null){
        print(credential.user!.email);
        FirebaseFirestore.instance.collection("usuario").doc(_emailController.text).set(data);
      }
      alert.alertSnackBar(context,Colors.green, 'Cadastro realizado com sucesso');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        alert.alertSnackBar(context,Colors.red, 'A senha fornecida é muito fraca.');

      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        alert.alertSnackBar(context,Colors.red, 'A conta já existe para esse e-mail.');

      }
    } catch (e) {
      print(e);
    }
    print(data);
  }
}
