import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/alertasnackbar.dart';

import 'package:appgestao/pages/homeinativo.dart';
import 'package:appgestao/pages/novaHome.dart';
import 'package:appgestao/usuaruio/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
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
        print('statusUsuario');
        print(documentSnapshot.data());
        Map<String, dynamic> data =  documentSnapshot.data()! as Map<String, dynamic>;
        if (data['status']) {
          if (data['admin']) {
            route.pushPage(context, const novaHome());
          } else {
            route.pushPage(context, const novaHome());
          }
        } else {
          route.pushPage(context, const HomeInativo());
        }
      }
    });
  }
  nivelUsuario()async{
  await  FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        FirebaseFirestore.instance
            .collection('usuario')
            .doc(user!.email)
            .get();
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
        route.pushPage(context, const Login());
      } else {
        var users = VerificaStatusFairebase();
        users.statusUsuario(user.email, context);
      }
    });
  }

  addDadosBasicos(context,dados){
    print(dados);
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        route.pushPage(context, const Login());
      } else {
        FirebaseFirestore.instance
            .collection('usuario')
            .doc(user.email)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            Map<String, dynamic> data =  documentSnapshot.data()! as Map<String, dynamic>;
            if (data['status']) {
              var dados_basicos ={
                'mes_selecionado':dados['mes_selecionado'],
                'quantidade_clientes_atendido': dados['quantidade_clientes_atendido'],
                'faturamento_vendas':dados['faturamento_vendas'],
                'gasto_com_vendas':dados['gasto_com_vendas'],
                'custo_insumos_terceiros':dados['custo_fixo'],
                'custo_fixo':dados['custo_insumos_terceiros'],
                'magem_desejada':dados['magem_desejada'],
                'cidade':data['cidade'],
                'estado':data['estado'],
                'setor_atuação':data['setor_atuação'],
                'email':data['email'],
                'telefone':data['telefone'],
                'timestamp_cadastro':formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn,':',ss])
              };
              FirebaseFirestore.instance.collection("dados_basicos").doc().set(dados_basicos);
            }
          }
        });

      }
    });
  }

}
