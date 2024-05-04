import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
import 'package:appgestao/pages/dadosbasicos.dart';
import 'package:appgestao/pages/novodadosbasicos.dart';
import 'package:flutter/material.dart';
import 'package:appgestao/classes/dadosbasicossqlite.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ListaDadosBasicos extends StatefulWidget {
  const ListaDadosBasicos({Key? key}) : super(key: key);

  @override
  _ListaDadosBasicosState createState() => _ListaDadosBasicosState();
}

class _ListaDadosBasicosState extends State<ListaDadosBasicos> {
  var route = PushPage();
  var bd = DadosBasicosSqlite();

  late Future<List<dynamic>> dadosDoBancoDeDados;
  void _consultar() async {
    dadosDoBancoDeDados = bd.lista();
    // //  var lista = extrairDadosBasicos(dados);
     print('dadosDoBancoDeDados');
     print(dadosDoBancoDeDados);
  }
  @override
  String get searchFieldLabel => 'Pesquisar';

  @override
  void initState() {
    super.initState();
    _consultar();
    initializeDateFormatting('pt_BR', null);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      //  title: Text('Histórico de Dados Básicos',),
        title: const Text(
          'Histórico de Dados Básicos',
          style: TextStyle(color: Colors.white), // Altera a cor do texto para branco
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final List<Map<String, dynamic>> dados = await dadosDoBancoDeDados.then((value) {
                return value.cast<Map<String, dynamic>>();
              });
              showSearch(
                context: context,
                delegate: DataSearch(dados: dados , context: context),
              );
            },
            icon: Icon(Icons.search),
            tooltip: 'Pesquisar',
          ),

        ],
        backgroundColor:const Color.fromRGBO(1, 57, 44, 1), // Altera a cor de fundo da AppBar
        iconTheme: const IconThemeData(color: Colors.white), // Altera a cor do ícone (seta) para branco
      ),
      body: FutureBuilder<List<dynamic>>(
        future: dadosDoBancoDeDados,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum dado encontrado.'));
          } else {
            List<dynamic> dadosDoBancoDeDados = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0), // Adiciona padding de 8.0 em todas as direções
                  child: Text(
                    'Para filtrar clique na lupa e digite a hora que deseja filtrar.',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8.0), // Adiciona um espaço entre os textos
                Expanded(
                  child: ListView.builder(
                    itemCount: dadosDoBancoDeDados.length,
                    itemBuilder: (context, index) {
                      var dado = dadosDoBancoDeDados[index];
                      return buildCard(dado);
                    },
                  ),
                ),
              ],
            );

            // return ListView.builder(
            //   itemCount: dadosDoBancoDeDados.length,
            //   itemBuilder: (context, index) {
            //     var dado = dadosDoBancoDeDados[index];
            //     return buildCard(dado);
            //   },
            // );
          }
        },
      ),
    );
  }

  Row buildRow(String titulo1 ,String valor1) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$titulo1'),
        SizedBox(width: 8.0), // Adicione um espaço entre os elementos
        Text('$valor1'),
      ],
    );
  }
  _delete(id)async{
    var alert = AlertSnackBar();
    await bd.deleteDadosBasicos(id);
    await bd.deleteDadosBasicos(id);
    alert.alertSnackBar(context, Colors.green, "Excluído com sucesso");
    //route.pushPage(context, NovoDadosBasicos());
    _consultar();
    setState(() {});
  }
  _reutilizar(id)async{
    var alert = AlertSnackBar();
    await bd.reutilizar(id);
     await bd.reutilizar(id);
     alert.alertSnackBar(context, Colors.green, "Atualizado com sucesso.");
    // route.pushPage(context, NovoDadosBasicos());
     _consultar();
    setState(() {});
  }
  Widget buildCard(Map<String, dynamic> dado) {
    String dateTimeString = dado['data_cadastro'];
    List<String> parts = dateTimeString.split('T');
    String datePart = parts[0];
    String timePart = parts[1];
    List<String> partsData = datePart.split('-');
    String ano = partsData[0];
    String mes = partsData[1];
    String dia = partsData[2];
    List<String> timeParts = timePart.split('.');
    String hora = timeParts[0];
    String faturamento = dado['faturamento'];
    String custo_fixo = dado['custo_fixo'];
    String gastos_insumos = dado['gastos_insumos'];
    String custo_varivel = dado['custo_varivel'];
    String margen = dado['margen'];
    String capacidade_atendimento = dado['capacidade_atendimento'];
    String quantidade_clientes_atendido = dado['qtd'];
    String dados_basicos_atual = dado['dados_basicos_atual'] == 'S' ? "Sim" : "Não";

    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Data: $dia/$mes/$ano'),
                SizedBox(width: 8.0),
                Text('Hora: $hora'),
              ],
            ),
            const SizedBox(height: 8.0),
            buildRow("Quantidade clientes atendidos:", quantidade_clientes_atendido),
            const SizedBox(height: 8.0),
            buildRow("Faturamento com vendas:", faturamento),
            const SizedBox(height: 8.0),
            buildRow("Gastos com vendas:", gastos_insumos),
            const SizedBox(height: 8.0),
            buildRow("Gastos com insumos e produtos de 3º:", custo_fixo),
            const SizedBox(height: 8.0),
            buildRow("Custo fixo:", custo_varivel),
            const SizedBox(height: 8.0),
            buildRow("Margem ideal:", "$margen%"),
            const SizedBox(height: 8.0),
            buildRow("Capacidade de atendimento:", capacidade_atendimento),
            const SizedBox(height: 8.0),
            buildRow("Dados basico atual:", dados_basicos_atual),
            const SizedBox(height: 8.0),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _delete(dado['id']);
                  },
                 style: colorButtonStyle(),
                  child: const Text('Remover'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _reutilizar(dado['id']);
                  },
                  style: colorButtonStyle(),
                  child: const Text('Reutilizar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  ButtonStyle colorButtonStyle() {
    return ButtonStyle(
      // primary: color, // Cor de fundo do botão
      backgroundColor:MaterialStateProperty.all<Color>(const Color.fromRGBO(1, 57, 44, 1)),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    );
  }
}
class DataSearch extends SearchDelegate<String> {
  final List<Map<String, dynamic>> dados;
  final BuildContext context; // Adicionando o contexto


