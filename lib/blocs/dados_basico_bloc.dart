import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import 'package:bloc_pattern/bloc_pattern.dart';

class DadosBasicosBloc extends BlocBase {
  var bd = DadosBasicosSqlite();
  final _mesController = BehaviorSubject();
  final _nomeController = BehaviorSubject();
  final _fulanoController = BehaviorSubject();

  Stream get mesOutUsuario => _mesController.stream;
  Stream get nomeOutUsuario => _nomeController.stream;
  Stream get fulanoController => _fulanoController.stream;

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
      var email = user!.email;
      if (user == null) {
      } else {
        FirebaseFirestore.instance
            .collection('usuario')
            .doc(email)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            Map<String, dynamic> data =  documentSnapshot.data()! as Map<String, dynamic>;
            final hora = DateTime.now().hour;
            _fulanoController.add(data['nome']);
            if (hora.toInt() < 13 && hora.toInt()>6) {
              // bom dia
              var userMsg = "Bom dia ${data['nome']}";
              _nomeController.add(userMsg);
              _fulanoController.add(data['nome']);
            } else if (hora.toInt() > 13 &&  hora.toInt() < 18) {
              // boa tarde
              var userMsg = "Boa tarde ${data['nome']}";
              _nomeController.add(userMsg);
              _fulanoController.add(data['nome']);
            } else if (hora.toInt() > 17 ) {
              //boa noite
              var userMsg = "Boa Noite ${data['nome']}";
              _nomeController.add(userMsg);
              _fulanoController.add(data['nome']);
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
