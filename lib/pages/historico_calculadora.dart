import 'package:appgestao/blocs/calculadora_bloc.dart';
import 'package:appgestao/classes/firebase/verificastatus.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/pages/calculadora.dart';
import 'package:flutter/material.dart';

class HistoricoCalculadora extends StatefulWidget {
  @override
  _HistoricoCalculadoraState createState() => _HistoricoCalculadoraState();
}

class _HistoricoCalculadoraState extends State<HistoricoCalculadora> {
  List historico = [];
  var calBloc;
  void initState() {
    calBloc = CalculadoraBloc();
    _loadHistorico();
    var users = VerificaStatusFairebase();
    users.verificaTrial(context);
  }
  Future<void> _loadHistorico() async {
    var dados = await calBloc.selectHistorico();
    setState(() {
      historico = dados;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => Calculadora()),
            );
          },
        ),
        title: const Center(
          child: Text(
            'Histórico Calculadora',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Ação ao clicar na lupa
            },
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.75,
          child: listProdutos(context),
        ),
      ),
    );

  }
  listProdutos(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: historico.length,
            itemBuilder: (BuildContext context, int index) {
              return  buildContainer(index, historico);
            }));
  }
  Container buildContainer(int index, historico) {
    var produto = historico[index]['produto'].toString();
    var data = historico[index]['data'].toString();
    var preco_atual = historico[index]['preco_atual'].toString();
    var preco_sugerido = historico[index]['preco_sugerido'].toString();
    var margem_desejada = historico[index]['margem_desejada'].toString();
    var margem_atual = historico[index]['margem_atual'].toString();

    var id = historico[index]['id'];

    return Container(
      // height: 250,
      // color: Colors.amber,
      // child: Center(child: Text(historico[index]['produto'].toString())),
      child: Card(
        elevation: 2,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
                title: Text("Produto: $produto"),
                subtitle: Text("Data: $data"),
                trailing: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                onTap: () {
                  confrimModal(context, id, index);
                }),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Preco Atual R\$: $preco_atual"),
                  buildSizedBox(),
                  Text("Margem Atual: $margem_atual "),
                  buildSizedBox(),
                  Text("Preço Sugerido R\$: $preco_sugerido"),
                  buildSizedBox(),
                  Text("Margem Desejada: $margem_desejada "),
                ],
              ),
            ),
            const Espacamento(),
          ],
        ),
      ),
    );
  }

  SizedBox buildSizedBox() {
    return const SizedBox(
      height: 4.0,
    );
  }
  confrimModal(context, id, index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Deseja mesmo excluir, esta ação é ireversivel.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
              softWrap: true,
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Cancelar",
                  style: TextStyle(color: Color.fromRGBO(1, 57, 44, 1)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text(
                  "Excluir",
                  style: TextStyle(color: Color.fromRGBO(1, 57, 44, 1)),
                ),
                onPressed: () {
                  calBloc.excluirHistorico(id).then((value) {
                    var alert = AlertSnackBar();
                    // historico.clear();
                    alert.alertSnackBar(context, Colors.green,
                        'Exclusão realizada com sucesso');
                    //  calBloc.selectHistorico();
                    setState(() {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => HistoricoCalculadora()),
                      );
                      //  _verHistorico = !_verHistorico;
                    // _pesquisaController.text = "";
                    //   historico.clear();
                      _loadHistorico();
                       historico = calBloc.selectHistorico();
                    });
                  });

                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
