

import 'package:appgestao/blocs/importancia_meses_bloc.dart';
import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/alertamodal.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/logo.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:appgestao/pages/analiseviabilidade.dart';
import 'package:appgestao/pages/calculadora.dart';
import 'package:appgestao/pages/dadosbasicos.dart';
import 'package:appgestao/pages/diagnostico.dart';
import 'package:appgestao/pages/gestaoPrioridades.dart';
import 'package:appgestao/pages/importanciameses.dart';
import 'package:appgestao/pages/newTelaDiagnostico.dart';
import 'package:appgestao/pages/novaTelaDiagnostico.dart';

import 'package:appgestao/pages/novodadosbasicos.dart';
import 'package:appgestao/pages/simulador.dart';
import 'package:flutter/material.dart';
import 'package:appgestao/componete/headerAppBar.dart';


class novaHome extends StatefulWidget {
  const novaHome({Key? key}) : super(key: key);

  @override
  State<novaHome> createState() => _novaHomeState();
}

class _novaHomeState extends State<novaHome> {
  var header = new HeaderAppBar();
  var alerta = AlertModal();
  var color =  Color.fromRGBO(1, 57,44,1);
  var route = PushPage();

  String textAjudaDadosBasicos = "Coração e cérebro do Get Up. Quando você digitar suas informações, o aplicativo ficará customizado para o seu negócio.\nSe você está planejando iniciar seu empreendimento, ou abrir uma filial, preencha com suas estimativas e metas. ";
  String textAjudaDiganostico = "Como está a saúde da empresa: lucratividade, valor médio das vendas, contribuição de cada venda para cobrir custos fixos e gerar lucro, faturamento necessário para começar a lucrar, produtividade.\n";
  String textAjudaCalculadoraPrecos = "Como aumentos ou diminuições nas vendas, nos preços, no valor médio das compras, ou nos custos, impactam a lucratividade de sua empresa?\nQuais as prioridades para lucrar mais?";
  String textAjudaGestaoPrioridades = "Por quanto vender! Qual a margem obtida com o preço atual!\nEste produto contribui para o resultado da empresa?\nQual o preço para atingir determinada margem!";
  String textAjudaInportanciaMeses = "Inportância dos meses";
  String textAjudaSimuladorProximosMeses = "Simulador Próximos meses";
  String textAjudaCalculadoraViabilidade = "Calculadora Viabilidade e P&P";
  String textAjudaCalculadoraCapitalGiro = "Calculadora Capital Giro";
  String textAjudaAnalizeVibilidade ="Analíse de viabilidade";

  String textBtnDadosBasicos = "Dados Básicos";
  String textBtnDiganostico = "Diagnóstico";
  String textBtnCalculadoraPrecos = "Calculadora de Preços";
  String textBtnGestaoPrioridades = "Gestão de prioridades";
  //String textBtnGestaoPrioridades = "Simulador";
  String textBtnInportanciaMeses = "Inportância dos meses";
  String textBtnSimuladorProximosMeses = "Simulador Próximos meses";
  String textBtnCalculadoraViabilidade = "Calculadora Viabilidade e P&P";
  String textBtnCalculadoraCapitalGiro = "Calculadora Capital Giro";
  String textBtnAnalizeVibilidade ="Analíse de viabilidade";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header.getAppBar('Home'),
      drawer: Menu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Espacamento(),
            const Espacamento(),
            const Espacamento(),
            const Espacamento(),
            const Espacamento(),
            const Espacamento(),
           // const Logo(),
            const Espacamento(),
            const Espacamento(),
            const Espacamento(),
            const Espacamento(),
            const Espacamento(),
            const Espacamento(),

            buildRowBtn(context,textAjudaDadosBasicos,textBtnDadosBasicos,NovoDadosBasicos()),
            buildRowBtn(context, '',textBtnDiganostico,NovaTelaDiagnostico()),
           // buildRowBtn(context, '',textBtnDiganostico,NovaTelaDiagnostico()),
           // buildRowBtn(context,textAjudaDiganostico,textBtnDiganostico,telaDiagnostico()),
            buildRowBtn(context,textAjudaCalculadoraPrecos,textBtnGestaoPrioridades,GestaoPrioridade()),
            buildRowBtn(context, textAjudaGestaoPrioridades ,textBtnCalculadoraPrecos,Calculadora()),
        //

        /*
          Tela removidas ou alteradas por solicitação  do cliente alguns dos arquivos foram removidos por solicitação do mesmo
             buildRowBtn(context,textAjudaDadosBasicos,textBtnDadosBasicos,DadosBasicos()),
             buildRowBtn(context,textAjudaInportanciaMeses,textBtnInportanciaMeses,InportanciaMeses()),
             buildRowBtn(context,textAjudaAnalizeVibilidade,textBtnAnalizeVibilidade,AnaliseViabilidade()),
             buildRowBtn(context,'Simulador',textBtnGestaoPrioridades,Simulador()),
             buildRowBtn(context,textAjudaCalculadoraViabilidade,textBtnCalculadoraViabilidade,null),
             buildRowBtn(context,textAjudaSimuladorProximosMeses,textBtnSimuladorProximosMeses,null),
             buildRowBtn(context,textAjudaCalculadoraCapitalGiro,textBtnCalculadoraCapitalGiro,null)
         */




          ],
        ),
      ),

    );
  }

  Row buildRowBtn(BuildContext context, textAjuda, textBtn, funcao) {
    return Row(
            children: [
              buildIconButton(textAjuda),
              buildButton(context,textBtn, funcao),
            ],
          );
  }

  IconButton buildIconButton(textoAjuda) {
    return IconButton(
                iconSize: 30,
                icon:  Icon(
                  Icons.help,
                  color:color,
                ),
                  onPressed:(){
                    alerta.openModal(context,textoAjuda);
                  },
              );
  }

  SizedBox buildButton(BuildContext context,text, funcao) {
    return SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: ElevatedButton(
                  style: colorButtonStyle(color),
                  onPressed:(){
                    route.pushPage(context, funcao);
                  },
                  child:  Text(text,
                      style: TextStyle(color: Colors.white)),
                ),
              );
  }SizedBox buildElevatedButtonIcon(text, icone, funcao, color) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton.icon(
        onPressed: () {
          funcao();
        },
        icon: Icon(icone),
        label: Text(text),
        style: colorButtonStyle(color),
       // Colors.blue,
      ),

    );

  }

ButtonStyle colorButtonStyle(color) {
  return ButtonStyle(
       // primary: color, // Cor de fundo do botão
          backgroundColor:MaterialStateProperty.all<Color>(color),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
   );
}

}
