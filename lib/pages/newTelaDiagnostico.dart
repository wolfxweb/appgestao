import 'package:appgestao/blocs/diagnostico.dart';
import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
class NovaTelaDiagnostico extends StatefulWidget {
  @override
  _NovaTelaDiagnosticoState createState() => _NovaTelaDiagnosticoState();
}

class _NovaTelaDiagnosticoState extends State<NovaTelaDiagnostico> {

  var bd = DadosBasicosSqlite();
  var dignosticoBloc = DignosticoBloc();
  String mensagem1 ="Existem 4 maneiras de aumentar a margem: 1. Aumentando os preços (se não prejudicar a competitividade); 2. Vendendo mais (se houver demanda, capacidade de atendimento, se a margem de contribuição for positiva e se houver disponibilidade  de capital de giro); 3. Faturando mais com cada cliente; 4. reduzindo custos (sem prejudicar a qualidade da oferta e do atendimento).";
  String mensagem2 ="Para faturar mais com cada cliente é preciso ofertar itens complementares ao que estiver sendo vendido, e/ou estabelecer quantidades mínimas, e/ou criar 'combos promocionais', e/ou 'vantagens' para compras acima de..., etc. É importante saber oferecer e divulgar.";
  String mensagem3 ="Este é o valor que cada venda deixa para cobrir os custos fixos e gerar margem. Para que seja maior, é preciso aumentar o faturamento e/ou reduzindo os gastos com as vendas e, principalmente, com insumos e produtos de 3os. ";
  String mensagem4 ="Aqui, produtividade = faturamento dividido pelos custos fixos. Por tanto, para aumentar a produtividade, você precisa faturar mais sem aumentar o custo fixo, ou, manter o faturamento com custo fixo menor! Ou seja: capriche no layout e no planejamento das atividades (uso do tempo). Combata os desperdícios, retrabalhos e indisciplina. Elimine a ociosidade dos recursos disponíveis. Invista em motivação, competência e comprometimento! ";
  String mensagem5 ="Esta é a quantidade de atendimentos (vendas) e o faturamento que foi preciso alcançar para começar a ter lucro. Ele pode ser melhorado aumentando a margem de contribuição e/ou reduzindo os custos fixos.";
  String mensagem6 ="";

  final _faturamentoGraficoController = StreamController<double>();
  final _custoController = StreamController<double>();


  // Variável para armazenar o título do campo
  String tituloCampo = "Lucro";
  bool _showComponents = false;


  String calcularSituacaoFinanceira(double faturamento, double custoTotal) {
    if (faturamento > custoTotal) {
      return "LUCRO";
    } else if (faturamento == custoTotal) {
      return "MARGEM";
    } else {
      return "PREJUÍZO";
    }
  }

