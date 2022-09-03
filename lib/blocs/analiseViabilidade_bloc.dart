



import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

class AnaliseViabilidadeBloc extends BlocBase{
  var bd = DadosBasicosSqlite();

  final _precoDescontoMaximoSemPrejuizoController = BehaviorSubject();
  final _precoPromocionalController = BehaviorSubject();
  final _vendaParaRecuperarInvestimentoController = BehaviorSubject();
  final _resultadoAcaoController = BehaviorSubject();
  final _resultadoAcaoCorController = BehaviorSubject();
  Stream get outPrecoDescontoMaximoSemPrejuizo => _precoDescontoMaximoSemPrejuizoController.stream;
  Stream get outPrecoPromocional => _precoPromocionalController.stream;
  Stream get outPrecoVendaParaRecuperarInvestimento => _vendaParaRecuperarInvestimentoController.stream;
  Stream get outResultadoController=> _resultadoAcaoController.stream;
  Stream get outResultadoCorController=> _resultadoAcaoCorController.stream;

  var calc_qtd;
  var calc_fat;
  var calc_cf;
  var calc_cv;
  var calc_gi;
  var calc_gas;
  var calc_cpv;
  var calc_mar;

  var _precoVendaAtual;
  var _custoInsumosProduto ;
  var _descontoPromocional;
  var _invertimentoAcao;
  var _objetivoVendas;
  var _venderComLucro;


  NumberFormat formatterPercentual = NumberFormat("0.0");
  NumberFormat formatterMoeda = NumberFormat("0.00");
  NumberFormat formatterQuantidade = NumberFormat("0");

  AnaliseViabilidadeBloc(){
    _getDadosBasicos();
  }

  _calculoResultadoAcao(){
    var resultadoAcao = (((_venderComLucro/100 - _descontoPromocional/100)*_precoVendaAtual)*_objetivoVendas)-_invertimentoAcao;
    _resultadoAcaoController.add("R\$ ${formatterMoeda.format(resultadoAcao)}");
    if(resultadoAcao>0){
      _resultadoAcaoCorController.add("lucro");
    }else if(resultadoAcao<0){
      _resultadoAcaoCorController.add("Prejuizo");
    }else{
      _resultadoAcaoCorController.add("nulo");
    }
  }
  _calculoInvestimentoComAcao(){
    var recuperarInvetimento = (_invertimentoAcao/((_venderComLucro-_descontoPromocional)*_precoVendaAtual))*100;
    if(recuperarInvetimento>0){
       _vendaParaRecuperarInvestimentoController.add(formatterQuantidade.format(recuperarInvetimento));
     }else{
       _vendaParaRecuperarInvestimentoController.add('Não recuperável!');
     }
  }
  _calculoPrecoPromocional(){
    var precoPromocional= _precoVendaAtual*((100-_descontoPromocional)/100);
    _precoPromocionalController.add("R\$ ${formatterMoeda.format(precoPromocional)}");
  }
  _calculoVenderSemPrejuizo(){
    if(_custoInsumosProduto !="" && _precoVendaAtual != ""){
      _venderComLucro =  (1-(((1/(1-((((calc_cv+calc_cf)/calc_fat)+0)/1)))*_custoInsumosProduto)/_precoVendaAtual))*100;
      if(_venderComLucro>0){
        _precoDescontoMaximoSemPrejuizoController.add("${formatterPercentual.format(_venderComLucro)}%");
      }else{
        _precoDescontoMaximoSemPrejuizoController.add('0');
      }
    }
  }
  precoVendaAtual(value){
    _precoVendaAtual =  _convertFloatMonetario(value);
    _calculoVenderSemPrejuizo();
  }
  custoInsumosProduto(value){
    _custoInsumosProduto =_convertFloatMonetario(value);
    _calculoVenderSemPrejuizo();
  }
  descontoPromocional(value){
    _descontoPromocional =_convertFloatMonetario(value);
    _calculoPrecoPromocional();
  }
  invertimentoAcao(value){
    _invertimentoAcao =_convertFloatMonetario(value);
    _calculoInvestimentoComAcao();
  }
  objetivoVendas(value){
    _objetivoVendas =_convertFloatMonetario(value);
    _calculoResultadoAcao();

  }
  _getDadosBasicos() async {
    await bd.lista().then((data) {
      data.forEach((element) {
        print(element);
        _convertFoat(element);
      });
    });
  }
  _convertFloatMonetario(value){
    var valueFormat = (value
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    return  double.parse(valueFormat).truncateToDouble();
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
    calc_gas = double.parse(gastos).truncateToDouble();

  }
}