import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerador de Licenças',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
      ),
      home: LicenseScreen(),
    );
  }
}

class LicenseScreen extends StatefulWidget {
  @override
  _LicenseScreenState createState() => _LicenseScreenState();
}

class _LicenseScreenState extends State<LicenseScreen> {
  final _quantityController = TextEditingController();
  String _statusFilter = 'todos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerador de Licenças', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromRGBO(1, 57, 44, 1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Quantidade de licenças"),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: buildInputDecoration(context,"sda", "sda", const Color.fromRGBO(245, 245, 245, 1)),
                      controller: _quantityController,
                      textAlign: TextAlign.start,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 8),
                    buildButton(context,'Gerar Licenças'),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<String>(
                        value: _statusFilter,
                        items: const [
                          DropdownMenuItem(value: 'todos', child: Text('Todos')),
                          DropdownMenuItem(value: 'disponível', child: Text('Disponível')),
                          DropdownMenuItem(value: 'ativada', child: Text('Ativada')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _statusFilter = value!;
                          });
                        },
                        isExpanded: true,
                      ),
                      Expanded(
                        child: _buildLicenseList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  SizedBox buildButton(BuildContext context,text) {
    var color =  Color.fromRGBO(1, 57,44,1);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: ElevatedButton(
        style: colorButtonStyle(color),
        onPressed:_generateLicenses,
        child:  Text(text,
            style: TextStyle(color: Colors.white)),
      ),
    );
  }
  ButtonStyle colorButtonStyle(color) {
    return ButtonStyle(
      // primary: color, // Cor de fundo do botão
      backgroundColor:MaterialStateProperty.all<Color>(color),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    );
  }
  Future<void> _generateLicenses() async {
    final quantity = int.tryParse(_quantityController.text) ?? 0;

    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantidade inválida')),
      );
      return;
    }

    final db = FirebaseFirestore.instance;
    final generatedLicenses = <String>{};

    for (int i = 0; i < quantity; i++) {
      String code;
      do {
        code = _generateUniqueCode();
      } while (generatedLicenses.contains(code));

      generatedLicenses.add(code);

      await db.collection('licenses').add({
        'code': code,
        'status': 'disponível',
        'email_ativacao':'',
      });
    }

    _quantityController.clear();
    setState(() {});
  }
  InputDecoration buildInputDecoration(BuildContext context, text, titulo,corFundo ) {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding:    const EdgeInsets.symmetric(horizontal: 5, vertical:0),
      fillColor:  corFundo,filled: true,
     // enabled: false,
      // filled: true,
      focusedBorder:  const OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide:    BorderSide(color: Color.fromRGBO(1, 57, 44, 1), width: 1.0),
      ),
      border:  const OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide:  BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
      ),

      // hintText: 'Quantidade de clientes atendidos',
    );
  }
  String _generateUniqueCode() {
    final random = (100000 + (900000 * Random().nextDouble())).toInt();
    return random.toString().padLeft(6, '0');
  }

  Widget _buildLicenseList() {
    final db = FirebaseFirestore.instance;
    Query query = db.collection('licenses');

    if (_statusFilter != 'todos') {
      query = query.where('status', isEqualTo: _statusFilter);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final licenses = snapshot.data!.docs;

        return ListView.builder(
          itemCount: licenses.length,
          itemBuilder: (context, index) {
            final data = licenses[index].data() as Map<String, dynamic>;
            final code = data['code'];
            final status = data['status'];
            final email_ativacao = data['email_ativacao'];
            return ListTile(
              title: Text(code),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status: $status'),
                  if (email_ativacao != null && email_ativacao.isNotEmpty)
                    Text('Email de Ativação: $email_ativacao'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
