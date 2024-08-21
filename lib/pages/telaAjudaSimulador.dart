import 'package:appgestao/blocs/dados_basico_bloc.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:flutter/material.dart';

class TelaAjudaSimulador extends StatelessWidget {
  const TelaAjudaSimulador({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var header = HeaderAppBar();
    var mesBloc = DadosBasicosBloc();
    var texto1 = "Experimente aumentar ou diminuir os itens que influenciam a lucratividade da empresa. Observe os que mais impactam e imponha-se o desafio de fazer acontecer, até uma determinada data.";
    var texto2 =
        "Você pode selecionar um ou vários itens, indicando aumentos % ou diminuições %. Sempre que fizer isso observe a consequência em 'Margem resultante'.";
    var texto3 =
        "\nCaso queira rever o % atribuido em um determinado item, é só selecioná-lo novamente.";

    var text4 ='''
Dados Básicos
    Se você está se preparando para iniciar um negócio, digite aqui suas estimativas e premissas.
    Tratando-se de empresa já em atividade, digite os resultados apurados a cada mês.
    Você também pode transcrever aqui o resultado de suas simulações em “Gestão de prioridades”. 
    Portanto, só você sabe se os “números” refletem a realidade, uma estimativa, ou especulação!
    A partir do momento em que você “salvar”, todas as funcionalidades do Aplicativo estarão levando em conta as quantidades e valores informados, os quais ficarão armazenados no “Histórico” para consultas futuras.
    Vale observar que este Aplicativo não utiliza Internet, funcionando apenas em seu telefone celular, sendo você quem define a senha de acesso.
    
Diagnóstico
    Aqui, os “Dados Básicos” passam por processo de análise, gerando indicadores, comentários, sugestões e orientações focadas em otimizar seus resultados, assim como faria um consultor! 
    Sejam as estimativas de um negócio novo, ou a realidade atual do Negócio, ou simulações para antecipar eventos futuros, você sempre terá orientações úteis, na palma da mão, em qualquer lugar do planeta, quando quiser.
    
Gestão de prioridades
    Na realidade trata-se de um “simulador”, no qual você pode definir percentuais de aumento (+) ou diminuição (-) de um ou até mesmo de todos os valores registrados em “Dados Básicos”.
    Desta forma, você poderá antever a lucratividade do Negócio, em consequência de alterações em seus gastos e custos; diante de volumes maiores ou menores de vendas, descontos promocionais, aumentos de preços e/ou no valor do ticket médio.
    Lembrando a possibilidade de transcrever os resultados das simulações em “Dados Básicos” e verificar qual o “Diagnóstico”; assim como poderá utilizar a “Calculadora de preços” para análises complementares.
    
Calculadora de preços
    Esta calculadora, com base na estrutura de custos do seu Negócio e em suas metas de lucro, será útil para você:
Analisar os preços que está praticando;
Definir os preços para produtos novos; 
    Atualizar preços quando de alterações nos custos; 
Definir preços para produtos novos;
    Analisar a viabilidade de ofertas promocionais;
    Complementar as considerações do “diagnóstico”, com observações relativas à lucratividade e competitividade;
    Obter índices de variação para utilizar em suas análises em “Gestão de prioridades”.
    Decidir providências em relação a produtos com baixa lucratividade.
    Tudo isso rapidamente, sem precisar fazer contas! E você pode salvar no Histórico para montar tabelas e rever a evolução de seus preços. Sem precisar de Internet, na palma de sua mão, em qualquer lugar do planeta. 



    ''';
    return Scaffold(
        appBar: header.getAppBar('Ajuda Simulador'),
        body: SingleChildScrollView(
          child: StreamBuilder(
              stream: mesBloc.fulanoController,
              builder: (context, snapshot) {
                // var data  =snapshot.data.toString();
             /*   if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ));
                }*/

                if (snapshot.data.toString().isNotEmpty) {
                  //texto1 =  "${snapshot.data.toString().isNotEmpty ? 'Esta' : 'Esta'}, após escolher qual o item que pretende alterar, você deverá digitar o percentual e apertar + (se quiser aumentar), ou, - (se quiser diminuir).\n\nPode alterar um ou mais itens e ver o que acontece com a Margem resultante, além de poder comparar com a Margem desejada (ideal), e com a informada (em função dos Dados Básicos).\n\nAssim você vai saber quais as providências que deve priorizar.  " ;

                }
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "$text4",
                            style: buildTextStyle(),
                            textAlign: TextAlign.justify,
                          ),
                       /*   Text(
                            "$texto1",
                            style: buildTextStyle(),
                            textAlign: TextAlign.justify,
                          ),
                          Text(
                            "$texto1",
                            style: buildTextStyle(),
                            textAlign: TextAlign.justify,
                          )*/
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ));
  }

  TextStyle buildTextStyle() {
    return const TextStyle(
      //  color: Colors.white,
      fontSize: 18,

      //  fontWeight: FontWeight.bold,
    );
  }
}
