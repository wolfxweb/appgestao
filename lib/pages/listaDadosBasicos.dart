import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:appgestao/componete/alertamodal.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
//import 'package:appgestao/pages/dadosbasicos.dart';
import 'package:appgestao/pages/gestaoPrioridades.dart';
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
  var alerta = AlertModal();
  late Future<List<dynamic>> dadosDoBancoDeDados;
  void _consultar() async {
    dadosDoBancoDeDados = bd.listaTodos();
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
          'Dados Básicos Histórico',
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
            print(snapshot.data!);
            List<dynamic> dadosDoBancoDeDados = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Padding(
                  padding: EdgeInsets.all(12.0), // Adiciona padding de 8.0 em todas as direções
                  child: IconButton(
                    iconSize: 35,
                    icon:  Icon(
                      Icons.lightbulb,
                      //color: Color.fromRGBO(1, 57, 44, 1),
                      color: Colors.amberAccent,
                    ), onPressed: () {
                      var textoAjudaHistorico ="Ao pressionar a seta (alto à esquerda) você retorna para a tela de Dados básicos.\nPressionando a lupa (alto à direita) e digitar o mês desejado, será exibido o que foi registrado naquele mês.\nPressionando 'REMOVER' você deleta (apaga) os Dados básicos que tiver selecionado.\nPressionando 'REUTILIZAR' você envia para a tela principal os dados. Importante: para que o aplicativo considere estes dados, é importante que na tela principal você pressione 'ATUALIZAR'. ";
                     alerta.openModal(context, textoAjudaHistorico);
                  },

                  ),
                ),
               const SizedBox(height: 8.0), // Adiciona um espaço entre os textos
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
     route.pushPage(context, NovoDadosBasicos());
     // route.pushPage(context, GestaoPrioridade());
    _consultar();
   // Navigator.pop(context);
    setState(() {});
  }
  Widget buildCard(Map<String, dynamic> dado) {
    String dateTimeString = dado['data_cadastro'];
    List<String> parts = dateTimeString.split('T');
    String datePart = parts[0];
    String timePart = parts[1];
    List<String> partsData = datePart.split('-');
    String ano = partsData[0];
    String mes_data = partsData[1];
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
    String mes = dado['mes'];
    String tipo_empresa = dado['tipo_empresa'];
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            buildRow("Mês:", mes),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Data: $dia/$mes_data/$ano'),
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
            tipo_empresa == 'Serviços'?buildRow("Demais custos fixos:", custo_varivel):buildRow("Custo fixo:", custo_varivel),
            const SizedBox(height: 8.0),
            buildRow("Margem ideal:", "$margen%"),
            const SizedBox(height: 8.0),
            tipo_empresa ==  'Serviços'? buildRow("Horas de trabalho em uma semana:", capacidade_atendimento): buildRow("Capacidade de atendimento:", capacidade_atendimento),
            const SizedBox(height: 8.0),
            buildRow("Dados basico atual:", dados_basicos_atual),
            const SizedBox(height: 8.0),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            //   IconButton(
            //   iconSize: 35,
            //   icon:const Icon(
            //     Icons.help,
            //     color: Color.fromRGBO(1, 57, 44, 1),
            //   ),
            //   onPressed: () {
            //     var msgAlertaMes ="Botão remover ira excluir a informação do banco de dados.\nBotão reutilizar alterar o  bados baícos se o atual.";
            //     alerta.openModal(context, msgAlertaMes);
            //   },
            // ),
                ElevatedButton(
                  onPressed: () {
                    _delete(dado['id']);
                  },
               //  style: colorButtonStyle(),
                  child: const Text('X',  style: TextStyle(
                    color: Colors.red,

                    // backgroundColor: Colors.white,
                  ),),
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
  String get searchFieldLabel => 'Digite o mês desejado. ';
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
      String dataCadastro = element['mes'];
      // Convertendo ambos os textos para minúsculas
      return dataCadastro.toLowerCase().contains(query.toLowerCase());
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
    Navigator.pop(context);
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
    String mes_ref = dado['mes'];
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            buildRow("Mês:", mes_ref),
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
                 // style: colorButtonStyle(),
                  child: const Text('X',  style: TextStyle(
                    color: Colors.red,
                 //   fontSize: 13,
                    // backgroundColor: Colors.white,
                  ),),
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

