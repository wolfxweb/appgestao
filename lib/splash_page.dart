

import 'package:appgestao/classes/firebase/verificastatus.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/classes/usuarioExtraCadastro.dart';

import 'package:appgestao/pages/homeinativo.dart';
import 'package:appgestao/usuaruio/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState(){
    super.initState();

  //  FirebaseFirestore.instance.collection("usuario").doc('email').set({"texto":"teste"});
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {

      if (user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } else {
        var users = VerificaStatusFairebase();
        users.statusUsuario(user.email, context);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green),)
      ),

    );
  }


}
