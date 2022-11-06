import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:appgestao/componete/alertasnackbar.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

class SimuladorBloc extends BlocBase {
  var bd = DadosBasicosSqlite();

  final _margemIdealController = BehaviorSubject();
  final _margemInformadaController = BehaviorSubject();
  final _vendasController = BehaviorSubject();
  final _ticketMedioController = BehaviorSubject();
  final _faturamentoController = BehaviorSubject();
  final _custoInsumosController = BehaviorSubject();
  final _custoProdutoController = BehaviorSubject();
  final _custoVariavelController = BehaviorSubject();
  final _custoFixoController = BehaviorSubject();
  final _margemDeContribuicaoController = BehaviorSubject();
  final _pontoEquilibrioController = BehaviorSubject();
  final _margemResultateController = BehaviorSubject();
  final _corVendaController = BehaviorSubject();
  final _corTicketMediolController = BehaviorSubject();
  final _corCustoInsumoslController = BehaviorSubject();
  final _corCustoProdutolController = BehaviorSubject();
  final _corCustoVariavelController = BehaviorSubject();
  final _corCustoFixoController = BehaviorSubject();
  final _percentualAddController = BehaviorSubject();
  final _percentualRemoveController = BehaviorSubject();
  final _corMargemResultateController = BehaviorSubject();
  final _corFaturamentoController = BehaviorSubject();
  final _corMargemContribuicaoController = BehaviorSubject();
  final _corPontoEquilibroController = BehaviorSubject();

  Stream get margemIdealController => _margemIdealController.stream;
  Stream get margemInformadaController => _margemInformadaController.stream;
  Stream get vendasController => _vendasController.stream;
  Stream get ticketMedioController => _ticketMedioController.stream;
  Stream get faturamentoController => _faturamentoController.stream;

  Stream get custoInsumosController => _custoInsumosController.stream;
  Stream get custoProdutoController => _custoProdutoController.stream;
  Stream get custoVariavelController => _custoVariavelController.stream;
  Stream get custoFixoController => _custoFixoController.stream;

  Stream get margemDeContribuicaoController =>_margemDeContribuicaoController.stream;
  Stream get pontoEquilibrioController => _pontoEquilibrioController.stream;
  Stream get margemResultateController => _margemResultateController.stream;

  Stream get corVendalController => _corVendaController.stream;
  Stream get corTicketMediolController => _corTicketMediolController.stream;
  Stream get corCustoInsumoslController => _corCustoInsumoslController.stream;
  Stream get corCustoProdutolController => _corCustoProdutolController.stream;
  Stream get corCustoVariavelController => _corCustoVariavelController.stream;
  Stream get corCustoFixoController => _corCustoFixoController.stream;

  Stream get percentualAddController => _percentualAddController.stream;
  Stream get percentualRemoveController => _percentualRemoveController.stream;

  Stream get corMargemResultateController => _corMargemResultateController.stream;
  Stream get corFaturamentoController => _corFaturamentoController.stream;
  Stream get corMargemContribuicaoController  => _corMargemContribuicaoController.stream;
  Stream get corPontoEquilibroController =>_corPontoEquilibroController.stream;


  SimuladorBloc() {
    getDadosBasicos();
  }

  var _qtd;
  var _fat;
  var _gi;
  var _gpv;
  var _cusf;
  var _cus;
  var _marIdeal;
  var _element;

  //var _marInformada;
  var calc_qtd;
  var calc_fat;
  var calc_cf;
  var calc_cv;
  var calc_gi;
  var calc_gas;
  var calc_cpv;

  var _margemCalculada;
  var _ticketMedio;
  var _tickeMedioMoeda;
  var _margemContribuicaoCalculada;
  var _calculoPontoEquilibio;
  var _margemReultanteCalculada;
  var novoCustoVariavel;
  var refTicketValor;
  var novoCustoFixo;
  var novaQtd;
  var novoTicketMedio;
  var novoValorInsumos;
  var novoCustoProduto;
  /** cores */

  var qtdx ;
  var faturamentox ;
  var gastosx ;
  var custo_fixox ;
  var custo_varivelx;
  var gastos_insumosx ;
  var margenx ;


