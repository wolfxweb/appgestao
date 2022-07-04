



import 'package:appgestao/pages/home.dart';
import 'package:appgestao/pages/homeinativo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VerificaStatusFairebase{

  statusUsuario(email,context){
    FirebaseFirestore.instance
        .collection('usuario')
        .doc(email)
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
  }
}