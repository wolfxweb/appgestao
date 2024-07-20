import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:appgestao/blocs/dados_basico_bloc.dart';
import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:appgestao/classes/sqlite/importanciameses.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';

class DignosticoBloc extends BlocBase {
  var bd = DadosBasicosSqlite();
  var bdi = InportanciasMeses();
  var dadosBasicosBloc = DadosBasicosBloc();

  final _textDiagnosticoController = BehaviorSubject();
  final _textPrejuisoController = BehaviorSubject();
  final _textLucro_1_Controller = BehaviorSubject();
  final _textLucro_2_Controller = BehaviorSubject();
  final _textLucro_3_Controller = BehaviorSubject();

  final _lucroController = BehaviorSubject<String>();
  final _percentualLucroController = BehaviorSubject<String>();
  final _margemContribuicaoController = BehaviorSubject<String>();
  final _produtividadeController = BehaviorSubject<String>();
  final _pontoEquilibrioController = BehaviorSubject<String>();
  final _percentualPontoEquilibrioController = BehaviorSubject<String>();
  final _ticketMedioController = BehaviorSubject<String>();
  //final _custoTotalController = BehaviorSubject<double>();
  final _margemContriController = BehaviorSubject<String>();
  final _card1 = BehaviorSubject();
  final _card2 = BehaviorSubject();
  final _card3 = BehaviorSubject();
  final _card4 = BehaviorSubject();
  final _card5 = BehaviorSubject();

  final _cardInformativoNovaTela = BehaviorSubject();

  Stream get textDiagnosticoController => _textDiagnosticoController.stream;
  Stream get textPrejuisoController => _textPrejuisoController.stream;
  Stream get textLucro_1_Controller => _textLucro_1_Controller.stream;
  Stream get textLucro_2_Controller => _textLucro_2_Controller.stream;
  Stream get textLucro_3_Controller => _textLucro_3_Controller.stream;


  //Utilizando na tela com grafico
  Stream get lucroController => _lucroController.stream;
  Stream get percentualLucroController => _percentualLucroController.stream;
  Stream get margemContribuicaoController => _margemContribuicaoController.stream;
  Stream get produtividadeController => _produtividadeController.stream;
  Stream get pontoEquilibrioController => _pontoEquilibrioController.stream;
  Stream get percentualPontoEquilibrioController => _percentualPontoEquilibrioController.stream;
  Stream get ticketMedioController => _ticketMedioController.stream;
  //Stream<double> get custoTotalController => _custoTotalController.stream;
  Stream get margemContriController => _margemContriController.stream;

  Stream get card1 => _card1.stream;
  Stream get card2 => _card2.stream;
  Stream get card3 => _card3.stream;
  Stream get card4 => _card4.stream;
  Stream get card5 => _card5.stream;
  Stream get cardInformativoNovaTela => _cardInformativoNovaTela.stream;
  var margemDadosBasicos;
  var custoFixoDadosBasicos;
  var qualTextoMostrar;
  var faturamentoDadosBasicos;
  var gastoVendasDadosBasicos;
  var gastoInsumos3DadosBasics;
  var quantidadeVendasDadosBasicos;
  var custoVendas;
  var capacidade_atendimento;

  //var _marInformada;
  var calc_qtd;
  var calc_fat;
  var calc_cf;
  var calc_cv;
  var calc_gi;
  var calc_gas;
  var calc_cpv;
  var calc_mar;

  var _fulano;
  var _A;
  var _B;
  var _Bnovo;
  var _C;
  var _D;
  var _E;
  var _F;
  var _FNOVO;
  var _G;
  var _H;
  var _I;
  var _J;
  var _K;
  var _L;
  var _M;
  var _N;
  var _O;
  var _X;

  var calculo_a;
  var calculo_b;
  var calculo_c;
  var calculo_d;
  var calculo_e;
  var calculo_f;
  var calculo_g;
  var calculo_k;
  var calculo_h;
  var calculo_n;

  var _text_1;
  var _text_2;
  var _text_3;
  var _text_4;
  var _text_5;
  var _text_6;
  var _text_strean;
  //info inportancia dos meses
  var _jan;
  var _fev;
  var _mar;
  var _abr;
  var _mai;
  var _jun;
  var _jul;
  var _ago;
  var _set;
  var _out;
  var _nov;
  var _dez;
  var _totalMeses = 0;

