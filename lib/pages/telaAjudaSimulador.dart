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
Quando o resultado das simulações não corresponder à sua expectativa, lance os valores em Dados Básicos e depois veja o Diagnóstico.
Quando você concluir que precisa alcançar determinados resultados:
1. Relacione todas as providências necessárias;
2. Anote quais dependem da conclusão de outras. E quais são independentes;
3. Assim você saberá por onde começar;
4. Estime quanto tempo será preciso para executar cada uma;
5. Agora defina três datas para cada tema: início, controle e conclusão;
6. Ao lado, quem executará;
7. Anote na agenda do seu celular. 



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
