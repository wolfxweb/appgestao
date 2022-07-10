import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UsuarioBloc extends BlocBase {

  final   _usersController = BehaviorSubject<List>();

  Map<dynamic, dynamic> _users = {};

  Stream<List> get outUsuarios=> _usersController.stream;

  UsuarioBloc() {
    _addUsuarioListner();
  }


  void _addUsuarioListner() {
    //verifica se tem mudança no documento
    FirebaseFirestore.instance.collection('usuario').snapshots().listen((response) {
      response.docs.forEach((element) {
        _users.addAll({element.id : element.data()});
        _usersController.add(_users.values.toList());
      });

    });
  }

  void onCheangedSearch(String search){
    _users.clear();
    FirebaseFirestore.instance.collection('usuario').snapshots().forEach((element) {
      element.docs.forEach((element) {
        if(element.data()['nome'].contains(search)){
          print(element.data());
          _users.addAll({element.id : element.data()});
          _usersController.add(_users.values.toList());
        }
      });
    });
  }


  @override
  void dispose() {
    _usersController.close();
  }
}












