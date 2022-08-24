import 'package:appgestao/blocs/dados_basico_bloc.dart';
import 'package:appgestao/componete/headerAppBar.dart';
import 'package:flutter/material.dart';

class TelaAjudaSimulador extends StatelessWidget {
  const TelaAjudaSimulador({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var header = HeaderAppBar();
    var mesBloc = DadosBasicosBloc();
    var texto1;
    var texto2 =
        "Você pode selecionar um ou vários itens, indicando aumentos % ou diminuições %. Sempre que fizer isso observe a consequência em 'Margem resultante'.";
    var texto3 =
        "Caso queira rever o % atribuido em um determinado item, é só selecioná-lo novamente.";

    return Scaffold(
        appBar: header.getAppBar('Ajuda Simulador'),
        body: SingleChildScrollView(
          child: StreamBuilder(
              stream: mesBloc.fulanoController,
              builder: (context, snapshot) {
                // var data  =snapshot.data.toString();
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ));
                }

                if (snapshot.data.toString().isNotEmpty) {
                  texto1 =
                      "${snapshot.data.toString().isNotEmpty ? snapshot.data.toString() : 'Esta'} essa ferramenta permite que você anteveja a consequência de alterações (Margem resultante),  na quantidade de vendas, no valor do Ticket médio ou em quaisquer dos Custos informados em DADOS BÁSICOS. Assim você pode tomar decisões estratégicas para o sucesso do seu negócio!";
                }
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "$texto1",
                            style: buildTextStyle(),
                            textAlign: TextAlign.justify,
                          ),
                          Text(
                            "$texto2",
                            style: buildTextStyle(),
                            textAlign: TextAlign.justify,
                          ),
                          Text(
                            "$texto3",
                            style: buildTextStyle(),
                            textAlign: TextAlign.justify,
                          )
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
      fontSize: 26,

      //  fontWeight: FontWeight.bold,
    );
  }
}
