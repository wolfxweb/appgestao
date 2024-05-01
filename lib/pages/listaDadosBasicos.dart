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
    //  var lista = extrairDadosBasicos(dados);
    print('dadosDoBancoDeDados');
    print(dadosDoBancoDeDados);
  }

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
        title: const Text('Histórico de Dados Básicos'),
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
            return ListView.builder(
              itemCount: dadosDoBancoDeDados.length,
              itemBuilder: (context, index) {
                var dado = dadosDoBancoDeDados[index];
                print(dado);
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
                String quantidade_clientes_atendido =dado['qtd'];
                String dados_basicos_atual = dado['dados_basicos_atual']=='S'?"Sim":"Não";
                var pad = 10;
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       // Text('Data: $dia/$mes/$ano  - Hora: $hora'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Data: $dia/$mes/$ano'),
                          SizedBox(width: 8.0), // Adicione um espaço entre os elementos
                          Text('Hora: $hora'),
                          ],
                         ),
                        const SizedBox(height: 8.0),
                        buildRow("Quantidade clientes atendidos:",quantidade_clientes_atendido),
                        const SizedBox(height: 8.0),
                        buildRow("Faturamento com vendas:",faturamento),
                        const SizedBox(height: 8.0),
                        buildRow("Gastos com vendas:",gastos_insumos),
                        const SizedBox(height: 8.0),
                        buildRow("Gastos com insumos e produtos de 3º:",custo_fixo),
                        const SizedBox(height: 8.0),
                        buildRow("Custo fixo:",custo_varivel),
                        const SizedBox(height: 8.0),
                        buildRow("Margem ideal:","$margen%"),
                        const SizedBox(height: 8.0),
                        buildRow("Capacidade de atendimento:",capacidade_atendimento),
                        const SizedBox(height: 8.0),
                        buildRow("Dados basico atual:",dados_basicos_atual),
                        const SizedBox(height: 8.0),
                        const SizedBox(height: 8.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _delete(dado['id']);

                            },
                            child: const Text('Remover'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _reutilizar(dado['id']);
                            },
                            child: const Text('Reutilizar'),
                          ),
                        ],
                      ),
                      ],
                    ),
                  ),
                );
              },
            );
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
    route.pushPage(context, NovoDadosBasicos());
    _consultar();
  }
  _reutilizar(id)async{
    var alert = AlertSnackBar();
    await bd.reutilizar(id);
     await bd.reutilizar(id);
     alert.alertSnackBar(context, Colors.green, "Atualizado com sucesso.");
     route.pushPage(context, NovoDadosBasicos());
     _consultar();
  }
}
