import 'package:appgestao/classes/sqlite/dadosbasicos.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

class CalculadoraBloc extends BlocBase {



  var bd = DadosBasicosSqlite();
  final _calculoMargemController = BehaviorSubject();
  final _msgMargemController = BehaviorSubject();
  final _calcluloSugeridoController = BehaviorSubject();
  final _comparativoPrecoController = BehaviorSubject();
  final _msgPrecoSugeridoController = BehaviorSubject();
  final _relacaoPrecoController = BehaviorSubject();
  final _calculoParte1Controller = BehaviorSubject();
  final _precoVendaAtualController = BehaviorSubject();
  final _custoComInsumoslController = BehaviorSubject();


  Stream get outCalculoMargem => _calculoMargemController.stream;
  Stream get outMsgMargem => _msgMargemController.stream;
  Stream get outCaculoPrecoSugerido => _calcluloSugeridoController.stream;
  Stream get outComparativoPreco => _comparativoPrecoController.stream;
  Stream get outMsgPrecoSugerido => _msgPrecoSugeridoController.stream;
  Stream get outCaculoPedido1Controller => _calculoParte1Controller.stream;
  Stream get outRelacaoPrecoController => _relacaoPrecoController.stream;
  Stream get outPrecoVendaAtualController => _precoVendaAtualController.stream;
  Stream get outCustosComInsumosController => _custoComInsumoslController.stream;


  var _custoInsumo = 200.0;
  var _margemDesejada = 0.3;
  var caluculoFinal = 1.0;
  var fat;
  var cf;
  var cv;
  var gi;
  var gas;
  var mars;
  var mar;
  var _precoVendaAtual = 1000.00;
  var _relacaoPreco;



  CalculadoraBloc() {
      Intl.defaultLocale = 'pt_BR';
    _getDadosBasicos();
  }
  //NumberFormat formatter = NumberFormat.simpleCurrency();
  NumberFormat formatter = NumberFormat("00.0000");
  _getDadosBasicos() async {
    await bd.lista().then((data) {
      data.forEach((element) {
    //    print(element);
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
         fat = double.parse(faturamento).truncateToDouble();
         cf = double.parse(custo_fixo).truncateToDouble();
         cv = double.parse(custo_varivel).truncateToDouble();
         gi = double.parse(gastos_insumos).truncateToDouble();
         gas = double.parse(gastos).truncateToDouble();
         mars = double.parse(element['margen']);
         mar = mars / 100;

         //Formula da margem atual
        /***------------------------calculadora ------------------------ * ---------------------------Dados básicos------------------------- * ----------------Calculardora----------------****/
       // ((preco atual de vendas calculadora-(preço insumos calculadora+((( total outros custos variaveis + custos fixo)/ faturamento vendas)*preço atual vendas)))/preco atual de vendas))
        var margemComPrecoAtual = (((double.parse(faturamento) -
                    ((double.parse(gastos_insumos) +
                        double.parse(custo_varivel) +
                        double.parse(custo_fixo) +
                        double.parse(gastos)))) /
                double.parse(faturamento)) *
            100);
        // print(margemComPrecoAtual);
        _calculoMargemController.add(margemComPrecoAtual);
        if (margemComPrecoAtual == mar) {
          _msgMargemController.add(
              'Este item contribui para manter a margem atual do seu negócio');
        } else if (margemComPrecoAtual > mar) {
          _msgMargemController.add(
              'Este item contribui para que a margem do seu negócio não seja menor');
        } else {
          _msgMargemController
              .add('Este item impede que a margem do seu negócio seja maior');
        }
      //  var _calculoPrecodugerido = (1 / (1 - ((cv / fat + cf / fat + _margemDesejada) / 1)))*_custoInsumo;
     //   _calcluloSugeridoController.add(formatter.format(_calculoPrecodugerido));

        _precoVendaAtualController.add(formatter.format(fat));
        _custoComInsumoslController.add(formatter.format(_custoInsumo));
        _precoVendaAtual = fat;
      //  _calculoController();
      //  calculoRelacaoPreco();
        _calculoMargemAtual();
      });
    });
  }

  _calculoMargemAtual(){
   // print(_precoVendaAtual);
    /***------------------------calculadora ------------------------ * ---------------------------Dados básicos------------------------- * ----------------Calculardora----------------****/
    // ((preco atual de vendas calculadora-(preço insumos calculadora+((( total outros custos variaveis + custos fixo)/ faturamento vendas)*preço atual vendas)))/preco atual de vendas))
    var margemComPrecoAtual =((_precoVendaAtual-(_custoInsumo+(((cv+ cf)/fat)*_precoVendaAtual)))/_precoVendaAtual)*100;
   // print('margemComPrecoAtual');

    var margem = formatter.format(margemComPrecoAtual);
    //print(margem);
    _calculoMargemController.add(margem);
    _calculoPrecodugerido();
  }
  calculoRelacaoPreco(){
   // (preço sugerido/preço atual) – 100%
    

  }
  calculadoraCusto(custoInsumos) {
    var _custoInsumos = (custoInsumos
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    _custoInsumo = double.parse(_custoInsumos);
    _calculoMargemAtual();


  }
  margemDesejada(margen) {
  //  _margemDesejada = margen/100;
    var _margem = (margen
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
       var mar1 = double.parse(_margem);
       var mar2 = mar1/100;
      _margemDesejada = mar2;
       _calculoMargemAtual();
       _calculoPrecodugerido();
  }
 percoVendaAtual(preco){
    var price =(preco
        .toString()
        .replaceAll("R\$", "")
        .replaceAll('.', '')
        .replaceAll(',', '.'));
    _precoVendaAtual = double.parse(price);
    _precoVendaAtualController.add(_precoVendaAtual);
    _calculoMargemAtual();
}
_calculoPrecodugerido(){

  //(1/1-((((total outros custos variaveis + custos fixo)/faturamento vendas)+margem desejada)/(1)))*custo insumos
  //(1/(1-((((B10+B11)/B7)+F15)/1)))*F10
  var _calculoPrecodugerido = (1/(1-((((cf+cv)/fat)+_margemDesejada)/1)))*_custoInsumo;
    _calcluloSugeridoController.add(formatter.format(_calculoPrecodugerido));
}

  /*
 *
 * informação do banco de dado

  var calculo1 = outros custos variaveis/faturamento
 * (1/100-((calculo1 + calculo3 + "margem desejada colocada na calculadora")/100))* valor de insumo informado na calculadora
 *
 *Cálculo “preço sugerido”:
(1/(100%-((total outros custos variáveis/faturamento* + total custos fixos/faturamento* + margem desejada informada na calculadora)/100%)) x custo dos insumos informado na calculadora.
 (*) informações dos DADOS BÁSICOS
 *
 *
 *
 * */
  @override
  void dispose() {
    // TODO: implement dispose
    _calculoMargemController.close();
    _msgMargemController.close();
    _calcluloSugeridoController.close();
    _comparativoPrecoController.close();
    _msgPrecoSugeridoController.close();
  }
}
