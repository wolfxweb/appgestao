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

  Stream get margemIdealController => _margemIdealController.stream;
  Stream get margemInformadaController => _margemInformadaController.stream;
  Stream get vendasController => _vendasController.stream;
  Stream get ticketMedioController => _ticketMedioController.stream;
  Stream get faturamentoController => _faturamentoController.stream;
  Stream get custoInsumosController => _custoInsumosController.stream;
  Stream get custoProdutoController => _custoProdutoController.stream;
  Stream get custoVariavelController => _custoVariavelController.stream;
  Stream get custoFixoController => _custoFixoController.stream;
  Stream get margemDeContribuicaoController =>
      _margemDeContribuicaoController.stream;
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

  var refTicketValor;

  NumberFormat formatterPercentual = NumberFormat("0.0");
  NumberFormat formatterMoeda = NumberFormat("0.00");

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

        updateStream(
            _marIdeal, _qtd, _fat, _gpv, _cusf, _cus, _marIdeal, _element);
      });
    });
  }

  calculoPercentual(percent, operacao, selecionado, modo, context) {
    print(selecionado);
    var select = selecionado;
    bool refTicketValor = true;
    var ticketOriginal;
    var novaQtd;
    var novoTicketMedio;
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
      percentual++;
      _percentualRemoveController.add('0');
      _percentualAddController.add(percentual.toStringAsPrecision(2));
    }
    if (modo == 2 && operacao == 2) {
      percentual++;
      _percentualAddController.add('0');
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
        calculoMargemResultante();
        break;
    }

    //  _percentualAddController.add('0');
    //    _percentualRemoveController.add('0');

    /*  print("operacao");
    print(operacao);
    print("item");
    print(select);
    print("modo");
    print(modo);
    print("-------------");
    print("selecionado");
    print(selecionado);
    print("percentual");
    print(percentual);*/
  }

  calculoCustoFixo(text) {
    var novoCustoFixo = convertMonetarioFloat(text);
    if (novoCustoFixo > calc_cv) {
      corCustoFixo('vermelho');
    } else if (novoCustoFixo < calc_cv) {
      corCustoFixo('verde');
    } else {
      corCustoFixo("desabilitado");
    }
    _calculoPontoEquilibio =
        (novoCustoFixo / _margemContribuicaoCalculada) * _ticketMedio;
    _pontoEquilibrioController
        .add("R\$ ${formatterMoeda.format(_calculoPontoEquilibio)}");
    _margemReultanteCalculada =
        ((calc_fat - (calc_gi + novoCustoFixo + calc_cf + calc_gas)) /
                calc_fat) *
            100;
    _margemResultateController
        .add(" ${formatterPercentual.format(_margemReultanteCalculada)} %");
  }

  corCustoFixo(cor) {
    _corCustoFixoController.add(cor);
  }

  getCustoFixo() async {
    corCustoFixo('desabilitado');
    await getDadosBasicos();
    var custoFixo = await "R\$ ${formatterMoeda.format(calc_cv)}";
    _custoVariavelController.add(custoFixo);
    return custoFixo;
  }

  calculoCustoVariavelInptu(text) {
    var novoCustoVariavel = convertMonetarioFloat(text);
/*
    print('novoCustoVariavel');
    print(novoCustoVariavel);
    print('calc_fat');
    print(calc_fat);
    print('calc_gas');
    print(calc_gas);


    print('calc_cf');
    print(calc_cf);
    print('calc_cv');
    print(calc_cv);
    print('calc_gi');
    print(calc_gi);
    print('calc_qtd');
    print(calc_qtd);

*/

    if (novoCustoVariavel > calc_cf) {
      corCustoVariavel('vermelho');
    } else if (novoCustoVariavel < calc_cf) {
      corCustoVariavel('verde');
    } else {
      corCustoVariavel("desabilitado");
    }
    calc_cf = novoCustoVariavel;

    _margemContribuicaoCalculada =
        (calc_fat - (calc_gi + novoCustoVariavel + calc_gas)) / calc_qtd;
    _margemDeContribuicaoController
        .add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");
    _calculoPontoEquilibio =
        (calc_cv / _margemContribuicaoCalculada) * _ticketMedio;
    _pontoEquilibrioController
        .add("R\$ ${formatterMoeda.format(_calculoPontoEquilibio)}");
    calculoMargemResultante();
  }

  corCustoVariavel(cor) {
    _corCustoVariavelController.add(cor);
  }

  getCustoVariavel() async {
    corCustoVariavel('desabilitado');
    await getDadosBasicos();
    var custoVariavel = await "R\$ ${formatterMoeda.format(calc_cf)}";
    _custoInsumosController.add(custoVariavel);
    return custoVariavel.toString();
  }

  calculoCustoProdutoInptu(text) {
    var novoCustoProduto = convertMonetarioFloat(text);
    if (novoCustoProduto > calc_gas) {
      corCustoProduto('vermelho');
    } else if (novoCustoProduto < calc_gas) {
      corCustoProduto('verde');
    } else {
      corCustoProduto("desabilitado");
    }
    calc_gas = novoCustoProduto;
    _margemContribuicaoCalculada =
        (calc_fat - (calc_gi + calc_cf + novoCustoProduto)) / calc_qtd;
    _margemDeContribuicaoController
        .add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");
    _margemReultanteCalculada =
        ((calc_fat - (calc_gi + calc_cv + calc_cf + novoCustoProduto)) /
                calc_fat) *
            100;
    _margemResultateController
        .add(" ${formatterPercentual.format(_margemReultanteCalculada)} %");
    calculoPontoEquilibrio();
  }

  corCustoProduto(cor) {
    _corCustoProdutolController.add(cor);
  }

  getCustoProduto() async {
    //  _corCustoProdutolController.add("padrao");
    corCustoProduto("desabilitado");
    await getDadosBasicos();
    var custoProduto = await "R\$ ${formatterMoeda.format(calc_gas)}";
    _custoInsumosController.add(custoProduto);
    return custoProduto.toString();
  }

  calculoCustoInsumosInptu(text) {
    var novoValorInsumos = convertMonetarioFloat(text);
    if (novoValorInsumos > calc_gi) {
      corCustoInsumos('vermelho');
    } else if (novoValorInsumos < calc_gi) {
      corCustoInsumos('verde');
    } else {
      corCustoInsumos('desabilitado');
    }
    calc_gi = novoValorInsumos;
    _margemContribuicaoCalculada =
        (calc_fat - (novoValorInsumos + calc_cv + calc_gas)) / calc_qtd;
    _margemDeContribuicaoController
        .add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");
    calculoMargemResultante();
    calculoPontoEquilibrio();
  }

  corCustoInsumos(cor) {
    _corCustoInsumoslController.add(cor);
  }

  getCustoInsumos() async {
    _corCustoInsumoslController.add('desabilitado');
    await getDadosBasicos();
    var custoInSumos = await "R\$ ${formatterMoeda.format(calc_gi)}";
    _custoInsumosController.add(custoInSumos);
    return custoInSumos.toString();
  }

  calculoTicketMedioInput(text) {
    var novoValorTicketMedio = convertMonetarioFloat(text);
    var state = true;

    if (state) {
      refTicketValor = novoValorTicketMedio;
      state = false;
    }

    if (novoValorTicketMedio > _ticketMedio) {
      corTicketMedio('verde');
    } else if (novoValorTicketMedio < _ticketMedio) {
      corTicketMedio('vermelho');
    } else if (refTicketValor == _ticketMedio) {
      corTicketMedio('desabilitado');
    }
    _ticketMedio = novoValorTicketMedio;
    _tickeMedioMoeda = "R\$ ${formatterMoeda.format(novoValorTicketMedio)}";
    _ticketMedioController.add(_tickeMedioMoeda);
    calc_fat = novoValorTicketMedio * calc_qtd;
    _faturamentoController.add("R\$ ${formatterMoeda.format(calc_fat)}");
    _margemContribuicaoCalculada =(calc_fat - (calc_gi + calc_cv + calc_gas)) / calc_qtd;
    _margemDeContribuicaoController.add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");
    _calculoPontoEquilibio =(calc_cv / _margemContribuicaoCalculada) * novoValorTicketMedio;
    _pontoEquilibrioController.add("R\$ ${formatterMoeda.format(_calculoPontoEquilibio)}");
    calculoMargemResultante();
  }

  corTicketMedio(cor) {
    _corTicketMediolController.add(cor);
  }

  getTicketMedio() {
    var ticket = calc_fat / double.parse(_qtd).truncateToDouble();
    _tickeMedioMoeda = "R\$ ${formatterMoeda.format(ticket)}";
    _corVendaController.add('desabilitado');
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
    _vendasController.add(qtdVenda);
    _faturamentoController.add("R\$ ${formatterMoeda.format(calc_fat)}");
    calculoMargemConribuicao();
    calculoMargemResultante();
    calculoPontoEquilibrio();
  }

  getVendas() async {
    getDadosBasicos();
    _corVendaController.add('desabilitado');
    var vendas = await bd.lista();
    return vendas;
  }

  calculoMargemResultante() {
    _margemReultanteCalculada =
        ((calc_fat - (calc_gi + calc_cv + calc_cf + calc_gas)) / calc_fat) *
            100;
    _margemResultateController
        .add(" ${formatterPercentual.format(_margemReultanteCalculada)} %");
  }

  calculoPontoEquilibrio() {
    _calculoPontoEquilibio =
        (calc_cv / _margemContribuicaoCalculada) * _ticketMedio;
    _pontoEquilibrioController
        .add("R\$ ${formatterMoeda.format(_calculoPontoEquilibio)}");
  }

  calPontoEquilibrio(
      calc_cf_v, _margemContribuicaoCalculada_v, _ticketMedio_v) {
    _calculoPontoEquilibio =
        (calc_cf_v / _margemContribuicaoCalculada_v) * _ticketMedio_v;
    _pontoEquilibrioController
        .add("R\$ ${formatterMoeda.format(_calculoPontoEquilibio)}");
  }

  calculoMargemConribuicao() {
    _margemContribuicaoCalculada =
        (calc_fat - (calc_gi + calc_cf + calc_gas)) / calc_qtd;
    _margemDeContribuicaoController
        .add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");
  }

  calMargemConribuicao(
      calc_fat_v, calc_gi_v, calc_cf_v, calc_gas_v, calc_qtd_v) {
    _margemContribuicaoCalculada =
        (calc_fat_v - (calc_gi_v + calc_cf_v + calc_gas_v)) / calc_qtd_v;
    _margemDeContribuicaoController
        .add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");
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
    _margemIdealController.add(marIdeal);
    _vendasController.add(qtd);
    _faturamentoController.add(fat);
    _custoInsumosController.add(gi);
    _custoVariavelController.add(element['custo_varivel']);
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
  }

  @override
  void dispose() {}
}
