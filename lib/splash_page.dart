

import 'package:appgestao/classes/firebase/verificastatus.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/classes/usuarioExtraCadastro.dart';
import 'package:appgestao/pages/home.dart';
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
        print('User is currently signed out!');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } else {
        var users = VerificaStatusFairebase();
        users.statusUsuario(user.email, context);
        /*
          var user = VerificaStatusFairebase();
         user.statusUsuario(value.user!.email, context);
        FirebaseFirestore.instance
            .collection('usuario')
            .doc(user.email)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            print(documentSnapshot.data());
            Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
            print('Document exists on the database');
            print(data['status']);
            if(data['status']){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
            }else{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeInativo()),
              );
            }
          }
        });

         */
      }
    });





  }
  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: Center(
        child: CircularProgressIndicator()
      ),

    );
  }


}
