import 'package:appgestao/classes/firebase/verificastatus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AtivacaoLicenca extends StatefulWidget {
  @override
  _AtivacaoLicencaState createState() => _AtivacaoLicencaState();
}

class _AtivacaoLicencaState extends State<AtivacaoLicenca> {
  final _licencaController = TextEditingController();
  String _mensagem = "";

  Future<void> _ativarLicenca() async {
    // Lógica de ativação
    if (_licencaController.text != "") {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('licenses')
          .where('code', isEqualTo: _licencaController.text)
          .where('status', isEqualTo: 'disponível')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var users = VerificaStatusFairebase();
        await users.atualizaChaveAtivacao(context, _licencaController.text);
        setState(() {
          _mensagem = "Licença ativada com sucesso!";
        });
      } else {
        setState(() {
          _mensagem = "Chave de ativação inválida.";
        });
      }
    } else {
      setState(() {
        _mensagem = "Chave de ativação inválida.";
      });
    }
  }

  @override
  void dispose() {
    _licencaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Insira a chave de ativação para continuar",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // TextField(
            //   controller: _licencaController,
            //   decoration: const InputDecoration(
            //     labelText: "Chave de Ativação",
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: _ativarLicenca,
            //   style: ButtonStyle(
            //     backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(1, 57, 44, 1)),
            //     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            //   ),
            //   child: const Text("Ativar Licença"),
            // ),
            // const SizedBox(height: 20),
            Text(
              _mensagem,
              style: TextStyle(
                fontSize: 16,
                color: _mensagem == "Licença ativada com sucesso!"
                    ? Colors.green
                    : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