  NumberFormat formatterPercentual = NumberFormat("0");
  NumberFormat formatterMoeda = NumberFormat("#,##0.00", "pt_BR");

  setPercentualInput(){
    _percentualAddController.add('0');
    _percentualRemoveController.add('0');
  }
  getDadosBasicos() async {
    await bd.lista().then((data) {
      data.forEach((element) {
        print(element);
        _qtd = element["qtd"];
        _fat = element["faturamento"];
        _gi = element["gastos_insumos"];
        _gpv = element["custo_varivel"];
        _cusf = element["custo_fixo"];
        _cus = element["gastos"];
        _marIdeal = element["margen"];
        _element = element;
        updateStream(_marIdeal, _qtd, _fat, _gpv, _cusf, _cus, _marIdeal, _element);
      });
    });
  }
  limparCorInputs(){
    corCustoFixo("desabilitado");
    corTicketMedio('desabilitado');
    corCustoInsumos('desabilitado');
    corCustoVariavel("desabilitado");
    corCustoProduto("desabilitado");
    _corVendaController.add('desabilitado');
  }


  calculoPercentual(percent, operacao, selecionado, modo, context) {

    var select = selecionado;

    if (select == "") {
      select = 'Quantidade de vendas';
    }
    var percentual = double.parse(percent);
    var fat= convertMonetarioFloat(_fat);
   // var fat =   double.parse(faturamentoConverido);
    var qtd =   double.parse(_qtd);
    var percoOriginal = fat/qtd;
    // percentual = percentual+1;
    if (modo == 1 && operacao == 1) {
     // percentual++;
      _percentualRemoveController.add('');
      _percentualAddController.add(percentual.toStringAsPrecision(2));
    }
    if (modo == 2 && operacao == 2) {
     // percentual++;
      _percentualAddController.add('');
      _percentualRemoveController.add(percentual.toStringAsPrecision(2));
    }


    switch (select) {
      case 'Quantidade de vendas':

        if (operacao == 1) {
          novaQtd = calc_qtd * ((percentual / 100) + 1);

        } else {
          var qtdAUX = calc_qtd * (percentual / 100);
          novaQtd = calc_qtd - qtdAUX;
        }
        calc_qtd = novaQtd;
        _vendasController.add(novaQtd.toString());
        calculoVendas(novaQtd.toString());
        calculoPontoEquilibrio();
        calculoMargemResultante();
      //  calculoTIKETMEDIO(operacao,percentual);
        custosINSUMOS(operacao,percentual);
        custoPRODUTO3(percentual,operacao);
        custoVARIAVEL(operacao,percentual);

        break;
      case 'Ticket médio':
            if (operacao == 1) {
              novoTicketMedio = _ticketMedio *((percentual / 100) + 1);
            } else {
              var qtdAUX = _ticketMedio *(percentual / 100);
              novoTicketMedio = _ticketMedio - qtdAUX;
            }
            _ticketMedio = novoTicketMedio;

            if (_ticketMedio > percoOriginal) {
              corTicketMedio('verde');
            } else if (_ticketMedio < percoOriginal) {
              corTicketMedio('vermelho');
            } else {
              corTicketMedio('desabilitado');
            }
            _ticketMedio = novoTicketMedio;
            _tickeMedioMoeda = "R\$ ${formatterMoeda.format(_ticketMedio)}";
            _ticketMedioController.add(_tickeMedioMoeda);
            calc_fat = novoTicketMedio * calc_qtd;
            _faturamentoController.add("R\$ ${formatterMoeda.format(calc_fat)}");
            _margemContribuicaoCalculada =(calc_fat - (calc_gi + calc_cv + calc_gas)) / calc_qtd;
            _margemDeContribuicaoController.add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");
            _calculoPontoEquilibio =(calc_cv / _margemContribuicaoCalculada) * novoTicketMedio;
            _pontoEquilibrioController.add("R\$ ${formatterMoeda.format(_calculoPontoEquilibio)}");
         //   quantidadeVENDADS(operacao,percentual);
           calculoMargemConribuicao();
           calculoMargemResultante();
            calculoPontoEquilibrio();
            calculoTIKETMEDIO(operacao,percentual);
            custosINSUMOS(operacao,percentual);
            custoPRODUTO3(percentual,operacao);
            custoVARIAVEL(operacao,percentual);
            corTicket();
          //  corMargemContribuicao();
        break;
    /*****************************/
      case 'Custo insumos':
        var calGi =  convertMonetarioFloat(_gi);
        if (operacao == 1) {
           novoValorInsumos = calc_gi *((percentual / 100) + 1);
        } else {
          var qtdAUX = calc_gi *(percentual / 100);
          novoValorInsumos = calc_gi - qtdAUX;
        }
          if (novoValorInsumos > calGi) {//_gi
            corCustoInsumos('vermelho');
          } else if (novoValorInsumos < calGi) {
            corCustoInsumos('verde');
          } else {
            corCustoInsumos('desabilitado');
          }
           calc_gi = novoValorInsumos;
           var custoInSumos = "R\$ ${formatterMoeda.format(novoValorInsumos)}";
          _custoInsumosController.add(custoInSumos);
          _margemContribuicaoCalculada = (calc_fat - (novoValorInsumos + calc_cv + calc_gas)) / calc_qtd;
          _margemDeContribuicaoController.add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");
        calculoMargemConribuicao();
        calculoMargemResultante();
        calculoPontoEquilibrio();
      //  corMargemContribuicao();

        break;
        /*****************************/
      case 'Custos produtos 3º':
        var custoDadosBasicos =  convertMonetarioFloat(_cus);
        if (operacao == 1) {
          novoCustoProduto = calc_gas *((percentual / 100) + 1);
        } else {
          var qtdAUX = calc_gas *(percentual / 100);
          novoCustoProduto = calc_gas - qtdAUX;
        }

        if (novoCustoProduto > custoDadosBasicos) {
          corCustoProduto('vermelho');
        } else if (novoCustoProduto < custoDadosBasicos) {
          corCustoProduto('verde');
        } else {
          corCustoProduto("desabilitado");
        }
         calc_gas = novoCustoProduto;
        var custoNovoProduto = "R\$ ${formatterMoeda.format(novoCustoProduto)}";
        _custoFixoController.add(custoNovoProduto);
        _margemContribuicaoCalculada =(calc_fat - (calc_gi + calc_cf + novoCustoProduto)) / calc_qtd;
        _margemDeContribuicaoController.add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");
        _margemReultanteCalculada =((calc_fat - (calc_gi + calc_cv + calc_cf + novoCustoProduto)) /calc_fat) *100;
        _margemResultateController.add(" ${formatterPercentual.format(_margemReultanteCalculada)} %");

        calculoMargemConribuicao();
        calculoMargemResultante();
        calculoPontoEquilibrio();

        break;
    /*****************************/
      case 'Outros custo variaveis':
        print("Outros custo variaveis calc_cf");
        print(calc_cf);
        var custoFixoDadosBasicos =  convertMonetarioFloat(_cusf);
        if (operacao == 1) {
          novoCustoVariavel = calc_cf *((percentual / 100) + 1);
        } else {
          var qtdAUX = calc_cf *(percentual / 100);
          novoCustoVariavel = calc_cf - qtdAUX;
        }
        if (novoCustoVariavel > custoFixoDadosBasicos) {
          corCustoVariavel('vermelho');
        } else if (novoCustoVariavel < custoFixoDadosBasicos) {
          corCustoVariavel('verde');
        } else {
          corCustoVariavel("desabilitado");
        }
        calc_cf = novoCustoVariavel;
        var novoCustoVariavelForm = "R\$ ${formatterMoeda.format(novoCustoVariavel)}";
        _custoVariavelController.add(novoCustoVariavelForm);
        _margemContribuicaoCalculada = (calc_fat - (calc_gi + novoCustoVariavel + calc_gas)) / calc_qtd;
        _margemDeContribuicaoController.add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");
        _calculoPontoEquilibio =(calc_cv / _margemContribuicaoCalculada) * _ticketMedio;
        _pontoEquilibrioController.add("R\$ ${formatterMoeda.format(_calculoPontoEquilibio)}");
        calculoMargemConribuicao();
        calculoMargemResultante();
        calculoPontoEquilibrio();
      //  corMargemContribuicao();
        /*
        quantidadeVENDADS(operacao,percentual);
        calculoTIKETMEDIO(operacao,percentual);
        custosINSUMOS(operacao,percentual);
        custoPRODUTO3(percentual,operacao);*/
       // custoVARIAVEL(operacao,percentual);
        break;
    /*****************************/
      case 'Custo fixo':
        print("Custo fixoCusto fixoCusto fixoCusto fixo");
        print(calc_cv);

       var novoCustoFixos = convertMonetarioFloat(_gpv);

        if (operacao == 1) {
          novoCustoFixo = calc_cv *((percentual / 100) + 1);
        } else {
          var qtdAUX = calc_cv *(percentual / 100);
          novoCustoFixo = calc_cv - qtdAUX;
        }

        if (novoCustoFixo > novoCustoFixos) {
          corCustoFixo('vermelho');
        } else if (novoCustoFixo < novoCustoFixos) {
          corCustoFixo('verde');
        } else {
          corCustoFixo("desabilitado");
        }

         calc_cv = novoCustoFixo;
        var novoCustonovoCustoFixo = "R\$ ${formatterMoeda.format(novoCustoFixo)}";
        _custoProdutoController.add(novoCustonovoCustoFixo);
        _calculoPontoEquilibio =(novoCustoFixo / _margemContribuicaoCalculada) * _ticketMedio;
        _pontoEquilibrioController.add("R\$ ${formatterMoeda.format(_calculoPontoEquilibio)}");
        _margemReultanteCalculada =((calc_fat - (calc_gi + novoCustoFixo + calc_cf + calc_gas)) /calc_fat) *100;
        _margemResultateController.add(" ${formatterPercentual.format(_margemReultanteCalculada)} %");
     //   calculoMargemConribuicao();
        calculoMargemResultante();
        calculoPontoEquilibrio();
        break;

    /*****************************/
    }
  }

quantidadeVENDADS(operacao,percentual){
  if (operacao == 1) {
    novaQtd = calc_qtd * ((percentual / 100) + 1);

  } else {
    var qtdAUX = calc_qtd * (percentual / 100);
    novaQtd = calc_qtd - qtdAUX;
  }
  calc_qtd = novaQtd;
  _vendasController.add(novaQtd.toString());
  calculoVendas(novaQtd.toString());
  calculoPontoEquilibrio();
  calculoMargemResultante();

}

custoVARIAVEL(operacao,percentual){
  var custoFixoDadosBasicos =  convertMonetarioFloat(_cusf);
  var calfat =  convertMonetarioFloat(_fat);
  if (operacao == 1) {
    novoCustoVariavel =  (custoFixoDadosBasicos/calfat )*calc_fat;
  //  novoCustoVariavel = calc_cf *((percentual / 100) + 1);
  } else {
    novoCustoVariavel =  (custoFixoDadosBasicos/calfat )*calc_fat;
  //  var qtdAUX = calc_cf *(percentual / 100);
   // novoCustoVariavel = calc_cf - qtdAUX;
  }

  corCustoVariavel("desabilitado");
   calc_cf = novoCustoVariavel;
  var novoCustoVariavelForm = "R\$ ${formatterMoeda.format(novoCustoVariavel)}";
  _custoVariavelController.add(novoCustoVariavelForm);
  _margemContribuicaoCalculada = (calc_fat - (calc_gi + novoCustoVariavel + calc_gas)) / calc_qtd;
  _margemDeContribuicaoController.add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");
  _calculoPontoEquilibio =(calc_cv / _margemContribuicaoCalculada) * _ticketMedio;
  _pontoEquilibrioController.add("R\$ ${formatterMoeda.format(_calculoPontoEquilibio)}");
  calculoMargemConribuicao();
  calculoMargemResultante();
  calculoPontoEquilibrio();
}

custoPRODUTO3(percentual,operacao){
  var custoDadosBasicos =  convertMonetarioFloat(_cus);
  var calfat =  convertMonetarioFloat(_fat);
  if (operacao == 1) {
    novoCustoProduto =  (custoDadosBasicos/calfat )*calc_fat;
   // novoCustoProduto = calc_gas *((percentual / 100) + 1);
  } else {
    novoCustoProduto =  (custoDadosBasicos/calfat )*calc_fat;
   // var qtdAUX = calc_gas *(percentual / 100);
  //  novoCustoProduto = calc_gas - qtdAUX;
  }
  corCustoProduto("desabilitado");

  calc_gas = novoCustoProduto;
  var custoNovoProduto = "R\$ ${formatterMoeda.format(novoCustoProduto)}";
  _custoFixoController.add(custoNovoProduto);

  calculoMargemConribuicao();
  calculoMargemResultante();
  calculoPontoEquilibrio();
}


custosINSUMOS(operacao,percentual){
  var calGi =  convertMonetarioFloat(_gi);
  var calfat =  convertMonetarioFloat(_fat);
  if (operacao == 1) {
    novoValorInsumos = (calGi/calfat )*calc_fat;
  //  novoValorInsumos = calc_gi *((percentual / 100) + 1);
  } else {
    novoValorInsumos = (calGi/calfat )*calc_fat;
   // var qtdAUX = calc_gi *(percentual / 100);
   // novoValorInsumos = calc_gi - qtdAUX;
  }
  if (novoValorInsumos > calGi) {//_gi
 //   corCustoInsumos('vermelho');
  } else if (novoValorInsumos < calGi) {
  //  corCustoInsumos('verde');
  } else {
  //  corCustoInsumos('desabilitado');
  }
  calc_gi = novoValorInsumos;
  var custoInSumos = "R\$ ${formatterMoeda.format(novoValorInsumos)}";
  _custoInsumosController.add(custoInSumos);
  _margemContribuicaoCalculada = (calc_fat - (novoValorInsumos + calc_cv + calc_gas)) / calc_qtd;
  _margemDeContribuicaoController.add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");

  calculoPontoEquilibrio();
  calculoMargemResultante();
}
  calculoTIKETMEDIO(operacao,percentual){
    if (operacao == 1) {
      novoTicketMedio = _ticketMedio *((percentual / 100) + 1);
    } else {
      var qtdAUX = _ticketMedio *(percentual / 100);
      novoTicketMedio = _ticketMedio - qtdAUX;
    }
    _ticketMedio = novoTicketMedio;
    corTicketMedio('desabilitado');

    _ticketMedio = novoTicketMedio;
    _tickeMedioMoeda = "R\$ ${formatterMoeda.format(_ticketMedio)}";
    _ticketMedioController.add(_tickeMedioMoeda);
    calc_fat = novoTicketMedio * calc_qtd;
    _faturamentoController.add("R\$ ${formatterMoeda.format(calc_fat)}");
    _margemContribuicaoCalculada =(calc_fat - (calc_gi + calc_cv + calc_gas)) / calc_qtd;
    _margemDeContribuicaoController.add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");
    _calculoPontoEquilibio =(calc_cv / _margemContribuicaoCalculada) * novoTicketMedio;
    _pontoEquilibrioController.add("R\$ ${formatterMoeda.format(_calculoPontoEquilibio)}");
    calculoMargemConribuicao();
    calculoMargemResultante();
    calculoPontoEquilibrio();
    corTicket();
  }