  DignosticoBloc() {
    // _textPrejuisoController.add('');
    //  _textDiagnosticoController.add('');
    _fulanoLogado();
  }
  NumberFormat formatterMoeda = NumberFormat("#,##0.00", "pt_BR");
  NumberFormat formatterPercentual = NumberFormat("0.00");
  NumberFormat formatterQuantidade = NumberFormat("0");
  _fulanoLogado() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      var email = user!.email;
      if (user == null) {
      } else {
        FirebaseFirestore.instance
            .collection('usuario')
            .doc(email)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            //  print(documentSnapshot.data());
            Map<String, dynamic> data =
                documentSnapshot.data()! as Map<String, dynamic>;
            _fulano = data['nome'];
            _getDadosBasicos();
          }
        });
      }
    });
  }
  String getColorBasedOnConditions() {
    _getDadosBasicos();
    _calculoTiketMedio();

   var  margemContribuicao = double.parse(
      (_D
          .toString()
          .replaceAll("R\$", "")
          .replaceAll('.', '')
          .replaceAll(',', '.')),
    );
    var ticketMedio = double.parse(
      (_C
          .toString()
          .replaceAll("R\$", "")
          .replaceAll('.', '')
          .replaceAll(',', '.')),
    );

    var proporcaoMargemContribuicao = margemContribuicao/ticketMedio;
    var proporcaoTicketMedio = ticketMedio/ticketMedio;
    if (proporcaoMargemContribuicao < 0.0) {
      return "VERMELHO";
    } else if (proporcaoMargemContribuicao > 0 && proporcaoTicketMedio < 0.20) {
      return "AMARELO";
    } else if (proporcaoMargemContribuicao > 0.20) {
      return  "VERDE";
    } else {
      return "Defualt";
    }
  }
  String getPrimeiroTexto(double margem, double margemIdeal) {
    if (margem == null || margem == 0) {
      return "Você deve estar bem preocupado!";
    } else if (margem < 0) {
      return "Atenção! Prejuízo!";
    } else if (margem > 0 && margem < margemIdeal * 0.6) {
      return "O lucro alcançado foi menor do que aquele que você gostaria!";
    } else if (margem >= margemIdeal * 0.6 && margem < margemIdeal * 0.9) {
      return "O lucro alcançado não é aquele que você gostaria!";
    } else if (margem >= margemIdeal * 0.9 && margem < margemIdeal * 1.05) {
      return "Você deve estar satisfeito com o lucro alcançado!";
    } else if (margem >= margemIdeal * 1.05) {
      return "Você deve estar muito satisfeito com o lucro alcançado!";
    } else {
      return "Você deve estar bem preocupado!";
    }
  }
  String getTerceiroTexto(double margem, double margemIdeal, double quantClientesAtendimento, double capacidadeAtendimento) {
    if (margem >= 0 && quantClientesAtendimento < capacidadeAtendimento * 0.9 && margem > 0) {
      return "Por que não vendeu mais? \n1) Mercado não comporta? Então reduza custos fixos; \n2) Concorrência? Crie diferenciais, corrija seus pontos fracos; \n3) Mês fraco? Crie incentivos!";
    } else if (margem < 0 && margem > 0) {
      return "Verifique seus preços de vendas! Item que dá prejuízo, que não pode ter o preço aumentado, nem ser descartado, associe com outros (combo); some seus preços e o custo dos insumos e/ou de aquisição e veja o resultado na Calculadora de Preços.";
    } else if (margem >= 0 && margem < margemIdeal * 0.9 && quantClientesAtendimento >= capacidadeAtendimento * 0.9 && quantClientesAtendimento < capacidadeAtendimento * 1.1) {
      return "Verifique seus preços de vendas! Item que dá prejuízo, que não pode ter o preço aumentado, nem ser descartado, associe com outros (combo); some os preços dos produtos e seus custos e veja o resultado na Calculadora de Preços.";
    } else if (margem >= margemIdeal * 0.9 && quantClientesAtendimento >= capacidadeAtendimento * 0.9 && quantClientesAtendimento < capacidadeAtendimento * 1.1) {
      return "Vale a pena estudar a viabilidade de aumentar sua capacidade de atendimento!";
    } else if (margem >= 0 && margem < margemIdeal * 0.9 && quantClientesAtendimento >= capacidadeAtendimento * 1.1) {
      return "Isso coloca em risco a qualidade da oferta e do atendimento (clientes e colaboradores estressados)! Verifique a lucratividade de cada item que comercializa!";
    } else if (margem >= margemIdeal * 0.9 && quantClientesAtendimento >= capacidadeAtendimento * 1.1) {
      return "Isso coloca em risco a qualidade da oferta e do atendimento (clientes e colaboradores estressados)!";
    } else if (margem < 0 && margem <= 0 && margemIdeal <= 0) {
      return "SUAS VENDAS ESTÃO CONTRIBUINDO PARA O PREJUÍZO! Se um Item dá prejuízo e não pode ter o preço aumentado, nem ser descartado, associe com outros (combo); some seus preços e o custo dos insumos e/ou de aquisição) e veja o resultado na Calculadora de Preços.";
    }
    return "";
  }
  String getSegundoTexto(double margem, double margemIdeal, double quantClientesAtendimento, double capacidadeAtendimento) {
    double percentual;
    if (margem > 0 && margem < margemIdeal * 0.9 && quantClientesAtendimento < capacidadeAtendimento * 0.9) {
      percentual = ((capacidadeAtendimento - quantClientesAtendimento) / capacidadeAtendimento) * 100;
      return "E, as vendas foram menores (${percentual.toStringAsFixed(2)}%) do que sua capacidade instalada.";
    } else if (margem < 0 && quantClientesAtendimento < capacidadeAtendimento * 0.9) {
      percentual = ((capacidadeAtendimento - quantClientesAtendimento) / capacidadeAtendimento) * 100;
      return "Pelo menos (${percentual.toStringAsFixed(2)}%) dos investimentos e custos fixos não estão sendo aproveitados!";
    } else if (margem > 0 && margem < margemIdeal * 0.9 && quantClientesAtendimento >= capacidadeAtendimento * 0.9 && quantClientesAtendimento < capacidadeAtendimento * 1.1) {
      percentual = ((quantClientesAtendimento - capacidadeAtendimento * 0.9) / capacidadeAtendimento) * 100;
      return "Mesmo com as vendas nos limites da capacidade instalada (${percentual.toStringAsFixed(2)}%).";
    } else if (margem < 0 && quantClientesAtendimento >= capacidadeAtendimento * 0.9 && quantClientesAtendimento < capacidadeAtendimento * 1.1) {
      percentual = ((quantClientesAtendimento - capacidadeAtendimento * 0.9) / capacidadeAtendimento) * 100;
      return "Mesmo com as vendas correspondendo a capacidade de atendimento! (${percentual.toStringAsFixed(2)}%).";
    } else if (margem > 0 && margem < margemIdeal * 0.9 && quantClientesAtendimento >= capacidadeAtendimento * 1.1) {
      percentual = ((quantClientesAtendimento - capacidadeAtendimento * 1.1) / capacidadeAtendimento) * 100;
      return "Apesar de estar vendendo (${percentual.toStringAsFixed(2)}%) acima da capacidade instalada.";
    } else if (margem < 0 && quantClientesAtendimento >= capacidadeAtendimento * 1.1) {
      percentual = ((quantClientesAtendimento - capacidadeAtendimento * 1.1) / capacidadeAtendimento) * 100;
      return "Mesmo vendendo acima da capacidade instalada! (${percentual.toStringAsFixed(2)}%).";
    } else if (margem >= margemIdeal * 0.9 && quantClientesAtendimento < capacidadeAtendimento * 0.9) {
      percentual = ((capacidadeAtendimento - quantClientesAtendimento) / capacidadeAtendimento) * 100;
      return "Mesmo vendendo (${percentual.toStringAsFixed(2)}%) menos do que a capacidade instalada.";
    } else if (margem >= margemIdeal * 0.9 && quantClientesAtendimento >= capacidadeAtendimento * 0.9 && quantClientesAtendimento < capacidadeAtendimento * 1.1) {
      percentual = ((quantClientesAtendimento - capacidadeAtendimento * 0.9) / capacidadeAtendimento) * 100;
      return "Suas vendas corresponderam à capacidade instalada (${percentual.toStringAsFixed(2)}%).";
    } else if (margem >= margemIdeal * 0.9 && quantClientesAtendimento >= capacidadeAtendimento * 1.1) {
      percentual = ((quantClientesAtendimento - capacidadeAtendimento * 1.1) / capacidadeAtendimento) * 100;
      return "Porém, ATENÇÃO! As vendas superaram em (${percentual.toStringAsFixed(2)}%) a capacidade instalada.";
    }
    return "";
  }
  String getQuartoTexto(double margem, double margemIdeal, double faturamento, double margContribuicao, double ticketMedio, double quantPontoEquilibrio, double quantVendas) {
    if (margemIdeal == 0 || faturamento == 0) {
      return "";
    }
    if (margem >= 0 && margem < margemIdeal * 0.9 && margContribuicao > 0 && margContribuicao / ticketMedio < 0.2 && quantPontoEquilibrio / quantVendas > 0.5) {
      return "Diminua a participação dos seus gastos com vendas, com suas compras e os custos fixos, sobre o faturamento. Você está calculando corretamente os preços dos itens que comercializa?";
    } else if (margem >= 0 && margem < margemIdeal * 0.9 && margContribuicao > 0 && margContribuicao / ticketMedio < 0.2 && quantPontoEquilibrio / quantVendas < 0.5) {
      return "Diminua a participação dos seus gastos com vendas e com suas compras, sobre o faturamento. Muita atenção com os estoques e com os prazos dos recebimento e dos pagamentos!";
    } else if (margem >= 0 && margem < margemIdeal * 0.9 && margContribuicao / ticketMedio >= 0.2 && quantPontoEquilibrio / quantVendas > 0.5) {
      return "Verifique a possibilidade de aumentar a produtividade!";
    } else if (margem >= 0 && margem < margemIdeal * 0.9 && margContribuicao / ticketMedio >= 0.2 && quantPontoEquilibrio / quantVendas < 0.5) {
      return "Você está calculando corretamente os preços dos itens que comercializa?";
    } else if (margem >= margemIdeal * 0.9 && margContribuicao > 0 && margContribuicao / ticketMedio < 0.2 && quantPontoEquilibrio / quantVendas > 0.5) {
      return "Diminua a participação dos seus gastos com vendas, com suas compras e custos fixos, sobre o faturamento!";
    } else if (margem >= margemIdeal * 0.9 && margContribuicao > 0 && margContribuicao / ticketMedio < 0.2 && quantPontoEquilibrio / quantVendas < 0.5) {
      return "Diminua seus gastos com vendas e com suas compras!";
    } else if (margem >= margemIdeal * 0.9 && margContribuicao / ticketMedio >= 0.2 && quantPontoEquilibrio / quantVendas > 0.5) {
      return "Verifique a possibilidade de reduzir a participação dos custos fixos sobre o faturamento!";
    } else if (margem >= margemIdeal * 0.9 && margContribuicao / ticketMedio >= 0.2 && quantPontoEquilibrio / quantVendas < 0.5) {
      return "A participação dos seus gastos e custos sobre o faturamento estão bem administrados!";
    } else if (margem < 0 && margContribuicao < 0) {
      return "Sua prioridade mais urgente é reduzir a participação dos gastos com vendas e com suas compras, sobre o faturamento!";
    } else if (margem < 0 && margContribuicao > 0) {
      return "Após analisar os preços, priorize reduzir os custos fixos! E reveja os gastos com vendas e com suas compras.";
    }
    return "";
  }
  String getQuintoTexto(double faturamento, double pontoEquilibrio, double margemContribuicao, double capacidadeAtendimento, double margem, double margemIdeal, double ticketMedio) {
    if (faturamento == 0 || pontoEquilibrio == capacidadeAtendimento || margemContribuicao <= 0) {
      return "";
    }
    if (margem <= 0 && pontoEquilibrio > 0 && pontoEquilibrio <= capacidadeAtendimento) {
      double c = (capacidadeAtendimento / pontoEquilibrio);
      double d = ((c - 1) * 100).roundToDouble();
      return "Para alcançar o ponto de equilíbrio a produtividade deveria ser de $c, ou seja: $d% maior.";
    } else if (margem <= 0 && pontoEquilibrio > 0 && pontoEquilibrio > capacidadeAtendimento) {
      double c = (pontoEquilibrio / capacidadeAtendimento);
      double d = ((c - 1) * 100).roundToDouble();
      return "Para alcançar o ponto de equilíbrio a produtividade deveria ser de $c, ou seja: $d% maior, o que não é possível com a atual capacidade de atendimento!";
    } else if (margem <= 0 && margemContribuicao <= 0) {
      return "Concentre-se em reduzir a participação dos gastos com vendas, insumos e produtos de 3os sobre o faturamento!";
    } else if (margem > 0 && margem < margemIdeal * 0.9 && pontoEquilibrio > 0) {
      double e = faturamento - margem / ticketMedio;
      double f = ((faturamento - margem / ticketMedio) / faturamento * 100);
      double g = (faturamento - margem) / margem * 100;
      double h = ((faturamento - margem / ticketMedio) / faturamento * 100);
      double i = (faturamento - margem) / margem * 100;
      return "Com a atual capacidade de atendimento e ticket médio, o faturamento seria de $e, (produtividade de $f%). Para conseguir lucro de $g%, a participação sobre o faturamento dos gastos (com vendas e insumos) teria que diminuir de  $h% para $i%.";
    } else if (margem > 0 && margem >= margemIdeal * 0.9 && pontoEquilibrio > 0) {
      double j = (margem * 0.1);
      return "Veja como é importante cuidar da produtividade: se você conseguir  aumentá-la em 10%, em 12 meses iguais, ganho adicional de $j";
    }
    return "";
  }
  _montaTexto() {
    //  ${_fulano}
    _text_1 =
        "As informações relativas ao mês de $_A indicam que o seu negócio apresentou lucro de $_Bnovo%.\n"
        "O ticket médio foi de R\$ $_C .\nMargem de contribuição R\$ $_D.\nPara começar a ter lucro foi preciso vender R\$ $_E, "
        "o que representa $_FNOVO% do total faturado no mês.\nA produtividade foi de R\$ $_G de faturamento para cada R\$1,00 de custo fixo.\n"
        "Principalmente se alcançar R\$ X ou se Y clientes forem atendidos. ";

    _text_2 = "O fato é que o resultado não é aquele que você gostaria.\n "
        "Use o SIMULADOR para ver o que pode ser feito! Com a ajuda da CALCULADORA DE PREÇOS verifique, "
        "a margem dos seus produtos que mais vendem.\n"; //Com um aumento de ${_X}% na produtividade você alcançaria os ${_H}% que considera ideal!";

    _text_3 =
        "Parabéns! Você certamente está satisfeito com a lucratividade do negócio.\n"
        "Mesmo assim dê uma analisada com a ajuda do SIMULADOR para ver se poderia ser ainda melhor.\n"
        "O resultado será um percentual 0%";

    _text_4 =
        "Sua previsão de vendas para o corrente mês indica que possivelmente ele se encerrará com $_J de   $_K %. \nEm $_L, com $_M de $_N%.\n"
        "O resultado spe um percentual 0%";

    _text_5 =
        "As informações relativas ao mês de $_A indicam que o seu negócio apresentou prejuízo de $_O%.\n"
        "Esta é uma situação que requer providências imediatas.\n"
            "Principalmente se ela chegar s R\$ x;";

    _text_6 = "1. Verifique se os DADOS BÁSICOS informados estão corretos"
        "2. Analise, no SIMULADOR, as providências prioritárias para sair do prejuízo."
        "3. Com a CALCULADORA DE PREÇOS verifique a margem de cada produto. Se você concluir que precisa vender mais, ou descontinuar algum produto, estude a VIABILIDADE DE PROMOÇÃO & PROPAGANDA"
        "4. Avalie como está sua disponibilidade de CAPITAL DE GIRO."; // Se for o caso, consulte o CHECKLIST 'O que fazer para diminuir a necessidade de capital de giro!'";

    var _b = double.parse(_B).truncateToDouble();
    var _h = double.parse(_H).truncateToDouble();
    var ticket = (_C
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    var margemcontribucao = (_D
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    var variacaoTicketMedioMargemContribuicao = (double.parse(margemcontribucao).truncateToDouble()/double.parse(ticket).truncateToDouble())*100;
    var margem95 = _h * 0.95;
    var margem105 = _h * 1.05;
    var margemCalculada = _b;
    var margemDadosBasicos = _h;
    var qtdAtendimento =formatterPercentual.format(custoFixoDadosBasicos/double.parse(margemcontribucao));
    var faturamento =(custoFixoDadosBasicos/double.parse(margemcontribucao))*double.parse(ticket);
    var variacaoPercentualFaturamento =formatterPercentual.format( (faturamento/faturamentoDadosBasicos)*100);
    var produtividade =formatterMoeda.format( faturamentoDadosBasicos/custoFixoDadosBasicos);
    var textoPositivoP1 = 'O lucro de ';
    if(calculo_b < 0.0){
       textoPositivoP1 = 'prejuízo de ';
    }else if(calculo_b == 0){
      textoPositivoP1 = 'A margem de ';
    }
    var caculoVariacaoCard3 =(faturamento/faturamentoDadosBasicos)*100;
    var textoPositivoCad3 = 'foi preciso atender';
    if(calculo_b < 0){
      textoPositivoCad3 = 'será preciso atender';
    }
    var x_clientes;
    var y_clientes;
    var faturamento_maior;
    var diminucao_custo;
    var chegar_valor;
    var margemIdealMenosDadosBasico = ((margemDadosBasicos-margemCalculada));
    var custoDadosBasicoMenosInsumos = ((custoFixoDadosBasicos+margemIdealMenosDadosBasico));
    var diminucao_custo_variacao;
    var soma_custos =gastoVendasDadosBasicos + gastoInsumos3DadosBasics + custoFixoDadosBasicos;
    var formulaPadrao =((soma_custos)/(1-(margemDadosBasicos/100)));
    var percentualMargemDadosBasicos =margemDadosBasicos/100;
    var parte1DiminuicaoCusto =faturamentoDadosBasicos-(faturamentoDadosBasicos*percentualMargemDadosBasicos);

    diminucao_custo_variacao = 100 -(((parte1DiminuicaoCusto)/(soma_custos))*100);
    diminucao_custo =  (formulaPadrao/faturamentoDadosBasicos);
    chegar_valor =(formulaPadrao/custoFixoDadosBasicos);
    faturamento_maior =  ((formulaPadrao)/(faturamentoDadosBasicos/10));
    x_clientes = formatterMoeda.format(formulaPadrao/quantidadeVendasDadosBasicos);
    y_clientes = formatterQuantidade.format(formulaPadrao/(faturamentoDadosBasicos/quantidadeVendasDadosBasicos));
    chegar_valor = formatterMoeda.format(formulaPadrao/custoFixoDadosBasicos);

    var textoCard1txt1 = "$textoPositivoP1 $_Bnovo% é menor do que aquele que você gostaria.\nUtilize a CALCULADORA DE PREÇOS para verificar a margem dos itens que comercializa.\nEm seguida analise possíveis providências em GESTÃO DE PRIORIDADES.";
    var textoCard1txt2 = "$textoPositivoP1  $_Bnovo%  supera suas expectativas. Previna-se para enfrentar possíveis alterações dos custos.\nAnalise possíveis providências em GESTÃO DE PRIORIDADES e use a CALCULADORA DE PREÇOS.";
    var textoCard1txt3 = "$textoPositivoP1  $_Bnovo% está muito próximo daquele que você considera ideal.\nVerifique em GESTÃO DE PRIORIDADES e também na CALCULADORA DE PREÇOS o que poderia fazer para melhorar ainda mais.";
    var textoCard1txt4 = "$textoPositivoP1  $_Bnovo% NÃO PERCA TEMPO! Vamos ajuda-lo a transformar suas dúvidas em DECISÕES PODEROSAS! \nConsulte o e-Book! AGORA!!!";
    var textoCard2txt1 = "";
    var textoCard4txt1 = "";
    var textoCard5txt1 ="";
    var fatGastosVendasEinsumos = (faturamentoDadosBasicos -(gastoVendasDadosBasicos +gastoInsumos3DadosBasics ));
    var margem = double.parse(calculo_b.toStringAsFixed(2));

    if(fatGastosVendasEinsumos<= 0){
      textoCard2txt1 = "O faturamento médio por cliente 'ticket médio' foi de R\$ $_C.\nReveja seus preços e/ou custo das vendas e com insumos e mercadorias de 3os. Aumentar vendas não é solução!\n";
    }else if(margem < 0) {
      textoCard2txt1 = "O faturamento médio por cliente 'ticket médio' foi de R\$ $_C.\nQuanto maior melhor!\nSeria preciso alcançar R\$ ${x_clientes} ou se ${y_clientes} clientes forem atendidos";

    }else if(margem > 0 && margem < margemDadosBasicos ) {
      textoCard2txt1 = "O faturamento médio por cliente 'ticket médio' foi de R\$ $_C.\nQuanto maior melhor!\nPrincipalmente se alcançar R\$ ${x_clientes} ou se ${y_clientes} clientes forem atendidos";
    }else {
      textoCard2txt1 = "O faturamento médio por cliente 'ticket médio' foi de R\$ $_C.\nQuanto maior melhor!\n";
    }


    if(margem!=0 && margem < margemDadosBasicos ){
      textoCard4txt1 = "Para começar a ter lucro (ponto de equilíbrio),"
          "$textoPositivoCad3 ${formatterQuantidade.format(custoFixoDadosBasicos/double.parse(margemcontribucao))}"
          " clientes,e faturar R\$ ${formatterMoeda.format(faturamento)} ou seja: $variacaoPercentualFaturamento%";
    }else if(margem> 0  && margem > margemDadosBasicos){
      textoCard4txt1 = "Para começar a ter lucro (ponto de equilíbrio),"
          "$textoPositivoCad3 ${formatterQuantidade.format(custoFixoDadosBasicos/double.parse(margemcontribucao))}"
          " clientes,e faturar R\$ ${formatterMoeda.format(faturamento)} ou seja: $variacaoPercentualFaturamento%\n"
          "Para atingir a margem ideal ${formatterQuantidade.format(margemDadosBasicos)}%, com"
          " com os custos atuais, os preços deveriam aumentar ${formatterPercentual.format(faturamento_maior)}%.";
    }else{
      textoCard4txt1 = "Para começar a ter lucro (ponto de equilíbrio),"
          "$textoPositivoCad3 ${formatterQuantidade.format(custoFixoDadosBasicos/double.parse(margemcontribucao))}"
          " clientes,e faturar R\$ ${formatterMoeda.format(faturamento)} ou seja: $variacaoPercentualFaturamento%";
    }

    if(double.parse(calculo_b.toStringAsFixed(2))!=0 &&double.parse(calculo_b.toStringAsFixed(2)) < margemDadosBasicos ){
      textoCard5txt1 = "A produtividade foi de R\$ $produtividade de faturamento para cada R\$1,00 de custo fixo.\n"
          "Quanto maior for a produtividade, melhor!\nPrincipalmente se ela chegar a R\$ ${chegar_valor}";
    }else{
      textoCard5txt1 = "A produtividade foi de R\$ $produtividade de faturamento para cada R\$1,00 de custo fixo.";
    }
    var textoCard3txt1 ="";
    if(double.parse(calculo_b.toStringAsFixed(2))!=0 && double.parse(calculo_b.toStringAsFixed(2)) < margemDadosBasicos ){
      textoCard3txt1 = "Margem de contribuição: R\$ $_D\nOu seja: da receita média gerada por cliente, restaram ${formatterPercentual.format(variacaoTicketMedioMargemContribuicao)}% "
          "para cobrir os custos fixos e gerar margem.";
    }else if(double.parse(calculo_b.toStringAsFixed(2)) > 0  && double.parse(calculo_b.toStringAsFixed(2)) > margemDadosBasicos){
      textoCard3txt1 = "Margem de contribuição: R\$ $_D\nOu seja: da receita média gerada por cliente, restaram ${formatterPercentual.format(variacaoTicketMedioMargemContribuicao)}% "
          "para cobrir os custos fixos e gerar margem."
          "\nQuanto maior for este índice, melhor!\nPara atingir a margem ideal  ${formatterQuantidade.format(margemDadosBasicos)}%, "
          "com faturamento atual, os custos precisariam diminuir ${formatterPercentual.format(diminucao_custo_variacao)}%";
    }else{
      textoCard3txt1 = "Margem de contribuição: R\$ $_D\nOu seja: da receita média gerada por cliente, restaram ${formatterPercentual.format(variacaoTicketMedioMargemContribuicao)}% "
          "para cobrir os custos fixos e gerar margem.";
    }


    if (margemCalculada > 0 && margemCalculada < margem95) {
      _card1.add(textoCard1txt1);
    } else if (margemCalculada > 0 && margemCalculada > margem105) {
      _card1.add(textoCard1txt2);
    } else if (margemCalculada > 0 &&   margemCalculada < margem105 && margemCalculada > margem95) {
      _card1.add(textoCard1txt3);
    } else if (margemCalculada < 0) {
      _card1.add(textoCard1txt4);
    }
    _card2.add(textoCard2txt1);
    _card3.add(textoCard3txt1);
    _card4.add(textoCard4txt1);
    _card5.add(textoCard5txt1);

    /* regra da tela antiga*/
    if (_b > 0.0) {
      if (_b < _h) {
        _textDiagnosticoController.add("Lucro");
        _textLucro_1_Controller.add(_text_1);
        _textLucro_2_Controller.add(_text_2);
        _textLucro_3_Controller.add(_text_4);
      } else if (_b > _h) {
        _textDiagnosticoController.add("Lucro");
        _textLucro_1_Controller.add(_text_1);
        _textLucro_2_Controller.add(_text_3);
        _textLucro_3_Controller.add(_text_4);
      }
    } else if (_b < 0.0) {
      _textPrejuisoController.add(_text_5);
      _textDiagnosticoController.add("prejuízo");
    }
    //var _b = double.parse(_B).truncateToDouble();
    var faturamentoTelaGrafico = faturamentoDadosBasicos - soma_custos;

    _lucroController.add("R\$ ${formatterMoeda.format(faturamentoTelaGrafico)}");

    _percentualLucroController.add("${_Bnovo.toString()} %");
   //  var calculo_teste = (calc_fat - (calc_gi + calc_cf + calc_gas)) / calc_qtd;
   //  var calculo_teste_result = formatterMoeda.format(calculo_teste);
   // // _margemContribuicaoController.add("R\$ $calculo_teste_result");
   //  _margemContriController.add("R\$ $calculo_teste_result");
    _produtividadeController.add(produtividade);
    _pontoEquilibrioController.add(formatterQuantidade.format(custoFixoDadosBasicos/double.parse(margemcontribucao)));
    _percentualPontoEquilibrioController.add("R\$ ${formatterMoeda.format(faturamento)}");
    _ticketMedioController.add("R\$ $_C");

    // DAQUI PARA BAIXO E O TEXTO DA TELA NOVA,

    var  margemContribuicao_parse = double.parse((_D.toString().replaceAll("R\$", "").replaceAll('.', '').replaceAll(',', '.')),);
    var ticketMedio_parse = double.parse((_C.toString().replaceAll("R\$", "").replaceAll('.', '').replaceAll(',', '.')), );
    double margem_1 = margem;
    double margemIdeal = margem;
    double quantClientesAtendimento = quantidadeVendasDadosBasicos;
    double capacidadeAtendimento = capacidade_atendimento;
   // double faturamento_ = 50000.0;
    double margContribuicao = double.parse(margemcontribucao);
    double ticketMedio =ticketMedio_parse;
    double quantPontoEquilibrio = faturamento;
    double quantVendas =quantidadeVendasDadosBasicos;
    double pontoEquilibrio = faturamento;
    double margemContribuicao = margemContribuicao_parse;

    String mensagem_1 = getPrimeiroTexto(margem_1, margemIdeal);
    String mensagem_2 = getSegundoTexto(margem_1, margemIdeal, quantClientesAtendimento, capacidadeAtendimento);
    String mensagem_3 = getTerceiroTexto(margem_1, margemIdeal, quantClientesAtendimento, capacidadeAtendimento);
    String mensagem_4 =  getQuartoTexto(margem_1, margemIdeal, faturamento, margContribuicao, ticketMedio, quantPontoEquilibrio, quantVendas);
    String mensagem_5 = getQuintoTexto(faturamento, pontoEquilibrio, margemContribuicao, capacidadeAtendimento, margem, margemIdeal, ticketMedio);
    String mensagem_6 ="Uma vez que estas considerações referem-se a mês anterior, recomendamos que em DEFINIÇÃO DE PRIORIDADES você estime comparativamente as variações para o corrente mês. Feito isso, digite suas estimativas para fechamento deste mês em DADOS BÁSICOS e veja o DIAGNÓSTICO.";
    String mensagemConcatenada = "$mensagem_1\n$mensagem_2\n$mensagem_3\n$mensagem_4\n$mensagem_5\n$mensagem_6";
    _cardInformativoNovaTela.add(mensagemConcatenada);
    // var calculo_teste = (calc_fat - (calc_gi + calc_cf + calc_gas)) / calc_qtd;
    // var calculo_teste_result = formatterMoeda.format(calculo_teste);
    // _margemContribuicaoController.add("R\$ $calculo_teste_result");
   // _margemContriController.add("R\$ $margContribuicao");

  }

  _getDadosBasicos() async {
    var dadosBasicos = true;
    await bd.lista().then((data) {
      data.forEach((element) {
        print(element);
        dadosBasicos = false;
        _A = element['mes'];
        calculo_a = element['mes'];
        _H = (element['margen']);
        calculo_h = element['margen'];
        _convertFoat(element);
        margemDadosBasicos = double.parse(element['margen']).truncateToDouble();
        custoFixoDadosBasicos = double.parse(
          (element['custo_varivel']
              .toString()
              .replaceAll("R\$", "")
              .replaceAll('.', '')
              .replaceAll(',', '.')),
        );
        faturamentoDadosBasicos= double.parse(
          (element['faturamento']
              .toString()
              .replaceAll("R\$", "")
              .replaceAll('.', '')
              .replaceAll(',', '.')),
        );
        gastoVendasDadosBasicos = double.parse(
          (element['gastos_insumos']
              .toString()
              .replaceAll("R\$", "")
              .replaceAll('.', '')
              .replaceAll(',', '.')),
        );
        gastoInsumos3DadosBasics = double.parse(
          (element['custo_fixo']
              .toString()
              .replaceAll("R\$", "")
              .replaceAll('.', '')
              .replaceAll(',', '.')),
        );
        quantidadeVendasDadosBasicos= double.parse(
          (element['qtd']
              .toString()
              .replaceAll("R\$", "")
              .replaceAll('.', '')
              .replaceAll(',', '.')),
        );
        capacidade_atendimento= double.parse(
          (element['capacidade_atendimento']
              .toString()
              .replaceAll("R\$", "")
              .replaceAll('.', '')
              .replaceAll(',', '.')),
        );
      });
    });

    if (dadosBasicos) {
      _textDiagnosticoController.add("dadosbssiconull");
    }
  }

  _lucroOuPrejuiso() {
    var _b = double.parse(_B).truncateToDouble();
    if (_b > 0.0) {
      _J = "lucro";
    } else {
      _J = "prejuízo";
    }
    _consultarMeses();
  }

  _consultarMeses() async {
    var dates = true;
    await bdi.lista().then((data) {
      data.forEach((element) {
        dates = false;
        _jan = (element['jan'] * 100) / element['total'];
        _fev = (element['fev'] * 100) / element['total'];
        _mar = (element['mar'] * 100) / element['total'];
        _abr = (element['abr'] * 100) / element['total'];
        _mai = (element['mai'] * 100) / element['total'];
        _jun = (element['jun'] * 100) / element['total'];
        _jul = (element['jul'] * 100) / element['total'];
        _ago = (element['ago'] * 100) / element['total'];
        _set = (element['setb'] * 100) / element['total'];
        _out = (element['out'] * 100) / element['total'];
        _nov = (element['nov'] * 100) / element['total'];
        _dez = (element['dez'] * 100) / element['total'];
        //    print('_A');
        //    print(_A);
        final mesAtual = DateTime.now().month;
           print('mesAtual');
           print(mesAtual);
        switch (mesAtual) {
          case 1:
            _calculoMensal(_dez, _jan, _fev, "Fevereiro");
            break;
          case 2:
            _calculoMensal(_jan, _fev, _mar, "Março");
            break;
          case 3:
            _calculoMensal(_fev, _mar, _abr, "Abril");
            break;
          case 4:
            _calculoMensal(_mar, _abr, _mai, "Maio");
            break;
          case 5:
            _calculoMensal(_abr, _mai, _jun, "Junho");
            break;
          case 6:
            _calculoMensal(_mai, _jun, _jul, "Julho");
            break;
          case 7:
            _calculoMensal(_jun, _jul, _ago, "Agosto");
            break;
          case 8:
            _calculoMensal(_jul, _ago, _set, "Setembro");
            break;
          case 9:
            _calculoMensal(_ago, _set, _out, "Outubro");
            break;
          case 10:
            _calculoMensal(_set, _out, _nov, "Novembro");
            break;
          case 11:
            _calculoMensal(_out, _nov, _dez, "Dezembro");
            break;
          case 12:
            _calculoMensal(_nov, _dez, _jan, "Janeiro");
            break;
        }
        _montaTexto();
      });
    });
    if (dates) {
      _textDiagnosticoController.add("inportanciamesesNULL");
    }
  }

  _calculoX() {
    //  var calculoX=(((24000.0+((((24000.0*25)-(7.1*24000.0))/13.0)*48.0))/4800.00)/(24000.00/4800.00));
    // print('calculoX');
    //  print(calculoX);
    var _h = double.parse(calculo_h);
    var calculoX = (((calc_fat +
                ((((calc_fat * _h) - (calculo_b * calc_fat)) / calculo_d) *
                    calculo_c)) /
            calc_cf) /
        (calc_fat / calc_cf));
    _X = calculoX.toStringAsPrecision(4);
  }

  _calculoMensal(mesDadosBasicos, mesAtual, proximoMese, textoL) {
    var mesReferencia = _calculoK(mesDadosBasicos, mesAtual, mesAtual);
    var calculo_ns = _calculoN(mesDadosBasicos, mesAtual, proximoMese);

    _K = formatterMoeda.format(mesReferencia * 100);

    _N = formatterMoeda.format(calculo_ns * 100);

    _L = textoL;
    _calculoM(calculo_n);
    _calculoX();
  }

  _calculoM(_n) {
    if (_n > 0.0) {
      _M = "lucro";
    } else {
      _M = "prejuízo";
    }

    _montaTexto();
  }

  // mesInicial = _jun;
  // mesProximo = _jul;
  _calculoK(mesInicial, mesProximo, mesAtual) {
    // _calculoTiketMedio();
    calculo_k = ((((mesAtual * calc_qtd) / mesInicial) * calculo_c) -
            ((((calc_gi + calc_gas + calc_cf) / calc_fat) *
                    (((mesProximo * calc_qtd) / mesInicial) * calculo_c)) +
                calc_cv)) /
        (((mesProximo * calc_qtd) / mesInicial) * calculo_c);
    return calculo_k;
  }

  _calculoN(mesAtual, mesInicial, mesProximo) {
    calculo_n = ((((mesProximo * calc_qtd) / mesAtual) * calculo_c) -
            ((((calc_gi + calc_gas + calc_cf) / calc_fat) *
                    (((mesProximo * calc_qtd) / mesAtual) * calculo_c)) +
                calc_cv)) /
        (((mesProximo * calc_qtd) / mesAtual) * calculo_c);
    return calculo_n;
  }

  _calculoG() {
    calculo_g = calc_fat / calc_cv;
    _G = formatterMoeda.format(calculo_g);
    _lucroOuPrejuiso();
  }

  _calculoF() {
    calculo_f = calculo_e / calc_fat;
    var calc = calculo_f * 100;
    _FNOVO = formatterMoeda.format(calc);
    _F = calc.toStringAsPrecision(2);
    _calculoG();
  }

  _calculoPontoEquilibrio() {
    calculo_e = (calc_cv / calculo_d) * calculo_c;
    _E = formatterMoeda.format(calculo_e);
    _calculoF();
  }

  _calculoMargemConribuicao() {
    calculo_d = (calc_fat - (calc_gi + calc_cf + calc_gas)) / calc_qtd;
    _D = formatterMoeda.format(calculo_d);
    _calculoPontoEquilibrio();
  }

  _calculoTiketMedio() {
    calculo_c = calc_fat / calc_qtd;
    _C = formatterMoeda.format(calculo_c);
    _calculoMargemConribuicao();
  }

  _calculoMargemResultante() {
    calculo_b =
        (((calc_fat - (calc_gi + calc_cv + calc_cf + calc_gas)) / calc_fat) *
            100);
    _Bnovo = formatterMoeda.format(calculo_b);

    _B = calculo_b.toStringAsPrecision(2);
    _O = _B;
    _calculoTiketMedio();
  }

  _convertFoat(element) {
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
    var qtd = (element['qtd']
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));

    calc_qtd = double.parse(qtd).truncateToDouble();
    calc_fat = double.parse(faturamento).truncateToDouble();
    calc_cf = double.parse(custo_fixo).truncateToDouble();
    calc_cv = double.parse(custo_varivel).truncateToDouble();
    calc_gi = double.parse(gastos_insumos).truncateToDouble();
   // calc_gas = double.parse(gastos).truncateToDouble();
    calc_gas =0.0;
  //  print(element);
    _calculoMargemResultante();
  }
  @override
  void dispose() {
    // Fecha todos os BehaviorSubject e Subjects ao sair do widget
    _textDiagnosticoController.close();
    _textPrejuisoController.close();
    _textLucro_1_Controller.close();
    _textLucro_2_Controller.close();
    _textLucro_3_Controller.close();

    _lucroController.close();
    _percentualLucroController.close();
    _margemContribuicaoController.close();
    _produtividadeController.close();
    _pontoEquilibrioController.close();
    _percentualPontoEquilibrioController.close();
    _ticketMedioController.close();

    _card1.close();
    _card2.close();
    _card3.close();
    _card4.close();
    _card5.close();

    _cardInformativoNovaTela.close();

    super.dispose();
  }
}