  var route = PushPage();
  var bd = DadosBasicosSqlite();
 // DataSearch({required this.dados});
  DataSearch({required this.dados, required this.context});
  @override
  String get searchFieldLabel => 'Pesquisar digite a hora ';
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = dados.where((element) {
      String dataCadastro = element['data_cadastro'];
      String dia = dataCadastro.split('T')[0].split('-').reversed.join('/');
      return dataCadastro.contains(query) || dia.contains(query);
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        var dado = results[index];
        // Aqui você pode construir o widget para exibir os resultados da pesquisa
        return ListTile(
          title: Text("ss $dado['data_cadastro']"),
          // Adicione aqui os outros campos que deseja exibir
          onTap: () {
            close(context, dado['data_cadastro']);
          },
        );
      },
    );
  }
  ButtonStyle colorButtonStyle() {
    return ButtonStyle(
      // primary: color, // Cor de fundo do botão
      backgroundColor:MaterialStateProperty.all<Color>(const Color.fromRGBO(1, 57, 44, 1)),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? dados
        : dados.where((element) {
      String dataCadastro = element['data_cadastro'];
      String dia = dataCadastro.split('T')[0].split('-').reversed.join('/');
      return dataCadastro.contains(query) || dia.contains(query);
    }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        var dado = suggestionList[index];
        print(dado['faturamento']);
        // Aqui você pode construir o widget para exibir as sugestões da pesquisa
        return buildCard(dado);
      },
    );
  }
  _delete(id)async{
    var alert = AlertSnackBar();
    await bd.deleteDadosBasicos(id);
    await bd.deleteDadosBasicos(id);
    alert.alertSnackBar(context, Colors.green, "Excluído com sucesso");
    route.pushPage(context, NovoDadosBasicos());
   // _consultar();
  }
  _reutilizar(id)async{
    var alert = AlertSnackBar();
    await bd.reutilizar(id);
    await bd.reutilizar(id);
    alert.alertSnackBar(context, Colors.green, "Atualizado com sucesso.");
    route.pushPage(context, NovoDadosBasicos());
    //_consultar();
  }
  Row buildRow(String titulo1 ,String valor1) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$titulo1'),
        SizedBox(width: 8.0), // Adicione um espaço entre os elementos
        Text('$valor1'),
      ],
    );
  }
  Widget buildCard(Map<String, dynamic> dado) {
    String dateTimeString = dado['data_cadastro'];
    List<String> parts = dateTimeString.split('T');
    String datePart = parts[0];
    String timePart = parts[1];
    List<String> partsData = datePart.split('-');
    String ano = partsData[0];
    String mes = partsData[1];
    String dia = partsData[2];
    List<String> timeParts = timePart.split('.');
    String hora = timeParts[0];
    String faturamento = dado['faturamento'];
    String custo_fixo = dado['custo_fixo'];
    String gastos_insumos = dado['gastos_insumos'];
    String custo_varivel = dado['custo_varivel'];
    String margen = dado['margen'];
    String capacidade_atendimento = dado['capacidade_atendimento'];
    String quantidade_clientes_atendido = dado['qtd'];
    String dados_basicos_atual = dado['dados_basicos_atual'] == 'S' ? "Sim" : "Não";

    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Data: $dia/$mes/$ano'),
                SizedBox(width: 8.0),
                Text('Hora: $hora'),
              ],
            ),
            const SizedBox(height: 8.0),
            buildRow("Quantidade clientes atendidos:", quantidade_clientes_atendido),
            const SizedBox(height: 8.0),
            buildRow("Faturamento com vendas:", faturamento),
            const SizedBox(height: 8.0),
            buildRow("Gastos com vendas:", gastos_insumos),
            const SizedBox(height: 8.0),
            buildRow("Gastos com insumos e produtos de 3º:", custo_fixo),
            const SizedBox(height: 8.0),
            buildRow("Custo fixo:", custo_varivel),
            const SizedBox(height: 8.0),
            buildRow("Margem ideal:", "$margen%"),
            const SizedBox(height: 8.0),
            buildRow("Capacidade de atendimento:", capacidade_atendimento),
            const SizedBox(height: 8.0),
            buildRow("Dados basico atual:", dados_basicos_atual),
            const SizedBox(height: 8.0),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _delete(dado['id']);
                  },
                  style: colorButtonStyle(),
                  child: const Text('Remover'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _reutilizar(dado['id']);
                  },
                  style: colorButtonStyle(),
                  child: const Text('Reutilizar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