  corCustoFixo(cor) {
    _corCustoFixoController.add(cor);
  }
  corCustoVariavel(cor) {
    _corCustoVariavelController.add(cor);
  }
  corCustoProduto(cor) {
    _corCustoProdutolController.add(cor);
  }
  corCustoInsumos(cor) {
    _corCustoInsumoslController.add(cor);
  }
  corTicketMedio(cor) {
    _corTicketMediolController.add(cor);
  }
  corMargemResultate(){
    var margemAtual = ((calc_fat - (calc_gi + calc_cv + calc_cf + calc_gas)) / calc_fat) * 100;
    var margemAtualFormatada =formatterPercentual.format(margemAtual);
    var margemAtualFloat = double.parse(margemAtualFormatada).truncateToDouble();
    var margemInicial =  ((faturamentox - (gastos_insumosx + custo_varivelx + custo_fixox + gastosx)) / faturamentox) * 100;
    var margemInicialFormatada =formatterPercentual.format(margemInicial);
    var margemIniciaFloat = double.parse(margemInicialFormatada).truncateToDouble();
    var corMargemResultate = "desabilitado";
    if(margemIniciaFloat < margemAtualFloat){
      corMargemResultate = "verde";
    }else if(margemIniciaFloat > margemAtualFloat){
      corMargemResultate = "vermelho";
    }
    _corMargemResultateController.add(corMargemResultate.toString());
  }
  corTicket(){
    var ticketValorInicial  = faturamentox / qtdx;
    var ticketValorAtual = calc_fat / double.parse(_qtd).truncateToDouble();
    var corTicketValorAtual = "desabilitado";
    if(ticketValorInicial < ticketValorAtual){
      corTicketValorAtual = "verde";
    }else if(ticketValorInicial > ticketValorAtual){
      corTicketValorAtual = "vermelho";
    }else{
      corTicketValorAtual = "desabilitado";
    }
    corTicketMedio(corTicketValorAtual);
  }
corFaturamento(){
    var faturamentoInicial = faturamentox;
    var faturamentoAtual = calc_fat;
    var corFaturamento = "desabilitado";
    if(faturamentoInicial < faturamentoAtual){
      corFaturamento = "verde";
    }else if(faturamentoInicial > faturamentoAtual){
      corFaturamento = "vermelho";
    }else{
      corFaturamento = "desabilitado";
    }
    _corFaturamentoController.add(corFaturamento.toString());

}


