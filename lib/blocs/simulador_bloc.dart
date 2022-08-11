import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
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
  var _marInformada;

  var calc_qtd;
  var calc_fat;
  var calc_cf;
  var calc_cv;
  var calc_gi;
  var calc_gas;

  var _margemCalculada;
  var _ticketMedio;
  var _margemContribuicaoCalculada;
  var _calculoPontoEquilibio;
  var _margemReultanteCalculada;

  NumberFormat formatterPercentual = NumberFormat("0.0");
  NumberFormat formatterMoeda = NumberFormat("0.00");

  getDadosBasicos() async {
    await bd.lista().then((data) {
      data.forEach((element) {
        //  print(element);
        _qtd = element["qtd"];
        _fat = element["faturamento"];
        _gi = element["gastos_insumos"];
        _gpv = element["custo_varivel"];
        _cusf = element["custo_fixo"];
        _cus = element["gastos"];
        _marIdeal = element["margen"];
        updateStream(
            _marIdeal, _qtd, _fat, _gpv, _cusf, _cus, _marIdeal, element);
      });
    });
  }

  calculoPercentual(op,campo, valor){


  }

  calculoMargemResultante(){
    _margemReultanteCalculada =((calc_fat - (calc_gi + calc_cv + calc_cf + calc_gas)) / calc_fat)*100;
    _margemResultateController.add(" ${formatterPercentual.format(_margemReultanteCalculada)} %");

  }
  calculoPontoEquilibrio(){
     _calculoPontoEquilibio = (calc_cv/_margemContribuicaoCalculada)*_ticketMedio;
     _pontoEquilibrioController.add("R\$ ${formatterMoeda.format(_calculoPontoEquilibio)}");
  }
  calculoMargemConribuicao() {
     _margemContribuicaoCalculada = (calc_fat - (calc_gi+calc_cf +calc_gas))/calc_qtd;
    _margemDeContribuicaoController.add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");
  }
  calculoMargen(element) {
    convertFoat(element);
    _margemCalculada =((calc_fat - (calc_gi + calc_cv + calc_cf + calc_gas)) / calc_fat)*100;
    _margemInformadaController.add(formatterPercentual.format(_margemCalculada));
  }
  calculoTiketMedio() {
    _ticketMedio = calc_fat / double.parse(_qtd).truncateToDouble();
    var _tickeMedioMoeda = "R\$ ${formatterMoeda.format(_ticketMedio)}";
    _ticketMedioController.add(_tickeMedioMoeda);
  }
  updateStream(marIdeal, qtd, fat, gi, gpv, cusf, cus, element) {
    _margemIdealController.add(marIdeal);
    _vendasController.add(qtd);
    _faturamentoController.add(fat);
    _custoInsumosController.add(gi);
    _custoVariavelController.add(gpv);
    _custoFixoController.add(cusf);
    _custoProdutoController.add(cus);
    calculoMargen(element);
    calculoTiketMedio();
    calculoMargemConribuicao();
    calculoPontoEquilibrio();
    calculoMargemResultante();
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
    calc_cf  = double.parse(custo_fixo).truncateToDouble();
    calc_cv  = double.parse(custo_varivel).truncateToDouble();
    calc_gi  = double.parse(gastos_insumos).truncateToDouble();
    calc_gas = double.parse(gastos).truncateToDouble();
  }

  @override
  void dispose() {}
}
