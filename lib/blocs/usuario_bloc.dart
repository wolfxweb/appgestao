import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import 'dart:async';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

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
  Future<void> openURL()async{
    final Uri _url = Uri.parse('https://wolfx.com.br/');
    if( await canLaunchUrl(_url)){
      if (await launchUrl(_url,mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $_url';
      }
    }
  }

  @override
  void dispose() {
    _usersController.close();
    _IsAdmiController.close();
  }
}