  calculoVendas(qtdVendas) {
    var qtdVenda = double.parse(qtdVendas).truncateToDouble();
    var qtdini = double.parse(_qtd).truncateToDouble();
    if (qtdVenda > qtdini) {
      _corVendaController.add('verde');
    } else if (qtdVenda < qtdini) {
      _corVendaController.add('vermelho');
    } else if (qtdVenda == qtdini) {
      _corVendaController.add('desabilitado');
    }
    calc_qtd = qtdVenda;
    calc_fat = _ticketMedio * qtdVenda;
    _vendasController.add(formatterPercentual.format(qtdVenda));
    _faturamentoController.add("R\$ ${formatterMoeda.format(calc_fat)}");

    calculoMargemResultante();
    calculoPontoEquilibrio();
  }


  calculoMargemResultante() {
    _margemReultanteCalculada = ((calc_fat - (calc_gi + calc_cv + calc_cf + calc_gas)) / calc_fat) * 100;
    _margemResultateController.add(" ${formatterPercentual.format(_margemReultanteCalculada)} %");
    corMargemResultate();
    corFaturamento();
  }

  calculoPontoEquilibrio() {
    _calculoPontoEquilibio = (calc_cv / _margemContribuicaoCalculada) * _ticketMedio;
    _pontoEquilibrioController.add("R\$ ${formatterMoeda.format(_calculoPontoEquilibio)}");
    var ticketValorInicial  = faturamentox / qtdx;
    var margemContribuicaoInicial =   (faturamentox - (gastos_insumosx + custo_fixox + gastosx)) / qtdx;
    var pontoEquilibrioInicial =  (custo_varivelx / margemContribuicaoInicial) * ticketValorInicial;

    var percentualMargenInicial = (pontoEquilibrioInicial/faturamentox)*100;
    var percentualMargenAtual  = (pontoEquilibrioInicial/calc_fat)*100;

    var corpercentualMargen = "desabilitado";
    if(percentualMargenAtual < percentualMargenInicial){
      corpercentualMargen = "verde";
    }else if(percentualMargenAtual > percentualMargenInicial){
      corpercentualMargen = "vermelho";
    }else{
      corpercentualMargen = "desabilitado";
    }
    _corPontoEquilibroController.add(corpercentualMargen);
    print("corpercentualMargen");
    print(corpercentualMargen);
    print("faturamentox");
    print(faturamentox);
    print("pontoEquilibrioInicial");
    print(pontoEquilibrioInicial);
    print("percentualMargenInicial");
    print(percentualMargenInicial);
    print("------------------");
    print("_calculoPontoEquilibio");
    print(_calculoPontoEquilibio);
    print("calc_fat");
    print(calc_fat);
    print("percentualMargenAtual");
    print(percentualMargenAtual);



  }
/*
  calPontoEquilibrio( calc_cf_v, _margemContribuicaoCalculada_v, _ticketMedio_v) {
    _calculoPontoEquilibio = (calc_cf_v / _margemContribuicaoCalculada_v) * _ticketMedio_v;
    _pontoEquilibrioController  .add("R\$ ${formatterMoeda.format(_calculoPontoEquilibio)}");

  }
*/


