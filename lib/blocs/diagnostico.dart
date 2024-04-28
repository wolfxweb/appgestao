import 'dart:ffi';

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

  final _card1 = BehaviorSubject();
  final _card2 = BehaviorSubject();
  final _card3 = BehaviorSubject();
  final _card4 = BehaviorSubject();
  final _card5 = BehaviorSubject();

  Stream get textDiagnosticoController => _textDiagnosticoController.stream;
  Stream get textPrejuisoController => _textPrejuisoController.stream;
  Stream get textLucro_1_Controller => _textLucro_1_Controller.stream;
  Stream get textLucro_2_Controller => _textLucro_2_Controller.stream;
  Stream get textLucro_3_Controller => _textLucro_3_Controller.stream;

  Stream get card1 => _card1.stream;
  Stream get card2 => _card2.stream;
  Stream get card3 => _card3.stream;
  Stream get card4 => _card4.stream;
  Stream get card5 => _card5.stream;

  var margemDadosBasicos;
  var custoFixoDadosBasicos;
  var qualTextoMostrar;
  var faturamentoDadosBasicos;
  var gastoVendasDadosBasicos;
  var gastoInsumos3DadosBasics;
  var quantidadeVendasDadosBasicos;
  var custoVendas;


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
  //  =((1/((100% - ((C.VENDAS DADOS BÁSICOS * (100% + (MARGEM IDEAL DADOS BÁSICOS – MARGEM ATUAL 1º. PARÁGRAFO DIAGNÓSTICO ))) +
    //  CUSTOS FIXOS DADOS BÁSICOS + MARGEM IDEAL DADOS BÁSICOS)) /100%)) * CUSTO DOS INSUMOS DADOS BÁSICOS)
    var margemIdealMenosDadosBasico = ((margemDadosBasicos-margemCalculada));
    var custoDadosBasicoMenosInsumos = ((custoFixoDadosBasicos+margemIdealMenosDadosBasico));
    var diminucao_custo_variacao;

    //=SE(H7>"";(C8+C9+C10)/(100%-C11))
    // =SE(H7>"";(Gastos com vendas+Gastos com insumos+Custos Fixos)/(100%-Custos Fixos))
    // =SE(H7>"";(gastoVendasDadosBasicos + gastoInsumos3DadosBasics + custoFixoDadosBasicos)/(1-custoFixoDadosBasicos))
    var soma_custos =gastoVendasDadosBasicos + gastoInsumos3DadosBasics + custoFixoDadosBasicos;

    var formulaPadrao =((soma_custos)/(1-(margemDadosBasicos/100)));

   //=SE(L15>"";((C7-(C7*C11))/(C8+C9+C10)-100%)*(-1);"")
    //=SE(L15>"";((faturamentoDadosBasicos -(faturamentoDadosBasicos * margemDadosBasicos))/(gastoVendasDadosBasicos + gastoInsumos3DadosBasics + custoFixoDadosBasicos)-1)*(-1);"")

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


    print('faturamento');
    print(faturamentoDadosBasicos);

    var fatGastosVendasEinsumos = (faturamentoDadosBasicos -(gastoVendasDadosBasicos +gastoInsumos3DadosBasics ));
    print('calculo_b');
    print(calculo_b);
  //  fatGastosVendasEinsumos = -1;
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
    print(double.parse(calculo_b.toStringAsFixed(2)));
    print(margemDadosBasicos);

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



  /*  var textoCard4txt1 = "Para começar a ter lucro (ponto de equilíbrio),"
        "$textoPositivoCad3 ${formatterQuantidade.format(custoFixoDadosBasicos/double.parse(margemcontribucao))}"
        " clientes,e faturar R\$ ${formatterMoeda.format(faturamento)} ou seja: $variacaoPercentualFaturamento%\n"
        "Para atingir a margem ideal ${formatterQuantidade.format(margemDadosBasicos)}%, com"
        " o faturamento atual, o faturamente precisa ser ${formatterPercentual.format(faturamento_maior)}% maior.";

    var textoCard5txt1 = "A produtividade foi de R\$ $produtividade de faturamento para cada R\$1,00 de custo fixo.\n"
        "Quanto maior for a produtividade, melhor!\nPrincipalmente se ela chegar a R\$ ${chegar_valor}";
*/
//custo fixo

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
        //   print('mesAtual');
        //   print(mesAtual);
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
    print(element);
    _calculoMargemResultante();
  }
}
