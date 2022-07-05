import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
import 'package:appgestao/pages/home.dart';
import 'package:appgestao/pages/homeadmin.dart';
import 'package:appgestao/pages/homeinativo.dart';
import 'package:appgestao/usuaruio/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificaStatusFairebase {
  var route = PushPage();
  var alert = AlertSnackBar();

  statusUsuario(email, context) {
    FirebaseFirestore.instance
        .collection('usuario')
        .doc(email)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print(documentSnapshot.data());
        Map<String, dynamic> data =
            documentSnapshot.data()! as Map<String, dynamic>;
        print('Document exists on the database');
        print(data['status']);
        if (data['status']) {
          if (data['admin']) {
            route.pushPage(context, const HomeAdmin());
          } else {
            route.pushPage(context, const Home());
          }
        } else {
          route.pushPage(context, const HomeInativo());
          /*
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeInativo()),
          );

           */
        }
      }
    });
  }

  logoutUsuario(context) {
    FirebaseAuth.instance.signOut().then((value) {
      alert.alertSnackBar(context, Colors.green, 'Logout realizado com sucesso');
      isLogadoFB(context);
    });
  }

  isLogadoFB(context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        route.pushPage(context, const Login());
        /*  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );*/
      } else {
        var users = VerificaStatusFairebase();
        users.statusUsuario(user.email, context);
      }
    });
  }
}
