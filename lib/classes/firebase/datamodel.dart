import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  final String? nome;
  final String? telefone;
  final String? email;
  final String? status;

  DataModel({this.nome, this.telefone, this.email, this.status});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold

  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =  snapshot.data() as Map<String, dynamic>;
      return DataModel(
          nome: dataMap['nome'],
          telefone: dataMap['telefone'],
          email: dataMap['email'],
          status: dataMap['status']);
     }).toList();
  }
}