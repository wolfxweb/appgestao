

import 'package:appgestao/classes/pushpage.dart';
import 'package:appgestao/componete/alertamodal.dart';
import 'package:appgestao/componete/espasamento.dart';
import 'package:appgestao/componete/logo.dart';
import 'package:appgestao/componete/menu.dart';
import 'package:appgestao/pages/calculadora.dart';
import 'package:appgestao/pages/dadosbasicos.dart';
import 'package:appgestao/pages/diagnostico.dart';
import 'package:appgestao/pages/gestaoPrioridades.dart';
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

  String textAjudaDadosBasicos = "Coração e cérebro do Get Up.app.br. Quando você digitar suas informações, o aplicativo ficará customizado para o seu negócio.\ne-Book Se você está planejando iniciar seu empreendimento, ou abrir uma filial, preencha com suas estimativas e metas. ";
  String textAjudaDiganostico = "Como está a saúde da empresa: lucratividade, valor médio das vendas, contribuição de cada venda para cobrir custos fixos e gerar lucro, faturamento necessário para começar a lucrar, produtividade.\nE-Book";
  String textAjudaCalculadoraPrecos = "Como aumentos ou diminuições nas vendas, nos preços, no valor médio das compras, ou nos custos, impactam a lucratividade de sua empresa?\nQuais as prioridades para lucrar mais? E-Book";
  String textAjudaGestaoPrioridades = "Por quanto vender! Qual a margem obtida com o preço atual!\nEste produto contribui para o resultado da empresa?\nQual o preço para atingir determinada margem! e-Book";
  String textAjudaInportanciaMeses = "Inportância dos meses";
  String textAjudaSimuladorProximosMeses = "Simulador Próximos meses";
  String textAjudaCalculadoraViabilidade = "Calculadora Viabilidade e P&P";
  String textAjudaCalculadoraCapitalGiro = "Calculadora Capital Giro";

  String textBtnDadosBasicos = "Dados Básicos";
  String textBtnDiganostico = "Diagnóstico";
  String textBtnCalculadoraPrecos = "Calculadora Precos";
  String textBtnGestaoPrioridades = "Gestão de  Prioridades";
  String textBtnInportanciaMeses = "Inportância dos meses";
  String textBtnSimuladorProximosMeses = "Simulador Próximos meses";
  String textBtnCalculadoraViabilidade = "Calculadora Viabilidade e P&P";
  String textBtnCalculadoraCapitalGiro = "Calculadora Capital Giro";
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
            const Logo(),
            const Espacamento(),
            const Espacamento(),
            buildRowBtn(context,textAjudaDadosBasicos,textBtnDadosBasicos,NovoDadosBasicos()),
            buildRowBtn(context,textAjudaDiganostico,textBtnDiganostico,Diagnostico()),
            buildRowBtn(context,textAjudaGestaoPrioridades,textBtnGestaoPrioridades,gestaoPrioridades()),
            buildRowBtn(context,textAjudaCalculadoraPrecos,textBtnCalculadoraPrecos,Calculadora()),
          // buildRowBtn(context,textAjudaInportanciaMeses,textBtnInportanciaMeses,null),
          // buildRowBtn(context,textAjudaSimuladorProximosMeses,textBtnSimuladorProximosMeses,null),
          // buildRowBtn(context,textAjudaCalculadoraViabilidade,textBtnCalculadoraViabilidade,null),
          // buildRowBtn(context,textAjudaCalculadoraCapitalGiro,textBtnCalculadoraCapitalGiro,null)


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
                iconSize: 35,
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
                  style: ElevatedButton.styleFrom(
                    primary: color,
                    // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed:(){
                    route.pushPage(context, funcao);
                  },
                  child:  Text(text,
                      style: TextStyle(color: Colors.white)),
                ),
              );
  }
  SizedBox buildElevatedButtonIcon(text, icone, funcao) {
    return SizedBox(
      width:  MediaQuery.of(context).size.width ,
      child: ElevatedButton.icon(
        onPressed: (){
          funcao;
        },
        icon: Icon(icone),  //icon data for elevated button
        label: Text(text), //label text
        style: ElevatedButton.styleFrom(
            primary: color //elevated btton background color
        ),
      ),
    );
  }
}
