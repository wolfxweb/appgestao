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
  final _variacaoMargemController  = BehaviorSubject();
  final _ticketDadosBasicos = BehaviorSubject();
  final _custoInsumosMercadoria3 = BehaviorSubject();
  final _margemInicial = BehaviorSubject();
  final _clientesAtendidoDadosBasico = BehaviorSubject();
  final _clientesAtendido = BehaviorSubject();
  final _clientesVariacao = BehaviorSubject();
  final _tickeMedioInicial = BehaviorSubject();
  final _variacaoTicketMedio  = BehaviorSubject();
  final _faturamentoInicial = BehaviorSubject();
  final _faturamentoVariacao = BehaviorSubject();
  final _margemVariacao = BehaviorSubject();
  final _clientesAtendidoCalculado = BehaviorSubject();
  final _clientesAtendidoVaricacao = BehaviorSubject();
  final _custoInicialVendas= BehaviorSubject();
  final _custoFixoVariacao =BehaviorSubject();
  final _corClientesAtendido =BehaviorSubject();
  final _corfaturamento = BehaviorSubject();
  final _variacaoCusto3 = BehaviorSubject();
  final _custoFixoInicialDadosBasicos =BehaviorSubject();
  final _custoFixosVariacao =BehaviorSubject();
  final _precoMedioCalculado =BehaviorSubject();
  final _precoMedioVendas = BehaviorSubject();

  final _corPrecoMedioVendas =BehaviorSubject();
  final _variacaoPrecoMedioVendas =BehaviorSubject();



  Stream get faturamentoInicial => _faturamentoInicial.stream;
  Stream get faturamentoVariacao => _faturamentoVariacao.stream;

  //** campos clientes atendidos*//
  Stream get clientesAtendidoDadosBasico => _clientesAtendidoDadosBasico.stream;
  Stream get clientesAtendido => _clientesAtendido.stream;
  Stream get clientesVariacao => _clientesVariacao.stream;
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
  Stream get ticketDadosBasicos => _ticketDadosBasicos.stream;
  Stream get tickeMedioInicial => _tickeMedioInicial.stream;
  Stream get variacaoTicketMedio => _variacaoTicketMedio.stream;
  Stream get custoInsumosMercadoria3 =>_custoInsumosMercadoria3.stream;
  Stream get margemInicial => _margemInicial.stream;
  Stream get margemVariacao =>_margemVariacao.stream;
  Stream get clientes =>_margemVariacao.stream;
  Stream get clientesAtendidoCalculado =>_clientesAtendidoCalculado.stream;
  Stream get clientesAtendidoVaricacao =>_clientesAtendidoVaricacao.stream;
  Stream get custoInicialVendas => _custoInicialVendas.stream;
  Stream get varicaoMargemController => _variacaoMargemController.stream;
  Stream get custoFixoVariacao => _custoFixoVariacao.stream;
  Stream get corClientesAtendido => _corClientesAtendido.stream;
  Stream get corfaturamento => _corfaturamento.stream;
  Stream get variacaoCusto3 =>_variacaoCusto3.stream;
  Stream get custoFixoInicialDadosBasicos =>_custoFixoInicialDadosBasicos.stream;
  Stream get custoFixosVariacao =>_custoFixosVariacao.stream;
  Stream get precoMedioCalculado => _precoMedioCalculado.stream;
  Stream get precoMedioVendas => _precoMedioVendas.stream;
  Stream get corPrecoMedioVendas =>_corPrecoMedioVendas.stream;
  Stream get variacaoPrecoMedioVendas => _variacaoPrecoMedioVendas.stream;


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

  var ticketBool = true;

  NumberFormat formatterPercentual = NumberFormat("0.00");
  NumberFormat formatterMoeda = NumberFormat("#,##0.00", "pt_BR");

  var faturamentoDadosBasicos;
  var custoVendasDadosBasicos;
  var custoInsumosTerceirosDadosBasicos;
  var custoFixoDadosBasicos;
  var margenDadosBasicos;
  var quantidadeDadosBasicos;
  var gastoComInsumosDadosBasicos;
  var quantidadeDeClientesAtendidoDadosBasicos;

  var quantidadeDeClientesAtendidoCalculada;

  var margemInicalCalculada;
  var quantidadeDeClientesAtendido;
  var ticketMedioInicialValor;
  var precoMedioVendasCalculado;


   var precoInicial;
  //
  // Margem = (faturamentoD-(custo vendasD + custo dos insumos terceirosD + custo fixoD ))/faturamentoD
  // Clientes atendidos = CLEINTESATENDIDODADOSBASICOS *(PERCENTUAL DIGITADO)
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
         faturamentoDadosBasicos =  convertMonetarioFloat(element["faturamento"]);
         custoVendasDadosBasicos = convertMonetarioFloat(element["gastos_insumos"]);
         custoInsumosTerceirosDadosBasicos =  convertMonetarioFloat(element["custo_fixo"]);
         custoFixoDadosBasicos =  convertMonetarioFloat(element["custo_varivel"]);
         margenDadosBasicos = convertMonetarioFloat(element["margen"]);
         quantidadeDadosBasicos =  convertMonetarioFloat(element["qtd"]);
         gastoComInsumosDadosBasicos =  convertMonetarioFloat(element["gastos"]);
         quantidadeDeClientesAtendidoDadosBasicos = element["qtd"];
         quantidadeDeClientesAtendidoCalculada  = element["qtd"];
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

    var fat = convertMonetarioFloat(_fat);
   // var fat =   double.parse(faturamentoConverido);
    var qtd =   double.parse(_qtd);

    var percoOriginal = fat/qtd;
    precoInicial =percoOriginal;

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
    print('opção selecionada');
    print(select);
    switch (select) {

      case 'Preço médio de vendas':
     //   print('Preço médio de vendas');
        //calculoTIKETMEDIO(operacao,percentual);
        precoMedioCalculo(operacao,percentual);

        break;
      case 'Custo das vendas':
       //   print('Custo das vendas case');

          var custoVendasCalculada;
          if (operacao == 1) {
            custoVendasCalculada = custoVendasDadosBasicos * ((percentual/100)+1);
          } else {
            var quantidadeDeClientesAtendidoAx = (custoVendasDadosBasicos * (percentual/100));
            custoVendasCalculada = custoVendasDadosBasicos - quantidadeDeClientesAtendidoAx;
          }
          calc_gi = custoVendasCalculada;
          var custoInSumos = "R\$ ${formatterMoeda.format(custoVendasCalculada)}";
          _custoInsumosController.add(custoInSumos);
          variacaoCustoFixo();

        break;
      case 'Quantidade clientes atendidos':

       //  print(quantidadeDeClientesAtendidoCalculada.runtimeType);
       //  print(percentual);

         if (operacao == 1) {
           quantidadeDeClientesAtendido = double.parse(quantidadeDeClientesAtendidoCalculada) * ((percentual/100)+1);
         } else {
           var quantidadeDeClientesAtendidoAx = (double.parse(quantidadeDeClientesAtendidoCalculada) * (percentual/100));
           quantidadeDeClientesAtendido = double.parse(quantidadeDeClientesAtendidoCalculada) - quantidadeDeClientesAtendidoAx;
         }

         var variacaoClientesAtendimento =  calculoVariacao(double.parse(quantidadeDeClientesAtendidoDadosBasicos), quantidadeDeClientesAtendido);

           calc_fat = _ticketMedio * quantidadeDeClientesAtendido;
          _faturamentoController.add("R\$ ${formatterMoeda.format(calc_fat)}");
           quantidadeDeClientesAtendidoCalculada = quantidadeDeClientesAtendido.toString();
           _clientesAtendidoCalculado.add('${formatterPercentual.format(quantidadeDeClientesAtendido)}');
           _clientesAtendidoVaricacao.add('${formatterPercentual.format(variacaoClientesAtendimento)}');

         if(quantidadeDeClientesAtendido < quantidadeDadosBasicos ){
           _corClientesAtendido.add('vermelho');
         }else if(quantidadeDeClientesAtendido > quantidadeDadosBasicos ){
           _corClientesAtendido.add('verde');
         }else{
           _corClientesAtendido.add('desabilitado');
         }
         novoCalculoCusto3(operacao,percentual);

          variacaoFaturamento();
          calculoMargemResultante();

        break;
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
        calculoTIKETMEDIO(operacao,percentual);
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
            print('_tickeMedioMoeda');
            print(_tickeMedioMoeda);
            print('novoTicketMedio');
            print(novoTicketMedio);
            print('calc_qtd');
            print(calc_qtd);
            calc_fat = novoTicketMedio * calc_qtd;

          //  _faturamentoController.add("R\$ ${formatterMoeda.format(calc_fat)}");
            _margemContribuicaoCalculada =(calc_fat - (calc_gi + calc_cv + calc_gas)) / calc_qtd;
            _margemDeContribuicaoController.add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");
            _calculoPontoEquilibio =(calc_cv / _margemContribuicaoCalculada) * novoTicketMedio;
            _pontoEquilibrioController.add("R\$ ${formatterMoeda.format(_calculoPontoEquilibio)}");
            quantidadeVENDADS(operacao,percentual);
           //calculoMargemConribuicao(); Estes são os calculos antes da segunda versão
           //calculoMargemResultante();
           //calculoPontoEquilibrio();
           //calculoTIKETMEDIO(operacao,percentual);
            custosINSUMOS(operacao,percentual);
            custoPRODUTO3(percentual,operacao);
            custoVARIAVEL(operacao,percentual);
           // var _tickeMI = calc_fat / double.parse(_qtd).truncateToDouble();
            var _tickeMIV =((_ticketMedio/percoOriginal)-1)*100;
            _variacaoTicketMedio.add(" ${formatterPercentual.format(_tickeMIV)} ");
            calc_fat = novoTicketMedio * calc_qtd;
           // var fats= convertMonetarioFloat(_fat);
            variacaoFaturamento();




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

        quantidadeVENDADS(operacao,percentual);
        calculoTIKETMEDIO(operacao,percentual);
       // custosINSUMOS(operacao,percentual);
        custoPRODUTO3(percentual,operacao);
        custoVARIAVEL(operacao,percentual);
        break;
        /*****************************/
      case 'Custos dos insumos e mercadorias de 3°':

        var custoDadosBasicos =  convertMonetarioFloat(_cusf);

        if (operacao == 1) {
          novoCustoProduto = calc_cf *((percentual / 100) + 1);
        } else {
          var qtdAUX = calc_cf *(percentual / 100);
          novoCustoProduto = calc_cf - qtdAUX;
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
        _margemResultateController.add(" ${formatterPercentual.format(_margemReultanteCalculada)} ");

       // quantidadeVENDADS(operacao,percentual);
      //  calculoTIKETMEDIO(operacao,percentual);
     //   custosINSUMOS(operacao,percentual);
        custoPRODUTO3(percentual,operacao);
        custoVARIAVEL(operacao,percentual);
        varicaoCusto3();
        break;
    /*****************************/
      case 'Outros custo variaveis':
      //  print("Outros custo variaveis calc_cf");
       // print(calc_cf);
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
        quantidadeVENDADS(operacao,percentual);
        calculoTIKETMEDIO(operacao,percentual);
        custosINSUMOS(operacao,percentual);
        custoPRODUTO3(percentual,operacao);
       // custoVARIAVEL(operacao,percentual);
        break;
    /*****************************/
      case 'Custo fixo':
   //     print("Custo fixoCusto fixoCusto fixoCusto fixo");
    //    print(calc_cv);

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
      //  print(novoCustoFixo);
         calc_cv = novoCustoFixo;
        var novoCustonovoCustoFixo = "R\$ ${formatterMoeda.format(novoCustoFixo)}";
        _custoProdutoController.add(novoCustonovoCustoFixo);
        _calculoPontoEquilibio =(novoCustoFixo / _margemContribuicaoCalculada) * _ticketMedio;
        _pontoEquilibrioController.add("R\$ ${formatterMoeda.format(_calculoPontoEquilibio)}");
        _margemReultanteCalculada =((calc_fat - (calc_gi + novoCustoFixo + calc_cf + calc_gas)) /calc_fat) *100;
        _margemResultateController.add(" ${formatterPercentual.format(_margemReultanteCalculada)}");

       var variacaoCusto =((calc_cv/custoFixoDadosBasicos)-1)*100;
       _custoFixosVariacao.add("${formatterPercentual.format(variacaoCusto)}");
        break;
     /*****************************/
    }
  }

  precoMedioCalculo(operacao,percentual){
    var novoPrecoMedio ;
    if (operacao == 1) {
      novoPrecoMedio = ticketMedioInicialValor *((percentual / 100) + 1);
    } else {
      var qtdAUX = ticketMedioInicialValor *(percentual / 100);
      novoPrecoMedio = ticketMedioInicialValor - qtdAUX;
    }

    if (ticketMedioInicialValor < novoPrecoMedio) {
     // corTicketMedio('verde');
      _corPrecoMedioVendas.add('verde');
    } else if (ticketMedioInicialValor > novoPrecoMedio) {
    //  corTicketMedio('vermelho');
      _corPrecoMedioVendas.add('vermelho');
    } else {
    //  corTicketMedio('desabilitado');
      _corPrecoMedioVendas.add('desabilitado');

    }

    var faturamento = novoPrecoMedio * calc_qtd;
    var _tickeMIV =((novoPrecoMedio/precoInicial)-1)*100;
    _variacaoTicketMedio.add(" ${formatterPercentual.format(_tickeMIV)} ");
    _precoMedioCalculado.add("R\$ ${formatterMoeda.format(novoPrecoMedio)}");
    _ticketMedioController.add("R\$ ${formatterMoeda.format(novoPrecoMedio)}");
    _faturamentoController.add("R\$ ${formatterMoeda.format(faturamento)}");
    var fats= convertMonetarioFloat(_fat);
    var _faturamentoMV =((faturamento/fats)-1)*100;
    _faturamentoVariacao.add("${formatterPercentual.format(_faturamentoMV)}");
    if(calc_fat < fats ){
      _corfaturamento.add('vermelho');
    }else if(calc_fat > fats ){
      _corfaturamento.add('verde');
    }else{
      _corfaturamento.add('desabilitado');
    }
    if (_ticketMedio > precoInicial) {
      corTicketMedio('verde');
    } else if (_ticketMedio < precoInicial) {
      corTicketMedio('vermelho');
    } else {
      corTicketMedio('desabilitado');
    }
    var precoMedioVariacaoCalculado = ((novoPrecoMedio/ticketMedioInicialValor)-1)*100;
    _variacaoPrecoMedioVendas.add('${formatterPercentual.format(precoMedioVariacaoCalculado)}');
    _ticketMedio =novoPrecoMedio;

  }
  varicaoCusto3() {
    var varicaoDeCusto = ((calc_gas/custoInsumosTerceirosDadosBasicos)-1)*100;
    _variacaoCusto3.add('${formatterPercentual.format(varicaoDeCusto)}');
  }
 novoCalculoCusto3(operacao,percentual){

   var custoDadosBasicos =  convertMonetarioFloat(_cusf);

   if (operacao == 1) {
     novoCustoProduto = calc_cf *((percentual / 100) + 1);
   } else {
     var qtdAUX = calc_cf *(percentual / 100);
     novoCustoProduto = calc_cf - qtdAUX;
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
   _margemResultateController.add(" ${formatterPercentual.format(_margemReultanteCalculada)} ");
   varicaoCusto3();
 }

variacaoCustoFixo(){
    var variacaoCusto =((calc_gi/custoVendasDadosBasicos)-1)*100;
    _custoFixoVariacao.add("${formatterPercentual.format(variacaoCusto)}");
  //  print(calc_gi.runtimeType);
  //  print(calc_gi);
    if(calc_gi >custoVendasDadosBasicos ){
      corCustoInsumos('vermelho');
    }else if(calc_gi < custoVendasDadosBasicos ){
      corCustoInsumos('verde');
    }else{
      corCustoInsumos('desabilitado');
    }
}
variacaoFaturamento(){
  var fats= convertMonetarioFloat(_fat);
  var _faturamentoMV =((calc_fat/fats)-1)*100;
  _faturamentoVariacao.add("${formatterPercentual.format(_faturamentoMV)}");
    if(calc_fat < fats ){
      _corfaturamento.add('vermelho');
    }else if(calc_fat > fats ){
      _corfaturamento.add('verde');
    }else{
      _corfaturamento.add('desabilitado');
    }
//  corClientesAtendido;
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
  if (operacao == 1) {
    novoCustoVariavel = calc_cf *((percentual / 100) + 1);
  } else {
    var qtdAUX = calc_cf *(percentual / 100);
    novoCustoVariavel = calc_cf - qtdAUX;
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
  if (operacao == 1) {
    novoCustoProduto = calc_cf *((percentual / 100) + 1);
  } else {
    var qtdAUX = calc_cf *(percentual / 100);
    novoCustoProduto = calc_cf - qtdAUX;
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
  _margemResultateController.add(" ${formatterPercentual.format(_margemReultanteCalculada)} ");
  calculoMargemConribuicao();
  calculoMargemResultante();
  calculoPontoEquilibrio();

  print('custoInsumosTerceirosDadosBasicos');
  print(custoInsumosTerceirosDadosBasicos);
  print('calc_gas');
  print(calc_gas);
  print('novoCustoProduto');
  print(novoCustoProduto);


  var varicaoDeCustos = ((calc_gas/custoInsumosTerceirosDadosBasicos)-1)*100;
  print('varicaoDeCusto');
  print(varicaoDeCustos);
  _variacaoCusto3.add('${formatterPercentual.format(varicaoDeCustos)}');
}


custosINSUMOS(operacao,percentual){
  var calGi =  convertMonetarioFloat(_gi);
  if (operacao == 1) {
    novoValorInsumos = calc_gi *((percentual / 100) + 1);
  } else {
    var qtdAUX = calc_gi *(percentual / 100);
    novoValorInsumos = calc_gi - qtdAUX;
  }
  corTicketMedio('desabilitado');
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

      if (_ticketMedio < novoTicketMedio) {
        corTicketMedio('verde');
      } else if (_ticketMedio > novoTicketMedio) {
        corTicketMedio('vermelho');
      } else {
        corTicketMedio('desabilitado');
      }

    _ticketMedio = novoTicketMedio;
   // corTicketMedio('desabilitado');

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
    variacaoFaturamento();
    var _tickeMIV =((_ticketMedio/precoInicial)-1)*100;
    _variacaoTicketMedio.add(" ${formatterPercentual.format(_tickeMIV)} ");

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
/*
  getVendas() async {
    getDadosBasicos();
    _corVendaController.add('desabilitado');
    var vendas = await bd.lista();
    return vendas;
  }
*/

  calculoMargemResultante() {
 //print( 'calculoMargemResultante()');
    _margemReultanteCalculada =((calc_fat - (calc_gi + calc_cv + calc_cf + calc_gas)) / calc_fat) * 100;
    print(_margemReultanteCalculada);
    _margemResultateController.add(" ${formatterPercentual.format(_margemReultanteCalculada)} ");
    variacaoMargem();
  }

  variacaoMargem(){
  //  print("variacaoMargem");
    margemInicialDadosBasicos();
   // _margemVariacao.add('');
    var margemVariacao =  calculoVariacao(margemInicalCalculada, _margemReultanteCalculada);
    if(margemVariacao!=1 && margemVariacao != 0.0) {
      _margemVariacao.add('${formatterPercentual.format(margemVariacao)}');
    }
  }
  calculoVariacao(valorDadosBasicos, valorCalculado){
    /* centralizado pois o cleinte deve querer alterar o calculo novamente. */
    return ((1-(valorCalculado/valorDadosBasicos))*100)*-1;
  }
  calculoPontoEquilibrio() {
    _calculoPontoEquilibio = (calc_cv / _margemContribuicaoCalculada) * _ticketMedio;
    _pontoEquilibrioController.add("R\$ ${formatterMoeda.format(_calculoPontoEquilibio)}");
  }

  calPontoEquilibrio( calc_cf_v, _margemContribuicaoCalculada_v, _ticketMedio_v) {
    _calculoPontoEquilibio = (calc_cf_v / _margemContribuicaoCalculada_v) * _ticketMedio_v;
    _pontoEquilibrioController.add("R\$ ${formatterMoeda.format(_calculoPontoEquilibio)}");
  }

  calculoMargemConribuicao() {
    _margemContribuicaoCalculada =(calc_fat - (calc_gi + calc_cf + calc_gas)) / calc_qtd;
    _margemDeContribuicaoController.add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");
  }

  calMargemConribuicao(
      calc_fat_v, calc_gi_v, calc_cf_v, calc_gas_v, calc_qtd_v) {
    _margemContribuicaoCalculada =(calc_fat_v - (calc_gi_v + calc_cf_v + calc_gas_v)) / calc_qtd_v;
    _margemDeContribuicaoController.add("R\$ ${formatterMoeda.format(_margemContribuicaoCalculada)}");
  }

  calculoMargen(element) {
    convertFoat(element);
    _margemCalculada = ((calc_fat - (calc_gi + calc_cv + calc_cf + calc_gas)) / calc_fat) *  100;
    _margemInformadaController.add(formatterPercentual.format(_margemCalculada));
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

    //print(element);

    var qtdjust = int.parse(qtd);

    //print(_margemInformadaController.value);

    _margemIdealController.add(marIdeal);
    _vendasController.add(qtdjust.toString());
    _faturamentoController.add(fat);
    _custoInsumosController.add(element['gastos_insumos']);
    _custoVariavelController.add(element['custo_fixo']);
   // _custoFixoController.add(cusf);
    _custoProdutoController.add(gi);
    calculoMargen(element);
    calculoTiketMedio();
    calculoMargemConribuicao();
    calculoPontoEquilibrio();
    calculoMargemResultante();
    _percentualAddController.add('0');
    _percentualRemoveController.add('0');
    _variacaoMargemController.add(formatterPercentual.format(double.parse(_marIdeal)/_margemCalculada));
    _clientesAtendidoDadosBasico.add(formatterPercentual.format(double.parse(qtd)));
    _clientesAtendidoCalculado.add('${formatterPercentual.format(double.parse(qtd))}');

    margemInicialDadosBasicos();
    var _tickeMI = calc_fat / double.parse(_qtd).truncateToDouble();
    ticketMedioInicialValor = _tickeMI;
    var _tickeMIF = "R\$ ${formatterMoeda.format(_tickeMI)}";
    _tickeMedioInicial.add(_tickeMIF);
    _faturamentoInicial.add(_fat);
    _custoInsumosMercadoria3.add(element['custo_fixo']);
    _custoFixoController.add(element['custo_fixo']);
    _custoInicialVendas.add(element['gastos_insumos']);
    _custoFixoInicialDadosBasicos.add(element['custo_varivel']);
  }


  margemInicialDadosBasicos(){

     margemInicalCalculada = ((faturamentoDadosBasicos -(custoVendasDadosBasicos +custoFixoDadosBasicos + custoInsumosTerceirosDadosBasicos))/faturamentoDadosBasicos)*100;
    _margemInicial.add('${formatterPercentual.format(margemInicalCalculada)}');
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
