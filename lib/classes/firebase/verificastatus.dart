import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
import 'package:appgestao/pages/ativacaoLicenca.dart';
import 'package:appgestao/pages/homeadmin.dart';

import 'package:appgestao/pages/homeinativo.dart';
import 'package:appgestao/pages/novaHome.dart';
import 'package:appgestao/usuaruio/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
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
       //  print('statusUsuario - statusUsuario');
        // print(documentSnapshot.data());
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
    print(user!.email);
      if (user == null) {
        FirebaseFirestore.instance
            .collection('usuario')
            .doc(user!.email)
            .get();
      }
    });

  }
  Future<String?> getTipoEmpresa() async {
    await initializeDateFormatting('pt_BR', null);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var snapshot = await FirebaseFirestore.instance
          .collection('usuario')
          .doc(user.email)
          .get();

      if (snapshot.exists) {
        var data = snapshot.data();
        return data?['tipo_empresa'];
      }
    }
    return null;  // Caso o usuário não esteja logado ou não encontrar o tipo de empresa
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

  Future<void> verificaTrial(context)async{
    await initializeDateFormatting('pt_BR', null);
    await  FirebaseAuth.instance.authStateChanges().listen((User? user) async {

      if (user != null) {

        var snapshot = await  FirebaseFirestore.instance
            .collection('usuario')
            .doc(user!.email)
            .get();

        if (snapshot.exists) {
          var data = snapshot.data(); // Acessa o Map dos dados
        //  print(data?['chave_ativacao']); // Exibe todos os dados
          var codigo_ativacao =data?['chave_ativacao'];
          if(codigo_ativacao =="") {
            String dataCriacaoStr = data?['data_criacao'];
            DateTime dataCriacao = DateFormat('yyyy-MM-dd HH:mm:ss', 'pt_BR')
                .parse(dataCriacaoStr);
            DateTime dataAtual = DateTime.now();
            int diferencaDias = dataAtual
                .difference(dataCriacao)
                .inDays;
            if (diferencaDias > 7) {
              route.pushPage(context,  AtivacaoLicenca());
            } else {
             // route.pushPage(context,  AtivacaoLicenca());
            //  route.pushPage(context, const Login());
            }
          }
        }
      }
    });
  }



  Future<void> atualizaChaveAtivacao(context, String codigoAtivacao) async {
    await initializeDateFormatting('pt_BR', null);
    print(codigoAtivacao);

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        // Referência ao documento do usuário autenticado
        var docRef = FirebaseFirestore.instance.collection('usuario').doc(user.email);
        var snapshot = await docRef.get();
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('licenses')
            .where('code', isEqualTo: codigoAtivacao)
            .where('status', isEqualTo: 'disponível')
            .get();

        if (querySnapshot.docs.isEmpty) {
          if (snapshot.exists) {
            await docRef.update({'chave_ativacao': codigoAtivacao});
            print("Chave de ativação atualizada com sucesso.");

            for (QueryDocumentSnapshot doc in querySnapshot.docs) {
              await doc.reference.update({
                'email_ativacao': user.email,  // Atualiza com o e-mail do usuário autenticado
                'status': 'ativado',           // Define o novo status
              });
            }
            route.pushPage(context, novaHome());
          } else {
            print("Documento do usuário não encontrado.");
          }
        } else {
          print("Não foram encontradas licenças disponíveis para o código de ativação fornecido.");
        }
      } else {
        print("Usuário não autenticado.");
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
