import 'package:appgestao/blocs/calculadora_bloc.dart';
import 'package:appgestao/classes/firebase/verificastatus.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/pages/calculadora.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class HistoricoCalculadora extends StatefulWidget {
  @override
  _HistoricoCalculadoraState createState() => _HistoricoCalculadoraState();
}

class _HistoricoCalculadoraState extends State<HistoricoCalculadora> {
  List historico = [];
  List historicoFiltrado = [];
  var calBloc;
  TextEditingController _pesquisaController = TextEditingController();
  bool isSearching = false; // Controla se está em modo de pesquisa

  @override
  void initState() {
    super.initState();
    calBloc = CalculadoraBloc();
    _loadHistorico();
    _pesquisaController.addListener(_filtrarHistorico);
  }

  Future<void> _loadHistorico() async {
    var dados = await calBloc.selectHistorico();
    setState(() {
      historico = dados;
      historicoFiltrado = dados;
    });
  }

  void _filtrarHistorico() {
    String query = _pesquisaController.text.toLowerCase();

    setState(() {
      historicoFiltrado = historico.where((item) {
        var nomeProduto = item['produto'].toString().toLowerCase();
        return nomeProduto.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isSearching ? Colors.white : const Color.fromRGBO(1, 57, 44, 1),
        iconTheme: IconThemeData(
          color: isSearching ? Colors.black : Colors.white,
        ),
        leading: !isSearching
            ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => Calculadora()),
            );
          },
        )
            : null,
        title: !isSearching
            ? const Center(
          child: Text(
            'Histórico Calculadora',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
            : null,
        actions: [

          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              },
            ),
          if (isSearching)
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: TextField(
                controller: _pesquisaController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Digite o nome do produto',
                  border: InputBorder.none,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: listProdutos(context),
          ),
        ],
      ),
    );
  }

  listProdutos(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: historicoFiltrado.length,
      itemBuilder: (BuildContext context, int index) {
        return buildContainer(index, historicoFiltrado);
      },
    );
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
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
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
                    alert.alertSnackBar(context, Colors.green, 'Exclusão realizada com sucesso');
                    historico.clear();
                    _loadHistorico();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) =>  HistoricoCalculadora()),
                    );
                  });
                },
              )
            ],
          );
        });
  }
}