  Color calcularCor(double margem) {
    if (margem == 0) {
      return Colors.yellow;
    } else if (margem < 0) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  void adicionarFaturamento(double valor) {
    _faturamentoGraficoController.add(valor);
  }

  void adicionarCusto(double valor) {
    _custoController.add(valor);
  }
  void _consultar() async {
    await bd.getDadosBasicoAtual().then((data) {
      data.forEach((element) {
      //  print('element');
      //  print(element);
        var faturamento = (element['faturamento']
            .toString()
            .replaceAll("R\$", "")
            .replaceAll('.', '')
            .replaceAll(',', '.'));
        var custo_fixo = (element['custo_fixo']
            .toString()
            .replaceAll("R\$", "")
            .replaceAll('.', '')
            .replaceAll(',', '.'));
        var custo_varivel = (element['custo_varivel']
            .toString()
            .replaceAll("R\$", "")
            .replaceAll('.', '')
            .replaceAll(',', '.'));
        var gastos_insumos = (element['gastos_insumos']
            .toString()
            .replaceAll("R\$", "")
            .replaceAll('.', '')
            .replaceAll(',', '.'));
        var gastos = (element['gastos']
            .toString()
            .replaceAll("R\$", "")
            .replaceAll('.', '')
            .replaceAll(',', '.'));
        // var qtd = (element['qtd']
        //     .toString()
        //     .replaceAll("R\$", "")
        //     .replaceAll('.', '')
        //     .replaceAll(',', '.'));
        var totalCusto = double.parse(gastos)+double.parse(gastos_insumos)+double.parse(custo_varivel)+double.parse(custo_fixo);
        adicionarFaturamento(double.parse(faturamento));
        adicionarCusto(totalCusto);
       // tituloCampo ="Prejuíso";
        String situacaoFinanceira = calcularSituacaoFinanceira(double.parse(faturamento), totalCusto);
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            tituloCampo = situacaoFinanceira;
          });
        });
      });
    });

  }
  @override
  void initState() {
    super.initState();
  //  Future.delayed(Duration(seconds: 1), _consultar);
    Future.delayed(Duration(seconds: 1), () {
      _consultar();
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _showComponents = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Tela Diagnóstico',
          style: TextStyle(color: Colors.white), // Altera a cor do texto para branco
        ),
        backgroundColor:const Color.fromRGBO(1, 57, 44, 1), // Altera a cor de fundo da AppBar
        iconTheme: const IconThemeData(color: Colors.white), // Altera a cor do ícone (seta) para branco
      ),
      drawer: Menu(),
      body:_showComponents? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:30, horizontal: 0.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
               // padding: EdgeInsets.symmetric(horizontal: 4.0),
               // width: double.infinity, // Define a largura do Container como infinita para ocupar toda a largura da tela
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                 // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                Expanded(
                child: Container(
                width: double.infinity,
                  child: StreamBuilder<double>(
                    stream: _faturamentoGraficoController.stream,
                    builder: (context, faturamentoSnapshot) {
                      return StreamBuilder<double>(
                        stream: _custoController.stream,
                        builder: (context, custoSnapshot) {
                          double faturamento = faturamentoSnapshot.data ?? 0;
                          double custo = custoSnapshot.data ?? 0;

                          // Calcula a proporção entre faturamento e custo
                          double proporcao = faturamento > 0 ? custo / faturamento : 0;

                          final List<Map<String, dynamic>> dataSource = [
                            {'category': 'Faturamento', 'value': faturamento, 'color': Colors.orange},
                            {'category': 'Custo', 'value': custo, 'color': Colors.amberAccent},
                          ];

                          return SfCartesianChart(
                            // Configurações do gráfico
                            primaryXAxis: const CategoryAxis(
                              axisLine: AxisLine(color: Colors.transparent),
                            ),
                            primaryYAxis: NumericAxis(
                              // Define a altura da segunda barra proporcional à primeira
                              maximum: faturamento * 1.2, // Define o máximo como 20% maior que o faturamento
                              // Define o intervalo do eixo Y
                              interval: faturamento / 10, // Ou qualquer outro intervalo desejado
                              // Oculta os rótulos do eixo Y
                              labelStyle: const TextStyle(color: Colors.transparent),
                            ),
                            series: <CartesianSeries>[
                              ColumnSeries<Map<String, dynamic>, String>(
                                dataSource: dataSource,
                                xValueMapper: (sales, _) => sales['category'] as String,
                                yValueMapper: (sales, _) => sales['value'] as num,
                                dataLabelSettings: const DataLabelSettings(isVisible: true),
                                pointColorMapper: (sales, _) => sales['color'] as Color,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
          ),



                    //     Expanded(
                //       child:Container(
                //         width: double.infinity,
                //        // padding: EdgeInsets.symmetric(horizontal: 4.0),
                //         //   width: double.infinity,
                //         child: SfCartesianChart(
                //           enableSideBySideSeriesPlacement: false,
                //           legend: const Legend(isVisible: false),
                //           primaryXAxis: const CategoryAxis(
                //             majorTickLines: MajorTickLines(size: 0),
                //             axisLine: AxisLine(color: Colors.transparent), // Remove as linhas de grade e os valores no eixo X
                //           ),
                //           primaryYAxis: const NumericAxis(
                //               majorTickLines: MajorTickLines(size: 0), // Remove as linhas de grade e os valores no eixo Y
                //              edgeLabelPlacement: EdgeLabelPlacement.shift, // Evita que os rótulos de dados sejam cortados
                //              labelStyle: TextStyle(color: Colors.transparent), // Define a cor do texto como transparente para ocultar os rótulos
                //              interval: 1000, // Defina um intervalo que não exibe nenhum rótulo
                //           ),
                //           series: <CartesianSeries>[
                //             ColumnSeries<Map, String>(
                //               dataSource: const [
                //                 {'category': 'Faturamento', 'value': 5000, 'color': Colors.orange}, // Barra azul para faturamento
                //                 {'category': 'Custo', 'value': 3000, 'color': Colors.amberAccent}, // Barra vermelha para custo
                //               ],
                //               xValueMapper: (Map sales, _) => sales['category'] as String,
                //               yValueMapper: (Map sales, _) => sales['value'] as num,
                //                 dataLabelSettings: const DataLabelSettings(isVisible: true), // Oculta os rótulos de dados
                //              // dataLabelMapper: (Map sales, _) => '',
                //               pointColorMapper: (Map sales, _) => sales['color'] as Color, // Define a cor da barra
                //             ),
                //           ],
                //         ),
                //   ),
                // ),

                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildRowWithHelpIcon(tituloCampo,'',dignosticoBloc.lucroController,mensagem1,"lucro_prejuiso"),
                            const SizedBox(height: 5.0),
                            _buildRowWithHelpIcon('Percentual','',dignosticoBloc.percentualLucroController,'Verificar o texto para este campo',"Percentual"),
                            const SizedBox(height: 5.0),
                            _buildRowWithHelpIcon('Ticket Médio','',dignosticoBloc.ticketMedioController,mensagem2,""),
                            const SizedBox(height: 5.0),
                            _buildRowWithHelpIcon('Margem de Contribuição','',dignosticoBloc.margemContribuicaoController,mensagem3,"margem"),
                            const SizedBox(height: 5.0),
                            _buildRowWithHelpIcon('Produtividade','',dignosticoBloc.produtividadeController,mensagem4,null),
                            const SizedBox(height: 5.0),
                            _buildRowWithHelpIcon('Ponto de Equilíbrio %','',dignosticoBloc.percentualPontoEquilibrioController,mensagem5,""),
                            const SizedBox(height: 5.0),
                            _buildRowWithHelpIcon('Ponto de Equilíbrio','',dignosticoBloc.pontoEquilibrioController,mensagem5,""),
                            const SizedBox(height: 5.0),
                            const SizedBox(height: 5.0),
                          ],
                        ),
                      ),
                      ),
                  ],
                ),
              ),
          Card(
           // elevation: 4.0, // Sombreamento do card
            margin: EdgeInsets.all(8.0), // Margem ao redor do card
            child: Container(
              padding: EdgeInsets.all(11.0), // Preenchimento interno do container
              // color: Colors.green, // Cor de fundo do container (opcional)
              child: StreamBuilder(
                stream: dignosticoBloc.cardInformativoNovaTela,
                builder: (context, snapshot) {
                  String texto = snapshot.data ?? ''; // Valor padrão se o snapshot estiver vazio
                  return Text(
                    texto.isEmpty ? 'Texto que ocupa toda a largura da tela' : texto,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      //color: Colors.white, // Cor do texto (opcional)
                    ),
                  );
                },
              ),
            ),
          )


          ],
          ),
        ),
      ): const Center(
        child: CircularProgressIndicator(), // Exibe um indicador de progresso enquanto os dados estão sendo carregados
    ),
    );
  }


  InputDecoration buildInputDecoration(BuildContext context, text, titulo,corFundo ) {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      /*    prefixIcon: IconButton(
        icon: const Icon(Icons.help, color: Colors.black54,),
        color: Colors.black54,
        onPressed: () {
          alerta.openModal(context, text);
        },
      ),*/

      //   suffixIcon: suffixIcon,
     // fillColor: const Color.fromRGBO(245, 245, 245, 1),
      fillColor:  corFundo,
      filled: true,
      // disabledBorder: true,
      focusedBorder: const OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide:    BorderSide(color: Color.fromRGBO(1, 57, 44, 1), width: 1.0),
      ),
      border: const OutlineInputBorder(
        // borderSide: BorderSide(color: Color(0xFFffd600)),
        borderSide:  BorderSide(color: Color.fromRGBO(105, 105, 105, 1), width: 1.0),
      ),

      labelText: titulo,
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13,
        // backgroundColor: Colors.white,
      ),
      // hintText: 'Quantidade de clientes atendidos',
    );
  }
  Widget _buildRowWithHelpIcon(String label,text , strean_text, textAlert,strean_color) {
    var cor_fundo = Color.fromRGBO(245, 245, 245, 1);
    return Row(
      children: [
        Expanded(
          child: StreamBuilder<String>(
            stream: strean_text,
            builder: (context, textSnapshot) {
              return StreamBuilder<Color>(
                stream:  null,
                builder: (context, colorSnapshot) {
                  if("lucro_prejuiso" == strean_color){
                    var valor = (textSnapshot.data
                        .toString()
                        .replaceAll("R\$", "")
                        .replaceAll('.', '')
                        .replaceAll(',', '.'));
                    cor_fundo = calcularCor(double.parse(valor));
                  }
                  if("margem" == strean_color){
                    var corSelecionada =  dignosticoBloc.getColorBasedOnConditions();
                    if( corSelecionada == 'VERDE'){
                       cor_fundo = Colors.green;
                    }else if( corSelecionada == 'AMARELO'){
                      cor_fundo = Colors.yellow;
                    }else if( corSelecionada == 'VERDE'){
                      cor_fundo = Colors.red;
                    }
                  }
                  return Container(
                    color: colorSnapshot.data ?? Colors.white,
                    child: TextField(
                      enabled: false,
                      decoration: buildInputDecoration(context, textSnapshot.data, label,cor_fundo),
                      controller: TextEditingController(text: textSnapshot.data ?? ''),
                    ),
                  );
                },
              );
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.help, size: 30, color: Color.fromRGBO(1, 57, 44, 1)),
          onPressed: () {
            _showHelpModal(context, textAlert);
          },
        ),
      ],
    );
  }

  void _showHelpModal(BuildContext context, String fieldName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
         // title: Text('Ajuda'),
          content: Text(fieldName),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
