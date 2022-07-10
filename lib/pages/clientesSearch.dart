import 'package:appgestao/blocs/usuario_bloc.dart';
import 'package:appgestao/classes/firebase/datamodel.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class clientesSearch extends StatefulWidget {
  const clientesSearch({Key? key}) : super(key: key);

  @override
  State<clientesSearch> createState() => _clientesSearchState();
}

class _clientesSearchState extends State<clientesSearch> {
  late UsuarioBloc _ususarioBloc;

  //final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('usuario').snapshots();

  @override
  void initState() {
    _ususarioBloc = UsuarioBloc();
    super.initState();
  }

  var header = new HeaderAppBar();

  var textSearch = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header.getAppBar('Clientes'),
      drawer: Menu(),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 1.0),
                    ),
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(Icons.password, color: Colors.transparent),
                    suffixIcon:
                        Icon(Icons.search_rounded, color: Colors.orange),
                    hintText: 'Digite o nome do cliente para filtrar',
                  ),
                  onChanged: (text) {
                    _ususarioBloc.onCheangedSearch(text);
                  },
                ),
                Expanded(
                  child: StreamBuilder<List>(
                    stream: _ususarioBloc.outUsuarios,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      //   print('snapshot.data');
                     // print(snapshot.data);
                      //   print(snapshot.data!.length);
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Algo deu errado, tente mais tarde.'));
                      }
                      /*
            if(snapshot.data!.length == 0){
                return  const Center(child:  Text('Algo deu errado, tente mais tarde.'));
            }*/
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.amber),
                          ),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.amber),
                          ),
                        );
                      }
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('Nenhum usuário encontrado'));
                      }

                      return ListView.separated(
                          itemBuilder: (context, index) {
                            String nome =
                                snapshot.data[index]['nome'].toString();
                            String email =
                                snapshot.data[index]['email'].toString();
                            String tel =
                                snapshot.data[index]['telefone'].toString();
                            bool status = snapshot.data[index]['status'];
                            return Card(
                              elevation: 1,
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ListTile(
                                      title: Text(nome),
                                      subtitle: Text(" $email  -  $tel "),
                                      trailing: status
                                          ? const Icon(Icons.check,
                                              color: Colors.green)
                                          : const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                      onTap: () {
                                        FirebaseFirestore.instance
                                            .collection("usuario")
                                            .doc(email)
                                            .update({'status': !status});
                                      }),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 0.0);
                          },
                          itemCount: snapshot.data!.length);
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
