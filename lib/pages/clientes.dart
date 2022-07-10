

import 'package:appgestao/componete/btnCadastrese.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Clientes extends StatefulWidget {
 const  Clientes({Key? key}) : super(key: key);

  @override
  State<Clientes> createState() => _ClientesState();
}

class _ClientesState extends State<Clientes> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('usuario').snapshots();


  var header = new HeaderAppBar();

var textSearch ='';

  Map<String, dynamic> datas ={};
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:header.getAppBar('Clientes'),
      drawer: Menu(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:  StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Algo deu errado, tente mais tarde.');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Carregando...");
          }

         return  SizedBox(
           child: Column(
             children: [

               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Column(
                   children: [
                     TextField(
                       keyboardType: TextInputType.text,
                       decoration: const InputDecoration(
                         focusedBorder: UnderlineInputBorder(
                           borderSide:
                           BorderSide(color: Colors.orange, width: 1.0),
                         ),
                         border: UnderlineInputBorder(),
                         prefixIcon: Icon(Icons.password, color: Colors.transparent),
                         suffixIcon: Icon(Icons.search_rounded,color: Colors.orange),
                         hintText: 'Digite o nome do cliente para filtrar',

                       ),
                       onChanged: (text) {
                         print('First text field: $text');
                         setState(() {
                           textSearch = text;
                         });
                       },
                     ),
                     Column(
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          datas = document.data()! as Map<String, dynamic>;
                          print(textSearch);

                          Map<String, dynamic> data = datas;

                          if(!textSearch.isEmpty){
                            _filter(textSearch);
                          }
                          var email = data['email'];
                          var tel = data['telefone'];
                          return Card(
                            elevation: 1,
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ListTile(
                                  title: Text( data['nome']),
                                  subtitle: Text(" $email  -  $tel "),
                                  trailing: data['status']?const Icon(Icons.check,color: Colors.green):const Icon(Icons.close,color: Colors.red,),
                                  onTap: () {
                                    FirebaseFirestore.instance.collection("usuario").doc(data['email']??"").update({'status':!data['status']});
                                  }
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                   ],
                 ),
               ),
             ],
           ),
         );
        },
        ),
      ),
    );
  }
  _filter(text){
    print(text);

  }
}
