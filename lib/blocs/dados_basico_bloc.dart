import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import 'package:bloc_pattern/bloc_pattern.dart';

class DadosBasicosBloc extends BlocBase {
  var bd = DadosBasicosSqlite();
  final _mesController = BehaviorSubject();
  final _nomeController = BehaviorSubject();

  Stream get mesOutUsuario => _mesController.stream;
  Stream get nomeOutUsuario => _nomeController.stream;

  DadosBasicosBloc() {
    _getMes();
    _nomeUsuarioLogado();
  }
  _getMes() async {
    await bd.lista().then((data) {
      data.forEach((element) {
        _mesController.add(element['mes']);
      });
    });
  }
  setMesStream(mesSelecioado){
    _mesController.add(mesSelecioado);
  }

  _nomeUsuarioLogado() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
     // print(user!.email);
      var email = user!.email;
      if (user == null) {
        print('logado');
      } else {
        FirebaseFirestore.instance
            .collection('usuario')
            .doc(email)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
          //  print(documentSnapshot.data());
            Map<String, dynamic> data =
                documentSnapshot.data()! as Map<String, dynamic>;
            final hora = DateTime.now().hour;
            if (hora.toInt() < 13 && hora.toInt()>6) {
              // bom dia
              var userMsg = " Bom dia ${data['nome']}";
              _nomeController.add(userMsg);
            } else if (hora.toInt() > 13 &&  hora.toInt() < 20) {
              // boa tarde
              var userMsg = " Boa tarde ${data['nome']}";
              _nomeController.add(userMsg);
            } else if (hora.toInt() > 19 ) {
              //boa noite
              var userMsg = " Boa Noite ${data['nome']}";
              _nomeController.add(userMsg);
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
   _mesController.close();
   _nomeController.close();
  }
}
