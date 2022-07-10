import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class UsuarioBloc extends BlocBase {
  final _usersController = BehaviorSubject<List>();
  final _IsAdmiController = BehaviorSubject();
  Map<dynamic, dynamic> _users = {};

  Stream<List> get outUsuarios => _usersController.stream;
  Stream get outIsAdminUsuario => _IsAdmiController.stream;

  UsuarioBloc() {
    _addUsuarioListner();
    _isUserAdminListner();
  }

  void _addUsuarioListner() {
    //verifica se tem mudança no documento
    FirebaseFirestore.instance
        .collection('usuario')
        .snapshots()
        .listen((response) {
      response.docs.forEach((element) {
        _users.addAll({element.id: element.data()});
        _usersController.add(_users.values.toList());
      });
    });
  }

  void onCheangedSearch(String search) {
    _users.clear();
    FirebaseFirestore.instance
        .collection('usuario')
        .snapshots()
        .forEach((element) {
      element.docs.forEach((element) {
        if (element.data()['nome'].contains(search)) {
          _users.addAll({element.id: element.data()});
          _usersController.add(_users.values.toList());
        }
      });
    });
  }

  _isUserAdminListner() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _IsAdmiController.add("ir login");
      } else {
        FirebaseFirestore.instance
            .collection('usuario')
            .doc(user.email)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            Map<String, dynamic> data =
                documentSnapshot.data()! as Map<String, dynamic>;
            if (data['status']) {
              if (data['admin']) {
                _IsAdmiController.add("admin");
              } else {
                _IsAdmiController.add("usuario");
              }
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _usersController.close();
    _IsAdmiController.close();
  }
}
