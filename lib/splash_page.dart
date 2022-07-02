

import 'package:appgestao/pages/home.dart';
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

    //FirebaseFirestore.instance.collection("usuario").doc('email').set({"texto":"teste"});

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    });





  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  Center(
        child: CircularProgressIndicator()
      ),

    );
  }


}