  calculoMargemConribuicao() {
    _margemContribuicaoCalculada =(calc_fat - (calc_gi + calc_cf + calc_gas)) / calc_qtd;
    _margemDeContribuicaoController.add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");
  //  corMargemContribuicao();
    var margemContribuicaoInicial =   (faturamentox - (gastos_insumosx + custo_fixox + gastosx)) / qtdx;
    var cormargemContribuicao = "desabilitado";
    if(margemContribuicaoInicial < _margemContribuicaoCalculada){
      cormargemContribuicao = "verde";
    }else if(margemContribuicaoInicial > _margemContribuicaoCalculada){
      cormargemContribuicao = "vermelho";
    }else{
      cormargemContribuicao = "desabilitado";
    }
    _corMargemContribuicaoController.add(cormargemContribuicao.toString());
  }

  calculoMargen(element) {
    convertFoat(element);
    _margemCalculada =
        ((calc_fat - (calc_gi + calc_cv + calc_cf + calc_gas)) / calc_fat) *
            100;
    _margemInformadaController
        .add(formatterPercentual.format(_margemCalculada));
  }

  calculoTiketMedio() {
    _ticketMedio = calc_fat / double.parse(_qtd).truncateToDouble();
    _tickeMedioMoeda = "R\$ ${formatterMoeda.format(_ticketMedio)}";
    _ticketMedioController.add(_tickeMedioMoeda);
  }

  calTiketMedio() async {

    _corTicketMediolController.add('desabilitado');
    await getDadosBasicos();
    _ticketMedio = await calc_fat / double.parse(_qtd).truncateToDouble();
    _tickeMedioMoeda = await "R\$ ${formatterMoeda.format(_ticketMedio)}";
    return _tickeMedioMoeda;
  }

  updateStream(marIdeal, qtd, fat, gi, gpv, cusf, cus, element) {


    var qtdjust = int.parse(qtd);
    _margemIdealController.add(marIdeal);
    _vendasController.add(qtdjust.toString());
    _faturamentoController.add(fat);
    _custoInsumosController.add(element['gastos_insumos']);
    _custoVariavelController.add(element['custo_fixo']);
    _custoFixoController.add(cusf);
    _custoProdutoController.add(gi);
    calculoMargen(element);
    calculoTiketMedio();
    calculoMargemConribuicao();
    calculoPontoEquilibrio();
    calculoMargemResultante();
    _percentualAddController.add('0');
    _percentualRemoveController.add('0');


  }

  convertMonetarioFloat(element) {
    var data = (element
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    return double.parse(data).truncateToDouble();
  }

  convertFoat(element) {
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
    calc_gas = double.parse(gastos).truncateToDouble();

    qtdx = double.parse(qtd).truncateToDouble();
    faturamentox =double.parse(faturamento).truncateToDouble();
    gastosx = double.parse(gastos).truncateToDouble();
    custo_fixox = double.parse(custo_fixo).truncateToDouble();
    custo_varivelx = double.parse(custo_varivel).truncateToDouble();
    gastos_insumosx = double.parse(gastos_insumos).truncateToDouble();


  }

  @override
  void dispose() {}
}
